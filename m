Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A5B6A87EE
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 18:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjCBRaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 12:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCBRap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 12:30:45 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0467B39CF9
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 09:30:45 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id m6so236667lfq.5
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 09:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEkw1KmmzfmMdZjy2G/k2kJ9Rp06l3CUoffIihDDUro=;
        b=NHKiRgrAmqk9eIhL3iuxoIjXu2mhPivH1rUX5Bub4b4iZVrpS9LhuM7Lp3YwwkCr9O
         TFkPa7WJyfAYYSvcH/Leua87wtruTpQzi46kWWpNglB8f5VAl04KNDo45TLGc+Az2G66
         eMjBj6usrJeW6NpVWSca3dKdw/v4J5ZUNZSMTFcltUE/tCtBwEJ2HyTpdpzVrMw4Zvv3
         GTDtpMUZa/T2Y/Uh2OLwMniQdOl5bkHb57FlG5D0D1/itTSka+IIz8RPiqD2zD/rUXFq
         Di+WiqJOxoFWzJfGAxNiEcw6Vkes8THXTgEFCIZQsrpgjxv7zz37TyCVxEBFD9wkmEmd
         ewWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEkw1KmmzfmMdZjy2G/k2kJ9Rp06l3CUoffIihDDUro=;
        b=Kr+O9CMaxVJC14Yo9OueXfBT0E3w73Gp8StiVg3oTEtpthB1er6Sv6Uj0D2dSCqzz1
         OcslCVYJcj5dGXJHlO2hIVd+GdpFdQeM8YGZK7/LrNIaPFow1hhynpvao3pwcW/wE4E2
         yQAaqKLdHDpvns5Ni+1WXzXfyo9QpVITd+RznQb0DEepxr/CJirt3yUVJ1VqMsQdIvez
         qy5NPji5EmWdqPhS2TQCqSNOrw4UOV1DysAvvR3cbtFaCRh1nhxgTnAYxxI7a9ll+zIQ
         fh8BDGHYxyizxqyyC58H/YiXZ+2lfcWKPk2zbFkh3F319PTE5+VL+tg51F3M+PnN/KLq
         7Y2w==
X-Gm-Message-State: AO0yUKWUTnxGGPgv3z2HnZ5d/3Vj6cLzeqCO0pyhV/wfQPRvrqkYERan
        5jKfWBnl0w44mdOTAcpBcHBKO5ig9M5YQApMMF0=
X-Google-Smtp-Source: AK7set8C8vY24Etobw2v6CAQXh+QNWYardCnbvbAcpJvwaFJV8tL3xcHbYYRwVyC0OiaiQeVxmyBov0e/aLfGMA9EX0=
X-Received: by 2002:a05:6512:281f:b0:4db:1e7d:5d42 with SMTP id
 cf31-20020a056512281f00b004db1e7d5d42mr1472075lfb.0.1677778242941; Thu, 02
 Mar 2023 09:30:42 -0800 (PST)
MIME-Version: 1.0
Sender: ibrahimabdul2006@gmail.com
Received: by 2002:ab3:6bcf:0:b0:222:5ab0:1c3 with HTTP; Thu, 2 Mar 2023
 09:30:41 -0800 (PST)
From:   AVA SMITH <avasmith1181@gmail.com>
Date:   Thu, 2 Mar 2023 17:30:41 +0000
X-Google-Sender-Auth: 6Xp-oHy6sig7nVOo8gvkdRByelY
Message-ID: <CAN-tx0wXtsV8HfDmfovZs=WMpdxXWE-=YQsuPsMh6=c=6A3Ekw@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
My name is Dr Ava Smith,a medical doctor from United States.I have
Dual citizenship which is English and French.I will share more details
about me as soon as i get a response from you.

Thanks
Ava
