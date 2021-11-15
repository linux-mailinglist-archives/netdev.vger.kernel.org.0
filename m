Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F9045066F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhKOOP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:15:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236330AbhKOOP3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:15:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 038C161AA9;
        Mon, 15 Nov 2021 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636985553;
        bh=rdG0qdS7xFz61S3CJ+yHo5n/KsphbmMwntjtHoRHHys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oKAalQulMA+piBox2bnWLmX7K4a6a4Y5rEY+U7XQoGgHxtWe92u4Kdnf/sScaxrqW
         m3hfpld3fHOLRlEj9IpWahxRSBdkGumkOkPPYT7O+EIfWC8wcNwW/qS3s8tk2wXLDH
         EzKQ9r1FesGLdJzw3vz3MR53LU59S9V5thZ64vftTURXQPV6U8GL37nyMWur/nEtUD
         NIScC9kA5O0et3Udu3p4oIOoPjKNQn6kyI+01pkzrOfCe6pGSvpXOz0Ynh+irr2mcJ
         pSEKULCzzZY76vPy9GanmEx0B141CDLqG5snOX1wVh8O3YL/JmYKxwruLp3JBh0jcz
         xV7TDq6uKVUpw==
Date:   Mon, 15 Nov 2021 06:12:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     aelior@marvell.com, skalluru@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bnx2x: fix variable dereferenced before check
Message-ID: <20211115061231.0426ceb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b99360be-feea-c33f-40ab-e7301307a794@gmail.com>
References: <20211113223636.11446-1-paskripkin@gmail.com>
        <b99360be-feea-c33f-40ab-e7301307a794@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Nov 2021 01:41:59 +0300 Pavel Skripkin wrote:
> Btw, looks like GR-everest-linux-l2@marvell.com doesn't exist anymore. 
> It's listed in 2 MAINTAINERS entries. Should it be removed from 
> MAINTAINERS file?

Yes, if it bounces it should be removed. Can you send a patch?
