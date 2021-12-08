Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCE746D977
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234735AbhLHRUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:20:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42820 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhLHRUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:20:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D056DCE2216
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 17:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA65C00446;
        Wed,  8 Dec 2021 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638983788;
        bh=cr82yUZVDWKOZPAfzGyliMxwZqLnE0a64/6EJmkfXRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j+SSn0GH6xoMw+kOnpd0lZddlM5w5aHhJJJ4o8elnfMk2MG1PuS47CqlcRkDxM1Hc
         eC4qZRTWbJORkURln1GwjlsynQPZJAOt7HJif8blyi+XkwSliTZV3VzWTHpCKUgEwm
         5Vo+03S/mQCTS+kpsllt0oyIR4IEW7oZsA3rMnLcfQnkyXSno3F7n19KlItlPaceG4
         42PLTd1a+iHW78fizlApBM5TNy97hfUrqTyEvGpCH2vwwMTn4MynDTiwT6/CEnSxry
         RyO50ZHI/V3AugeWwMrUv4EZA6Za6WE8XF8q94XrwUIeXhzXN5yHelKBN6xIAbZBdj
         OAIOK3rKzgawQ==
Date:   Wed, 8 Dec 2021 18:16:23 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Message-ID: <20211208181623.6cf39e15@thinkpad>
In-Reply-To: <YbDkldWhZNDRkZDO@lunn.ch>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208162852.4d7361af@thinkpad>
        <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
        <20211208171720.6a297011@thinkpad>
        <YbDkldWhZNDRkZDO@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 18:00:05 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> This gets interesting when PCIe and USB needs
> to use this property, what names are used, and if it is possible to
> combine two different lists?

I don't think it is possible, I tried that once and couldn't get it to
work.

I am going to try write the proposal. But unfortunately PHY binding is
not converted to YAML yet :(

Marek
