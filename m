Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B7D2B9FCB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgKTBfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgKTBfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:35:23 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4959322254;
        Fri, 20 Nov 2020 01:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605836123;
        bh=N0kdo0aZujVoSZM1juiGNen6gF3n89ASxhmwOx6KOYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K7PUrwBdqKcGKQzFxSlokUcsJcCtdTCUUQbhRDRAUe1wMdV4i2AU2wIWeWtUtZrbO
         edeTnUvjp9C0Cx1lGMjShTcNu2RlKlczN2PwL1I6X6PlDLUCrWvXeKP03pl33x2ux2
         zOkGLjdj3yLISN3RYlzWdi4Wi8nQnjYxTjPJpPko=
Date:   Thu, 19 Nov 2020 17:35:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201119173521.204c4595@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <533a8308c25b62d213990e5a7e44562f4dc7b66f.camel@kernel.org>
References: <20201112192424.2742-1-parav@nvidia.com>
        <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
        <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201117184954.GV917484@nvidia.com>
        <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <533a8308c25b62d213990e5a7e44562f4dc7b66f.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 22:12:22 -0800 Saeed Mahameed wrote:
> > Right, devices of other subsystems are fine, I don't care.
> 
> But a netdev will be loaded on SF automatically just through the
> current driver design and modularity, since SF == VF and our netdev is
> abstract and doesn't know if it runs on a PF/VF/SF .. we literally have
> to add code to not load a netdev on a SF. why ? :/

A netdev is fine, but the examples so far don't make it clear (to me) 
if it's expected/supported to spawn _multiple_ netdevs from a single
"vdpa parentdev".
