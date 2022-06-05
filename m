Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC2F53DC75
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 17:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345410AbiFEPLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 11:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbiFEPLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 11:11:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC5C24963;
        Sun,  5 Jun 2022 08:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iWUbGe4LrkszuU4l/we/4GAXrYyZL/tQclEBTdqNsUU=; b=wkdQflUSAzs9i1PnUB+Eg2PW06
        dMUud3WOM8o9J0P01ibvjsMW4vzeyI/PVVWMvGihfz1oR1OT1Ng4NJK2QcSYb3C5HZiKIiVM6c3kH
        HMgIlQhv9GN2OS0mM3qeNwey0w5fNY6c68nFdN12I5prpmBcDgvexqi/bl40dr5svV4s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nxruA-005eSM-HH; Sun, 05 Jun 2022 17:11:02 +0200
Date:   Sun, 5 Jun 2022 17:11:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org, nm@ti.com,
        ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, rogerq@kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, kishon@ti.com,
        robh+dt@kernel.org, afd@ti.com
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Message-ID: <YpzHhsPlbKLecUdO@lunn.ch>
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-2-p-mohan@ti.com>
 <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
 <faff79c9-7e1e-a69b-f314-6c00dedf1722@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faff79c9-7e1e-a69b-f314-6c00dedf1722@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> He said ethernet-port is preferred but all other drivers were using
> "port" so I though it is not compulsory. Will change it if it compulsory
> to use ethernet-port
 
It is a good idea to mention this in the change history. It is then
clear you have considered it, but decided against it.

      Andrew
