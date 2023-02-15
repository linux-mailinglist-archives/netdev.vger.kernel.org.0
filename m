Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D6B6973EC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjBOBwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 20:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBOBv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:51:58 -0500
Received: from out28-220.mail.aliyun.com (out28-220.mail.aliyun.com [115.124.28.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED2A29155;
        Tue, 14 Feb 2023 17:51:56 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2547287|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.011767-0.00220176-0.986031;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=11;RT=11;SR=0;TI=SMTPD_---.RMSivG-_1676425912;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.RMSivG-_1676425912)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 09:51:53 +0800
Message-ID: <02c16d4c-1e88-c9b4-4649-a6125c160c09@motor-comm.com>
Date:   Wed, 15 Feb 2023 09:51:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] net: phy: Uninitialized variables in
 yt8531_link_change_notify()
Content-Language: en-US
To:     Dan Carpenter <error27@gmail.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Y+utT+5q5Te1GvYk@kili>
From:   Frank Sae <Frank.Sae@motor-comm.com>
In-Reply-To: <Y+utT+5q5Te1GvYk@kili>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/2/14 23:48, Dan Carpenter wrote:

> @@ -1534,9 +1534,9 @@ static void yt8531_link_change_notify(struct phy_device *phydev)
>  {
>  	struct device_node *node = phydev->mdio.dev.of_node;
>  	bool tx_clk_adj_enabled = false;
> -	bool tx_clk_1000_inverted;
> -	bool tx_clk_100_inverted;
> -	bool tx_clk_10_inverted;
> +	bool tx_clk_1000_inverted = false;
> +	bool tx_clk_100_inverted = false;
> +	bool tx_clk_10_inverted = false;

Thanks, please keep reverse christmas tree.

>  	u16 val = 0;
>  	int ret;
>  
