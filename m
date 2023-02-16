Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0AF699D54
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 21:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjBPUEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 15:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBPUEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 15:04:42 -0500
X-Greylist: delayed 330 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 12:04:40 PST
Received: from ms11p00im-qufo17281701.me.com (ms11p00im-qufo17281701.me.com [17.58.38.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83F4497FF
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 12:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1676577550; bh=zdrd5hFqfnMpxxDPi4zR591CnSfBLmMkbGQ0MsTc1So=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=1RZs9rC0XqIcV0LqrgIvnTSum2tff1FRGXc0vg528niD1ATMXJmiAdIkW/uMDO9fP
         3IRBujlF7x0F1tUfeP/V+v85GeJOsK+e9USZSR1U31TEj+a31shBjpIfMA3vQW0GgQ
         m9iGgsB+ksZrhOIgH1s6dZ3kQaIooO/kaPNuehONSh1zeyT4ApXh4EKMCiP5ZpQqZm
         XxVIDGajX2ttN9uBTHCvAu4R4uQfnO/MNuE6X0WSAyzlnNhY217SVX3bVdotB4hZOc
         IM6yjbVDJnXaqDsN6q7kvU47i2DNbboNHYaKp42hkyE5vaFQnpVSsZ268Pvw/kPWCy
         NNH0U68QXj84g==
Received: from imac101 (ms11p00im-dlb-asmtpmailmevip.me.com [17.57.154.19])
        by ms11p00im-qufo17281701.me.com (Postfix) with ESMTPSA id 1750F7435AA;
        Thu, 16 Feb 2023 19:59:04 +0000 (UTC)
Date:   Thu, 16 Feb 2023 20:59:01 +0100
From:   Alain Volmat <avolmat@me.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Message-ID: <Y+6LBeMIxXDw0JF7@imac101>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
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
 <Y+YKeVoq91/mtlo2@imac101>
 <20230210101320.331c1d95@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210101320.331c1d95@kernel.org>
X-Proofpoint-ORIG-GUID: 25eaZDf0VAVPiYGYD3wSD__bVUWeAGEp
X-Proofpoint-GUID: 25eaZDf0VAVPiYGYD3wSD__bVUWeAGEp
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 clxscore=1015 spamscore=0 mlxlogscore=707 mlxscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302160172
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 10:13:20AM -0800, Jakub Kicinski wrote:
> On Fri, 10 Feb 2023 10:12:25 +0100 Alain Volmat wrote:
> > Having seen situations like that for some other series I was guessing
> > that each maintainer would apply the relevant patches on his side.
> > Those two platforms being no more used, there is no specific patch
> > ordering to keep.
> > 
> > I've actually been wondering at the beginning how should I post those
> > patches.  If another way is preferrable I can post again differently
> > if that helps.
> 
> You'd have most luck getting the changes accepted for 6.3 if you split
> this up and resend to individual maintainers.

Alright, since those patches do not have real dependencies between each
others, I won't update this serie and send the patches separately to
their related maintainers.
