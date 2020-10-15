Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5FE28EB4E
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 04:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgJOCsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 22:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgJOCsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 22:48:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2C32222E;
        Thu, 15 Oct 2020 02:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602730086;
        bh=97TGT0GSwMUDUcWHMqacDF/nsz6GSSFP4gckFz4SG/Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MpPvq25hkWD9zG/zr9bsRGRTpk3MUq229bu67X1rhIaArV7t21wVPjnvbcSAWnzt1
         7Lnm2i3YttCP4941UTCiYdCvM1QNtEyrfArOGRPDlHTBJ39v3mKUpsPB8kJ6O0yG7Y
         EdIxslk+OKjBR3Xtp8ZPuc/xn/2c+3d0Gtie9awY=
Date:   Wed, 14 Oct 2020 19:48:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep.lkml@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, rsaladi2@marvell.com,
        sgoutham@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 06/10] octeontx2-af: Add NIX1 interfaces to NPC
Message-ID: <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
        <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Oct 2020 15:56:28 +0530 sundeep.lkml@gmail.com wrote:
> -static const struct npc_mcam_kex npc_mkex_default = {
> +static struct npc_mcam_kex npc_mkex_default = {
>  	.mkex_sign = MKEX_SIGN,
>  	.name = "default",
>  	.kpu_version = NPC_KPU_PROFILE_VER,

Why is this no longer constant? Are you modifying global data based 
on the HW discovered in the system? 
