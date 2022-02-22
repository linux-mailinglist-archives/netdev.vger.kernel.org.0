Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4239D4C049A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiBVW1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiBVW1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:27:38 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B77C17A
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:27:12 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2d6d0cb5da4so136411977b3.10
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e3V5mFIh0kSezlREepW1IaOOm8Uybf+OrJ5Qgf9lw3Q=;
        b=l3GiAJ+6VMAHPb/dc/vcsNhWYneByQ/+glFAdma+FCPbIRA/FoSmhQQJkHarN0jmR/
         wMoT/Z8Un3RmQAbKpbQscu2nbDQ/di4hn/+YJBRI9c5yUJqbFV+RNiAPKQW3M9ZETBqV
         /+ZLSb04Jx4VFQjtECXK6uJu8dmN8dKaNzj7nh99K7i6S2RI4wIGrZGv16DuDQHawSXq
         Vpz6FARNVKcanwePU3Oh1UbRDrDIDGIArcsC/1//AcsHFL0Po4QspQaXfRwn1b1Q9V26
         EyIePcKgi6RwmCtSEMOMP98RVuIXNUbyxAlppw5rWZhpInWNVpzxn0X/gbc2WQcQTySu
         W76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e3V5mFIh0kSezlREepW1IaOOm8Uybf+OrJ5Qgf9lw3Q=;
        b=M5004j85ACeBtIi90YHp2NN33w9FWVWvrQLHfCB6K0yiIgqqWaqnsLGvXmX5NCENCU
         Ak6XME6XHAzfxPrGoDulEUtZ4qtdU8ISKW1PvfyXTfvl/Tgi4+chei1g7UpKR69Va2H/
         0QTRdvoej6/d4r5/bZmDiW4F81MXNhEziVeMi0BRUx2qCBzPXblMVPzi8gDwmgLvv8lu
         WUAVTf1bDMPkTiuFlo3WDykegpHACCUvLx6FrgCvA/s5KtdylTTOZy6DEiU4Pg1YDwte
         K6kM+VZxD0E9GMs+spWGfOsTM6vOIGqlQuGjyyBrTeUQD/sU1kINvflYZ74dy5BTdBgZ
         4EbA==
X-Gm-Message-State: AOAM532LRN2PgHkc4JCrA31M5OuuuFMH8oUL2uduZ8VAa8BqMIHljnHv
        EGm0RlrvcNSxd70zJ5wHZFwiHflvAIQzONBYhHNz+CueF+JJ9A==
X-Google-Smtp-Source: ABdhPJwPz2CE4Z1CkZcF6r8tirVvm9q3uXFu5ehZ+hf3yy2Dw6z0APxYTyDyrJN6uG5F6M8g5hwPVI07w5Wk+yEpSrQ=
X-Received: by 2002:a81:9d7:0:b0:2d6:34d1:e917 with SMTP id
 206-20020a8109d7000000b002d634d1e917mr25802560ywj.126.1645568831661; Tue, 22
 Feb 2022 14:27:11 -0800 (PST)
MIME-Version: 1.0
References: <20220222161408.577783-1-alvin@pqrs.dk>
In-Reply-To: <20220222161408.577783-1-alvin@pqrs.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 22 Feb 2022 23:27:00 +0100
Message-ID: <CACRpkdY4Ymi8VcWVfEkZDQ6iwMB1YxkwgCsKpsAurfS5sj-E-w@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: add myself as co-maintainer for Realtek
 DSA switch drivers
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ALSI@bang-olufsen.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 5:14 PM Alvin =C5=A0ipraga <alvin@pqrs.dk> wrote:

> From: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
>
> Adding myself (Alvin =C5=A0ipraga) as another maintainer for the Realtek =
DSA
> switch drivers. I intend to help Linus out with reviewing and testing
> changes to these drivers, particularly the rtl8365mb driver which I
> authored and have hardware access to.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
