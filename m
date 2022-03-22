Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36394E481E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 22:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbiCVVJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 17:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiCVVJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 17:09:43 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76FC41FB3
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:08:13 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c2so13492865pga.10
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=53R/g/LMvK/S7OERlC3PZ25IGM+OZr4T4ypuQ75WHCM=;
        b=S6Yl12p+8YMgCjKOoatNiWnOiBtl9Dg8Ktjrd93uNn67TN8T/ypIcvOwe2pfJbcFFZ
         lW+Oe3T+L6V1Vb2rFhuTJ5DpFt/ppMwsnjikURjuT7O9M+qB0S6pB58SuifLsgorGD7i
         jg36+thjdd0weoPS8Hslyjs2++tIRj0dUSaF6RbeYhzRvvOSxSfQY+VVG1W8OOYnMBjn
         DM/okQx0T0KnXUsNl6EJcJ5sjyXljOpkn8/BvoQgYMGkjucrhqBTuoR7YoDCHjTTe2uE
         HoR+ICG8mTTDdTLfCNcqdLIjzyAFanU5L6Oqv2q0pvz6UolY+Vus2jrUS2bv01LYV6Kf
         vN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53R/g/LMvK/S7OERlC3PZ25IGM+OZr4T4ypuQ75WHCM=;
        b=J1Fvgp461lZwIZTyPTev7jBQyufqV0RALr9tHGceAfU8YOI+fHmUHN2KaKCCLUY5ci
         ZwAB6SRZUM11flvfsz20mfrnRC3cauwvvadkX5ylDihHzLhnNHH8ahzV+cqyv+GsX4ef
         NCCs4OIHvItWtMI0uwHMNqraM2eeKAhjwZG/PjgS50E6ZqwsnjHMKbq8VW85U3lqivh4
         74VYERoR8cMlbqH+FxB8ni5PAjXJCikvENFP15gmOaorjaTSh03vImbYpdh1cWGJUjq8
         WUzTwvo2XbtvBWpA16ll1STgSiCPw2EkI0Tplsq0FJI3RqtZ2XbSh5PrPi/Ke0kzh9rM
         tkjA==
X-Gm-Message-State: AOAM531LCtWtyAIGUv3dsgtj4FgXM0ylXXU6ohozMu0g0C+5Oyxz+pmk
        NHa0v1gZA4bntMiMD4RsTqWi+gIoRgvEvtQJzK4=
X-Google-Smtp-Source: ABdhPJxUN+7dT3Fb/3D/OiowMWiIlGBX/ulRuAm5mtdFoi/yBVLLaJlz2h/nYlsY6Q7JUufZxyl64jHweq73s9wsYKQ=
X-Received: by 2002:a05:6a00:b96:b0:4fa:93cc:eadc with SMTP id
 g22-20020a056a000b9600b004fa93cceadcmr14414134pfj.74.1647983293280; Tue, 22
 Mar 2022 14:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAN9FmivnSq-AmNC32EEy__vmB+GSBn2YxSy-jBHZyiDf3ymgoA@mail.gmail.com>
 <YjizDlrhNrCzxpjn@lunn.ch>
In-Reply-To: <YjizDlrhNrCzxpjn@lunn.ch>
From:   Andreas Svensson <andreas93.svensson@gmail.com>
Date:   Tue, 22 Mar 2022 22:07:59 +0100
Message-ID: <CAN9Fmiu83wbnKmbY8wBwdkhbmH37W_Ly10ZYyMaTST3nX4H-Mw@mail.gmail.com>
Subject: Re: Comment about unstable DSA devicetree binding in marvell.txt
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 6:17 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Mar 21, 2022 at 06:03:59PM +0100, Andreas Svensson wrote:
> > Hi,
> >
> > I'm looking at using mv88e6xxx-mdio-external for the external MDIO
> > bus to communicate with a PHY.
> >
> > I couldn't help but notice the comment about the devicetree binding
> > being unstable in Documentation/devicetree/bindings/net/dsa/marvell.txt:
> >
> > "WARNING: This binding is currently unstable. Do not program it into a
> > FLASH never to be changed again. Once this binding is stable, this
> > warning will be removed."
> >
> > Any update on this, is marvell.txt still considered unstable?

Thanks for the fast reply Andrew.

> I personally would never write it to FLASH never to be changed
> again. I would always load the DT blob from disk, a version which
> matches the kernel. DT blobs do contain bugs and they need to be
> fixed.

Totally agree.

> The marvell binding has not changed for a long time, so in practice
> you can consider it stable. But just because it is stable does not
> mean DT blobs are bug free.

This is my understanding as well. I have not found any issues so far
using mv88e6xxx-mdio-external which is marvell binding specific.

Thanks for the clarification about the comment!

Best Regards,
Andreas
