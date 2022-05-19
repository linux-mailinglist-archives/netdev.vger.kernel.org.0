Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36C852E07A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245715AbiESXWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245089AbiESXWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:22:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56579106343
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:22:49 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id y13so11887297eje.2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=a/pj+Mfp56zl5sHhmblMoQwDcoYok1hvSBKpEttikLU=;
        b=MBpnKwURWW3R76GIsEpyXAyUbRaBPXWbZ+s1lONCKg8CJyy0M6RvclHyPAvy3fqeJi
         gffzdc+ObN5EiblRxHlv94rboC0vDnCLnTIEHbwwoRmZTxbULm5YatllldnzImIeAsaB
         PtVcS67N/E49yx341fsIa8uwKzuWKpLhOn8g0Cr9p8MGY7XnMmDZr55kSXrRnR+LW3b1
         Nx3QifEJDceGn9SoEhZPWBS8aFayTwAC0RUrF4lKBcV/dzW0JL9AQqsyHhmmbyLdaljh
         EiUveDG3hcmaf7gTxA4g4WuWv8xrWO93qo1HObKe4+JKkwhxmfCMg9PFh2Sy0C1odL3E
         BS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=a/pj+Mfp56zl5sHhmblMoQwDcoYok1hvSBKpEttikLU=;
        b=4XNEkjJjQFUdtRqAZilT4nTMIZ3e2q5+mKaFbf4rVXldTp8qaG3mQ0WyCeOFl7cOvn
         hoihicjOmBjdQDhr2mfW97mXE1mSlJI9YckRyWppA3i7FmO25YJ6sDu5hH2eHe2yWb/+
         omPxCQqVoK7pXpJ0Y3L7J6p2Bn4ssJteACQV60CbYpYZKaUvLsgmEUw9ELBP/pR9f76K
         vsj7klL4SblON2f6Doh2JXobupyGjzOU85c+jDW81jgj881OW50jXB+/MUQkVQS/cYIx
         TPzawrEznZI1AGOy9waejxgM5tebDVvQyg2AGl4RV9BGcsFmEOBAgI0MMtvV3FQpUxko
         xrHg==
X-Gm-Message-State: AOAM530b4ZcHn377N/f9ANdheobIMiTY5kPi8B6MyLhNRL3nPTowUdIa
        jRqMyMZKsVp2LaJSn0kr6rk1pta5/cfAP178t7A=
X-Google-Smtp-Source: ABdhPJx4Y8xo04naCQvTBKjvPdQ2dxb7ubfB1KxkwvWRG1LrDXtQm1cr7yq0X1YASHRmfJmhwyikMMrgRNIwx8Wc8+0=
X-Received: by 2002:a17:907:3da1:b0:6fe:ae46:997d with SMTP id
 he33-20020a1709073da100b006feae46997dmr284360ejc.633.1653002567955; Thu, 19
 May 2022 16:22:47 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsshantelwilliams3@gmail.com
Received: by 2002:a54:3b0b:0:0:0:0:0 with HTTP; Thu, 19 May 2022 16:22:47
 -0700 (PDT)
From:   "Mrs. Rabi Affason Marcus" <affasonrabi@gmail.com>
Date:   Thu, 19 May 2022 16:22:47 -0700
X-Google-Sender-Auth: fLsstRCbpL87rtAYreD8xpJy6_U
Message-ID: <CAOZEOzvtO2CkMPgL6hms5U5wk1m+5fegn+Ca3p+W-8qYsiXdvg@mail.gmail.com>
Subject: PLEASE INDICATE YOUR INTEREST FOR MORE DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings my beloved,

My name is Mrs. Rabi Affason Marcus, I am from France. I contacted you
earlier concerning a Humanitarian Gesture Project for the poor and the
needs that I need your assistance to execute, but no response.
