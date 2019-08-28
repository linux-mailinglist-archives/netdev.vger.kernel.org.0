Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9E3A0DF1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfH1W5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:57:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38320 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbfH1W5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:57:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D39CE153AFD5F;
        Wed, 28 Aug 2019 15:57:01 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:57:01 -0700 (PDT)
Message-Id: <20190828.155701.124973288104934003.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        jakub.kicinski@netronome.com, willemb@google.com
Subject: Re: [PATCH net] tcp: inherit timestamp on mtu probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
References: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 15:57:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 27 Aug 2019 15:09:33 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> TCP associates tx timestamp requests with a byte in the bytestream.
> If merging skbs in tcp_mtu_probe, migrate the tstamp request.
> 
> Similar to MSG_EOR, do not allow moving a timestamp from any segment
> in the probe but the last. This to avoid merging multiple timestamps.
> 
> Tested with the packetdrill script at
> https://github.com/wdebruij/packetdrill/commits/mtu_probe-1
> 
> Link: http://patchwork.ozlabs.org/patch/1143278/#2232897
> Fixes: 4ed2d765dfac ("net-timestamp: TCP timestamping")
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied and queued up for -stable.
