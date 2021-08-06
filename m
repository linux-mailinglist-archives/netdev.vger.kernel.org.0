Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B713E3212
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhHFXRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhHFXRu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 19:17:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AC0561164;
        Fri,  6 Aug 2021 23:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628291854;
        bh=NTkLy+4XFG9qgSOlLy/WbdHgyaG3Nv4CWelnMV5nbuo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sy+caq2tbcfttbDCuwWSq4urZbr5CQL+zu98kpXz7bVqd/18ci/qAf6ULfTIvRsbh
         eU0AXTXY/bSm+GbULDlSV1vP5F6KZnknVfZjMULcLohBjC2t4wPwnl6SxZjdacF0mL
         rlr1cz7ySAIlzchVRpFOgAPHobJPEyz9xOTX9DRfBndoi3ErKPDsFh6ClpRApak8TP
         Gwa+p/LfjYXaFUOROON9OiQO2cA10VeGn+nPOzefI3ozfmq1Y9oxADqs7SIN49qB+f
         MGGSLinUpM03Grf+t7cuHkthcPfDAGxOmM3poRXl59n/BJLRiCnrFuGBqJpc7W15Ib
         0TWBH8d/BRe6A==
Date:   Fri, 6 Aug 2021 16:17:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maksim <bigunclemax@gmail.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Message-ID: <20210806161733.609a01ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806140437.4016159-1-bigunclemax@gmail.com>
References: <20210806140437.4016159-1-bigunclemax@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Aug 2021 17:04:37 +0300 Maksim wrote:
> According to Armada XP datasheet bit at 0 position is corresponding for
> TxInProg indication.
> 
> Signed-off-by: Maksim <bigunclemax@gmail.com>

We'll need your full name in the From and Sign-off tag.
