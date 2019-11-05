Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F01F0908
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbfKEWGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:06:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39372 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730237AbfKEWGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:06:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 020DF1506A9A5;
        Tue,  5 Nov 2019 14:06:16 -0800 (PST)
Date:   Tue, 05 Nov 2019 14:06:16 -0800 (PST)
Message-Id: <20191105.140616.1174888253359674234.davem@davemloft.net>
To:     michael@walle.cc
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, simon.horman@netronome.com
Subject: Re: [PATCH 0/5] net: phy: at803x device tree binding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191102011351.6467-1-michael@walle.cc>
References: <20191102011351.6467-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 14:06:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Sat,  2 Nov 2019 02:13:46 +0100

> Adds a device tree binding to configure the clock and the RGMII voltage.

This does not apply cleanly to net-next, please respin.

Thank you.
