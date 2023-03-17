Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C176BE2F2
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCQIUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjCQIUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:20:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3067D589B;
        Fri, 17 Mar 2023 01:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF2D8B824DB;
        Fri, 17 Mar 2023 08:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEF8C433D2;
        Fri, 17 Mar 2023 08:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679040858;
        bh=2xB2mT32ve+cPvMoyMEWr/WHQwF5/3cn9Vw7Tloef3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SM2WNcTX+Rs0C+RBJFKAXcjcNUwolzWRbaV6P3ifOl1TAClp2q2pDaMk2P0jyWFrb
         kBHAylp4KeAxfb3eOjDClEqVou+aTHIR2sOV9xGP4GwaEpPZjAARTybeGLndxE/N/n
         IJD/rB+oBPynsPFTMBHmJ9tlNb1UASJpYvRn7yAkc0imKG1MJqWqqTE2vcJ9NDDc1i
         1m8RIvFr4jxgif8GxEms8P5zyNCy1RzGIFyUY8gGB2rwp41nYAWdwL1hjIfuzNfgT5
         755D4mxxp1q60JmnfAqFfK8EfaTiWiBZN4YqC7un9S2oV8kOKUpZWKyHam49n4NURw
         9IoF0RumcFk+w==
Date:   Fri, 17 Mar 2023 09:14:10 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org, pavel@ucw.cz
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v4 10/14] dt-bindings: net: dsa: qca8k: add
 LEDs definition example
Message-ID: <20230317091410.58787646@dellmb>
In-Reply-To: <20230317023125.486-11-ansuelsmth@gmail.com>
References: <20230317023125.486-1-ansuelsmth@gmail.com>
        <20230317023125.486-11-ansuelsmth@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.35; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Christian, also Rob Herring, Andrew Lunn and Pavel Machek,

On Fri, 17 Mar 2023 03:31:21 +0100
Christian Marangi <ansuelsmth@gmail.com> wrote:

> Add LEDs definition example for qca8k Switch Family to describe how they
> should be defined for a correct usage.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 389892592aac..2e9c14af0223 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -18,6 +18,8 @@ description:
>    PHY it is connected to. In this config, an internal mdio-bus is registered and
>    the MDIO master is used for communication. Mixed external and internal
>    mdio-bus configurations are not supported by the hardware.
> +  Each phy has at least 3 LEDs connected and can be declared
> +  using the standard LEDs structure.
>  
>  properties:
>    compatible:
> @@ -117,6 +119,7 @@ unevaluatedProperties: false
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/leds/common.h>
>  
>      mdio {
>          #address-cells = <1>;
> @@ -226,6 +229,27 @@ examples:
>                      label = "lan1";
>                      phy-mode = "internal";
>                      phy-handle = <&internal_phy_port1>;
> +
> +                    leds {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        led@0 {
> +                            reg = <0>;
> +                            color = <LED_COLOR_ID_WHITE>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            default-state = "keep";
> +                        };
> +
> +                        led@1 {
> +                            reg = <1>;
> +                            color = <LED_COLOR_ID_AMBER>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            default-state = "keep";
> +                        };
> +                    };
>                  };

I have nothing against this, but I would like to point out the
existence of the trigger-sources DT property, and I would like to
discuss how this property should be used by the LED subsystem to choose
default behaviour of a LED.

Consider that we want to specify in device-tree that a PHY LED (or any
other LED) should blink on network activity of the network device
connected to this PHY (let's say the attached network device is eth0).
(Why would we want to specify this in devicetree? Because currently the
 drivers either keep the behaviour from boot or change it to something
 specific that is not configurable.)

We could specify in DT something like:
  eth0: ethernet-controller {
    ...
  }

  ethernet-phy {
    leds {
      led@0 {
        reg = <0>;
        color = <LED_COLOR_ID_GREEN>;
        trigger-sources = <&eth0>;
        function = LED_FUNCTION_ ?????? ;
      }
    }
  }

The above example specifies that the LED has a trigger source (eth0),
but we still need to specify the trigger itself (for example that
the LED should blink on activity, or the different kinds of link). In my
opinion, this should be specified by the function property, but this
property is currently used in other way: it is filled in with something
like "wan" or "lan" or "wlan", an information which, IMO,
should instead come from the devicename part of the LED, not the
function part.

Recall that the LED names are of the form
  devicename:color:function
where the devicename part is supposed to be something like mmc0 or
sda1. With LEDs that are associated with network devices I think the
corresponding name should be the name of the network device (like eth0),
but there is the problem of network namespaces and also that network
devices can be renamed :(.

So one option how to specify the behaviour of the LED to blink on
activity would be to set
  function = LED_FUNCTION_ACTIVITY;
but this would conflict with how currently some devicetrees use "lan",
"wlan" or "wan" as the function (which is IMO incorrect, as I said
above).

Another option would be to ignore the function and instead use
additional argument in the trigger-source property, something like
  trigger-sources = <&eth0 TRIGGER_SOURCE_ACTIVITY>;

I would like to start a discussion on this and hear about your opinions,
because I think that the trigger-sources and function properties were
proposed in good faith, but currently the implementation and usage is a
mess.

Marek
