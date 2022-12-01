Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF5D63E96B
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 06:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiLAFq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 00:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLAFqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 00:46:55 -0500
Received: from gw.red-soft.ru (red-soft.ru [188.246.186.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7315AA283D;
        Wed, 30 Nov 2022 21:46:53 -0800 (PST)
Received: from localhost.localdomain (unknown [10.81.81.211])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by gw.red-soft.ru (Postfix) with ESMTPSA id 0680F3E4023;
        Thu,  1 Dec 2022 08:46:51 +0300 (MSK)
Date:   Thu, 1 Dec 2022 08:46:49 +0300
From:   Artem Chernyshev <artem.chernyshev@red-soft.ru>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] net: dsa: Check return value from skb_trim_rcsum()
Message-ID: <Y4g/yVcE4gKo+2PE@localhost.localdomain>
References: <20221129165531.wgeyxgo5el2x43mj@skbuf>
 <20221129194309.3428340-1-artem.chernyshev@red-soft.ru>
 <20221130224618.efk7tjv54o57lolj@skbuf>
 <20221130225330.6ybtgsycioq2h73p@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130225330.6ybtgsycioq2h73p@skbuf>
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 173867 [Nov 30 2022]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: artem.chernyshev@red-soft.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;red-soft.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2022/12/01 04:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2022/12/01 00:48:00 #20630840
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Dec 01, 2022 at 12:53:30AM +0200, Vladimir Oltean wrote:
> One more thing. I gave you a Reviewed-by tag for v1. The patch submitter
> is supposed to carry it over to the applicable code in future patch
> revisions, below his Signed-off-by tag (see "git log" for examples).
> The reviewer is not supposed to chase the submitter from one revision to
> another with the same tags all over again. So I expect that v3 will have
> the tag added for the tag_ksz.c related change.

Thank you for detailed explanation. I'll fix flaws in patches as quickly
as possible.

Artem
