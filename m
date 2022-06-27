Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1E855C1C4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237364AbiF0PEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbiF0PEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:04:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AB41707F
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:04:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so9714588pjv.3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=tEcR4Yf4Pxbn3po5iIQimLfypZXloy0PqyCU480O85w=;
        b=mphmH1MJDsm43b704Lhh1x+DcmpWQ4I/iLAKsrHsR+ATGSlRC35d1DJNpUhPrNG6ri
         +FbKlzy81OXL4MeRZaJAOIuETiSel4wqGxsH2QFbeDACyfq7c8w/1WWahQcpdPuLi0sB
         uDZj+UWMeHnZxMAXx2QY7p8TqE62g4FUVFf5fG5h1hZyT6AB13sPUAoX3sTuUFFP0Dw+
         F8b3Fzlt9lYC5TYy+h2GD3x9DQzji0tQFPv3bowNqzjSwCmHZBY6h26MCm8jG5lsipUj
         JlHFxP9uJBr8gHEI2wdi6WTpr1eONZZh5T7Bq3DXuymZkcPO2F74eAEJb0I2vgNG7mvX
         LeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=tEcR4Yf4Pxbn3po5iIQimLfypZXloy0PqyCU480O85w=;
        b=VJeRqWxb83HlQqlOaNpfhNveDB5gZSigVXM4s1JIeOzmHmmLGjoIh41dY3JkNyKaAz
         n5TUv0fuI483XDeY31YDbUZ2S4l0XBHiZ1NFl+8UNZ9+GjWTPhFJV2BD+W37q0y0KePp
         udSr/hgg3KuckoiHJ8F28Xmnz1fJFl1vWXjgU+hf2V5A8yWUjGLx4sVGIWCiMnY4XzX5
         3hcFX/Ng72dnxnul7JDMl24pnA5cbSCUyxnox2ofMiV6riEjXtxQ58d7TgUh5vhHSnd1
         VEC6upzjB0o/qdI7F+mKxNOciE1SWcRBje/cXSI4XnrGOuimAAsAQztIwKJWCULvmS2j
         Ls6g==
X-Gm-Message-State: AJIora/0PQXB6XskVbgcv+W5nD8UnnujjhY4KZOO1ON5sqI/hdan919Y
        e4glnYKb1DCMJizUVgXDyyAvQ12g+4mTS7JxEmM=
X-Google-Smtp-Source: AGRyM1tXz1+pSDRJWCYnYw2xBKqun6+920S5zV9XF5IaWJyKjXMQkaE1B8sGCGC33rJc6n2DpABJu56f00dxnPh5s/g=
X-Received: by 2002:a17:902:aa05:b0:16a:5113:229d with SMTP id
 be5-20020a170902aa0500b0016a5113229dmr15172790plb.111.1656342290692; Mon, 27
 Jun 2022 08:04:50 -0700 (PDT)
MIME-Version: 1.0
Sender: vivienkoko693@gmail.com
Received: by 2002:a05:7022:792:b0:40:f5ae:5a8c with HTTP; Mon, 27 Jun 2022
 08:04:50 -0700 (PDT)
From:   "Capt. Sherri" <sherrigallagher409@gmail.com>
Date:   Mon, 27 Jun 2022 15:04:50 +0000
X-Google-Sender-Auth: BHsyMz6_njJ9RnN_0UBb9HPozzU
Message-ID: <CACkbk-4FjqSb17OUycMAhKf182Oax3_ECJxTMYzbyuy_kyHf+A@mail.gmail.com>
Subject: Re: Hello Dear, How Are You
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2YXYsdit2KjZi9in2IwNCg0K2YfZhCDYqtmE2YLZitiqINix2LPYp9mE2KrZiiDYp9mE2LPYp9io
2YLYqdifINmE2YLYryDYp9iq2LXZhNiqINio2YMg2YXZhiDZgtio2YQg2YjZhNmD2YYg2KfZhNix
2LPYp9mE2Kkg2YHYtNmE2Kog2YXYsdipDQrYo9iu2LHZiSDYjCDZhNiw2YTZgyDZgtix2LHYqiDY
o9mGINij2YPYqtioINmF2LHYqSDYo9iu2LHZiS4g2YrYsdis2Ykg2KfZhNiq2KPZg9mK2K8g2KXY
sNinINiq2YTZgtmK2Kog2YfYsNinINit2KrZiQ0K2KPYqtmF2YPZhiDZhdmGINin2YTZhdiq2KfY
qNi52Kkg2IwNCg0K2KfZhtiq2LjYsSDYsdiv2YMuDQoNCtmK2LnYqtio2LHYjA0K2KfZhNmG2YLZ
itioINi02YrYsdmKDQo=
