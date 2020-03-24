Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 963B91903F6
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 04:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgCXDwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 23:52:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55806 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCXDwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 23:52:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5008215493414;
        Mon, 23 Mar 2020 20:52:46 -0700 (PDT)
Date:   Mon, 23 Mar 2020 20:52:43 -0700 (PDT)
Message-Id: <20200323.205243.1289681464997955216.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: Re: [PATCH net-next 0/4] MSCC PHY: RGMII delays and VSC8502 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319211649.10136-1-olteanv@gmail.com>
References: <20200319211649.10136-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 20:52:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 19 Mar 2020 23:16:45 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series makes RGMII delays configurable as they should be on
> Vitesse/Microsemi/Microchip RGMII PHYs, and adds support for a new RGMII
> PHY.

Series applied, thanks Vladimir.
