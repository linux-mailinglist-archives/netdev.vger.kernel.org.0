Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE3A4BFC6F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbiBVPY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 10:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiBVPYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 10:24:55 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B78114FE2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:24:29 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id q11so6083757pln.11
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 07:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=+mcTZ2eqc3eLQRfLqaTPyOtzxWrRbXuCUvN2Q5tWSyo=;
        b=JHHsYwXZtn3qKWl/a+F0o0nHv9w35e4Hwsn9tw5DEvJIKVXpwM3VXvsU+9/IVQ3aer
         bKEOjAAqd4T/HIpZ15s5H6z36tvbZ7T+kuXA9Hsj82K/cljQ2vxEEh8oZby07qkWvRil
         CW02Dy3Pn/Tum3Bw41sERzBm7bFxbdc5HCD73kjpbj/h7213WRXxDnJeShgmZnE7llLZ
         0Tn56mESBtsvGqvK8QPBzbO/BPImfj3EuoVrpxg8hgfhuagjA8tkDxB0XBnh7pOXLyhn
         mu4Ya3qNx9Zqd5hKtMF21AgD/JiQUXoA1hPpG6kKm52/geYHL8GNwLjw8aCdHXwoxnmk
         WRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=+mcTZ2eqc3eLQRfLqaTPyOtzxWrRbXuCUvN2Q5tWSyo=;
        b=ZdIE6eS1Dy1ckXUYC1EkRVjHXOGrXqbdrv7qR2zU3pMkE1Q63OmuwUhXHe229OT8lP
         hldHhlyc9Mex4XOh9Cbxi1c+ZLfhs2A5jXmwostxz6qpgpP5whlUmO1uAs8Dy9hp3MzX
         pHF0Bxm5YqfdwxJdRnFREHFhdZ3VGNzfGr6ivyAWwSf031IMumicqJjqXEJWa9TJYFNE
         qsGXya3IKFYZgOsmiZv2f5juET0dh7Xgm84PkO7gB1Mcen4gii93kdn7+qWjuWbz2cVk
         WzBjNZH2EVvebF7kCqUs5g2QT2tx7DwbVxF4RJLwLE0HNfLxslZjJf4gHfoCqBolhrJW
         TKfw==
X-Gm-Message-State: AOAM531n5WAkVTjedn3xsBSpCanNmiNHWLLT0dXM1obQlHyUhxqPZjH9
        HU6MhzE8egWPQQrhHZFGleFSODkZ4sm9kdS2Kbc=
X-Google-Smtp-Source: ABdhPJznr5xfu9OYL9Sh5hyRU/BMAI6OXxn1qrNvz867g1ijRQu0Y7l3M6nXvUXSiL138E8rrHxctZDUdwUGrmWySuI=
X-Received: by 2002:a17:90b:3594:b0:1bc:7001:5203 with SMTP id
 mm20-20020a17090b359400b001bc70015203mr4131727pjb.84.1645543469035; Tue, 22
 Feb 2022 07:24:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:80d0:b0:56:d55e:15b3 with HTTP; Tue, 22 Feb 2022
 07:24:28 -0800 (PST)
From:   Michelle Goodman <michellegoodman45@gmail.com>
Date:   Tue, 22 Feb 2022 15:24:28 +0000
Message-ID: <CA+PxuvX62a2M99pdG6Zbb_okQLhtvgUGt-DKjdbsSXO4PgZ6Eg@mail.gmail.com>
Subject: Halo
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWVyaGFiYSB1bWFyxLFtIG1lc2FqxLFtxLEgYWxtxLHFn3PEsW7EsXpkxLFyLg0KaMSxemzEsSB0
ZXBraWxlcmUgaWh0aXlhY8SxbSB2YXINCg0KVGXFn2Vra8O8cmxlci4NCk1pY2hlbGxlDQo=
