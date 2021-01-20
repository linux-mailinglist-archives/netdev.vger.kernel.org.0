Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E804B2FC732
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbhATBxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731434AbhATBvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:51:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61D7E22472;
        Wed, 20 Jan 2021 01:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611107469;
        bh=XqhusBcw27JMCulRlNAFfujkKFBBkbJwSXc71mtVzqs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S+3TUSJU1wfkTrRW5jshGGLjtJaH0mdVg3buZfta+tDBSaqtEti878PvWUV+Dc9aV
         obVZXozwTIEEq9uYkX752iA0dUHHuzOFSJJsAl/rCiZlSOO829JHCVDTixXbS/uFRP
         1vyWwpM1oTNcuGViyqNkfpvaUBQ6NbvBpvvegKU9KT3PMlctM3p+7abmqP0UYjYMPZ
         5cNouezYF1WrnZ0Bl6jwYC0GtQcpQo54JuqqT9Ta4B6avHwM7O3H35ALlLMu+LQXCM
         jBGFjErUbPGK+Uu1+t9D5/mEgEdItKlCtnOsMGWRjcAgSJ/5dyuAyEDicnO6W/UBI8
         QaXs+0RW9f/5g==
Date:   Tue, 19 Jan 2021 17:51:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2-af: Remove unneeded semicolon
Message-ID: <20210119175108.5b95a7a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119075059.17493-1-vulab@iscas.ac.cn>
References: <20210119075059.17493-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 07:50:59 +0000 Xu Wang wrote:
> fix semicolon.cocci warnings:
> ./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c:272:2-3: Unneeded semicolon
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

I squashed your 3 patches for octeontx2-af and applied them to net-next.

Thanks.
