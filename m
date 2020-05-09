Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C0F1CC3D1
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 20:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgEISxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 14:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbgEISxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 14:53:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71BC92072F;
        Sat,  9 May 2020 18:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589050398;
        bh=3IeRY31njpLOvPMFz5mXU1h/ZTxepFdm8cCWD9yxjK4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eynrlXn62F5oI316PPMQErLWjzYIRWNKAkpbHE12Z4k5kswD0TYRmJ5ImTrQEIsj6
         Xjh0bm9CNukrS58vJ/R1blfJ+YUyUS/tM/FGUZusZoLvqaBzKAqfD+d987QXxkrNxU
         /YKCr41H2T9pRbUZ/rag3NGXM0haSjsv6IgLJr+A=
Date:   Sat, 9 May 2020 11:52:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: Re: [PATCH v2 net-next 0/7] net: atlantic: driver updates
Message-ID: <20200509115235.4d84d41e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509064700.202-1-irusskikh@marvell.com>
References: <20200509064700.202-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 09:46:53 +0300 Igor Russkikh wrote:
> From: Mark Starovoytov <mstarovoitov@marvell.com>
> 
> This patch series contains several minor cleanups for the previously
> submitted series.
> 
> We also add Marvell copyrights on newly touched files.
> 
> v2:
>  * accommodated review comments related to the last patch in series
>    (MAC generation)
> 
> v1: https://patchwork.ozlabs.org/cover/1285011/

Applied, thank you!
