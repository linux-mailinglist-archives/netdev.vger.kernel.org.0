Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AC06F276A
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 04:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjD3C4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 22:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjD3CzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 22:55:00 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E64E1BD5
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 19:54:59 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-55a26b46003so1883547b3.1
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 19:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682823299; x=1685415299;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YfC8PTqy+5axBI5hIB+fPihJZX0zHehuWvizoV+nuag=;
        b=UinWc98xFsgGh+IHvpYOiwvmQkH10urOKj3WMtAQjKms7h2G2ZazmkgB3QJ+0AZeTw
         6oAolGKEEDtMVFN2TeGBaW9faTDO36N0XFUfyNzF0l0IlmlHm2GOzHYRHw72pSgzZlzn
         SmYucqCtTlc6lvkCPl3h209UueNqTLb3l0E13jB1ZDJrw/X5CzChOx0Nq9q37VwxVqhr
         2kXYmXLGPTExr/KcQhT0lI1/evjk82JjXQeGNuRnesblaO8EqdMsiDByyhXzr7GiYtg3
         SEGuK3bcKkj1OrMh2Fye3ay/1h3mJxP+yTMpb/lk4omN7npMothjGIw0xPPKaRdc0Nvu
         9QsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682823299; x=1685415299;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YfC8PTqy+5axBI5hIB+fPihJZX0zHehuWvizoV+nuag=;
        b=E6hccC4hOKI/ljQfrtkc40sNUk3Vzbuqy2LUkVI5If5/u8OPHQyQSTZR0RbSOQzN9N
         cJynSjHJOXv26nVWIyzNB7VqBniiZaPmk4/syrd9+QIwtSysyeVXmBTwhk6mPIECDy4E
         nxQgsF/kOc5rqnBtFm7xGQ0Tv0kk6f6Lg5+j7Z7cCPCm76TBAs1DOLSey1MZctKRnE3r
         VYnhyJ4hVeIX37KEnD+QDuWyOnqeJCZ9tRPDJ4Of+Gc4yoZjwdH6pSI3bL1xGO/aPmvw
         14Wecbthr+adfzdgYSynG4YU/7mOd2KnZKeygonYQrhf+0y6JCwF/5bheFn3uDnfYn0o
         6BWw==
X-Gm-Message-State: AC+VfDwniNQ8dn0ToE2//cegV1yIXP4iq+TGPJJQIlj4mOXmSdjZq1Kd
        mkf0iqaAEP27hxtP+HXxJZyu0hJeO0pDjvkhwWw=
X-Google-Smtp-Source: ACHHUZ7FHjtOMBVlTqiO7NmYTbvWc9rR+TpvGWBHLCFuEGQprmxP2p8qKLRxeeU5Jb2UmlIYLuhDSju8XtKFho9FGfU=
X-Received: by 2002:a81:4641:0:b0:54f:89c2:a249 with SMTP id
 t62-20020a814641000000b0054f89c2a249mr7947594ywa.51.1682823298735; Sat, 29
 Apr 2023 19:54:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:b411:b0:4a6:d404:2373 with HTTP; Sat, 29 Apr 2023
 19:54:58 -0700 (PDT)
From:   Zeb Damian <zad704beth@gmail.com>
Date:   Sat, 29 Apr 2023 19:54:58 -0700
Message-ID: <CAP13HaYwR8rvHLJfoT92Cu_M3hmyXxxS=Meh7XxHqEn5Yq08aQ@mail.gmail.com>
Subject: Investment proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sir,

I am Mr. Zeb. Dami=C3=A1n, a retired chartered accountant and a broker
to lenders/Investors who are willing to invest or partner in projects like
{Real Estate Construction, business, give loans to prospective companies
or any viable projects }

Our amiable lenders/investors have the financial capacity to loan fund proj=
ects
between $1,000,000,00 USD to $5 Billion USD at 3% interest rate for a 10 ye=
ars
duration with grace period of 12/18 months.

Kindly send your business plan and executive summary or refer us to
anyone with a good business plan, for our investment team review and immedi=
ate
funding. We are waiting to proceed with the closing and disbursement
of investment
loan funds.

I hope we can work together in securing this investment loan funds you
seek and other future transactions.

Thank you in advance as I anticipate your kind response.

Regards,

Mr. Zeb. Dami=C3=A1n,
