Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7042941F527
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354603AbhJASrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354510AbhJASrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 14:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97CB56124F;
        Fri,  1 Oct 2021 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633113961;
        bh=CKAAC2OXyGm5bmCnnHP4/xfqQwfeho4xebAjwhPsDzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MfACnr/D4a4+7bPwhwdA9Akn59IP9UonN6n8hHQkJEzr6bhswSDRfEdOQkv33HBAr
         BJzNPohqG0TSWkyLh8K/h1bVCgFvaRBcEttsFDUPfljzPmUNcV0Qw0PKs+Nk3ly806
         9gWPol3V+rLpTGBCeV7IrA2x4G8eSpMGlgVLOnhqDDOoVieiOun7Kd/dIZ5YBH0qDq
         xoN5/bUsAsNefelGSelzUluZymsuXXlfT7YWcyTeaemCaHibuY/Tx5GX9TwSCK9v0p
         H5bWUzg8nnsYKkC/cJZF+VwVELYrOzMoa4uRxKs/qzJRx2ehVy3jgfVVMIMNCvk3rM
         hA5uCoudmVxFA==
Date:   Fri, 1 Oct 2021 11:45:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH 0/8] Fillup stubs for Gigabit Ethernet driver support
Message-ID: <20211001114559.376cbf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
References: <20211001164305.8999-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Oct 2021 17:42:57 +0100 Biju Das wrote:
> This patch series depend upon [1]
> [1] https://lore.kernel.org/linux-renesas-soc/20211001150636.7500-1-biju.das.jz@bp.renesas.com/T/#t

Post it as an RFC, then, please.
