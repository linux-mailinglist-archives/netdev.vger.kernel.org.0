Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B33F2736
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfKGFmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:42:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfKGFmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:42:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF7391511FD64;
        Wed,  6 Nov 2019 21:42:22 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:42:22 -0800 (PST)
Message-Id: <20191106.214222.912233743829797849.davem@davemloft.net>
To:     michael@walle.cc
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, robh@kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, andrew@lunn.ch, o.rempel@pengutronix.de
Subject: Re: [PATCH v2 0/6] net: phy: at803x device tree binding
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106223617.1655-1-michael@walle.cc>
References: <20191106223617.1655-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:42:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Wed,  6 Nov 2019 23:36:11 +0100

> Adds a device tree binding to configure the clock and the RGMII voltage.
 ...

Series applied, thank you.
