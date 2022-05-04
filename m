Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD12519E7A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 13:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349067AbiEDLvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 07:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbiEDLvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 07:51:23 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF90201B5
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 04:47:46 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bq30so1874490lfb.3
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 04:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=GBgQb/W5R93LBXwe1puEQIXZ/v4kYHy/Vvot2WDzYI0=;
        b=fuX+BfPlC1A/alsycE4nUZHBwmCnQRctuRurVXxyjqNw9L3q2XpLGw2cYYfBjTPO9v
         Uf5gRUPPrsgQ3DHHXHXOgmm1PEFqDfrTPrBZ3xWbXQhH1SsbOuGbQpoAQNUdRTKPlG0i
         IintJn8NNm+BIF0gHTI4/7eIhPE/uFEA/W01Li5TDcHEhytYgQSeVLt4PijCFC9x4tdW
         epXd46tTO1bby+thHdhuMKiqeDp+GHhm1IssEPIXXHoeOC/trzg9WRwBNRHcnVaemQK5
         60CALSYZU2YVj+e7gFpn8XWbavbmgBDn620C35DsECSM0pZeQI9E1Hki+rBBtCZU4g/c
         hGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=GBgQb/W5R93LBXwe1puEQIXZ/v4kYHy/Vvot2WDzYI0=;
        b=WLyCMAG5fyJgsOQwV0F3K8ymCcCoi/tQMbuf/5RLH18GmISJ0GFdym3UbmMt3XlqcX
         24U1sRPD8nIdmZX0kQkx2xibBvXgptG7f9PdMfEubvULhY6rBSrYZLj7JeM96Sumcj8F
         iDV1A6zaFaa6y0hE485qg/uOHgg6rjlOSHSg+NH8Q6Ul24qp8y6Q4vOn9hPipNSe4vAu
         rMVEph4Bgq1enm6xUU7niQvTJ+r9nQOhkwPcqwe3+sBlCuNzsugV1y+zFZLPpARLWw6Q
         WyAPYbgA0HDX8rPxUSe80Scif40NPh/otqYhZSbwQY9/XWYKZ45qKTPUFtS9Jz3R3Rrs
         4Vrw==
X-Gm-Message-State: AOAM5314lOuijwEJgtwCqa/ufnUsN0OkeZRaJJzzLRJhJuBaSABwxvhN
        MK5J6D/J8gr4acEZHoEtqG0EBC0fFZPpaHpL1g4=
X-Google-Smtp-Source: ABdhPJwXtqJLxDwoyOuu2alNy2NJG+zQr956vauCkzJSEP6YZo8BUeHisWpFXQRNkvOWGqn08L8ha3OLnwE+mHIPqbQ=
X-Received: by 2002:a05:6512:16a7:b0:445:862e:a1ba with SMTP id
 bu39-20020a05651216a700b00445862ea1bamr13052798lfb.85.1651664864893; Wed, 04
 May 2022 04:47:44 -0700 (PDT)
MIME-Version: 1.0
Sender: sdavid46620@gmail.com
Received: by 2002:a05:6504:1691:0:0:0:0 with HTTP; Wed, 4 May 2022 04:47:44
 -0700 (PDT)
From:   "Mr. Jimmy Moore" <jimmymoore265@gmail.com>
Date:   Wed, 4 May 2022 12:47:44 +0100
X-Google-Sender-Auth: -MAww_4oE0ONWe9xi4zMurBJJms
Message-ID: <CAE1Pi3q2BJDpNryZk5BcsskgW_yJ4qKu3R+dBz=BAL8Jr4zW4g@mail.gmail.com>
Subject: YOUR COVID-19 COMPENSATION
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,HK_NAME_FM_MR_MRS,LOTS_OF_MONEY,
        LOTTO_DEPT,MILLION_USD,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:136 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jimmymoore265[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sdavid46620[at]gmail.com]
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 HK_NAME_FM_MR_MRS No description available.
        *  1.0 FREEMAIL_REPLY From and body contain different freemails
        *  2.0 LOTTO_DEPT Claims Department
        *  2.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UNITED NATIONS COVID-19 OVERDUE COMPENSATION UNIT.
REFERENCE PAYMENT CODE: 8525595
BAILOUT AMOUNT:$10.5 MILLION USD
ADDRESS: NEW YORK, NY 10017, UNITED STATES

Dear award recipient, Covid-19 Compensation funds.

You are receiving this correspondence because we have finally reached
a consensus with the UN, IRS, and IMF that your total fund worth $10.5
Million Dollars of Covid-19 Compensation payment shall be delivered to
your nominated mode of receipt, and you are expected to pay the sum of
$12,000 for levies owed to authorities after receiving your funds.

You have a grace period of 2 weeks to pay the $12,000 levy after you
have received your Covid-19 Compensation total sum of $10.5 Million.
We shall proceed with the payment of your bailout grant only if you
agree to the terms and conditions stated.

Contact Dr. Mustafa Ali, for more information by email at:(
mustafaliali180@gmail.com ) Your consent in this regard would be
highly appreciated.

Best Regards,
Mr. Jimmy Moore.
Undersecretary-General United Nations
Office of Internal Oversight-UNIOS
UN making the world a better place
http://www.un.org/sg/
