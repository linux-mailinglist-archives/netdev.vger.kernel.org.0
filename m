Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6CF572FA6
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiGMHwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiGMHwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:52:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD95313A4
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:52:32 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id l124so9548584pfl.8
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1Ey+uaCMVT4hiM2bi4CjkHvDaUe0EstHF51AGXh6sLo=;
        b=SWxCfkihaMmMRcT0xgI2LFiCBVXv5Bzq5tcVT2+lJRDnbBcxAywd5y6eyXlt0zwrwf
         JYI3WJVkZZuVuVubo7NGXALKMBrf2qCxBGsUlWDWmpcnw539RQlrNtth1DH36g3N6bWM
         xXZxmCdtGE60VGvd4RxsCxzFsEJOk8FpBF4yQXx6fMC63S1f34K+OlJ59njyZVOjsUGn
         YhAdv5sah82BDS60/jvaTV7N4ALcTrRzZv93LygeJQUy0lN8i6zMxAFeM6ZVTFCF8JZW
         6LFnO58YeI4wynZHSJOrol37rKJ738K5Eup2uUuvx8Da0XgInfoT80oEIKOpNF+kBrcM
         1Awg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=1Ey+uaCMVT4hiM2bi4CjkHvDaUe0EstHF51AGXh6sLo=;
        b=ZmqrT1FaRfIyftdRrDeJXg6KBl5sRWHP6IrAnRyVOAyiBTQLHeRb8FhX4PtnOYJLRo
         6h2vrlSDCEY4bxAHiGfqR9qyam2IAsaLXSAfHJs2MoIceiKXL45W+OFGyGT3fYUzAeKc
         CBQHL2/WDQnCt008VjPKB1nMFNvtuPk20b7o4je2fvTaw5TL1rgk/nF8ltMDCkd3s04g
         Oz+uuy/ur3NCT0jUGgEXbQg5JXZHEf5D9LBA7qPxWKYmhzJtiex2FxfXOskn93VB10sh
         /bsv3WuVh6RrW1V44HuWImuF+vRcBRDKvRCb4mEMSrB4bmcTfKuPkaSWFUz1Tv0+5CiZ
         dGyA==
X-Gm-Message-State: AJIora/NYhcrYkMHMXCFIQI8ASHY9WSIoUc9O/lkFxX0dQ9gUPym389K
        RO5U/N7CNMiYSVu5sA/M7NFg0fPYQ2o5LypZifk=
X-Google-Smtp-Source: AGRyM1sMKsvfIpfPHLuLqemoN6ePIzjFLCeRe5gakZ6pFJR2eFxf9pu0QVGRJ1iaIqS7T9v/5/GnK/36UN9wyYvQq8I=
X-Received: by 2002:a63:a46:0:b0:412:b1d6:94cf with SMTP id
 z6-20020a630a46000000b00412b1d694cfmr1927884pgk.373.1657698752442; Wed, 13
 Jul 2022 00:52:32 -0700 (PDT)
MIME-Version: 1.0
Sender: akidieke2017@gmail.com
Received: by 2002:a05:7300:ed93:b0:6a:a58a:b6d with HTTP; Wed, 13 Jul 2022
 00:52:32 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Wed, 13 Jul 2022 07:52:32 +0000
X-Google-Sender-Auth: cgLShI3X6pPTXq07lLdzGv0fmTM
Message-ID: <CAJghZkLqrSmqmDqrH_nZJPRuC9s30fROEqYhX+g1tM6BO6VxEQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

H=C3=A4lsningar, hur m=C3=A5r du? fick du mina tv=C3=A5 tidigare mejl? koll=
a och svara mig.
