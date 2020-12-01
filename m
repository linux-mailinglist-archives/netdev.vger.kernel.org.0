Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D91F2C9523
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 03:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgLACWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 21:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgLACWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 21:22:43 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F376820809;
        Tue,  1 Dec 2020 02:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606789322;
        bh=AuvhWrp5dQBF6O3Vfqz49tHcYxH8KvTF5rwV1b6xMKk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OQnVWtbWyR/0f5/corUDXCBGLWPvPsTs3q/J2uxg45SI7Bqs7pmyu46UczlfAu0NW
         tgTC7c4EpVvJRW1khTslcwYP9V4p4DW7y8w2CPqAZbnYNHKTkru6sgkpag5AdOxvXG
         k3c+FjQ3h8J6TXv8WBKW2K+WOrB/PjpXZ9GHTaVc=
Date:   Mon, 30 Nov 2020 18:22:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <george.cherian@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <saeed@kernel.org>, <jiri@resnulli.us>
Subject: Re: [PATCHv5 net-next 1/3] octeontx2-af: Add devlink suppoort to af
 driver
Message-ID: <20201130182201.66a3bae2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201126140251.963048-2-george.cherian@marvell.com>
References: <20201126140251.963048-1-george.cherian@marvell.com>
        <20201126140251.963048-2-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 19:32:49 +0530 George Cherian wrote:
> Add devlink support to AF driver. Basic devlink support is added.
> Currently info_get is the only supported devlink ops.
> 
> devlink ouptput looks like this
>  # devlink dev
>  pci/0002:01:00.0
>  # devlink dev info
>  pci/0002:01:00.0:
>   driver octeontx2-af
>   versions:
>       fixed:
>         mbox version: 9

You need to document what this version is exactly. See how other
drivers document things. It's also strongly preferred to use one 
of the existing identifiers if any one is matching the semantics.

Fixed versions are for hardware versions, like ASIC rev or PCB board
id or version.

Your thing looks like a SW message format. It's not even FW.
It doesn't belong in devlink at all.
