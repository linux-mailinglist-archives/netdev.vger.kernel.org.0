Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9198B55A631
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 04:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiFYCjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 22:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiFYCjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 22:39:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936563B031;
        Fri, 24 Jun 2022 19:39:15 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id n12so4112216pfq.0;
        Fri, 24 Jun 2022 19:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uxeJZ2NEpdr/p0H0bAwKdFlOkVDS+ePjkPNzrVO3Wx0=;
        b=dyysU6bgFbOZ8bYsIz6ztYIp2ehSIF8Q0RWPA0OT+CNiCKAzRfIxOh9+z9sGahhZdJ
         Lukdntkuc6F3WDxos7yMEch0GPmvYwGg8iOIdIpVjNlS7jWq11+dNnAMV2/4gcXNrFpG
         E6MplOKW/ic4G9qs07vTe76/AwgiItn20WES3SRk0PhrTc9LmUQMu+mfQWLll3JV0Gtf
         XEODVPMejOWNNxlubZF7vHx2OnDW4lhzl7S5NxYzJgmqC7ePF56eiSa4bi2K0C00aMV7
         FFhdLDQ3MzqXQqKKVtMOD6qNrhQ6AU6AeJAOcqSnFav0qKd0L5ATD/gI4BwXw+Al+7vF
         i9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uxeJZ2NEpdr/p0H0bAwKdFlOkVDS+ePjkPNzrVO3Wx0=;
        b=fqvYJVNZbBccoh2Qamfj4/fFzLWNefv87DCu3oIINGWPPiXUikPk75PipaKz0Unjx2
         zbL22wP3/7F6fryTBlP2XNB0nMduu1XXK+6ixe77nP34gkYynwzXxj7AsiZ8rb5Cx+6g
         ukCmmcJ53AOtEaZJmZN7AKj7Byce+bZ14uN7MqVDryXm6/bPQlhk/4AwZ+l5+2XDN+C6
         /dxndIvhlm2GjsGeZ0AaInBtEQmFyAfdL9faZbdllZu7S1eSCrsX38xzeH37C4IB7auX
         WSCfW9H0ZA4VHH6/4y1r7CrYLz7Mduv6yai3PJnEjmUovvguFHRWzhQTb+wOb9c4cD5q
         /5fw==
X-Gm-Message-State: AJIora9HJ2mFC/r0SALkQOnO0YIfp8Zwt3+2PXJqpXTOYKm/4fer6zhO
        UOZTP5e/QAyDabjD9k1pDrk=
X-Google-Smtp-Source: AGRyM1vuOKlLZJBWdS5XjU9X8M7sgfMlCEc6NTsizgz50b832+vGNausbZ8s2Aowqmz2TTmr0dJQsg==
X-Received: by 2002:aa7:838c:0:b0:525:3816:2340 with SMTP id u12-20020aa7838c000000b0052538162340mr2240910pfm.35.1656124755029;
        Fri, 24 Jun 2022 19:39:15 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:edae:5ad3:3d10:1075? ([2600:8802:b00:4a48:edae:5ad3:3d10:1075])
        by smtp.gmail.com with ESMTPSA id bf3-20020a170902b90300b0015f2b3bc97asm2503608plb.13.2022.06.24.19.39.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 19:39:14 -0700 (PDT)
Message-ID: <e3bf16d2-01c1-303f-03c0-378fc109713a@gmail.com>
Date:   Fri, 24 Jun 2022 19:39:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v9 14/16] ARM: dts: r9a06g032: describe switch
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220624144001.95518-1-clement.leger@bootlin.com>
 <20220624144001.95518-15-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220624144001.95518-15-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2022 7:39 AM, Clément Léger wrote:
> Add description of the switch that is present on the RZ/N1 SoC. This
> description includes ethernet-ports description for all the ports that
> are present on the switch along with their connection to the MII
> converter ports and to the GMAC for the CPU port.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
