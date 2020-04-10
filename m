Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6EA31A3E71
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 04:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgDJCt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 22:49:26 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:37844 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgDJCt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 22:49:26 -0400
Received: by mail-il1-f195.google.com with SMTP id a6so716728ilr.4
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 19:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/sfn69J/dohNo9kDpfzOv7dy0VahZspr69zJfNmiPP8=;
        b=R1myvxuC7fVf2LJwDDU+mjofJvqlMbT52v2NhLrdiadNJ8ldFLSr5pBRsKT7xxjDSZ
         F7+nKp4G4CbP37vAd3ubrquuG+i3jwouORiZ02jQ3/RZVAYxjY8sMUjki1GDyLJcnN7p
         NQgnbxR/lqwkvF0M7WgPmHl4VY9UpPrE+bVwfLk2UqxdcsTKN2ZmUnT1nt+WljVZva+p
         tW8BINv5Ctm4r/4PjqwASpPW/g1DGdHIznrohjn0pU5XxG0pBTjlmdSiZJk9YS3oSKq9
         1dmEaaC0lFZCj4VvnKQ7gGwJBiB8GDukBejfJZX0i9vikpe98KUuOn11TMF3jeb03++V
         PZMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/sfn69J/dohNo9kDpfzOv7dy0VahZspr69zJfNmiPP8=;
        b=Lmz3pJqZWqpLOLq+gjM6yxw1gfxm2OMZAt4NQn1hCiDMP9x9pVMDLYvcu9qvM0nJY3
         zf4EI45KWS1gPioIaeDWE/Tn6FyvNGX/z0BMu5V2DkVo9mIDlmrlE6fNRBawPevKLP+7
         iGRpq5kNTuy5UOF7xNJaCo5EqBAmW1zSunNTxcV2uh6sce+oVT3s9H046p2KDeSp38QQ
         0YdNMj1VB8x3qKFZx6ZlhCU3uPIkjrwi5GMMOUC2TkjIuXHFqN5UfDIloCG8yOscqpjR
         UTnU9nlMU1bpi/nuNwV2O+SMOtRftFpDWVbsz275mt0ZUrCKTqEFIts9ykZTie+iTsyU
         SyPw==
X-Gm-Message-State: AGi0PubLVVVENaqyowUtiFPioNjzBHFty9SLBstxEipRMYciSVtjoReF
        ThUWK4lzI0lFG2J07k48QJy4rnM9v84frpugdr0=
X-Google-Smtp-Source: APiQypKJqA2Yk1dt33hG2du26+gxJQz8kWBqwdXmIWt37zo5U96ahHd4TtOPvnVKjvFJKkDiVic0hFNFMZ2ab3GPoB4=
X-Received: by 2002:a92:8c08:: with SMTP id o8mr2872774ild.123.1586486965715;
 Thu, 09 Apr 2020 19:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200409155409.12043-1-dqfext@gmail.com> <20200409.102035.13094168508101122.davem@davemloft.net>
 <CALW65jbrg1doaRBPdGQkQ-PG6dnh_L4va7RxcMxyKKMqasN7bQ@mail.gmail.com> <c7da2de5-5e25-6284-0b35-fd2dbceb9c4f@gmail.com>
In-Reply-To: <c7da2de5-5e25-6284-0b35-fd2dbceb9c4f@gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 10 Apr 2020 10:49:15 +0800
Message-ID: <CALW65jZAdFFNfGioAFWPwYN+F4baL0Z-+FX_pAte97uxNK3T6g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: enable jumbo frame
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Wang <sean.wang@mediatek.com>,
        Weijie Gao <weijie.gao@mediatek.com>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 10:27 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 4/9/2020 7:19 PM, DENG Qingfang wrote:
> > So, since nothing else uses the mt7530_set_jumbo function, should I
> > remove the function and just add a single rmw to mt7530_setup?
>
> (please do not top-post on netdev)
>
> There is a proper way to support the MTU configuration for DSA switch
> drivers which is:
>
>         /*
>          * MTU change functionality. Switches can also adjust their MRU
> through
>          * this method. By MTU, one understands the SDU (L2 payload) length.
>          * If the switch needs to account for the DSA tag on the CPU
> port, this
>          * method needs to to do so privately.
>          */
>         int     (*port_change_mtu)(struct dsa_switch *ds, int port,
>                                    int new_mtu);
>         int     (*port_max_mtu)(struct dsa_switch *ds, int port);

MT7530 does not support configuring jumbo frame per-port
The register affects globally

>
> >
> > On Fri, Apr 10, 2020 at 1:20 AM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: DENG Qingfang <dqfext@gmail.com>
> >> Date: Thu,  9 Apr 2020 23:54:09 +0800
> >>
> >>> +static void
> >>> +mt7530_set_jumbo(struct mt7530_priv *priv, u8 kilobytes)
> >>> +{
> >>> +     if (kilobytes > 15)
> >>> +             kilobytes = 15;
> >>  ...
> >>> +     /* Enable jumbo frame up to 15 KB */
> >>> +     mt7530_set_jumbo(priv, 15);
> >>
> >> You've made the test quite pointless, honestly.
>
> --
> Florian
