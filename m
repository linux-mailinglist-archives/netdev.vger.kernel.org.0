Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BC33590E6
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 02:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbhDIAai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 20:30:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhDIAah (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 20:30:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUf2K-00FdkA-F7; Fri, 09 Apr 2021 02:30:12 +0200
Date:   Fri, 9 Apr 2021 02:30:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Dexuan Cui <decui@microsoft.com>, davem@davemloft.net,
        kuba@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, liuwe@microsoft.com,
        netdev@vger.kernel.org, leon@kernel.org, bernd@petrovitsch.priv.at,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v3 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YG+gFMnVuvtlHNQQ@lunn.ch>
References: <20210408225840.26304-1-decui@microsoft.com>
 <20210408164552.2d67f7b1@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408164552.2d67f7b1@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Linux kernel doesn't do namespaces in the code, so every new driver needs
> to worry about global symbols clashing

This driver is called mana, yet the code uses ana. It would be good to
resolve this inconsistency as well. Ideally, you want to prefix
everything with ana_ or mana_, depending on what you choose, so we
have a clean namespace.

	   Andrew
