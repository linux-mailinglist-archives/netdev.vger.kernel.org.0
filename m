Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695752489B7
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgHRPZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbgHRPZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 11:25:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF37206DA;
        Tue, 18 Aug 2020 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597764312;
        bh=SSmt1+EOy9Ujvbe+15BXNCpT/eTQv/ZegyIfORgamdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tqwjH6i/82FuoirOq0MTZIrdpe/m9IozBSEOiaNE6RARs8QXXTrEaJohUWvvIEmHI
         HPs2N/M1/kMAZQbL3ZktmNP3ahtgi3y/pkCcHKsyhkixDGXfIsTkclcH4Msm2vOCWv
         e791UMsSZ0zFv9nVnpWnOycDZBDkz17v0FyYbvGI=
Date:   Tue, 18 Aug 2020 08:25:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>,
        <Parthiban.Veerasooran@microchip.com>
Subject: Re: [PATCH net-next v3 3/3] smsc95xx: add phylib support
Message-ID: <20200818082510.380cd722@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818111127.176422-4-andre.edich@microchip.com>
References: <20200818111127.176422-1-andre.edich@microchip.com>
        <20200818111127.176422-4-andre.edich@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 13:11:27 +0200 Andre Edich wrote:
> +static inline int lan87xx_config_aneg(struct phy_device *phydev)

> +static inline int lan87xx_config_aneg_ext(struct phy_device *phydev)

Please don't use static inline in C files, the compiler will know what
to inline so it's unnecessary, and it hides dead code.
