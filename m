Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD1D691AF8
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 10:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjBJJMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 04:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbjBJJMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 04:12:36 -0500
Received: from mr85p00im-ztdg06021101.me.com (mr85p00im-ztdg06021101.me.com [17.58.23.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934F737720
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 01:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1676020353; bh=ILKYIIRd6kMS4UnYulq9JOaUkpq0+0KEk+MTEwNILxs=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=Mi7CnmPz4rSN/7Vqyzsw/sfB06lbDNCPNrRa5O0R1zgwLa3xqCQivZUjBUmM1p8t8
         +Y2pRd/s0KoSW+udC8jAT0gXAbvHDZ66rKN6yiCU823KaWgy1gJlCRZ9alyEjJVJG8
         KMudh7LgiwTHtENBUeKjmnS19dSvx5r3oEeEWynv/M6i3Uy7SycvKttiy/Y5CTZDbz
         svZSYbB0eE86gWv3tW0MFC7RLo+P7DfdxJ1fmUjVZEdryStOANihbuslwIKf3XZifm
         zgzu5jkIMSVzNSuVpjTa3nEeyuwuN4EMs7++yKvj/HeCuf4p9cCqn9dKiapx2DfNRm
         X9TEgLlX6hBWw==
Received: from imac101 (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-ztdg06021101.me.com (Postfix) with ESMTPSA id B454D80B94;
        Fri, 10 Feb 2023 09:12:28 +0000 (UTC)
Date:   Fri, 10 Feb 2023 10:12:25 +0100
From:   Alain Volmat <avolmat@me.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: Re: [PATCH 00/11] ARM: removal of STiH415/STiH416 remainings bits
Message-ID: <Y+YKeVoq91/mtlo2@imac101>
Mail-Followup-To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Amit Kucheria <amitk@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org
References: <20230209091659.1409-1-avolmat@me.com>
 <20230210090420.GB175687@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230210090420.GB175687@linaro.org>
X-Proofpoint-ORIG-GUID: JHGVi_UVrX6scGCC87yDBtTbmYZETUZI
X-Proofpoint-GUID: JHGVi_UVrX6scGCC87yDBtTbmYZETUZI
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 mlxlogscore=716 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302100080
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:04:20AM +0100, Daniel Lezcano wrote:
> On Thu, Feb 09, 2023 at 10:16:48AM +0100, Alain Volmat wrote:
> > Most of code in order to support STiH415 and STiH416 have already
> > been removed from the kernel in 2016, however few bits are still
> > remainings.
> > This serie removes the last pieces of support for STiH415, STiH416
> > and STiD127.
> 
> How would like to have the patches applied ?
> 
> Ack from the different maintainers or each maintainer apply the relevant patches ?

Having seen situations like that for some other series I was guessing
that each maintainer would apply the relevant patches on his side.
Those two platforms being no more used, there is no specific patch
ordering to keep.

I've actually been wondering at the beginning how should I post those
patches.  If another way is preferrable I can post again differently
if that helps.

Thanks
Alain

> 
> Thanks
>   -- Daniel
> 
> -- 
> 
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
