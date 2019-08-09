Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29CE686F0B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404787AbfHIBCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:02:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIBCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:02:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8922214254DF3;
        Thu,  8 Aug 2019 18:02:12 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:02:12 -0700 (PDT)
Message-Id: <20190808.180212.865026468498688254.davem@davemloft.net>
To:     ross.lagerwall@citrix.com
Cc:     netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        paul.durrant@citrix.com, wei.liu@kernel.org
Subject: Re: [PATCH] xen/netback: Reset nr_frags before freeing skb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805153434.12144-1-ross.lagerwall@citrix.com>
References: <20190805153434.12144-1-ross.lagerwall@citrix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:02:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>
Date: Mon, 5 Aug 2019 16:34:34 +0100

> At this point nr_frags has been incremented but the frag does not yet
> have a page assigned so freeing the skb results in a crash. Reset
> nr_frags before freeing the skb to prevent this.
> 
> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>

Applied and queued up for -stable.
