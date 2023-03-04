Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB346AA62F
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjCDAV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCDAVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:21:25 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3018C5B5D0;
        Fri,  3 Mar 2023 16:21:24 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id z5so4028075ljc.8;
        Fri, 03 Mar 2023 16:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JinayjQ+FRJfdz6rtIqH02UdJx0VHccAawBNmE8kFLI=;
        b=otzTRpj2mVxBB2jy4tVDGo+7c4Bhy+M5/xoDVew66k5kMGm2DaaN71u3n4f4/gittE
         UoGXkEg77ZJZAFiJR8/xT3dGsAgSXkByl+koOa5nhzMFSb8MoFr5AbLHPUb/VWE2ck6O
         PhrLI6z6Y/5WTDZ3UCMO8kG+1bSTgoZbLv+mUvrKkOYC+GYC1vXzthQho1tVSK3jl0e1
         Z8kp4tglonkwsSbFtPQ8mpgkhvRcieRa02Nh393FqfM/z0+lAbMtCH1U6HsvbLLdF21g
         SVAmAjV9/Kfvvv8QTHVmrl7/6BWNFkNm5jG8Z7vOAwzQ5kFPfwgZTW9cqxwqoGFtYnQ4
         U+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JinayjQ+FRJfdz6rtIqH02UdJx0VHccAawBNmE8kFLI=;
        b=OtDzt9FzfVLVF/qR5ZcbNLv19qDn/glY3Wq9N+xh1Plx1vQyFvr7r0vM1cSaCJfP66
         KilXmrfE4/6iEYQODC37gIQ6nW5bXa047nAF0U1gal6Tj+j8/sHniNov7N6K+U5nXQGN
         gkS9ToRkRVUW7PuiU2TCpSfiz1wr3daqPn150mB+1GbZkOBmzr0eMXG+USqZo3JbTwsU
         BC9UzZ+kmXqSBzvsUboOXdHLDvJtgBYCjQ27EV4pBkC0iahIXmqqZ9S2ipI/9jxOA+zj
         538U4iNcR7PTAPuQwNyi3fVyQPFpW6ifI15dod3TGFqM98SxK/hMQUg4Sm0HYjMvNFy/
         iPnw==
X-Gm-Message-State: AO0yUKXrOVGXLnoWW6kW/JDNvCzRfPpNLdahqrpOvs9vAewRGfvUJ6V3
        08Ut7dMS37inRsyknwziEBhnaY75tbPk3p1Y6lBN+4pLIRM=
X-Google-Smtp-Source: AK7set9D99c+i6SWpFr5eOXLcsEwBWpUbeNnXnVvzaZAVbE39bnRoE/pylU8uWjZ2OrFbqAIxfbXwhL13a9ljTiXT7k=
X-Received: by 2002:a05:651c:b9b:b0:295:9dc0:f204 with SMTP id
 bg27-20020a05651c0b9b00b002959dc0f204mr1108583ljb.9.1677889282251; Fri, 03
 Mar 2023 16:21:22 -0800 (PST)
MIME-Version: 1.0
References: <20230206233912.9410-1-bage@debian.org> <20230206233912.9410-2-bage@debian.org>
In-Reply-To: <20230206233912.9410-2-bage@debian.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 3 Mar 2023 16:21:10 -0800
Message-ID: <CABBYNZLuCoTZEnC83E_Ctz4kF4Bpr=O7a9WbBY-92_3auYT_ew@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] Bluetooth: Add new quirk for broken local ext
 features page 2
To:     Bastian Germann <bage@debian.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bastien,

On Mon, Feb 6, 2023 at 3:39=E2=80=AFPM Bastian Germann <bage@debian.org> wr=
ote:
>
> From: Vasily Khoruzhick <anarsoul@gmail.com>
>
> Some adapters (e.g. RTL8723CS) advertise that they have more than
> 2 pages for local ext features, but they don't support any features
> declared in these pages. RTL8723CS reports max_page =3D 2 and declares
> support for sync train and secure connection, but it responds with
> either garbage or with error in status on corresponding commands.
>
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> Signed-off-by: Bastian Germann <bage@debian.org>
> ---
>  include/net/bluetooth/hci.h | 7 +++++++
>  net/bluetooth/hci_event.c   | 4 +++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 8d773b042c85..7127313140cf 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -294,6 +294,13 @@ enum {
>          * during the hdev->setup vendor callback.
>          */
>         HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG,
> +
> +       /* When this quirk is set, max_page for local extended features
> +        * is set to 1, even if controller reports higher number. Some
> +        * controllers (e.g. RTL8723CS) report more pages, but they
> +        * don't actually support features declared there.
> +        */
> +       HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
>  };
>
>  /* HCI device flags */
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index ad92a4be5851..83ebc8e65b42 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -886,7 +886,9 @@ static u8 hci_cc_read_local_ext_features(struct hci_d=
ev *hdev, void *data,
>         if (rp->status)
>                 return rp->status;
>
> -       if (hdev->max_page < rp->max_page)
> +       if (!test_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
> +                     &hdev->quirks) &&
> +           hdev->max_page < rp->max_page)
>                 hdev->max_page =3D rp->max_page;
>
>         if (rp->page < HCI_MAX_PAGES)
> --
> 2.39.1

Looks like I never replied to this one, we might want to add a warning
when the controller requires such quirks since the manufacturer is
supposed to fix this in their firmware.



--=20
Luiz Augusto von Dentz
