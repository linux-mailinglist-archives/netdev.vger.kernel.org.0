Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77994D4183
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 08:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbiCJHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 02:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiCJHH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 02:07:29 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEAE1301A6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 23:06:29 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id z30so9152317ybi.2
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 23:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=A7SqxPeuATRIawRLPRXdbXUmc+x9RhbBGbJAJobYDWo=;
        b=BsL44mEFQELwdZa7t40gSpAkFJEx/LNk8Yb1aupLF7+xGSbDJFUjkcNOswWlxDCw9d
         Ofr6tJrFqV0NYYbo/x3ea8UWDzyZ2yRTqkHk0/yQG2TpnMoYH3GRCwVwZxqZbLHzLpMR
         fJq4fI15c6YbskwHTUoKNn5LC8gZqrszRMmhQtqKa+aMrOB8AYeqX3IcN7K9wKYyHa/c
         QScfB+lMu7XnaGT5tziQqgYXMZKQjTpHtLFN9vjrVxK/D9MTfoERXMXBVSAi1AmYwsnH
         xJQrsT+Z05t8niq9zrl0KZFGK3UrrFqDx8iy7QgddFb6qMcPOctEjhd2c9rPR409Cywf
         LbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=A7SqxPeuATRIawRLPRXdbXUmc+x9RhbBGbJAJobYDWo=;
        b=ee/XP06o24kRnYAXHNDLpI+46GO+xooAcLjWy+FXJX6bvNMAkOyCVq1DL6fGyHeaNw
         8ie0p33oJqYTttSR1Zf2p5yPBCCT/s2sJImFIVhJvNU6j2GPWw48WwL/pThlvmYx0J5Z
         Tf7psAQfu+lUgHUsIZIXoliJGK2ttzbdzxamEM1XzPa+oxEamoYgFutyg4iCgzdgS0pr
         At90jLmhT/wxb4VFAPzTbYjZAd98QgOh4ssM1J6/m0taY4yqeq/4oU/D0hRhTPgN88qE
         vvEbpdMF2IH/AXh3AVzzvI+QInxgrwh13e+a/TtM/aNmyBIioAvygoqzriAlVXcEjYg5
         hNuw==
X-Gm-Message-State: AOAM533mQUrQHHQVFN/t5U5MdmOmxSourHWFoTlpBalGPPEFHlAsKBQG
        CZIb8ofqODaNB5sP2QV6mYHwyasdZ+VQu9/Sez2h6c6TA9ZPxw==
X-Google-Smtp-Source: ABdhPJyHxJo+Aqd9sJ4Uxo/r8TDEcrTGAOtCyhRwKAyZFda1rFlkMnxlnRmhJmy1BW8qEg/yDG8N9cApc1N1D7lV7BM=
X-Received: by 2002:a25:6910:0:b0:628:ddbb:4b98 with SMTP id
 e16-20020a256910000000b00628ddbb4b98mr2915950ybc.12.1646895987945; Wed, 09
 Mar 2022 23:06:27 -0800 (PST)
MIME-Version: 1.0
Sender: ibrahimabdul2006@gmail.com
Received: by 2002:a05:7010:a625:b0:211:5028:ea29 with HTTP; Wed, 9 Mar 2022
 23:06:27 -0800 (PST)
From:   Miss Qing Yu <qing9560yu@gmail.com>
Date:   Thu, 10 Mar 2022 07:06:27 +0000
X-Google-Sender-Auth: 1R1xB80PkZbFu7d9rd_1N_OgX4M
Message-ID: <CAN-tx0z8d-P0uQfUrXMdcar4SaM43CtDpZYpoR=h75EQfEYjSg@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_NAME_FM_MR_MRS,HK_SCAM,LOTS_OF_MONEY,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it with the critical condition am in because all
vaccines has been given to me but to no avian, am a China woman but I
base here in France because am married here and I have no child for my
late husband and now am a widow.

My reason of communicating you is that i have $9.2million USD which
was deposited in BNP Paribas Bank here in France by my late husband
which am the next of kin to and I want you to stand as the replacement
beneficiary beneficiary and use the fund to build an orphanage home
there in your country.

Can you handle the project?

Mrs Yu. Ging Yunnan.
