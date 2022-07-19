Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A77957A4A6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 19:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbiGSRKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 13:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238096AbiGSRKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 13:10:37 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03A8220F3
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 10:10:36 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id o10so689959vkl.3
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 10:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=t+pQa5dRvfaXNuusnmsa3SIVfyR2GaEPDHqht+u9DDE=;
        b=XQCAkhnA7mNuYuIpoxdZ46pFQ1GUHqOWGIPinA58WhbL+BxTGPchHB+WV19Rwx2J4A
         c9nPu1OsLat/rEtA6nWx5bpZX7oa7k8XvkntQvJmet0YWlRMROCrh0Fo0PQPUFBhfhuT
         geu9ht1d/6s4Ow0kkc/bRDuygGPHSgS4P1wIee9EqzSFWvpvgdcQ4i0RoAP5xtt+5ccd
         epEqjA4Uwg4NYfAYu0YtI3QtsTsAsl07rWOmVUWe8GHuEtpxkHgxUid9T6W8WbroWzUG
         lUZrdP2x+MLSxKIzOUhBLJM/5H7sfDb5f1Ho9DZ0m/IgeHRoPKrghv3uPf9snJfoxvR+
         q02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=t+pQa5dRvfaXNuusnmsa3SIVfyR2GaEPDHqht+u9DDE=;
        b=qKGeSvfE0+Lto+TUU4E5cqFr4gW35FH4xt9nBd/6iBrnnc9tPK6OoCgBRdwmTiYZZc
         nfFxNxlqKoRKcoE+UkJaeTcm93BXwTC53xOmAPZKCuwDBz2sxwLlfVUdPtVjeSJWItoZ
         HIEf5XIkYLod7p6vmP2xCQwvqzafQysYDvb3jNj7wPwrU2IaJ855ZDo0OugBGuGDxf5l
         hPqbfYbX14/1JrxAhT0joYeqHCFj3VtZ3wCt8DOY6dUk2ZssaDrXtGPA8a++aN7rv4SV
         M13hUky2c4i6zvJyXgZ6pOcA1NFlv+bA04d7obwd6g+MOZNrwa3qdCoNYZduANsAgYOn
         TxEQ==
X-Gm-Message-State: AJIora+mAuoGwFoDz4RXLZ0El862BG7WOHglF8+fzfF3tsEcHfD6/w7Z
        HwkfUv92bwI6cG/772ZCIUinTyfkJUYGmWQrSTs=
X-Google-Smtp-Source: AGRyM1tOmj4/Axjb7fzmg+gUpcndNHpFdiXLWdrsHFNQ3wh/qDFFLg62Qs93BjAJTGkzi/+GIOVrzlDA5fQKKrwoK6M=
X-Received: by 2002:a1f:2a55:0:b0:375:8e1b:d374 with SMTP id
 q82-20020a1f2a55000000b003758e1bd374mr4302231vkq.2.1658250635191; Tue, 19 Jul
 2022 10:10:35 -0700 (PDT)
MIME-Version: 1.0
Sender: saniumarm46@gmail.com
Received: by 2002:a05:6102:3fa7:0:0:0:0 with HTTP; Tue, 19 Jul 2022 10:10:32
 -0700 (PDT)
From:   Mimi Hassan <mimihassan971@gmail.com>
Date:   Tue, 19 Jul 2022 18:10:32 +0100
X-Google-Sender-Auth: UrtF_6bhvEuqSXzZLWV4e7Gmb8w
Message-ID: <CAEBNbt5zo9EDk5S43tfxBS7OYJDPwuB_kQorDCxfuiJfHydN5w@mail.gmail.com>
Subject: Good day.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i am Mrs Mimi Hassan Abdul Muhammad and i was diagnosed with cancer
about 2 years
ago,before i go for a surgery  i  have to do this by helping the
Less-privileged,so If you are interested to use the sum of
US17.3Million)to help them kindly get back to me for more information.
Warm Regards,
Mrs Mimi Hassan Abdul Muhammad
