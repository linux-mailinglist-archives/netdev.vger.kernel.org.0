Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE797262253
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgIHWC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:02:59 -0400
Received: from mail.nic.cz ([217.31.204.67]:52778 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgIHWC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 18:02:57 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 9ECD2140AE4;
        Wed,  9 Sep 2020 00:02:54 +0200 (CEST)
Date:   Wed, 9 Sep 2020 00:02:54 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?B?T25kxZllag==?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: ethernet-phy: add
 description for PHY LEDs
Message-ID: <20200909000254.13ce9923@nic.cz>
In-Reply-To: <20200908000300.6982-2-marek.behun@nic.cz>
References: <20200908000300.6982-1-marek.behun@nic.cz>
        <20200908000300.6982-2-marek.behun@nic.cz>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch, still refactoring...
