Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F1D33DA41
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbhCPRGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239087AbhCPRGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 13:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A4FB65115;
        Tue, 16 Mar 2021 17:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615914377;
        bh=L3Wwuoc+0jCDrKjluqD3/6h3roo1LSNauhjIL1FD3Do=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ojzkd6/yXh5qbU1uqmYwLzTzJWekdPdfCIJ+mfhGVm0F7aA3R+HvZ9erNBsJeL2UQ
         aL8l5vTWmzTJUR6mWzQRGA432oA0tFYn94wGQ4uvaH6LVyorsnrThq/VEecvTxJ99h
         y1dO4VuLua6aUoHkoEwhkmMliNuyUqYQOnUA+GruuYIxSSp5MKB0mHoETtzELYDzO3
         x+bq9HjIcRrhnt1ud3tiibdsU9FK9mvh5jBWTm6xRCrh1G8HWfRdYUi6arauN7vNQC
         /lwGC+I5y5/b/lPeCrnqdljrwsjdCS4NKhUavRJ9CpEdUCj3jp+18ej31HwBJBi/Gw
         uWJogWDiMGIcA==
Date:   Tue, 16 Mar 2021 10:06:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: Re: [net PATCH 4/9] octeontx2-af: Remove TOS field from MKEX TX
Message-ID: <20210316100616.333704ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615886833-71688-5-git-send-email-hkelam@marvell.com>
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
        <1615886833-71688-5-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 14:57:08 +0530 Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> TOS overlaps with DMAC field in mcam search key and hence installing
> rules for TX side are failing. Hence remove TOS field from TX profile.

Could you clarify what "installing rules is failing" means?
Return error or does not behave correctly?
