Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C9E6E9C96
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 21:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjDTTl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 15:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDTTlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 15:41:55 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F40E2137
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:41:54 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-506b8c6bbdbso1168158a12.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 12:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682019712; x=1684611712;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FQzF34rdBW8w+FN0s1ouVT/A/E8MA1y0Ug/Ly6m9JE=;
        b=HVA2rJmfBYgfIbYIIwzXhUlJn/2ZOzRIaKCbPPCF7uEfuP0ksw8y9o1ouBDyfLQGKX
         xP4xmZ7rTVsda6GKsm71RygSzfURyY73IaIa7Rk/1Fk3YfwGcWll+mddgZ6VOKlJmgOf
         dsw4hllEPl9X/OHVcIaIWjhHzEuEoS6t1w79oQAZqGJvZbCJYpuqCUWDtQK0rxMDcox6
         I/3k6vg7BV90RYHGqK8zifSiTMI1SsQqW9FVjX1272ffEuzKcU98cS4RcaNXlrWxYL9z
         4ohHs9fbMb2/Ezx8SSsQaxwgcVSOZ+WIQTWUtyBa2l07/K1TDlSE+wq9rqZtOO+9nn5F
         t29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682019712; x=1684611712;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FQzF34rdBW8w+FN0s1ouVT/A/E8MA1y0Ug/Ly6m9JE=;
        b=IifY+g0X818G9WNzTZcoxmc1S3L8udOniQznHxyKK9TT3DvtK1g7hPH4+z69LSDHxY
         Ww7Ir2F1x7J66iQ7gX463ZeAIfjiDOjNrHGnBHOeqTJGOWbgF+jFPu9Doi94CGbdDe9C
         89aU3E0mZxWXkcMaiaIHMgqq3giol3YIFFNIrcjPJZqL6U+knJRoYtmQlAsLKoVFcWp/
         rBYXr2qx6ATfkInRPkFuZQyUVzdEyt0PpQzcgGa5f2bkfrCZI5NiJWpEGHYC9O/mEm+L
         90rIiLUDuh1dZhesWm5HJ+Q5uKhUUaojh7I0VlA6mBqO6LXAaEGVNVajw+2i3XimrDX8
         vB9w==
X-Gm-Message-State: AAQBX9ev8Q129URMJHUD3J7nPRXce0orvupMv4wT5pisg9QdTNLNQPGI
        /e1sH788sQfHBPaAO87/RRFoNFeR3Zt+bzy6h2o=
X-Google-Smtp-Source: AKy350a2Xk5CzdBXlyAmUzVkRPClT6UcRvmF2zPlunMH1wY17EG0g1WzXL+IrvtuZg9jP9h6cjg0Ow5EccdJS1rCGBs=
X-Received: by 2002:a50:9b0a:0:b0:4fb:2593:846 with SMTP id
 o10-20020a509b0a000000b004fb25930846mr1101743edi.3.1682019711930; Thu, 20 Apr
 2023 12:41:51 -0700 (PDT)
MIME-Version: 1.0
Sender: sggsggfagsg@gmail.com
Received: by 2002:a50:3390:0:b0:20b:ae1c:4718 with HTTP; Thu, 20 Apr 2023
 12:41:51 -0700 (PDT)
From:   neemakimjohn <neemakimjohn@gmail.com>
Date:   Thu, 20 Apr 2023 19:41:51 +0000
X-Google-Sender-Auth: 1TgFEAB8LiIdwMFNrrUw-cUQu-0
Message-ID: <CAK6tjcRQuYRmWm5NNcOgkZ+hzEDJ=Dd=Y5oW+5fuafpf1BFFrQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_00,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

  CHARITY DONATION Please read carefully, I know it is true that this
letter may come to you as a surprise. i came across your e-mail
contact through a private search while in need of your assistance. am
writing this mail to you with heavy sorrow in my heart, I have chose
to reach out to you through internet because it still remains the
fastest medium of communication, I sent this mail praying it will
found you in a good condition of health, since I myself are in a very
critical health condition in which I sleep every night without knowing
if I may be alive to see the next day,

I'M Mrs.Neema John Carlsen, wife of late Mr John Carlsen, a widow
suffering from long time illness. I have some funds I inherited from
my late husband, the sum of ($11.000.000,eleven million dollars) my
Doctor told me recently that I have serious sickness which is cancer
problem. What disturbs me most is my stroke sickness. Having known my
condition, I decided to donate this fund to a good person that will
utilize it the way Am going to instruct herein. I need a very honest
and God fearing person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained,

I do not want a situation where this money will be used in an ungodly
manners. That's why Am taking this decision. Am not afraid of death so
I know where Am going. I accept this decision because I do not have
any child who will inherit this money after I die. Please I want your
sincerely and urgent answer to know if you will be able to execute
this project, and I will give you more information on how the fund
will be transferred to your bank account. Am waiting for your reply,

Best Regards,
Mrs.Neema John Carlsen,
