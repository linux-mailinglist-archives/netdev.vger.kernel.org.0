Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44361568581
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiGFK07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiGFK06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:26:58 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A821B2654D
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:26:57 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e40so18689047eda.2
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 03:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=yC9L2Uh1XP+ymUFlfOJIjK5vcWIy6ZKsu2xteH/8LBo=;
        b=OvJ8zaJV2fVKu4bUoPHlmvu1MH0j9sxetlYVkmZC5lphkvgAYRJUtm1qUi5/wUizC0
         2Oi2joGFci7tfJXUqYUaqej+BSpCbbyaswkP7Cucfx3nTaXceMHPeetcjK9z77TmHwYh
         wCUPGdtbkFpTtdLAkX8EEQYiNejqqLrpNrlz7MDb/2XQwJo7nbhN8jd1zs4lN2zAheWi
         u5pvrLB5ylSACYCrjmf4x+h83DaxwjqfFUwIdVAGIKVRrzsS0DOpJ1JtZzyKQPDhXoWB
         iq+q3BN1bABXiLkHVa0nakFqqAylhr8l/AJGHa1b+eK5llUHC3nbNp9zD6nT/Ty8onmt
         G0Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=yC9L2Uh1XP+ymUFlfOJIjK5vcWIy6ZKsu2xteH/8LBo=;
        b=221kFaEOTdTDaIfcNvxPxK3ra6SebArkGQ4Qn3rE0wye7nSv1zNCGIhjjOWDBlIUiI
         cw+LRS9vTMY7s+mtnjkL8o3zD5bssVhxKfmT5UbJDjJxSdq8h1rsXWEim88auPDeNCpC
         TBDHmV7Jf7hHnxHi1PyVuUzeAHiJqgQ0bDyhrlAW6N0X+JPK7tHSkdMjfKJ6y2m1dfbt
         H2dJPr4JOvNQny4o+LWk2SzSk1pLUsJwpCLS/qfAmItnGk9MiPcxAm6mr/e64WdqpuDX
         X6KMNC+XVI7tWmt/u/Fd5MYynrTW3XZu24Xw26/hv1ew9kJVlhHc/P96/LNPQVRARJ0W
         6WHg==
X-Gm-Message-State: AJIora+GQPCF+PfqigXyIKTHn1JZug8OAnRQPhc1vhRfG0BqYqd/nWi+
        j6dxDOTlDNaQllICMh8d5Z9jZBgvZ2vTNgEnFmI=
X-Google-Smtp-Source: AGRyM1vCyndFTZYl5l4V+o6WQXUT3bsDJuUdVvdfyuywb8E/Jx3AiV1PA+8JE9oUv/yW4rPKLI4j79qPJiwoMP79a0U=
X-Received: by 2002:a05:6402:501d:b0:437:e000:a898 with SMTP id
 p29-20020a056402501d00b00437e000a898mr50818530eda.265.1657103216291; Wed, 06
 Jul 2022 03:26:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6400:691:0:0:0:0 with HTTP; Wed, 6 Jul 2022 03:26:55
 -0700 (PDT)
Reply-To: mariaschaeffler1111@gmail.com
From:   Maria Elisabeth Schaeffler <dausaletangaji@gmail.com>
Date:   Wed, 6 Jul 2022 03:26:55 -0700
Message-ID: <CAFxJB1mpSR845T9by56VH8jCfWg7yBGZkk-4P6d1Kp4_tP4-NQ@mail.gmail.com>
Subject: Reply
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
I have an urgent matter to discuss with you which is of a great benefit.
=E2=80=9CI apologize for the urgency, but could you reply at your soonest p=
ossible
convenience.
