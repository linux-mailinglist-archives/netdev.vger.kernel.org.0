Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22441690EC1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBIRAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjBIRAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:00:10 -0500
Received: from mr85p00im-zteg06011501.me.com (mr85p00im-zteg06011501.me.com [17.58.23.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2607D6467F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 09:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1675962007; bh=9SoWufoa6fwEHefnS455/PdhOj3uOv+LruSHJSZAeo0=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=Y0LVhzxwcxTUXeuOG+WPP808SpDz9YN7KU0OQqehLsJ/IWgraQr6ZBe12MrVaNpXk
         xDCU8/UvTAA/7UvsuUf51uISmYF3VxhQjK+FQPA5Vp+MkzHnwXmp3gkFP00shTcQ5n
         TUByWfyEIO51w3D+2eA9Vyp7QpaC7Rhwp1tAPpkUQH3MQeRo4WNKT0+baUPdO2klh0
         rDrioDKaRw7xtk4MVl93HnPL2PIyDv3zQ9kXVKEwrTh3wO9W0NCPXAQNmhRJZLU0qt
         qksUqNbX+YBwFgi6yD/HOsx6xZ46Kf3QubMQr78mb7yu750Uuq2fau3RyOsjHMbdvD
         3ESU6hKU79q2Q==
Received: from imac101 (mr38p00im-dlb-asmtp-mailmevip.me.com [17.57.152.18])
        by mr85p00im-zteg06011501.me.com (Postfix) with ESMTPSA id 1A9284805C8;
        Thu,  9 Feb 2023 17:00:01 +0000 (UTC)
Date:   Thu, 9 Feb 2023 17:59:58 +0100
From:   Alain Volmat <avolmat@me.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
        Daniel Lezcano <daniel.lezcano@linaro.org>,
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
Subject: Re: [PATCH 09/11] dt-bindings: reset: remove stih415/stih416 reset
 bindings
Message-ID: <Y+Umjs66mx7LCr8y@imac101>
Mail-Followup-To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org
References: <20230209091659.1409-1-avolmat@me.com>
 <20230209091659.1409-10-avolmat@me.com>
 <a7bbc64d-1b16-490a-5424-4a2f08aba111@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7bbc64d-1b16-490a-5424-4a2f08aba111@linaro.org>
X-Proofpoint-GUID: FDo7WBUMFrvgJQVoLgvu_j1-qoz2I80w
X-Proofpoint-ORIG-GUID: FDo7WBUMFrvgJQVoLgvu_j1-qoz2I80w
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.816,17.11.62.513.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-18=5F01:2022-01-14=5F01,2022-01-18=5F01,2021-12-02?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1011 spamscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2302090161
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 10:32:04AM +0100, Krzysztof Kozlowski wrote:
> On 09/02/2023 10:16, Alain Volmat wrote:
> > Remove the stih415 and stih416 reset dt-bindings since those
> > two platforms are no more supported.
> 
> Subject: drop second/last, redundant "bindings". The "dt-bindings"
> prefix is already stating that these are bindings.
> 
> This applies to your other patches as well.

Thanks for the review.  I corrected that and will push a v2 once
I got further comments about the overall serie.

> 
> > 
> > Signed-off-by: Alain Volmat <avolmat@me.com>
> > ---
> >  include/dt-bindings/reset/stih415-resets.h | 28 ------------
> >  include/dt-bindings/reset/stih416-resets.h | 52 ----------------------
> >  2 files changed, 80 deletions(-)
> >  delete mode 100644 include/dt-bindings/reset/stih415-resets.h
> 
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Best regards,
> Krzysztof
> 
