Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15119416230
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbhIWPja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241991AbhIWPj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 11:39:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDC9961029;
        Thu, 23 Sep 2021 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632411476;
        bh=VgngCLYF8TWGvRKksxYlx6ErAL/9VuC8RC/wRFpGdhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qAkWktLfddoGRVeWiTvWgxK6SAFjlrhVxf5gk1J97xrpQJgKtM3Ge4hrTOYh50ipP
         6DWQn0AZkU4ioqkyZ10x2NherKtomTYRsBwAlFDqgRdfiLjG9lqMC5xo5oFYH77aPy
         WMpsnF6irjju561R5UywbJYiCFvCMOj8x5jfHUE5OH38O8rncHZ+172lrRrdGDbZif
         BoyP6FPxgzfsr/Qv3OftzebWtUVAW89nZF3gq4blkG4b1PQbvg79iSPVJLazgcwYYm
         zffMYdaE5u5Gil1/oUUQHymVxYljTCecTZ/ODHH2yrJ0ibmD2S7StZm3JDmHIP6zuZ
         MqbxPCN4ZD4Lg==
Date:   Thu, 23 Sep 2021 08:37:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [RFC/PATCH 00/18] Add Gigabit Ethernet driver support
Message-ID: <20210923083755.12186362@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c423d886-31f5-7ff2-c8d3-6612b2963972@omp.ru>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
        <c423d886-31f5-7ff2-c8d3-6612b2963972@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 18:11:49 +0300 Sergey Shtylyov wrote:
> >  drivers/net/ethernet/renesas/ravb_main.c | 631 ++++++++++++++++++++---
> >  2 files changed, 630 insertions(+), 92 deletions(-)  
> 
>    There's a lot of new code....

TBH the patches look small an reasonably split to me.

Thanks for the "intending to review" note :)
