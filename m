Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED3151B072
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355018AbiEDV1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiEDV1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:27:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4604ECF3;
        Wed,  4 May 2022 14:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=t193kCtbz84k4NqKCB/hub8TFRvgLN7u8xZAZsAuxJw=; b=Ux
        r1z1r9vj0dyQ/xQAlBLIV2RAbSdFyLqwgy9DCU5aco08VXgJVtFsNTddy+f3lW1Pc0LuQ+9BPIXMg
        4pNYq712wFI1CQZGTwmoQH5t6tzqYg+h4Acba/IBFnJ+gFn0FulJiWs8mlg/bDUtd8tNhA6AxHrpE
        NVW52RFZqotG7VU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmMSp-001GMU-RI; Wed, 04 May 2022 23:23:15 +0200
Date:   Wed, 4 May 2022 23:23:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 1/4] dt-bindings: net: add bitfield defines for Ethernet
 speeds
Message-ID: <YnLuw2N76cv5eYky@lunn.ch>
References: <20220503153613.15320-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220503153613.15320-1-zajec5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 05:36:10PM +0200, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>

Hi Rafał

Please take a look at:

https://lore.kernel.org/netdev/1651616511.165627.139789.nullmailer@robh.at.kernel.org/T/

You need to somehow combine with that series. We want one way to
configure PHY leds.

Also, please don't post only DT patches, we want to see the driver
changes as well which goes with it.

    Andrew
