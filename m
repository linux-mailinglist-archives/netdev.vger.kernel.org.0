Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BB63EDE0D
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 21:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhHPTrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 15:47:32 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:47833 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhHPTrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 15:47:31 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Mgebs-1mjJ9y0GM8-00h7Dj; Mon, 16 Aug 2021 21:46:58 +0200
Received: by mail-wr1-f53.google.com with SMTP id f5so25113196wrm.13;
        Mon, 16 Aug 2021 12:46:57 -0700 (PDT)
X-Gm-Message-State: AOAM532zMQY95Ol20MAk/aEKEfAF3jtd6XQqtpewy1CUlWcDs5VI0q+K
        d5+R2ieIQwwptxh9ywgPlJJjUx5jaGR3wPpzQpI=
X-Google-Smtp-Source: ABdhPJz5KjKHIA5/4EOwJb7Ma2A00qBnJujFrxAsE6LdiU6qcLYPR0auEFNX3ZzUUJs3kVABWL/CCX9eg5zq7HVAbSw=
X-Received: by 2002:adf:f202:: with SMTP id p2mr103174wro.361.1629143217650;
 Mon, 16 Aug 2021 12:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com> <20210816160717.31285-5-arkadiusz.kubalewski@intel.com>
In-Reply-To: <20210816160717.31285-5-arkadiusz.kubalewski@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 16 Aug 2021 21:46:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0N3N3mFvoPj_fkqOY30uudJceox=uwSW+nd0B0kf8-ng@mail.gmail.com>
Message-ID: <CAK8P3a0N3N3mFvoPj_fkqOY30uudJceox=uwSW+nd0B0kf8-ng@mail.gmail.com>
Subject: Re: [RFC net-next 4/7] net: add ioctl interface for recover reference
 clock on netdev
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Shuah Khan <shuah@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        cong.wang@bytedance.com, Colin Ian King <colin.king@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:yNnIHyXVxaeyxuMJCEkJe9nl/mAlWh6pT6ME1VnoRxlYf2Vy5qv
 UIsW+97Lwg92jh5cdntwIGmC+4+u+Ok/dZp5PIKekDmJThG9xi5pyrgkzbtj+Rq+pJscjTF
 ZfTkZFR5ks8OehgiMvfGKvJclDpIf+AT0jP40YdflB6y/8WYbwYhdlr+s8e4uY3KqPeiB8Y
 BiG7rnkx6n5GLH8ZyiASg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:h12WhL+ACR8=:HprYk9onqHj4BGSFYamkSv
 XZm/1agnx2KVx9NVkBzlTxklhug+eNdwqLizoJmSWM6RxsUrueqluEuTsvyB3PlYGzj3B2IMu
 QipVQjQewAuYr3vf9O3oEumeA/HzNiepDAAyMRoEMzgZGDPkDHE4nwamHoDt8UdDyiNiUjjHU
 dNGj4WOkLCcWoz3XP2geO1J+cF3l4aa/WqX8J7h3yi0HFCW81e6Lpk8wWPn5G/jj1s8snCZXw
 eC+8jSbaXX5y/KhyJXnKnrgNEEc5bS2dUHgy1AiLF2C3AWcyMpjfwV2RPsEfHQZIx9rWxbkVe
 6CeNN7/D1Vtlg385m5hCofhCIT4LAH0keVX0YyI/1J1oHKtLl6SqI/i9igLP5whirznl+tSNb
 B4ik9NJzIBObN1Z/H9eCJsKKAIqkehuO8t6psRtwnV1b462f7FD9OIP06lJ0uSoA/RwjxikW2
 DNfho9IAawRKD8qBHv4Il1Mj4XVe6QETvvmmLswFHSM/rqT6XiUVdrWWcSisgwdVVEtb+Lsjk
 n/1TP2LIZuz7+nbaY05WUUVKL6R0FT9GhECOA2LKWumv+v0tu7LvJYTnWEutd9S94EwCHpV7c
 1E61UYHVTdFuaKWzgEV5+yFIMoU5GjyqNtIedb171ycAOdSiCdeNhT6SOlFyRGoWiRgYPWIpO
 eK6of1WFSOGp+M12KqweNFx+O6nOlsIX5XA6p44hK1aMNhc9bfrzviiCo6uJJm7Lrb4xS1V5U
 MYdy/s9+uDwInJ2jEkmnwEb0otqRbSQWB11Qdy0nfGR9vO68quqEJ13ETZBHIiPCtIBS0rScn
 BXeSqKjIsGwrIEsiOKcaZvNNECuPjFhM8RRtHe1v9u0gKC8bh4pn043WnQk4V30azTjK2ec
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 6:18 PM Arkadiusz Kubalewski
<arkadiusz.kubalewski@intel.com> wrote:

> +/*
> + * Structure used for passing data with SIOCSSYNCE and SIOCGSYNCE ioctls
> + */
> +struct synce_ref_clk_cfg {
> +       __u8 pin_id;
> +       _Bool enable;
> +};

I'm not sure if there are any guarantees about the size and alignment of _Bool,
maybe better use __u8 here as well, if only for clarity.

> +#endif /* _NET_SYNCE_H */
> diff --git a/include/uapi/linux/sockios.h b/include/uapi/linux/sockios.h
> index 7d1bccbbef78..32c7d4909c31 100644
> --- a/include/uapi/linux/sockios.h
> +++ b/include/uapi/linux/sockios.h
> @@ -153,6 +153,10 @@
>  #define SIOCSHWTSTAMP  0x89b0          /* set and get config           */
>  #define SIOCGHWTSTAMP  0x89b1          /* get config                   */
>
> +/* synchronous ethernet config per physical function */
> +#define SIOCSSYNCE     0x89c0          /* set and get config           */
> +#define SIOCGSYNCE     0x89c1          /* get config                   */

I understand that these are traditionally using the old-style 16-bit
numbers, but is there any reason to keep doing that rather than
making them modern like this?

#define SIOCSSYNCE     _IOWR(0x89, 0xc0, struct  synce_ref_clk_cfg)
/* set and get config   */
#define SIOCGSYNCE     _IOR(0x89, 0xc1, struct  synce_ref_clk_cfg)
/* get config   */

        Arnd
