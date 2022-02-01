Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BC44A5C28
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiBAMY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:24:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57698 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiBAMY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:24:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08177614F1;
        Tue,  1 Feb 2022 12:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3C7C340EB;
        Tue,  1 Feb 2022 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643718293;
        bh=ooC0NvRuprHdmJZFzg4LMCCX2H+CyKZoohO2KL8HGD4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VRz6QowMJZkaY7Dy9wn0nzAhOqiptpxHv/1QEcA9ff+rglRHtOftfgG9P7vxGSld+
         Os2H7/cGbci9v6Gl0ZmP0lPElPXP+XQhN9DbTyJAwfM5UbQOkDoDcGODOgK3Cl1Lqb
         h4ZVHBVK4PRGEGJgtVUSaSuMmkNzi5sXulh81z3XVMWxy0mBQUX85skMxs/jVVaq9e
         T3pnJ8gckBW4KpXnNGX7L5SZnfnFDy/QgeLpExU0ly1A5+HIiGdnSD+F4JQYhS7R/M
         yZug1YGuoCrcNfzs/6F9b4bXelx0J7rD446DWxWY2tAWINP3TjTx60uPBNFYiA9RFO
         ytI6ClQD/znbA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: ray_cs: Check ioremap return value
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211230022926.1846757-1-jiasheng@iscas.ac.cn>
References: <20211230022926.1846757-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164371828600.16633.15192450644077513815.kvalo@kernel.org>
Date:   Tue,  1 Feb 2022 12:24:51 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> As the possible failure of the ioremap(), the 'local->sram' and other
> two could be NULL.
> Therefore it should be better to check it in order to avoid the later
> dev_dbg.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Patch applied to wireless-next.git, thanks.

7e4760713391 ray_cs: Check ioremap return value

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211230022926.1846757-1-jiasheng@iscas.ac.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

