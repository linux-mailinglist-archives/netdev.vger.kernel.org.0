Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813452F04B1
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 02:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbhAJBV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 20:21:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJBV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 20:21:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 641BF23447;
        Sun, 10 Jan 2021 01:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610241647;
        bh=nZNHm1QKEeRPxfucewsA6D4m/j9x1D9PRd0fse90BdE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G3yewPrHechmWuqemxUU1IzLORSlDGIe5gx4o3xQ55f9imzYspgEFamjrxV06GAiS
         mFRFrTQqm8JAgaaQ7V6XZqBD8JrJS8mLqXQTe9NOnFR+4g+0tr8QWmO/Cz4bPnEhMu
         UlxYUec11R8umqcv2JXRxD64T04ppSBBSKbuCOQMVA7EhE3uAFCb8s+ikQ16x7pX2t
         87Vw625ipvsWPMvOXX+mRDstxLjumsylnZhX6ai8xd8mcmMbtJo+E7TCCDwnB4G4wW
         igxz/iZ1P23QbxMUpFq+7do89ZmPjbyz/RF2euSkjnObFjmUua3Z+5GY92n6+ohfTT
         X7FXj8OMrm1DA==
Date:   Sat, 9 Jan 2021 17:20:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 02/10] net: mscc: ocelot: add ops for
 decoding watermark threshold and occupancy
Message-ID: <20210109172046.635e4456@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108175950.484854-3-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 19:59:42 +0200 Vladimir Oltean wrote:
> +	*inuse = (val & GENMASK(23, 12)) >> 12;

FWIW FIELD_GET()
