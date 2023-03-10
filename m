Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70076B3835
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 09:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCJILD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 03:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCJIKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 03:10:37 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C224F5D247
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:10:00 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-53d277c1834so83077557b3.10
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678435797;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=auzSBdYo+YLoquMCzM6W/n6zM9jG47jKj+TfcWkMnt8=;
        b=fvKU7rrhYeAzt3/28/2vf1ASgCVuDAoq67qFPKu8p+sLZ4WLZ4yCcO/fAvoFT30lW4
         h/1qa9rFGy8Tl5mqPOcgj/M7J1Tpc+6gcyO/Mc8MM1nyiyEqe9eY8qYVehYHc9dqXfyO
         hUDXuZagO0Jrrgdk+giC4naO9bMCNRYfJJ0DzhjTCmD+VGZGzReuDF8vt7shCNsQ5eEm
         jTEDODc4Rf0uC98F6CvsklF7JeyvxPpYJBGH6k5NVdj3uU0+aqkRTlnpZ8T7YkxWGRiD
         Z6O+KRpZ9/+1hAFFQ/cZ/7EVTPlFoLjm3PVhc+Dd598udMYA4sGyxDZzLyi7hIxryhZY
         eO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678435797;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=auzSBdYo+YLoquMCzM6W/n6zM9jG47jKj+TfcWkMnt8=;
        b=gY5LFYzQeK12eJN3IBEooCBAmOjqdbEuYQTVUVvUINmZXxtkCtaupwlB0ly3+OUrv6
         Rg8kVXPDNuAPZsCE5ufsOehz1bemgZs1jr/s0sjr3/JqbsKj0Ok2gseT/MybV0kTgyWx
         RoHHNDgAVjEQ/NOWVojNCqF3szf440nJ1Bfe1j67epRkzmkctcjV5pAmhtKSGjw7+O30
         ThDk6wp6ns0oL1km6UMxKHiASdv6QQs3NzeuNFY5vUoOOMaiV4Few/4FjSEnqZoY5hpo
         C2iW50P4csq1QBsM8mPKt+L7UVeESi+EpK5wOeW7dG7racJ3Z7l0FYy+HCH6aVBXzz4S
         fKlw==
X-Gm-Message-State: AO0yUKXl8lP6NrBv58r+QL4d32LZ6Oj5OOTUnpvZjpqOw88LR1exmG0B
        OeYug5FAYuXHG9im8LmIidxBK0ybGi8J9vwSJow=
X-Google-Smtp-Source: AK7set/N/oP8aYXIxr1DCju+MWFrHoFfjdm8+5GB3z7IvXVwgYNRHj9q8NIpDnmaSBF+rQGeBIejmVVdycv7BpH3GJo=
X-Received: by 2002:a81:b612:0:b0:52e:ec03:9b2f with SMTP id
 u18-20020a81b612000000b0052eec039b2fmr15975912ywh.8.1678435797241; Fri, 10
 Mar 2023 00:09:57 -0800 (PST)
MIME-Version: 1.0
Sender: nadiaemaan50@gmail.com
Received: by 2002:a05:7010:d303:b0:33a:77cf:6f12 with HTTP; Fri, 10 Mar 2023
 00:09:56 -0800 (PST)
From:   Stepan CHERNOVETSKY <s.chernovetskyi@gmail.com>
Date:   Fri, 10 Mar 2023 09:09:56 +0100
X-Google-Sender-Auth: x9eFka44jhRjreUVOPf4XphCrLo
Message-ID: <CAO1QzD3N2Qzo9Swcnt-ntq_LO04GeOy7sMNTtjY_KNgipgkfYQ@mail.gmail.com>
Subject: I Need Your Help In Investment Project;;;
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.7 required=5.0 tests=ADVANCE_FEE_5_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings Dear Friend,

Please do not be embarrassed for contacting you through this medium; I
got your contact from Google people search and then decided to contact
you. My goal is to establish a viable business relationship with you
there in your country.

I am Mr Stepan l, CHERNOVETSKYi, from Kyiv (Ukraine); I was a
businessman, Investor and Founder of Chernovetskyi Investment Group
(CIG) in Kyiv before Russia=E2=80=99s Invasion of my country. My business h=
as
been destroyed by the Russian military troops and there are no
meaningful economic activities going on in my country.

I am looking for your help and assistance to buy properties and other
investment projects, I consider it necessary to diversify my
investment project in your country, due to the invasion of Russia to
my country, Ukraine and to safeguard the future of my family.

Please, I would like to discuss with you the possibility of how we can
work together as business partners and invest in your country through
your assistance, if you can help me.

Please, if you are interested in partnering with me, please respond
urgently for more information.

Yours Sincerely,
Mr Stepan l, CHERNOVETSKYi.
Chairman and founder of Chernovetskyi Investment Group (CIG)
