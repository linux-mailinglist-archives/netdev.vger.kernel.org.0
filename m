Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9D55E61E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiF1QXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiF1QWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:22:16 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9783B2A6
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:13:47 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l9-20020a056830268900b006054381dd35so10090613otu.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ETMZUDWYS9G7NuH4Fik2uRyKKY9c/z8nBEfvUz+1dFs=;
        b=N0f9A1SLEeYq0NZb1Sbi6BUytkw+2osKnZJzsb+rMIlulNe3JRf46hAjQra94QuP7e
         3N8pw/u+pul3Xx9l1qE/snP5diadJ9//u+3G0IQ/VDXA9NaSK8B9e2EAdr27txaKm4V3
         p858C0ZVdGZnAyVJC3f/5nLiGJpQ2D/3y45dgucOiu6XHuoBjXKFgvqq+t2GlennBbsm
         RrJBtZbRwtQz2beMQa5naBVQOqxMkjj17/tbyAMWUJjpIPfRQt63NOMADXw0HRpy0Wlx
         bmkV3Pj2mliuXLaqfRVEndvWYQc3A8aU/OeFyML5VRjEUUkAKo3Iokt7XDkePk9KVHBB
         jjhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ETMZUDWYS9G7NuH4Fik2uRyKKY9c/z8nBEfvUz+1dFs=;
        b=mv+bsPYtzC4qiiyZzKM9gPU4auQmGUhfzxryzTNHOPsiKLQvMA6s8vOisuCHmq5e05
         CpB7GESyZCHfUMLDe/KlPIVWo+sEH8KIrhgdOMjSzvOFj/5dDsUGSkzpUKzSjoIzfNNs
         e+hCNZC+DzKclCrYVKbchKhpC/b1/0tAdoDXplH2YIm7jRcIO6PgU+yA8t1xDZjKRGjT
         l2KqmQLhbIo6xGpXoQ7Rt/YTidg9PLPFMmgwX/C9+U6/WF0s3op3HbkLxK3kUT/PgiKv
         JfP06G8T2O+YrsDrgRkHuu6h3AWowcJRXs53QwerVzdqvxsEi2XMgEfkP8+ZSucj1tZO
         CxNw==
X-Gm-Message-State: AJIora+HNR4kz9u76hoNLWaGnlIqHxAKtAkN3/7mJoMP6OSJ2gy6O9NO
        3jIBZd9LhTJV+68q61JZbz2xuHC2+MFynd6MEWI=
X-Google-Smtp-Source: AGRyM1uUS8wekfvai4fLqzkEkiFd+AgJRD7CngscjcDjG42+WmSSInvmPSR4rihHKVYmlnm/UM/U3Sqa1s6GZZNS41s=
X-Received: by 2002:a05:6830:44a5:b0:60c:25a4:9fb1 with SMTP id
 r37-20020a05683044a500b0060c25a49fb1mr8860840otv.144.1656432825625; Tue, 28
 Jun 2022 09:13:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6850:610a:b0:30c:b5e2:bdb3 with HTTP; Tue, 28 Jun 2022
 09:13:45 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <gonwse11@gmail.com>
Date:   Tue, 28 Jun 2022 08:13:45 -0800
Message-ID: <CALtkzuszf3mmkisG0C-N=B-pt8-pEMonGKZbtChw08ObyZbdKQ@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

My name is Dr Lily William from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lily
