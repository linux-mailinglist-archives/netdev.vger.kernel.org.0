Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB2631112F
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhBERqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:46:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhBERoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 12:44:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36AE664E3D;
        Fri,  5 Feb 2021 19:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612553143;
        bh=BgOb+TcaSnI3cZprwqZFAncIJNytyVytQSSPUe6lB9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lTTRFWaovu+4k6fALquGQu3mNtOYEKG2KuGug9GcoNhj6+CO+pTluxrvkx5PAqRNb
         zR2xeh8wu8Vyah5gKiDi6w7z1SENCZeVB3Kd+G+KPa+ZsirrXigeDNUMAdYBiUant3
         SbZtdnZWaD7udDIiZ//6gpPjZjyMwskvsKZ2Fq4+zVO8rh8470GbzZguVvirsq5QUI
         cbVh9TQNt0FkCWLmojPfjtWjZU0Mj5oPJjPkhFQpobuDdreeX/nlpNvKlbnr7LfXOW
         z3bcpBeHSVxlL5QFn0lwzm+Pksnyehfj+ChQIgeplt0OxVu9oisK5GKsaUxtIKHxWX
         kY+TgwqQMn+Hw==
Date:   Fri, 5 Feb 2021 11:25:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Message-ID: <20210205112542.335c6bd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CY4PR18MB1414EF4948CEF69C49E06F85DEB29@CY4PR18MB1414.namprd18.prod.outlook.com>
References: <CY4PR18MB1414EF4948CEF69C49E06F85DEB29@CY4PR18MB1414.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 14:15:01 +0000 Hariprasad Kelam wrote:
> > > Will add multi advertised mode support in near future.  
> > 
> > Looking at patch 6 it seems like the get side already supports multiple modes,
> > although the example output only lists supported no advertised.
> > 
> > Is the device actually doing IEEE autoneg or just configures the speed, lanes
> > etc. according to the link mode selected?  
> 
> Device supports IEEE autoneg mode. Agreed get_link_ksetting returns multiple modes .  
> But set side  firmware code designed in such way that  it handles  single mode. Upon
> Successful configuration firmware updates advertised modes to shared memory
>  such that kernel will read and updates to ethtool.

It needs to be symmetric, get needs to reflect what set specified. 
