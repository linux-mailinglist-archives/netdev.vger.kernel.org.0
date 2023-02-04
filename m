Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5AF68AB98
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbjBDRQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjBDRQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:16:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61711BCF;
        Sat,  4 Feb 2023 09:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Rz2wOIqPJZoO1YMR0cT+YJTPsv/AXO3X485DH8BF1nU=; b=fZbe5zpPLTA1Jg2yRN6RjqixfX
        9cTWIUv5vfI1FJpaCr4kPo2trL/AiTmGcL8094Ii4hAgYKjaGRkc+L/sib7PxenptO2Lxt+8LisRl
        tE175eRIFdGTmCPiH50lsXV9Cjo2q99ILChfI5QV4udEmW5QkK5gYMgp1uB409+EHDmI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pOM9c-0046CH-PA; Sat, 04 Feb 2023 18:16:44 +0100
Date:   Sat, 4 Feb 2023 18:16:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conor Dooley <conor@kernel.org>
Cc:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v4 0/7] Add Ethernet driver for StarFive JH7110 SoC
Message-ID: <Y96S/MMzC92cOkbX@lunn.ch>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <Y8h/D7I7/2KhgM00@spud>
 <81217dc9-5673-f7eb-3114-b39de8302687@starfivetech.com>
 <958E7B1C-E0FF-416A-85AD-783682BA8B54@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <958E7B1C-E0FF-416A-85AD-783682BA8B54@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >For the patchs of yt8531, see [1]
> >
> >1 - https://patchwork.kernel.org/project/netdevbpf/cover/20230202030037.9075-1-Frank.Sae@motor-comm.com/
> 
> Please put that info into the cover of the next round of your submission then.

These patches just got merged, so it is less of an issue now. Just
make sure you are testing with net-next.

You might need an updated DT blob, the binding for the PHY had a few
changes between the initial version to what actually got merged.

     Andrew
