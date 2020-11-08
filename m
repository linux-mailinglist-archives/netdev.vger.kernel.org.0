Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12EA2AAA0E
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 09:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgKHIVe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Nov 2020 03:21:34 -0500
Received: from wp148.webpack.hosteurope.de ([80.237.132.155]:36272 "EHLO
        wp148.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbgKHIVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 03:21:34 -0500
X-Greylist: delayed 2278 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Nov 2020 03:21:33 EST
Received: from ip1f127119.dynamic.kabel-deutschland.de ([31.18.113.25] helo=[192.168.178.34]); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1kbfMD-0003E2-AC; Sun, 08 Nov 2020 08:43:25 +0100
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
From:   Roelof Berg <rberg@berg-solutions.de>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] lan743x: correctly handle chips with internal PHY
Date:   Sun, 8 Nov 2020 08:43:24 +0100
Message-Id: <180E897D-A99A-43E2-8033-AE1C2499C5BF@berg-solutions.de>
References: <20201108041447.GZ933237@lunn.ch>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20201108041447.GZ933237@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
X-Mailer: iPhone Mail (17G68)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1604823693;fc97992f;
X-HE-SMSGID: 1kbfMD-0003E2-AC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My last customer has a fixed link setup, contact me if you need one. Maybe they let me have it and I can test all future patches on fixed link as well. I tested the current driver version on a Lan7430 EVM in a PC by the way and it seemed to be working. I have the EVM still here if needed.

Greetings,
Roelof
