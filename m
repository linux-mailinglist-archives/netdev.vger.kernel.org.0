Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5F2530BAA
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 11:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiEWIjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 04:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiEWIjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 04:39:12 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCA33CFFB
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:39:08 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ff7b90e635so73859697b3.5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ms1xiGnp9VFH8Q9WvnNJjHzsFoHcObvaufuDxPzB8s=;
        b=Uet4r7oIXi/ElVe63yV1mWhDRZ+fGIgc5OZMp+pGq/pwPrZ33OPF1HDuE/BKkaKPXK
         jQDEkdFsjwaDOM0WHhuA6doA6kC9TMW7VHOC3aArWFo8rD/XFve21eGHC2NVQEFM2Fsa
         2BBCBMxfigeAO9ep6xDQ7mXqxxb34jwF1pEXTfDTPfYT9Kc/Ugs23KFhBZSXh10RM9Zx
         AIEUjNNEc3uDMKeQMajmp/JwzZqX9O+cG6X1BA+62WhYx8hK945ueObKZ6qjPB/0xKbQ
         2KETO5q4v/umXdZUIidDW+RgYqN91R5iY8+h+dRBlHq3TGczK5IM4T4WU7a8EIkNSg9q
         r69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ms1xiGnp9VFH8Q9WvnNJjHzsFoHcObvaufuDxPzB8s=;
        b=hAKVc1aSvpM9xZPzjpgiHSJnMHA2F2JVY6NmBzE9TUA/PDqUwSkF89D60v1yggvhQw
         HY3Si/bMnslKRdEtc+U9zFmpP+d28XUe56JILN/QP9CngdurPYkxFAzTMFjtr9iz9tj1
         L4RuZ8/nD78Tan0M1tQ6aUnqLt4BtXtQ2jqj+Mve/Fci1L94YAIihhSC9HxlKIsF4WjT
         4nWqUqXxDx9i/Ckl/nhB9aaToC9HKYqj9c2ZIj4ruf2K/BZD5J54ds226NpWHexrecNb
         08g2phO1VnQr1lcjqUI1KvF/lSCp9B99bw7yd0LwV4BWsmaLznuGm8cTDwlDgF6Zb17R
         H7Iw==
X-Gm-Message-State: AOAM530dAPwXhxYjQ1H+v7kao2VO5dcjC75HslCWSnumj7Eab/IxtM1J
        ZYYl9IbOlpE4js+B3/llOo0u/FLeZG9Qe7Sh5nkXgg==
X-Google-Smtp-Source: ABdhPJzVCJisNVWwF/tRYhS+3OQBbnOrRKNdHmqe9UxkbvUyiNZVzi+GLJWTPkxmpI2apsjpExrpugAd+DKqFmDQJAE=
X-Received: by 2002:a81:a107:0:b0:2ff:e11d:3ad8 with SMTP id
 y7-20020a81a107000000b002ffe11d3ad8mr5164601ywg.448.1653295147509; Mon, 23
 May 2022 01:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220521200734.421223-1-a.fatoum@pengutronix.de>
 <CACRpkdbKUHu-T2whY4wgk5xnR7X-hptEg+Jm5Hudq8ieQi3VwA@mail.gmail.com> <80306a31-462c-4ce3-5c54-c0f74ad828f8@pengutronix.de>
In-Reply-To: <80306a31-462c-4ce3-5c54-c0f74ad828f8@pengutronix.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 23 May 2022 10:38:56 +0200
Message-ID: <CACRpkdbR_pbQ7L4m8oYt3PN4QT0oXx2-ESHWNTt=QRcpH_gOrg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT binding
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 12:16 AM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> On 22.05.22 23:03, Linus Walleij wrote:
> > On Sat, May 21, 2022 at 10:07 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> >
> >> The BCM4349B1 chip is a single-chip Bluetooth 5.0 controller and
> >> Transceiver. It is contained in the CYW/BCM89359 WiFi+BT package.
> >
> > So the BT and the package have two different names.
>
> The package also goes by the name BCM4349B1 apparently.
> Cypress support had later confirmed BCM4349B1 and BCM89359 to
> be the same chipset. I should probably rephrase the commit message.
>
>
> >> +      - brcm,bcm4349-bt
> >
> > Then why do you have to tag on "-bt" on this compatible?
> >
> > That is typically used when the wifi and bt has the *same* name, so
> > the only way to distinguish between them is a suffix.

> I think that's the case here too.

OK then!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
