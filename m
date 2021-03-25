Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9813349CFB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhCYXlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:41:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhCYXlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 19:41:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPZbH-00D2xe-Ok; Fri, 26 Mar 2021 00:41:15 +0100
Date:   Fri, 26 Mar 2021 00:41:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V5 net-next 0/5] ethtool: Extend module EEPROM dump
 API
Message-ID: <YF0fm+j7pwxxzHDR@lunn.ch>
References: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616684215-4701-1-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 04:56:50PM +0200, Moshe Shemesh wrote:
> Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
> But in current state its functionality is limited - offset and length
> parameters, which are used to specify a linear desired region of EEPROM
> data to dump, is not enough, considering emergence of complex module
> EEPROM layouts such as CMIS 4.0.
> Moreover, CMIS 4.0 extends the amount of pages that may be accessible by
> introducing another parameter for page addressing - banks.

This is looking much better.

Do you have a version of ethtool using this new API? WIP code is
O.K. I will add basic support to sfp.c and test it out on the devices
i have.

  Andrew
