Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980FE2F85AB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388016AbhAOTlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:41:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbhAOTlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 14:41:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0925235F8;
        Fri, 15 Jan 2021 19:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610739623;
        bh=XNxp8xHBDQP2IcHDqxydaT/OqHqJ+vKmPDqfBTp85nY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TflnFr0DORdAHQFTP0Ps4hHIxJrv854lSzQFloK4sVLcvK/oOnjIlkNrYsdyznp9+
         JYhR27qGRdHqdv/LvtaqpidIuYxs+ctZWs39ExUjDzbUTpMuXLEJcedb3KH0jcvJ2K
         mca3qHGq14T/mPqY3f1mJ6rH8CDku1vArDa20DmNoeNrv5TlnXvI5R+9PPfpW4wJSZ
         SOMli/dk0PXVd3XWpW7QZwYDMaQ/kBJiCxvqXsBOxiGoH8+8dkRis8CC5b1USHc95a
         i9jPXFP8rZlo51Vgm9Rg/60YNMQMBpYQZqq/WhHQeIcCT2iPICtVyyoTEO2rOE1BSz
         SwGuHZbwuh0Qg==
Date:   Fri, 15 Jan 2021 11:40:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Yingjie Wang" <wangyingjie55@126.com>
Cc:     "Geethasowjanya Akula" <gakula@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Vidhya Vidhyaraman" <vraman@marvell.com>,
        "Stanislaw Kardach [C]" <skardach@marvell.com>,
        "Sunil Kovvuri Goutham" <sgoutham@marvell.com>,
        "Linu Cherian" <lcherian@marvell.com>,
        "Jerin Jacob Kollanukkaran" <jerinj@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH v3] octeontx2-af: Fix missing check bugs in
 rvu_cgx.c
Message-ID: <20210115114021.4ad6e588@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7378cece.54f3.177063b30b6.Coremail.wangyingjie55@126.com>
References: <1610602240-23404-1-git-send-email-wangyingjie55@126.com>
        <DM6PR18MB26023B6D29E67754CDF8FB2FCDA71@DM6PR18MB2602.namprd18.prod.outlook.com>
        <7378cece.54f3.177063b30b6.Coremail.wangyingjie55@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 21:27:58 +0800 (CST) Yingjie Wang wrote:
> Thanks for your reply. I have resended the email with the Reviewed-by tag.

Thanks, applied. In the future there is no need to resend to add the
tags. The automation will gather the tags the patch received on the
latest revision.
