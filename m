Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFDB53ECAE
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbiFFOET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 10:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiFFOES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 10:04:18 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501852BA941
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 07:04:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gd1so12911260pjb.2
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 07:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=0diyaDPPTei4VRk0k/tPJHiWIyHkkhA2GllK6jPG5V0=;
        b=Xh+vm2O0b+iuI00Y24usVjWukXqtAMjOrMLtsBD4Cei4hWq8XjKKK1ur2UeHA5PrVl
         4CzaJRinDVMCQ+iqx10oa0nxe1hVhYcibZRA5NuEfeVMsxFLBDtGolWqESYtbWpd8jk5
         t01kB4fSmDIgmYZo90eF+GeHb3/+z1imO5k6ME3rkaotlYtx3EFFUcj41WPo1+rP5yVn
         7G0EV4zMcHAIak0eU/XeMFLqrf7Vov39WlYycSJ8cAS9Ntf55aUgnmxwHVSpOtdYCJuD
         2dZ8sC/sT8chTyj5UxnSR9rQuzV0JV9OUAF7CMG9YyRxrcmGsOgzsmCyXt6lh7sjI8N6
         jNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0diyaDPPTei4VRk0k/tPJHiWIyHkkhA2GllK6jPG5V0=;
        b=CqflIopdg4UjoEbtk9gORp/i9A1ofmE5vVqAaIWxzO0d9KeegWBkkwTL0Z7emleIUN
         Oce+S8qFhOCcGXvXMkkiVWhOhdmzFPnIpZtSC7xc2k+va/Tvq568I0M+uaejmJ9/Q0cy
         gwfvcu+1QUGA+THlmm4rNXAewFu7VZ07Hp6DojAwTTm/wVDgxAcxF8FaNAabFT3UyCjR
         6/5H/YUnkm0u1zCOW7vpObSvMDMmSO68Osj/G+EJhzKlfoWfLBiNSfpC9GCX7S8b82gJ
         luHf6dUEuIMprem9Udo3tl5h+vtml9xH2QR0Q323lPNP8PRTbW3mTwlLUldrwEvX2hP3
         Pzzw==
X-Gm-Message-State: AOAM531ymEyGM/O7bCnd6iPZ0J3YZnls2dOVUTuB58UM/6m0knkzrHNP
        vwICshga90NsRM5yXaCtdH1hPWhexp2b+PqIFUU=
X-Google-Smtp-Source: ABdhPJwmh7JJVDj/9ka7TczD+P6+IP11Yq7Jgk6qF6Q8DtzzMBjhAZYpdeS/DZv7N1MfHdpmO6LyFauc7ifKrGP/nQM=
X-Received: by 2002:a17:902:d5ce:b0:167:6c02:754c with SMTP id
 g14-20020a170902d5ce00b001676c02754cmr10138841plh.135.1654524256683; Mon, 06
 Jun 2022 07:04:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:6982:b0:40:d348:faa7 with HTTP; Mon, 6 Jun 2022
 07:04:16 -0700 (PDT)
From:   Mr Cheng Dasha Lee <mrs.aishagadhafi@gmail.com>
Date:   Mon, 6 Jun 2022 16:04:16 +0200
Message-ID: <CA+rtw+NXHtiSb=7j3PmW2O76=ermqnseTdJY+H3NWF4FTbfHYA@mail.gmail.com>
Subject: GREETINGS,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assalam alaikum,
I have a proposal for you, however is not mandatory nor will I in any
A manner compel you to honor against your will. I am Mr Cheng Dasha Lee, I am a
Business partner with executive directors of Arab Tunisian Bank here in Tunisia;

I retired A year and 7 months ago after putting in 28 years of meticulous
service. During my days with Arab Tunisian Bank, I was the personal
account officer and one of the financial advisers to Mr. Zine
Al-Abidine Ben Ali the past Tunisian President in self exile at Saudi
Arabia. During his tryer period he instructed me to move all his
investment in my care which consists of US$115M and 767KG of gold out
of the Gulf States for safe keeping; and that I successfully did by
moving US$50M to Madrid Spain, US$50M to Dubai United Arab Emirate,
US$15M to Burkina Faso and the 767KG of gold to Accra Ghana in West
Africa as an anonymous deposits, so that the funds will in no way to
be traced to him. He has instructed me to find an investor who would
stand as the beneficiary of the fund and the gold; and claim it for
further investment.

Consequent upon the above, my proposal is that I would like you as a
foreigner to stand in as the beneficiary of this fund and the gold
which I have successfully moved outside the country and provide an
account overseas where this said fund will be transferred into. It is
a careful network and my voluntary retirement from the Arab Tunisian
Bank is to ensure a hitch-free operation as all modalities for you to
stand as beneficiary and owner of the deposits has been perfected by
me. Mr. Zine al-Abidine Ben Ali will offer you 20% of the total
investment if you can be the investor and claim this deposits in Spain
and Burkina Faso as the beneficiary.


Now my questions are:-

1. Can you handle this transaction?
2. Can I give you this trust?

Consider this and get back to me as soon as possible so that I can
give you more details regarding this transaction. Finally, it is my
humble request that the information as contained herein be accorded
the necessary attention, urgency as well as the secrecy it deserves
I expect your urgent response if you can handle this project.

Respectfully yours,
From:Mr Cheng Dasha Lee.
