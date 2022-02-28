Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4164C7BDC
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 22:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiB1VZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 16:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiB1VZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 16:25:10 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5676E12019F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 13:24:31 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2d62593ad9bso123561637b3.8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 13:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=TKeiUDC9DsSk94paBiH1Qbp9HA9MsmdxcC1SPeQVCp8tLgqks2upX2/wH3dVfE1dBK
         Kwg+tlyAEOF/bPgu7thENTLb6O3NBQQyqgYsBH3zeRgTbYRUrh70d5Ual1FqH2eWa+8/
         msayNF12IrRuBFaPIwj/vDdjCjjvjloUExRRLPU6q6o3mUktbPVgWqHkzGA6B47NrHMA
         qBnu38ptOu2q8wkA23gj4P5v3XS6vQo2EjecxHGiaymNnk4ShPKXZws8WP5Ptwcv67RB
         3tYZexY23Rl6BbYAlO5BzmMr8t7zwZ42pbvRzpTTK6xBYS+z1eZ6JHz2f2zJGgkyfOQq
         QrTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=SYd/g+XvfBRad77rOdZN6JDwzOONKekzioDQVns1lywWYQtRmjRDOSUMBR/h+Y3cod
         mYMso3Q14EO5VF94EZMuKw/isWXMnkvbf8fJlpyZ1/im/2v1zqEmmXmX0KaJDp9i9lRo
         bIWspFJ630WfCJinNkAgLs1iXWRVYtDJiu5dIDbV04cta67OytYk2Jucx9kvl+a2T2ld
         MnbIOqKiun5dzoxAySyMQovFsqLeZ6ec/EbOebc6MVYC+STe4Z+3yUummkVThKg/XTQ0
         AXSY/pGoh2ZttOPY6XOJ1Wx1pE1pnT57ckjNa97IzcszbFg1MS0Jk+8WLB2nfL2fXUBE
         8c5g==
X-Gm-Message-State: AOAM532XeR3L2zioZxmOSiN5BTy3TkCpw3xFU5uCFF7hV6yU17yMo+qh
        FHmR/+BN3JLN2nH57xt1hghkeR0yvGWGzrQOqT0=
X-Google-Smtp-Source: ABdhPJxt7Shj1AoDgW83X5tgWyteMHA8TUtapNn5uC/Ihnb2tGiqx2/yTIjFuvQ4xaVNnhQe9tBPUlwiX9v3MBEgqes=
X-Received: by 2002:a81:743:0:b0:2ca:287c:6ca2 with SMTP id
 64-20020a810743000000b002ca287c6ca2mr21409769ywh.327.1646083470644; Mon, 28
 Feb 2022 13:24:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:33c9:b0:210:739b:d3f with HTTP; Mon, 28 Feb 2022
 13:24:30 -0800 (PST)
Reply-To: abrahamamesse@outlook.com
From:   Abraham Amesse <marhgreat042@gmail.com>
Date:   Mon, 28 Feb 2022 21:24:30 +0000
Message-ID: <CAMy7vC0wp8Jh8EtjdLfNMLd3vqoXHvy02oC60abd7yZfUhvq5Q@mail.gmail.com>
Subject: Please. I would like to know if you received the message which I sent
 to you two days ago concerning humanitarian aid work.Many thanks and God bless
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


