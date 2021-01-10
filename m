Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEB32F04C3
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 03:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbhAJCCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 21:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJCCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 21:02:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C278B22513;
        Sun, 10 Jan 2021 02:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610244083;
        bh=iCmz5Oe0rjZ45FKKL2ANl11S+MFBXpHu01TgXCj41ZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M/5OX8KSYi9YoRzFxDwKq2WjP1zo87nqyPETFvqilgut7I+dt6IwUq5lEV+VcK1BR
         Xn4XZKuY7Hi29vfv8KLVAJ2VrbJ3qup0FfMisGm9hyqX3rhr4stP4GqfYOf5Bzkc1+
         R2sBA9rqOIHRKKvu/6ScAtzcvBT01+AO9cvvoMSErNASjMkLajsqDwz2uOvKJmofhF
         FKVvkbkArd64RYtywIMmMST+KOs2v7tbjBg26E6jTNazhETj0mpozMZwLDcT2e+W3M
         0m+7EtOClzDbNTdeHORgHs1re3JVUjGu7oZesXiaRwHmjieI1OmMiGpR42Ws+uDtRW
         E+j8cXJjDoOXQ==
Date:   Sat, 9 Jan 2021 18:01:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210109180121.7b1ed217@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108175950.484854-9-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 19:59:48 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add devlink integration into the mscc_ocelot switchdev driver. Only the
> probed interfaces are registered with devlink, because for convenience,
> struct devlink_port was included into struct ocelot_port_private, which
> is only initialized for the ports that are used.

This sounds like something that DSA should have a general policy on.
I actually feel like it was discussed in the past.. Do you know what
other drivers do?

