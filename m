Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56216455511
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbhKRHJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:09:09 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:55191 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbhKRHJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 02:09:09 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N4yuK-1mdT6h3uTM-010tBj; Thu, 18 Nov 2021 08:06:07 +0100
Received: by mail-wr1-f42.google.com with SMTP id n29so9489190wra.11;
        Wed, 17 Nov 2021 23:06:07 -0800 (PST)
X-Gm-Message-State: AOAM532AifYI4jU7rKXgSwn0NR2idR9NCx0bdWV5YC500+jsbJSBrP45
        KIU5ko9R8zrmv9FaPEphb+weHkM3zT0dQ3xr0cQ=
X-Google-Smtp-Source: ABdhPJw/0fDUXwFJX8w8eAQlT4yGLHAFhPQpcpmd+gcXpzvGBgl+xm5e+ThehwL1RJZLZwQm3zC8zp6otu+O5W1WRlw=
X-Received: by 2002:adf:efc6:: with SMTP id i6mr28866965wrp.428.1637219167491;
 Wed, 17 Nov 2021 23:06:07 -0800 (PST)
MIME-Version: 1.0
References: <20211118070118.63756-1-starmiku1207184332@gmail.com>
In-Reply-To: <20211118070118.63756-1-starmiku1207184332@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 18 Nov 2021 08:05:51 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3HsvNe2Rkpx9DqDRLpxCFrOi8hx5iAhJziwOQcKj-Ltw@mail.gmail.com>
Message-ID: <CAK8P3a3HsvNe2Rkpx9DqDRLpxCFrOi8hx5iAhJziwOQcKj-Ltw@mail.gmail.com>
Subject: Re: [PATCH v2] net: ethernet: dec: tulip: de4x5: fix possible array
 overflows in type3_infoblock()
To:     Teng Qi <starmiku1207184332@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, tanghui20@huawei.com,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>, islituo@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:cHhTKein5BxNHNld9DHUgvqbA2RjfkZ2Rzb8QXQBJedQ3dzYSRI
 qqfq1Ns+6OyK8u0F1116DxTfp8yPEJ+wrrfRpKhP4KYWG6BRtMnFBvWJZ/yXKIYi0aAAO3s
 RCkrjPOn0f2UuqJceg59et5N5P3nNlu4455DcA7Q3hj+tD8aoqF0DVzo71+Yh6cRrARmIyb
 xrNAXfYoSzMPk+38H8MsA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Vf3rweY/7RQ=:8PV5wjclh63/C+0w63McGX
 acq8lktPaw/PdZPxCbl80SdRsj4Dl3NKoAel5S+SqchUV19eODsLsxDeGNxuk7FeEq4SxyrHZ
 apwwTxJTMvyrAy/502BEfPDLaFkIZHDFSOrcKEuqXM2s7biOd21q34T8oq7S/1m+ZlLEsX3q/
 flqHbPnXTd2AbEg6mfELxf5zzdGkhvubLPQkSd/HiM0h4ldRo5pmUpZmPcsr4hMFKPt+ZwGHo
 N5NPMymQV2wG1Pa57YHIYuDYOZvmtAqa6+Ex0G212+A6t7YKbdVosmRvtrAUT3jo61FFHkFyA
 6yeYUWJkCWPVod3lTkrd8sW/6LZamiTSia3L5Ti2P072CQRX/zHis5Ll1ALQWos8Wg8oNHdx3
 w/YXpM6aW3rZF+PGM9B3bZ/UwPLHysjRPGDeHATB50kACEJc2LAOJpAcRZVhrrG3I+KIx5LOy
 0zFnpL21x5CZO8YdSd4kjJ1+jdKeT7F6TB85VbRMhowEEOn7BLfykr4AIDMuTcv+nM0kPiww3
 FzppwZPRIMUcqQKCPGjow7bCDhYcdWwZ2gj40OYhVM7OSj0MC7zZNOIIT+f7LbG4s4FzxDSEg
 H5EyAZXnHhOXwoIep9/nex6j+U/yhksdSHGB7OjsnYOxaEhzJk8gOqEluX1thj/wd6a/YK2h1
 WNatC0rmAnMFgEJzXUg4dX783MF7gZxDXtSRi8RVJsluGTqCju1IpsGbxU/C0vlHqUjGKRASV
 YNNnre6ax8YNPQFR17A5HFFZNvGBvbIQXBIoWBpneK01e4tfUtQWJGfkfuw8HxND8aiKeUgFp
 JO3uECfbcnitQt8zahrEApVr0A3PF31SVnKTw4HvfjAh1so4P8=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 8:01 AM Teng Qi <starmiku1207184332@gmail.com> wrote:
>
> The definition of macro MOTO_SROM_BUG is:
>   #define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(
>   dev->dev_addr) & 0x00ffffff) == 0x3e0008)
>
> and the if statement
>   if (MOTO_SROM_BUG) lp->active = 0;
>
> using this macro indicates lp->active could be 8. If lp->active is 8 and
> the second comparison of this macro is false. lp->active will remain 8 in:
>   lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
>   lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
>   lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].ttm = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].mci = *p;
>
> However, the length of array lp->phy is 8, so array overflows can occur.
> To fix these possible array overflows, we first check lp->active and then
> return -EINVAL if it is greater or equal to ARRAY_SIZE(lp->phy) (i.e. 8).
>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
