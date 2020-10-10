Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E27E28A206
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbgJJWxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730253AbgJJSr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 14:47:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2963E20663;
        Sat, 10 Oct 2020 17:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602351468;
        bh=2X73WvH8+0g3Vm/qDBzXgbj/M0tM65Yl4Fgb+KIMfTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LkRcsgwiDiE2sGwUMx5636jl/J1FYsQfd1RRa6sbP5jjRrk63aqZ7RCG7PGTte8PZ
         S4bGI2RXL4H4urHpFDXYrHjCsKK1zyp4gx5jLJ564Z0H5ggmgGXeBjm2JnEvcUCX+x
         UYwNR6chASYblEA4y9lp46huklRntltGJGEB8M7g=
Date:   Sat, 10 Oct 2020 10:37:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pujin Shi <shipujin.t@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hankinsea@gmail.com
Subject: Re: [PATCH 1/2] net: smc: fix missing brace warning for old
 compilers
Message-ID: <20201010103746.3c05e1f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008121929.1270-1-shipujin.t@gmail.com>
References: <20201008121929.1270-1-shipujin.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 20:19:28 +0800 Pujin Shi wrote:
> For older versions of gcc, the array = {0}; will cause warnings:
> 
> net/smc/smc_llc.c: In function 'smc_llc_send_link_delete_all':
> net/smc/smc_llc.c:1317:9: warning: missing braces around initializer [-Wmissing-braces]
>   struct smc_llc_msg_del_link delllc = {0};
>          ^
> net/smc/smc_llc.c:1317:9: warning: (near initialization for 'delllc.hd') [-Wmissing-braces]
> 
> 1 warnings generated
> 
> Fixes: f3811fd7bc97 ("net/smc: send DELETE_LINK, ALL message and wait for send to complete")
> Signed-off-by: Pujin Shi <shipujin.t@gmail.com>

Applied both, thanks!
