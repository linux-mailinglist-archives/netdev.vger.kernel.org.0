Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5969AD43
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjBQN6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBQN6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:58:42 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFBC6A056;
        Fri, 17 Feb 2023 05:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mn2YdWkFcL6Ae+Ff818yS4ufU/Ud2IoVDGKh7MUqoRQ=; b=EViK8fRXQtkgM55djQ/72gds7/
        lkJP8WWagq1/cxmOvPjfhv54besDmSyxTgOLcUM0/BzKJHtCYG3IpMy35R3XwQwasnWJNDtE4juXB
        H8YHTZ/v3XMH6OYNLTO5jNtJ0fAnpWvhDrzwGzg1FW3OfVGPhFqSr+u8lfQJH4Uo4pJA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pT0oX-005Hjw-FD; Fri, 17 Feb 2023 14:30:13 +0100
Date:   Fri, 17 Feb 2023 14:30:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH 07/12] dt-bindings: net: Add StarFive JH7100 SoC
Message-ID: <Y++BZWhJm1LpdrA9@lunn.ch>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-8-cristian.ciocaltea@collabora.com>
 <Y+e74UIV/Td91lKB@lunn.ch>
 <586971af-2d78-456d-a605-6c7b2aefda91@collabora.com>
 <Y+zXv90rGfQupjPP@lunn.ch>
 <cfa0f980-4bb6-4419-909c-3fce697cf8f9@collabora.com>
 <Y+5t4Jlb0ytw40pu@lunn.ch>
 <a824a7f6-0a62-7cab-180b-f20297311a2b@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a824a7f6-0a62-7cab-180b-f20297311a2b@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I would actually say it shows we don't understand what is going on
> > with delays. "rgmii" is not every often the correct value. The fact it
> > works suggests the MAC is adding delays.
> > 
> > What value are you using for starfive,gtxclk-dlychain ?
> 
> This is set to '4' in patch 12/12.
> 
> > Try 0 and then "rgmii-id"
> 
> I made some more tests and it seems the only stable configuration is "rgmii"
> with "starfive,gtxclk-dlychain" set to 4:
> 
> phy-mode | dlychain | status
> ---------+----------+--------------------------------------------
> rgmii    |        4 | OK (no issues observed)
> rgmii-id |        4 | BROKEN (errors reported [1])
> rgmii    |        0 | UNRELIABLE (no errors, but frequent stalls)
> rgmii-id |        0 | BROKEN (errors reported)
> 
> [1] Reported errors in case of BROKEN status:
> $ grep '' /sys/class/net/eth0/statistics/* | grep -v ':0$'

Thanks for the testing.

So it seems like something is adding delays when it probably should
not. Ideally we want to know what.

There is a danger here, something which has happened in the past. A
PHY which ignored "rgmii" and actually did power on defaults which was
"rgmii-id". As a result, lots of boards put "rmgii" in there DT blob,
which 'worked'. Until a board came along which really did need
"rgmii". The developer bringing that board up debugged the PHY, found
the problem and made it respect "rgmii" so their board worked. And the
fix broke a number of 'working' boards which had the wrong "rgmii"
instead of "rgmii-id".

So you have a choice. Go with 4 and "rgmii", but put in a big fat
warning, "Works somehow but is technically wrong and will probably
break sometime in the future". Or try to understand what is really
going on here, were are the delays coming from, and fix the issue.

      Andrew
