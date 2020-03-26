Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B98194186
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgCZOcF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 10:32:05 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:45501 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbgCZOcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:32:05 -0400
Received: from mail-qv1-f47.google.com ([209.85.219.47]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MkpjD-1jfDVk2T9T-00mGtE for <netdev@vger.kernel.org>; Thu, 26 Mar 2020
 15:32:03 +0100
Received: by mail-qv1-f47.google.com with SMTP id g4so2977652qvo.12
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 07:32:03 -0700 (PDT)
X-Gm-Message-State: ANhLgQ07hqHREbTEkon6z2votWiDP05qqwzVpTqybOUEA7bjOp8MgfhD
        aGmOaywFbxypGAen7cjrNv+NFxCOj/j9nmjbea4=
X-Google-Smtp-Source: ADFU+vvPo1eWm5CuJlWEMWMyDYQTa8RbmaRy4cW1v5AITQaskgyjbMlWdTh7wt07yLDwJNJtPELg4S+4CFCTGDZjFag=
X-Received: by 2002:a0c:a602:: with SMTP id s2mr8585355qva.222.1585233122247;
 Thu, 26 Mar 2020 07:32:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
 <CAK8P3a2THNOTcx=XMxXRH3RaNYBhsE7gMNx91M8p8D8qUdB-7A@mail.gmail.com> <c70371c2-7783-b66a-3108-dbbda383673d@alphalink.fr>
In-Reply-To: <c70371c2-7783-b66a-3108-dbbda383673d@alphalink.fr>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 26 Mar 2020 15:31:45 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2oWT2yob76QQHDm0z7z6xcVoRDEejj7ro4heQYyWGQ3A@mail.gmail.com>
Message-ID: <CAK8P3a2oWT2yob76QQHDm0z7z6xcVoRDEejj7ro4heQYyWGQ3A@mail.gmail.com>
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
To:     Simon Chopin <s.chopin@alphalink.fr>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:5IDrtKQV9PymG4R8Bd1maalmOT/8mMlBg6NdZbke3rtOJWiKhAD
 LPaIPeHzTrwjB9HjuJQWTMD5eFfFVML+WLaqsZ1AntGI8gyfX3uME4SyMgzYZV+7n2DcCMA
 Oa2rzgxBI0G+pD37pZW8uBteKvG13xLpliYaCW9SzPR7Rsz+pS/FLUvmfIpdn4zhzATYb6A
 EkfBdYA/I4y+b2UZdSmWw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IxLxEobinVg=:YdTP0GOjaZDE/KUQ1PFoqf
 S/F0GCO/bt/+i8DvyDvOmBbbfveVlbutCRS+hZcYGiGXaYMzCV9Q+/gHZetIBinnIrpIp3IFl
 2RVepRwmMyFcKZIevPewxr5gvOSJzGNC0LO9SkN8D5q9jz5FidoYu5NeuA4e11sCs3+5lDpqV
 kb1eYOIy7GFJOdM+m46df+bo7Tdh8588G1AkvIWi5qu9VYrrCdzIQOI810OFpTlGgfJZZkT4h
 GQBPoYd90e/1bnHpTwTtlyGYl1t++aFQnMTpfH62Lvon60qaq7RHlz0q3g8r1iitqPkxyywTt
 +4Pv2Vn0l3g94OIs8b2MFdYGDXCR9lTNV7NPL/7W9uY6D8WFgiUo9QYPKHqhPsgtKrQ5dXQ8x
 m3hbpsRmvin9SEXRJkN8cFCMpoY4cDmrxY04T+5jPhYpdGyQwJPyuQSeMRTpoY3k8UnZ0SMBb
 GboSZLf7PJc6l0AKbDexKgAQN+MZ9yAkYd2ZrD3I0JYVNw8naBXbMdguf2HZxmlT1asFHS49U
 HY21tAzV6Jq4/6SPwnp56UJjyBTA0PkG3PycoGWfWoGG51lQi/8SCTsqTB0wb5im3jjWYwVjM
 0NoeqVXXJNyXeW9Pnj3h4vl11D0vs6t5bwF+Ja38wG3Zt1WbgccombUo9/5S/F00yQv0E2tZT
 Wq+JrNRe/oEO1Ay8y2/gTFKkaeWXhHm2sNmuB6jxwhlITTGhFchcDi4XeXnm82870ZZU6YwKx
 XiSyjbneXCUKN4ydq919kecPUWFXhJM94raobr3PIG2AgzWtgC6bXELgVnRXqhOlkSnPvv/eL
 RIuvdHz3YBGpZEqGnFGCSEznPIZfSTVf4H/WLr/kfCHbV5D0EQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 2:48 PM Simon Chopin <s.chopin@alphalink.fr> wrote:
> Le 26/03/2020 à 11:42, Arnd Bergmann a écrit :
> > The patch looks fine from from an interface design perspective,
> > but I wonder if you could use a definition that matches the
> > structure layout and command number for PPPIOCGL2TPSTATS
> > exactly, rather than a "very similar mechanism" with a subset
> > of the fields. You would clearly have to pass down a number of
> > zero fields, but the implementation could be abstracted at a
> > higher level later.
> >
> >       Arnd
>
> This sounds like a good idea, indeed. Is what follows what you had in mind ?
> I'm not too sure about keeping the chan_priv field in this form, my knowledge
> of alignment issues being relatively superficial. As I understand it, the matching
> fields in l2tp_ioc_stats should always be packed to 8 bytes as they fall on natural
> boundaries, but I might be wrong ?
>
> diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
> index a0abc68eceb5..803cbe374fb2 100644
> --- a/include/uapi/linux/ppp-ioctl.h
> +++ b/include/uapi/linux/ppp-ioctl.h
> @@ -79,14 +79,21 @@ struct pppol2tp_ioc_stats {
>         __aligned_u64   rx_errors;
>  };
>
> -/* For PPPIOCGPPPOESTATS */
> -struct pppoe_ioc_stats {
> +struct pppchan_ioc_stats {
> +       __u8            chan_priv[8];
>         __aligned_u64   tx_packets;
>         __aligned_u64   tx_bytes;
> +       __aligned_u64   tx_errors;
>         __aligned_u64   rx_packets;
>         __aligned_u64   rx_bytes;
> +       __aligned_u64   rx_seq_discards;
> +       __aligned_u64   rx_oos_packets;
> +       __aligned_u64   rx_errors;
>  };
>
> +_Static_assert(sizeof(struct pppol2tp_ioc_stats) == sizeof(struct pppchan_ioc_stats), "same size");
> +_Static_assert((size_t)&((struct pppol2tp_ioc_stats *)0)->tx_packets == (size_t)&((struct pppchan_ioc_stats *)0)->tx_packets, "same offset");

Conceptually this is what I had in mind, but implementation-wise, I'd suggest
only having a single structure definition, possibly with a #define like

#define pppoe_ioc_stats pppchan_ioc_stats

When having two struct definitions, I'd be slightly worried about
the bitfield causing implementation-defined structure layout,
so it seems better to only have one definition, even when you cannot
avoid the bitfield that maybe should not have been used.

>  /*
>   * Ioctl definitions.
>   */
> @@ -123,7 +130,7 @@ struct pppoe_ioc_stats {
>  #define PPPIOCATTCHAN  _IOW('t', 56, int)      /* attach to ppp channel */
>  #define PPPIOCGCHAN    _IOR('t', 55, int)      /* get ppp channel number */
>  #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
> -#define PPPIOCGPPPOESTATS _IOR('t', 53, struct pppoe_ioc_stats)
> +#define PPPIOCGCHANSTATS _IOR('t', 54, struct pppchan_ioc_stats)

here I'd do

#define PPPIOCGCHANSTATS _IOR('t', 54, struct pppchan_ioc_stats)
#define PPPIOCGL2TPSTATS PPPIOCGCHANSTATS

       Arnd
