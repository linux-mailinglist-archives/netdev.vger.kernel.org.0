Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29EC519FAFC
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgDFRGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:06:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728816AbgDFRGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:06:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0686B15DA0ACE;
        Mon,  6 Apr 2020 10:06:06 -0700 (PDT)
Date:   Mon, 06 Apr 2020 10:06:06 -0700 (PDT)
Message-Id: <20200406.100606.1382059106426370272.davem@davemloft.net>
To:     alex.aring@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        mcr@sandelman.ca, stefan@datenfreihafen.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: rpl: fix loop iteration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200404152257.32262-1-alex.aring@gmail.com>
References: <20200404152257.32262-1-alex.aring@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Apr 2020 10:06:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <alex.aring@gmail.com>
Date: Sat,  4 Apr 2020 11:22:57 -0400

> This patch fix the loop iteration by not walking over the last
> iteration. The cmpri compressing value exempt the last segment. As the
> code shows the last iteration will be overwritten by cmpre value
> handling which is for the last segment.
> 
> I think this doesn't end in any bufferoverflows because we work on worst
> case temporary buffer sizes but it ends in not best compression settings
> in some cases.
> 
> Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> Signed-off-by: Alexander Aring <alex.aring@gmail.com>

Applied, thanks.
