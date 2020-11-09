Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B922AC5B1
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729838AbgKIUDV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Nov 2020 15:03:21 -0500
Received: from wp148.webpack.hosteurope.de ([80.237.132.155]:43398 "EHLO
        wp148.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726410AbgKIUDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:03:20 -0500
Received: from ip1f127119.dynamic.kabel-deutschland.de ([31.18.113.25] helo=[192.168.178.34]); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1kcDNX-0002X3-RQ; Mon, 09 Nov 2020 21:03:03 +0100
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Roelof Berg <rberg@berg-solutions.de>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] lan743x: correctly handle chips with internal PHY
Date:   Mon, 9 Nov 2020 21:03:03 +0100
Message-Id: <C2D2036C-9FDF-4AD4-BB80-C476CCD9BC14@berg-solutions.de>
References: <CAGngYiUy5D6xONticHdrcmwTtx4x6zsLXh_1V62k7yiQZFg7_Q@mail.gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGngYiUy5D6xONticHdrcmwTtx4x6zsLXh_1V62k7yiQZFg7_Q@mail.gmail.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
X-Mailer: iPhone Mail (17G68)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1604952200;75cc64b1;
X-HE-SMSGID: 1kcDNX-0002X3-RQ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.
> I would love to test this patch on fixed-link, but unfortunately

Yes, understandable, it’s quite dome effort. I will e-mail the company that owns the test setup. They have their own pcba‘s ready meanwhile, so maybe they can give me the EVM setup and I can use it for testing your and other patches.
