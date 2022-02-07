Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52C14AC861
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbiBGSQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 13:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244883AbiBGSJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:09:10 -0500
X-Greylist: delayed 1789 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 10:09:08 PST
Received: from smtpout-03.clustermail.de (smtpout-03.clustermail.de [IPv6:2a02:708:0:31::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5456CC0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 10:09:08 -0800 (PST)
Received: from [10.0.0.7] (helo=frontend.clustermail.de)
        by smtpout-03.clustermail.de with esmtp (Exim 4.94.2)
        (envelope-from <Daniel.Klauer@gin.de>)
        id 1nH7yg-0002uz-8d; Mon, 07 Feb 2022 18:39:07 +0100
Received: from [217.6.33.237] (helo=Win2012-02.gin-domain.local)
        by frontend.clustermail.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384
        (Exim 4.94.2)
        (envelope-from <Daniel.Klauer@gin.de>)
        id 1nH7yg-0004jF-3p; Mon, 07 Feb 2022 18:39:02 +0100
Received: from [10.176.8.31] (10.176.8.31) by Win2012-02.gin-domain.local
 (10.160.128.12) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Mon, 7 Feb
 2022 18:38:58 +0100
Message-ID: <c96e84a5-9920-d41a-cee2-b6c06ae99820@gin.de>
Date:   Mon, 7 Feb 2022 18:38:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net 1/7] net: dsa: mv88e6xxx: don't use devres for mdiobus
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        "DENG Qingfang" <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "Richter, Rafael" <Rafael.Richter@gin.de>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
 <20220207161553.579933-2-vladimir.oltean@nxp.com>
From:   Daniel Klauer <daniel.klauer@gin.de>
In-Reply-To: <20220207161553.579933-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.176.8.31]
X-ClientProxiedBy: Win2012-02.gin-domain.local (10.160.128.12) To
 Win2012-02.gin-domain.local (10.160.128.12)
X-EsetResult: clean, is OK
X-EsetId: 37303A29342AAB5361776A
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for this patch, with it the 5.16 kernel no longer BUGs on 
shutdown on our board (LX2160A + mv88e6xxx).

Tested-by: Daniel Klauer <daniel.klauer@gin.de>
