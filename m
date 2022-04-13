Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1A94FFDF7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbiDMSlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiDMSlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:41:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D315EDCF;
        Wed, 13 Apr 2022 11:38:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso7077703pju.1;
        Wed, 13 Apr 2022 11:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cEzcqNKQJRno/ztLVjgvqhJnUGI4j+IRpbWZqgnuI2U=;
        b=ElJ2fyWFc20KUOfeHeVZS0rZ4WK9P1B+yTcorYvtT1F6IIctEgKFwEK/NafanCXmLp
         vSD4/OPDHx5jHH2gwxOx7zhuv7WxTojIaWBZdKwuFA+lRXDuOfb8XhaiftXrAkNOqyMM
         eG6Ot+ZI17MW/bP79onnmHc3c7HpHBOYQFXgArCZOTVNIlCjCU6MWybbLatoRPZTVxvI
         GpZznM6wZTbPjkZ8TPRaxSNMI+wC0bxWis43jCtfkxZ9dzzqC+rf4DqUhzD3xcw3T2ki
         Be6SuQjTWDnxpujKqF62gRm98CigUNYn6dEjriPGlnc5u9ns5MaSoLGQqAWJr+if6kyP
         6/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cEzcqNKQJRno/ztLVjgvqhJnUGI4j+IRpbWZqgnuI2U=;
        b=i7CZVcnQRBGI5QN4T7VlMDruAsFhwgOwJMZebRa5fKvDgb0DX73bsLfsSEnRir/+Xi
         qVXVmxX7AKHBfdBF1PVrCih+PqDGNe3Fpi3OA0s/oc4wFOOkPEmyxafBNjKNQ4fnPCJo
         r5wQv/6x44uzOhIbrVLQORKRIbBi9whTXx3sENCHb/wObabiTJgn5Z9frZBcwIbnyGcu
         3ldoBZAH5gmN8dP+bKKdnWd0EhoQ/GoAH+mWjGfyihKDSPSWlfv9H/R7MqVK3HAtUn/k
         TCYeUbFjG9UV65ZdGoCO+lTlIs+zLnPB0gbDDtOyKo8w0K6oXh28DOCr8+9R29TDNKd7
         Bo7A==
X-Gm-Message-State: AOAM532Rhg06kcokz3Xm+VbXlqWL/LCZneZKtVqJ2xtUY/kIhTpEqWoX
        Pjl8RLwy8tKsuMXof6Jw2IFp8a5zVuZ/GhF5HipOLzdlwsIkOA==
X-Google-Smtp-Source: ABdhPJzQ2DunR1fkUqXI18LQ+lM6B1Ik7d9U3UJFXMZlVuVIIT9g4pmVif8orrlxTKNkZNTZVzfAQgdiuNsHAZEG0XI=
X-Received: by 2002:a17:90a:db16:b0:1cb:9ba8:5707 with SMTP id
 g22-20020a17090adb1600b001cb9ba85707mr133432pjv.32.1649875122832; Wed, 13 Apr
 2022 11:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220411210406.21404-1-luizluca@gmail.com> <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
In-Reply-To: <20220412105018.gjrswtwrgjyndev4@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 13 Apr 2022 15:38:31 -0300
Message-ID: <CAJq09z53MZ6g=+tfwRU-N5BV5GcPSB5n0=+zj-cXOegMrq6g=A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for RTL8367RB-VB
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "tobias@waldekranz.com" <tobias@waldekranz.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Apr 11, 2022 at 06:04:07PM -0300, Luiz Angelo Daros de Luca wrote=
:
> > RTL8367RB-VB was not mentioned in the compatible table, nor in the
> > Kconfig help text.
> >
> > The driver still detects the variant by itself and ignores which
> > compatible string was used to select it. So, any compatible string will
> > work for any compatible model.
>
> This is not quite true: a compatible string of realtek,rtl8366rb will sel=
ect the
> other subdriver, assuming it is available.

Yes, how about:

The string (no matter which one) is currently only used to select the
subdriver. Then, the subdriver
will ignore which compatible string was used and it will detect the
variant by itself using the
chip id/version returned by the device.

rtl8367rb chip ID/version of the '67RB is already included in the
driver and in the dt-bindings.

> Besides that small inaccuracy, I think your description is missing one cr=
ucial
> bit of information, which is that the chip ID/version of the '67RB is alr=
eady
> included in the driver. Otherwise it reads as though the '67RB has the sa=
me ID
> as one of the already-supported chips ('65MB or '67S).
> With the above clarifications:
>
> Reviewed-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
