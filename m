Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55500603081
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 18:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJRQGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 12:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJRQGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 12:06:44 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D16ABF17
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 09:06:38 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id a29so23402302lfo.1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 09:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=30mLK80vSZcSwBOrdpYOKvqdrdKJjCkQDSG3S0CWQyQ=;
        b=UIZWtkVdFVcYKQMQPrpcXS4tuWE0CJ8ntjJmxocs0Y6H5GSEzLp3c1DVKTTR0uyGeg
         c3Z+indHhkzY1spn9jVjLcmlso2fbVCUN8Q5JQy1LjBZC7ezGfFtlo9zmxABL0nmxp3X
         7FNAlfJ7hlAkGybhTeaTooh0F477vINCs7JhtYuRNqIbeT96jwMhm2zG0stBd2uDnIsf
         ZBsby/QIk2rYlvZsofdbk6RcE5ZW8YnCxeQdnGDxjthwdm9H1jn09qJXx+MY0CKnK9+c
         PwaGcl2oFL3qKCb5IBcYr8mIWrJjKHS1RVwPaxVM83ZP7D9xXbsX0ol+Sq3EY6/e9+vW
         1PCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=30mLK80vSZcSwBOrdpYOKvqdrdKJjCkQDSG3S0CWQyQ=;
        b=uGe5SU+GajfYzxrtiAbsfVdEbPUq/wwNW7nJoReuVtFeP9IasmtD6SL3eUS3sOKXn8
         CZby8VgalVnywvsHQHHOLJB2JSmz8NeXwxc5gSAC1ejHXouXBYBzvQYEp4d/LIpHDR+n
         P4rN68S3KFZ4nmmZbD3xXDenx5le9vJqAHcHD8zHlWoIvyk6HfSjSXqBKVLIl/k5OHIb
         uMNL62zrlNFdd5EgppK8IDuZTAuOlnC0QaE5OST0QUulki5MRuET88xbdTlMCkJy8PBC
         XO02CcIHoyzoFK79TdLuyYdaQGfntKdAZ0NPONxfX+vAgXrhm1GMtklq8J7s4CWjSs0W
         h5VA==
X-Gm-Message-State: ACrzQf0+VHUJsvuMH39ihJWWoVa0B/AUZs5+R1/SQvzLgduSZOd+YTKr
        Va7r24Rp0GZmmkMJ6uexv6aoddYwkQLX2penQl4=
X-Google-Smtp-Source: AMsMyM4DPeM/KqcrMuZH+gd3KwP+DdfviSQgAcN3NVUoXsfAzzjSLsTsmT8Oz4Su+ajmoNlsVJM2uz58K6wJI8HB0XQ=
X-Received: by 2002:a05:6512:34c9:b0:4a2:2b33:5358 with SMTP id
 w9-20020a05651234c900b004a22b335358mr1171533lfr.106.1666109196831; Tue, 18
 Oct 2022 09:06:36 -0700 (PDT)
MIME-Version: 1.0
Sender: essoweatakati@gmail.com
Received: by 2002:a05:6520:68f:b0:1f9:75a5:d7d8 with HTTP; Tue, 18 Oct 2022
 09:06:36 -0700 (PDT)
From:   Miss Katie <katiehiggins302@gmail.com>
Date:   Tue, 18 Oct 2022 16:06:36 +0000
X-Google-Sender-Auth: aFXpfEosEqizSx_STOfbOy-3T6k
Message-ID: <CALyJv2pi8AanAvcGVcVdi5dC9FbbpdJLqOsQguT5RUzVtNfMYw@mail.gmail.com>
Subject: RE: HELLO DEAR
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo,

Sie haben meine vorherige Nachricht erhalten? Ich habe Sie schon
einmal kontaktiert, aber die Nachricht ist fehlgeschlagen, also habe
ich beschlossen, noch einmal zu schreiben. Bitte best=C3=A4tigen Sie, ob
Sie dies erhalten, damit ich fortfahren kann.

warte auf deine Antwort.

Gr=C3=BC=C3=9Fe,
Fr=C3=A4ulein Katie
