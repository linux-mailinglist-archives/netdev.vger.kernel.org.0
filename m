Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E76F4BB7F3
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiBRLVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:21:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiBRLVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:21:33 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012E3171852
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:21:16 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id c23so2375791ioi.4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=lw9NIdwsYnQk7WvrEKyjOLbn3iVZ1iKovMOquM2wek07GvEn9E6VlNrtxnMVvCSYcQ
         Wp/ADQ3jgaGI5xjqpsDyqMKLcX8VrmCnMnlGKsr/m+eP7laOJ7MVM2tvKeEAby/9gpg2
         3b+rBbOIHQeKwnTQ72q3qr3harC+V3hcYiaYaD6fZdA5w1UyOnY9lq3UAr2NRPLENrZ0
         0uyhyJMXtBgx3gryTTaVBjWjC9iRt634Vo94knZq/OLZeTPm1FJl1jxdFb/N5ZvS9Xkd
         fHda9pXHPA2qahw59BEKoavDsA1w5CpsiV+KQQsodfQFwyY7luKZKKHRTP/9sNKYqHD/
         HzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mTe6rsF1WlocKfWRCIawejpNJl6lRYSIlYxDz8jltlQ=;
        b=odBaXFoiTOh6NmMsbQPQdWJwLg07Uz/8o9m2yvwQ/ObRKw43qRrdHgU7xaBI9fFp3e
         sAaX4J7C4d7lxwYRpc6mUii++5E2TjmIBwu/Ta8rE6iGu9eE4hWUqhP7ZOe13/5fLuH0
         ngYYauoQyFTdWkKdHB1UzswUFFhlKmV8bfCYqC+CeY/b+sYb7ESEbYyZkQmApXtk7D5c
         WVA89AI7oFBzty7LQa+nt49h6uQtiBLjJfhnZift71c33ijcPaCOjV3NU897WQrtQvSu
         keof3o5lbVGMkOivuqiEdoNcnjDWsVlCUBeWQzJmzb8DAzWNxT8UuLcBmDLsnLJtFgMG
         OEeA==
X-Gm-Message-State: AOAM530hgtVHGZoJUkELp0yRi9Eus57Bm+sjHCoVgI8VGYWhYMx/DlpC
        EKNknsLYRwy1LSjyR93eCHAES/2CE99YjY39QA==
X-Google-Smtp-Source: ABdhPJzOlXxZmlKxT21yHv+h7yFTVOYS6Tg2uehGQXYKyfHvSIP8wzdGFq6UsOSoluF3Tc7QbJH/wHRKhr5mWVSwRus=
X-Received: by 2002:a02:a1cb:0:b0:314:b9d8:7ccf with SMTP id
 o11-20020a02a1cb000000b00314b9d87ccfmr193709jah.239.1645183276122; Fri, 18
 Feb 2022 03:21:16 -0800 (PST)
MIME-Version: 1.0
Reply-To: zahirikeen@gmail.com
Sender: ali.wa1234ara@gmail.com
Received: by 2002:a05:6638:3013:0:0:0:0 with HTTP; Fri, 18 Feb 2022 03:21:15
 -0800 (PST)
From:   Zahiri Keen <zahirikeen2@gmail.com>
Date:   Fri, 18 Feb 2022 11:21:15 +0000
X-Google-Sender-Auth: mbfYdBTzQz2V9UsQ_ZNF0N_W0_Y
Message-ID: <CA+0F4TFxW5u5fxckAsfBViGhukcMgA2o3epVBGCn1pU0rBXzzQ@mail.gmail.com>
Subject: Greetings to you.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day,

I know this email might come to you as a surprise because is coming
from someone you haven=E2=80=99t met with before.

I am Mr. Zahiri Keen, the bank manager with BOA bank i contact you for
a deal relating to the funds which are in my position I shall furnish
you with more detail once your response.

Regards,
Mr.Zahiri
