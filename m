Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DDB696645
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjBNOPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbjBNOPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:15:30 -0500
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A24B2137
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:15:01 -0800 (PST)
Received: by mail-vk1-xa32.google.com with SMTP id v189so8011647vkf.6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZGmGzEBf88NZV2L0gZd+dlXSRGe6cc2y3WGO1trIsQ4=;
        b=LPIvM3qsEeYhpX+4cWw23tCN5cnB+hJpv5X7Up4nbIqT663Qc48wqUhMGKuz2+6Dzz
         Ug87EOJhgEPvW6LhFXj6PKDA+Xo0+gVsip45hVVkjfsM1GyyNSH+jxE5aEOhjmtbWPtc
         q5mlpvTZcJ3DaLCBqZL38eTX0HWu77omKR0tGb1/Nuqr+sX442GC9E/Wzl1kwsUSv9Xp
         iASV61UshGvIXBY37aPkKss9euognrY7/MHJIh3muiNKkZPinRtSZOm5ESzuKx9apUXA
         awQdoh+P48gOBayzO4LhPj/VCvowbk3o8i5vk1U9ypkfPmlzIczS8f4OGNxjySiRALkY
         RGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZGmGzEBf88NZV2L0gZd+dlXSRGe6cc2y3WGO1trIsQ4=;
        b=aApbqLScbs3uu5uxKcSLLljZB0EHkfYOPudaCoDt5EVyVpuXcZJjnX/7e6D1VS/OJu
         fBhqDokPasMgBXIVjlfWpn74Vr0Whr/i9ic4ze/ZmCcyxEVS3MjI3F4Wydo518N/iF1b
         ORTxb+hx/TFsSTgV7iLws54aw+jEWU1E0GsYIXSMOBD3eMZJLibE32P+X+QBMrjLaBrL
         4UghuGXz1/e8jjhYUGtcwxjN0D2U4rfRV5thmkH8w/nyAhdzOm4SxiBDYrLJ+aJNpl7N
         yjbGmnDBeBU7wRNEgJ/YMF403CuHzVjVGVdjGhN3WT5mN1akBIQj6Pf0bwuHPMfJXIou
         2GMQ==
X-Gm-Message-State: AO0yUKXJFwEuDRDsMknlCkPaZV0hEu8qAQVxeGdCqPpASwsbDoEZ5u9f
        q/c+LFmc9M9laX/5LHtno92M+O3/cvftLznISQp7joWMMZI=
X-Google-Smtp-Source: AK7set9t2O7xWBSi09aI6uVHsJxhEVcQg8D5JE6F4ak6IEgpXq3Op8Y3UPPISsltHSsfLgxZP8O0Z731Nb5IMJKxC8A=
X-Received: by 2002:a1f:aa85:0:b0:401:a873:7bd with SMTP id
 t127-20020a1faa85000000b00401a87307bdmr379965vke.6.1676384055253; Tue, 14 Feb
 2023 06:14:15 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:ce0c:0:b0:39b:db4e:223 with HTTP; Tue, 14 Feb 2023
 06:14:14 -0800 (PST)
From:   Stephen jack <sj9787861@gmail.com>
Date:   Tue, 14 Feb 2023 19:44:14 +0530
Message-ID: <CAEHmQJE+WtnE+gC_F42_YhMffaGkStZ50DS2TWPQYDehcPDcxw@mail.gmail.com>
Subject: Business proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=ADVANCE_FEE_4_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a32 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5345]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sj9787861[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sj9787861[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.5 ADVANCE_FEE_4_NEW Appears to be advance fee fraud (Nigerian
        *      419)
        *  3.3 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 


-- 
Sorry for intruding into your privacy
I am Mr.Stephen Robinson,
Compliment of the season.

I got your contact email from the international business directorate
and I decided to let you know about the lucrative business
opportunity of supplying a raw material to the company
where I work as a staff,
I am an employee to a multi international company.

we use a certain raw material in our pharmaceutical firm
for the manufacture of animal vaccines and many more.

My intention is to give you the contact information of the
local manufacturer of this raw material in India and every
detail regarding how to supply the material to my company
if you're interested, my company can pay in advance for this
material.

Due to some reasons, which I will explain in my next email,
I cannot procure this material and supply it to my company
myself due to the fact that I am a staff in the company.

Please get back to me as soon as possible
for further detail if you are interested.

Thanks, and regards
Robinson.
