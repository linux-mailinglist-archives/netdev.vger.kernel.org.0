Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5051E1893
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbgEZAxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388013AbgEZAxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:53:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87584C061A0E;
        Mon, 25 May 2020 17:53:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA0D112796426;
        Mon, 25 May 2020 17:53:07 -0700 (PDT)
Date:   Mon, 25 May 2020 17:53:06 -0700 (PDT)
Message-Id: <20200525.175306.1437742984438170741.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     viro@zeniv.linux.org.uk, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ipv4: potential underflow in
 compat_ip_setsockopt()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200523174648.GA105146@mwanda>
References: <20200523174648.GA105146@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:53:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 23 May 2020 20:46:48 +0300

> The value of "n" is capped at 0x1ffffff but it checked for negative
> values.  I don't think this causes a problem but I'm not certain and
> it's harmless to prevent it.
> 
> Fixes: 2e04172875c9 ("ipv4: do compat setsockopt for MCAST_MSFILTER directly")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
