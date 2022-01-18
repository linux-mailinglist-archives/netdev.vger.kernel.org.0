Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D26492B79
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbiARQrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236908AbiARQrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:47:23 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFBFC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 08:47:22 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id bf5so7159035oib.4
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 08:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=rF60vm/8dNwvA4UcIattIMqMmIBYqOWiYQ4XAq5dQ6E=;
        b=ZaXiuGO7Hn/Y9w/E9xJfrok3iZJo5AhoS2zOoHNfNgGF/9c87UiLBexEISWxD8j7F9
         okOEkVZpGsAMkh8WbcLoTX7jDG4krKhPe3Tq+dTkDGgmNemdNaHfLPDGjpd/U5Si4rtn
         ZxcJhfsUQUvdtkA9jx+ecqL+Czp/8OZ29BGtxijmY3UTwC12/uD5pS0JljdjfUTa9sk1
         70tbf7kczHmxu09n+FSnIz8rKf2zaybCBfxFkf/jtkxHm3sZr4WIEvWqGmVySlMxmbDS
         H4MoFbXxIhpQgyFXTeoM0a4iQr0IY17RsOQrmEYPC7geJJksOD6lZ0+FdglPDurns0Xf
         bO/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=rF60vm/8dNwvA4UcIattIMqMmIBYqOWiYQ4XAq5dQ6E=;
        b=19hQuvpYsk0jJdJ2iPD/DOpVKjCC+EIZY8kVwfeOnAUiS+jKPporM1AazAiDEML0vS
         TTSD6/SgMw5ZomGZvgsHqETfaPjWoN1DBiJWkkNlip6xa83lOxZ/vbfYM5wy3Md+FK0B
         Y4EjRnMoMlBpn03prQUtwZlPBT9pcwKAksfwYr3AxMY/+wlyQJem4ZKnsDDzkRVxz+5b
         jwGpPJtAvk5hDqQwI2K+o7FPU95jLOByxJbLm/xY5ZrsG896RAzf4238ofbVwYMrjcLL
         rQriuD94tMJhHUvXJARa1ZrJuiIa/c5jAHO6r00QqUoIiTFvHBoKByJMeV52rXWFUULP
         X75A==
X-Gm-Message-State: AOAM5312zyLCoP0ornHRwaUuahXenDfr1p6lTR92QppzemwUc0vWcb3J
        9v3mXgPefQQ0U01ldsUTy87gFYzq2VMksWZeLIw=
X-Google-Smtp-Source: ABdhPJxHWVXopTJW+wgz0E82gs1QXgnIkRZ4iJmb/drn96wHC3sCJnvyg/NBtSziaDGKJXS3f6Bl68qCRuA74UA+VN4=
X-Received: by 2002:aca:ad17:: with SMTP id w23mr25432374oie.38.1642524441449;
 Tue, 18 Jan 2022 08:47:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:7d5d:0:0:0:0 with HTTP; Tue, 18 Jan 2022 08:47:20
 -0800 (PST)
Reply-To: djene.conde2022@gmail.com
From:   =?UTF-8?B?TWlzcyBEamVuw6kgQ29uZMOp?= <alexbrak8@gmail.com>
Date:   Tue, 18 Jan 2022 16:47:20 +0000
Message-ID: <CA+r-Va0nHGcW8iwE0hmYYR5Tdhd9+2965ptrF_+HmganThKr-g@mail.gmail.com>
Subject: =?UTF-8?Q?From_Miss=2EDjene_Alfa_Cond=C3=A9=2E?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Hello,
I am sorry that my letter may come to your mailbox as spam because of
internet exchange. I am Djene Cond=C3=A9, the daughter to the former
president of the Republic of Guinea who as toppled in a military coup
on the 5th septembre 2021. I solicit your assistance for a fund
transfer to your country for urgent investment on important projects.,
If you are interested to help me i will accord you twenty percent of
the total fund. Please contact me here: (conde.djene2022@gmail.com)
Rgds
Djene
