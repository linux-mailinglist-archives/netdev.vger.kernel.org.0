Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BB46EF19B
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240417AbjDZKB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240396AbjDZKBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:01:14 -0400
Received: from out28-100.mail.aliyun.com (out28-100.mail.aliyun.com [115.124.28.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384674EC0;
        Wed, 26 Apr 2023 03:01:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3684256|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0756489-0.0141251-0.910226;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.SRApSpG_1682503259;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.SRApSpG_1682503259)
          by smtp.aliyun-inc.com;
          Wed, 26 Apr 2023 18:01:00 +0800
Message-ID: <04f4e968-946e-cbf0-3d78-cfe6cb17afb3@motor-comm.com>
Date:   Wed, 26 Apr 2023 17:59:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
To:     Samin Guo <samin.guo@starfivetech.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
 <20230426063541.15378-2-samin.guo@starfivetech.com>
Content-Language: en-US
From:   Frank Sae <Frank.Sae@motor-comm.com>
In-Reply-To: <20230426063541.15378-2-samin.guo@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/4/26 14:35, Samin Guo wrote:
> The motorcomm phy (YT8531) supports the ability to adjust the drive
> strength of the rx_clk/rx_data, the value range of pad driver
> strength is 0 to 7.
> 
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../devicetree/bindings/net/motorcomm,yt8xxx.yaml      | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> index 157e3bbcaf6f..e648e486b6d8 100644
> --- a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> @@ -18,6 +18,16 @@ properties:
>        - ethernet-phy-id4f51.e91a
>        - ethernet-phy-id4f51.e91b
>  
> +  rx-clk-driver-strength:
> +    description: drive strength of rx_clk pad.
> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
> +    default: 3
> +
> +  rx-data-driver-strength:
> +    description: drive strength of rxd/rx_ctl rgmii pad.
> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
> +    default: 3
> +

rx-clk-driver-strength and rx-data-driver-strength are not standard, so please add "motorcomm,".
rx-clk-driver-strength => motorcomm,rx-clk-driver-strength


>    rx-internal-delay-ps:
>      description: |
>        RGMII RX Clock Delay used only when PHY operates in RGMII mode with
