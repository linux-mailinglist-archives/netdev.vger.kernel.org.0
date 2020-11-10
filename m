Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3522AE3FF
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbgKJX0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:26:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgKJX0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:26:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC7D20781;
        Tue, 10 Nov 2020 23:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605050762;
        bh=gJjjMa0V5H+EAlYsHkzwK5YEswkJdBh8XP+DDSZC2U4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j5fSaEU1lH7h5ujWWG3S7Drs4YsUU/vw3I6Tn3RlSqGeNBa5WGU6k6SjnYzbWJiBe
         UfdBNBz0Ow7wCSq3CNev0UuaRV1EiyHP25iGKo2cV1EAQua/PiPHGs8HRb24utdDG0
         F1amS/lj8rIGFoaFf2Uwips2/BHnsX+1MC46wAw0=
Date:   Tue, 10 Nov 2020 15:26:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiakaixu1987@gmail.com
Cc:     irusskikh@marvell.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2] net: atlantic: Remove unnecessary conversion to bool
Message-ID: <20201110152600.40c919a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604797919-10157-1-git-send-email-kaixuxia@tencent.com>
References: <1604797919-10157-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Nov 2020 09:11:59 +0800 xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The '!=' expression itself is bool, no need to convert it to bool.
> Fix the following coccicheck warning:
> 
> ./drivers/net/ethernet/aquantia/atlantic/aq_nic.c:1477:34-39: WARNING: conversion to bool not needed here
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Applied.
