Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14AF4DAD96
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354916AbiCPJgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354912AbiCPJgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:36:50 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466492E0A4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:35:35 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id d6so886143vkn.7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=X41+jG72x03P7WchvoWXtwXk/0DV9vHShkJLSHTwz4A=;
        b=fXMbZqG7MlcS4n5zMLeHAZbJOTDxIlbOPZseXUVy74od0KsH9YV+e43U6BUc1sqqH3
         H2Taw4GkBC9SvVtJvU5wJv59bIX28CicfF0htNaj3vaJ9v9QraQ+n3O1ukQjGGRjRQvK
         leTWbljIfDdgni8tWGO5xQyr9m9D8uDp0fM7bp0rdnwY5putrft8merflBbd/zXPoSYX
         6m21PmicQnxaJilHPNy4KP4sJaQ6HKZMa2qR4ff0PN6QSRm81DmFaHHvAQTRQUpFOfwy
         N2rHAlNnnZ7wFkv3qpCrVNGo5oC0VSu++yKGCaKPRGEg9x+Kf0LR2iLxyPzvjbXqQ+Eh
         NVfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=X41+jG72x03P7WchvoWXtwXk/0DV9vHShkJLSHTwz4A=;
        b=IdqD8er/NaSV4v7exo+BrO71TJcCvwfGjX18ElpPSbIbEaltTz8K2yZ23tQVDDaoqN
         K5u6eutD28TWRH57uf1MCLqibelQU1OUvn8weZJd3LMrWgla4eaS3kwK3DXkgkwQScw4
         kvYftM+7y7FnIAX6/4/p0D85tRac3wT5J2iXgZV4TSMHsrYNKHMDC9tihORl9zXQ2tEQ
         8UYwsdaDmvTpmHLXEbQILr4/9jIFKf1MXT5sZ+qFB7Beuz35Os7ea+WvdOoXm318Gfdq
         VfGS5f8AkURJvRS0EbRIARtvX61FeRMeoxJsUOZoM/Z3YuVkowchvdybt63Ny67UlNH1
         Fw0Q==
X-Gm-Message-State: AOAM533zpWJqvGp8vIHVLMzXXz/k3MwGgebCeNQeQzxoofAKFdQU7qXa
        CtW1oPGN0IetvIPaM7YpM5jkmJ+pAjF/itHAPQA=
X-Google-Smtp-Source: ABdhPJzSSiJuQekb8yu0JgbtkEelcrtRWO0++tTUPYpOJUIGPADOL753ys3dWurgDxEU+kwo3W6VCkwD3n5DNFj+t/s=
X-Received: by 2002:a1f:6101:0:b0:336:ea3c:48b0 with SMTP id
 v1-20020a1f6101000000b00336ea3c48b0mr13107349vkb.19.1647423333893; Wed, 16
 Mar 2022 02:35:33 -0700 (PDT)
MIME-Version: 1.0
Sender: aliamohamed495@gmail.com
Received: by 2002:a59:c58e:0:b0:29c:1ca2:c18 with HTTP; Wed, 16 Mar 2022
 02:35:33 -0700 (PDT)
From:   "Dr. Aisha al-gaddafi." <dr.aishaalgaddafi09@gmail.com>
Date:   Wed, 16 Mar 2022 09:35:33 +0000
X-Google-Sender-Auth: aFR0TV6xZCrVH5UW2U6Oy0hhbX8
Message-ID: <CAFe_VbW2m0R4tEU3KcewqUj2djWd=Pp=D0W4mU8W25ShAS3=Vg@mail.gmail.com>
Subject: Hola
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aliamohamed495[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aliamohamed495[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am Dr. Aisha al-Gaddafi, the daughter of the late Libyan president,

 i am contacting you, because I need a Partner or an investor

Who will help me in investing the sum of $27.5 MillionUSD  in his or
her country?

The funds are deposited  in Burkina Faso, where I am living for the
moment with my children Please after reading this mail try to  contact
me through  this my private email if you really want me to see your
response

Thanks, I await your response

Dr. Aisha al-gaddafi.
