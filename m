Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168EB32F62E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 23:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCEWz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 17:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhCEWzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 17:55:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D1564F11;
        Fri,  5 Mar 2021 22:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614984919;
        bh=1CrTjEZoV5A6twTZemcbfp0/ikfp7xshxhN94nII4HE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XRapI5bpZ/1gK1LK9S7TSPUmza0m/ryBvnmYdNmJMrQYclcI3aKjGqvdIf7P3gBsr
         sIx/uR24OOOKgZO/njQqR8wwiTfBpYVyJrU42CAXPmTpYAuVXXClrBY/Pl4KCC/PZE
         JuebKxzrNx1UJE2KZ/taEaCZ5fNZfYd22tMCW+KpFAMs5niNTLXgSSBEHbcq5ghDXp
         UB4HEicHVpdZGvCJ4NrgCgBmPaHtWmhze3EtVG82tsBm9qUeBS7lu5k2cRjpo//j3b
         rmg7JcY8mDcm1D8RKS0Jr1t0qeDrvyv2qRa4vxKQ3qSsvP93CIuwXVIuRyAcVgNwnk
         L8Z7SkIs4tXHQ==
Date:   Fri, 5 Mar 2021 14:55:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Don Bollinger" <don@thebollingers.org>
Cc:     "'Andrew Lunn'" <andrew@lunn.ch>, <arndb@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <brandon_chuang@edge-core.com>, <wally_wang@accton.com>,
        <aken_liu@edge-core.com>, <gulv@microsoft.com>,
        <jolevequ@microsoft.com>, <xinxliu@microsoft.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>
References: <20210215193821.3345-1-don@thebollingers.org>
        <YDl3f8MNWdZWeOBh@lunn.ch>
        <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
        <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>
        <YD1ScQ+w8+1H//Y+@lunn.ch>
        <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Mar 2021 11:07:08 -0800 Don Bollinger wrote:
> Acknowledging your objections, I nonetheless request that optoe be accepted
> into upstream as an eeprom driver in drivers/misc/eeprom.  It is a
> legitimate driver, with a legitimate user community, which deserves the
> benefits of being managed as a legitimate part of the linux kernel.

It's in the best interest of the community to standardize on how 
we expect things to operate. You're free to do whatever you want
in your proprietary systems but please don't expect us to accept
a parallel, in now way superior method of accessing SFPs. 
