Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335142A324B
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgKBRwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgKBRwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 12:52:44 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E24D421D91;
        Mon,  2 Nov 2020 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604339564;
        bh=Cyo0Xml74Eo/5P2I5gPDEpvxOZH13kEW3r7dlpUJ1yc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v1V1HOQhMXTyQ0X01sZ1rshYaEOi5woe6LTJNDU2/4Gd+d/Tkj3a0cUY40HaQ2upf
         ORBS3SUieQ701Wca9Asv0H/HZBvCWD4KCrMJ0tXLiSzHRBRHhO0Z5ouWG2l4NmGctd
         cyHJgXzUfGSwjsiMDGIlh7me9wL4v+V9BAOlZmnY=
Date:   Mon, 2 Nov 2020 09:52:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Kiran Kumar K <kirankumark@marvell.com>
Subject: Re: [PATCH net-next 02/13] octeontx2-af: Verify MCAM entry channel
 and PF_FUNC
Message-ID: <20201102095243.2e606021@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102061122.8915-3-naveenm@marvell.com>
References: <20201102061122.8915-1-naveenm@marvell.com>
        <20201102061122.8915-3-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 11:41:11 +0530 Naveen Mamindlapalli wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> This patch adds support to verify the channel number sent by
> mailbox requester before writing MCAM entry for Ingress packets.
> Similarly for Egress packets, verifying the PF_FUNC sent by the
> mailbox user.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c:81:17: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c:81:17:    expected unsigned short [assigned] [usertype] pf_func
drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c:81:17:    got restricted __be16 [usertype]
