Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7845917E3A
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfEHQjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 12:39:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfEHQjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 12:39:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A1091403CDE7;
        Wed,  8 May 2019 09:39:10 -0700 (PDT)
Date:   Wed, 08 May 2019 09:39:09 -0700 (PDT)
Message-Id: <20190508.093909.1720169724642229427.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv4: Fix raw socket lookup for local traffic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190508034459.31250-1-dsahern@kernel.org>
References: <20190508034459.31250-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 09:39:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue,  7 May 2019 20:44:59 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> inet_iif should be used for the raw socket lookup. inet_iif considers
> rt_iif which handles the case of local traffic.
> 
> As it stands, ping to a local address with the '-I <dev>' option fails
> ever since ping was changed to use SO_BINDTODEVICE instead of
> cmsg + IP_PKTINFO.
> 
> IPv6 works fine.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable, thanks David.
