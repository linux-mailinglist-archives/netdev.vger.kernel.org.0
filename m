Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1815D1E4
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfGBOkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:40:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40801 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfGBOkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:40:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so1302066wmj.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tTmjtWmWf6ZvGqYByeM0PAx1Zh0B/h0VLok6y8JFxKo=;
        b=a30Sb2J/457IynmLDyZPJms4qf14q0PyLiU/z8Glv3g2iB72yL7nDusskvXdF81q3k
         r3OWjTSWFOC15CEywhzL5pY4ysjnI/mgdoT/kGh/hTFFI5vdFQAIQP6aNJQQjWacD/zw
         euIUYnxmpkoLLiK8U3UfPMlMgrdNmP8KKXro0XK/c8wX/49sdVzPjkQkrbqN7JOdVrg1
         iD63o/xOhc9I0V/jvgpi9rJ7euFyEN82buXmobY3vpLJ5lg+luNBEr03tM+WJbhyYgyP
         WQXkLrw23kkHQqy3gmXGSWW3Qpt/nNFaJRYM/3l5H3Dc1QBIIRS+20qeoRAqLDrwsmtb
         gb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tTmjtWmWf6ZvGqYByeM0PAx1Zh0B/h0VLok6y8JFxKo=;
        b=qGb1euKLF3Acr8MYUa7DPYm6bihl6QvsuJRk72xCC32aI4Tq9rpDSKzVnN6jMjZqtA
         7+uH5nVHBcFxHJCNVqPEi7dNhoCp7I/A403kHtqtStIPqNAiefFB3/Klp487wUjPp4nf
         X3Xf6N18bEScDFSXnDTD0krrdMxfGSRTG14J0/ZnwgCt+QOFI+qTX+v4CawAGU86aE4Y
         b9Lm238bO8m13DEDBaF296vfyn1sBxEzIXPFaEUJKd67ELpMYOhI7gVf9piJwMSpxhkk
         lwZetEIWrYYiGStFob0t3aX1rV6wFB3ymj4MFugUeAE9lRLXfnNDBPPbExo+n79FNF+e
         gcNg==
X-Gm-Message-State: APjAAAWu77XZrFsS5+2M4E+liJEQTapmtfNj6n0QwVb0Bafk5hQFNaNK
        /gEoyb3ST5y760cmj+n/wBK0tzYejduLysrbVYw=
X-Google-Smtp-Source: APXvYqztise+8XJdpsu/8AJaoAsgwG0QyM0Qr630Y9vulFEOxxuIcTCA/unfEunjR6/r5ZRJIUjKEB7ANireHmdbTrU=
X-Received: by 2002:a05:600c:2182:: with SMTP id e2mr3687092wme.104.1562078415791;
 Tue, 02 Jul 2019 07:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <54cee375-f1c3-a2b3-ea89-919b0af60433@yandex.ru> <fc526c78-2d3f-90ca-8317-a89eb653cbf9@yandex.ru>
In-Reply-To: <fc526c78-2d3f-90ca-8317-a89eb653cbf9@yandex.ru>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Tue, 2 Jul 2019 16:40:03 +0200
Message-ID: <CAFLxGvytDC1TFdT0m9vvijz_93B8TziWURcR-3mskWB-7TzFag@mail.gmail.com>
Subject: Re: [PATCH] User mode linux bump maximum MTU tuntap interface [RESAND]
To:     =?UTF-8?B?0JDQu9C10LrRgdC10Lk=?= <ne-vlezay80@yandex.ru>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing um folks.

On Tue, Jul 2, 2019 at 3:01 PM =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 <=
ne-vlezay80@yandex.ru> wrote:
>
> Hello, the parameter  ETH_MAX_PACKET limited to 1500 bytes is the not
> support jumbo frames.
>
> This patch change ETH_MAX_PACKET the 65535 bytes to jumbo frame support
> with user mode linux tuntap driver.
>
>
> PATCH:
>
> -------------------
>
>
> diff -ruNP ../linux_orig/linux-5.1/arch/um/include/shared/net_user.h
> ./arch/um/include/shared/net_user.h
> --- a/arch/um/include/shared/net_user.h    2019-05-06 00:42:58.000000000
> +0000
> +++ b/arch/um/include/shared/net_user.h    2019-07-02 07:14:13.593333356
> +0000
> @@ -9,7 +9,7 @@
>  #define ETH_ADDR_LEN (6)
>  #define ETH_HEADER_ETHERTAP (16)
>  #define ETH_HEADER_OTHER (26) /* 14 for ethernet + VLAN + MPLS for
> crazy people */
> -#define ETH_MAX_PACKET (1500)
> +#define ETH_MAX_PACKET (65535)
>
>  #define UML_NET_VERSION (4)
>
> -------------------
>
>


--=20
Thanks,
//richard
