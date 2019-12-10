Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC2117EE3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfLJET3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:19:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39710 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfLJET3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:19:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D48C154F0608;
        Mon,  9 Dec 2019 20:19:26 -0800 (PST)
Date:   Mon, 09 Dec 2019 20:19:26 -0800 (PST)
Message-Id: <20191209.201926.728362288698200079.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        bunk@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com
Subject: Re: [PATCH net-next v3 0/2] Fix Tx/Rx FIFO depth for DP83867
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191209201025.5757-1-dmurphy@ti.com>
References: <20191209201025.5757-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 20:19:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Mon, 9 Dec 2019 14:10:23 -0600

> The DP83867 supports both the RGMII and SGMII modes.  The Tx and Rx FIFO depths
> are configurable in these modes but may not applicable for both modes.
> 
> When the device is configured for RGMII mode the Tx FIFO depth is applicable
> and for SGMII mode both Tx and Rx FIFO depth settings are applicable.  When
> the driver was originally written only the RGMII device was available and there
> were no standard fifo-depth DT properties.
> 
> The patchset converts the special ti,fifo-depth property to the standard
> tx-fifo-depth property while still allowing the ti,fifo-depth property to be
> set as to maintain backward compatibility.
> 
> In addition to this change the rx-fifo-depth property support was added and only
> written when the device is configured for SGMII mode.

Series applied, thanks.
