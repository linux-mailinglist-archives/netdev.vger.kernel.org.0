Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9B268AF4A
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 11:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBEKLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 05:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBEKLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 05:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733ED1BAD1;
        Sun,  5 Feb 2023 02:11:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 162F3B80B22;
        Sun,  5 Feb 2023 10:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D571CC433D2;
        Sun,  5 Feb 2023 10:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675591897;
        bh=BZ28gvdiTkc7YTOSLd75uiAxygPFFmTcSTP6m1bNxqs=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=DpiNPO/yo5p53P1JPencToMQjHKsTJ2kFzL2hGhgxgp4fJZZUUwNe31e8lY4Cf0KJ
         WIbEcuqmFc+Qryf6VCwPtT4IToJOjRWgHQCx4eQkQtuHcZE/m+IAPcsDEiCw2mJjOb
         uCrT1ZnjIoROaZeCjSd95FBq3qTnj1Pztve7TFs6Y0kAAgf+sQOelHQL+Q2g2um7U+
         Mu0CP3FGNzIipUTlUjANWW/qtuFTRzHL+EotFiWyOgaNsZ596no76pD0KdV8lJ1BPN
         ciMLUQAg3JYhyLsO3dVUbBvVd47kq0vnVA3d5pK3QOSj2iAyCL5BXHTqgAUa9Y5JQi
         g53qXWVGkCdog==
Date:   Sun, 05 Feb 2023 11:11:32 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     yanhong wang <yanhong.wang@starfivetech.com>,
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
User-Agent: K-9 Mail for Android
In-Reply-To: <Y96S/MMzC92cOkbX@lunn.ch>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com> <Y8h/D7I7/2KhgM00@spud> <81217dc9-5673-f7eb-3114-b39de8302687@starfivetech.com> <958E7B1C-E0FF-416A-85AD-783682BA8B54@kernel.org> <Y96S/MMzC92cOkbX@lunn.ch>
Message-ID: <4C150A01-7FB3-4609-8B8E-6F6023CC22AF@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4 February 2023 18:16:44 GMT+01:00, Andrew Lunn <andrew@lunn=2Ech> wrot=
e:
>> >For the patchs of yt8531, see [1]
>> >
>> >1 - https://patchwork=2Ekernel=2Eorg/project/netdevbpf/cover/202302020=
30037=2E9075-1-Frank=2ESae@motor-comm=2Ecom/
>>=20
>> Please put that info into the cover of the next round of your submissio=
n then=2E
>
>These patches just got merged, so it is less of an issue now=2E Just
>make sure you are testing with net-next=2E

Oh, cool=2E Water under the bridge so=2E
Sorry for the noise!

>You might need an updated DT blob, the binding for the PHY had a few
>changes between the initial version to what actually got merged=2E

Cool, thanks,
Conor=2E
