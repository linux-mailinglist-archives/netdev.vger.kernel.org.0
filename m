Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580EA14F7EB
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 14:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgBANOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 08:14:10 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:49559 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgBANOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 08:14:10 -0500
Received: from mail-qv1-f51.google.com ([209.85.219.51]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mqal4-1jJxnk1tmy-00meOJ; Sat, 01 Feb 2020 14:14:08 +0100
Received: by mail-qv1-f51.google.com with SMTP id o18so4679652qvf.1;
        Sat, 01 Feb 2020 05:14:08 -0800 (PST)
X-Gm-Message-State: APjAAAW//JkEy+BCiksALGX+7u5lTM42mlU1/tetHh3wlntMABcuskcM
        vCGVx4WDCYrI1YDTKhJDJFj8Vv0Wg+D/dd6uvzg=
X-Google-Smtp-Source: APXvYqzuLmZzlDe0WECUf1s9qKLEpATfkBs6kbKsvRbW3f8o8LQknpzhDn9B3Z0XpzmFVAqpHPZ3Q2HxrreY9WC02o4=
X-Received: by 2002:a05:6214:524:: with SMTP id x4mr12953450qvw.4.1580562847224;
 Sat, 01 Feb 2020 05:14:07 -0800 (PST)
MIME-Version: 1.0
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 1 Feb 2020 14:13:49 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0eL7MH8cfMcq9NNWOggepNAu7vhQSw9_ED_4WXZyY35A@mail.gmail.com>
Message-ID: <CAK8P3a0eL7MH8cfMcq9NNWOggepNAu7vhQSw9_ED_4WXZyY35A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        isdn4linux@listserv.isdn4linux.de,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:/orgqm+0oCsfIzcahMzGBa3JvU1sljA5C8ADaFWsmDJtqNLj7xR
 kHxLR4yJiS37kOpkQ+B8FwPzcsELccuM6+Bq3AtCdmbCMqzjYI+jdjLC0Wnpr+VxvBchqx7
 uiy6kRNfhDHGRTx/BAQpvFcCPcNvDekf5d5cf96uGumWbVcqNSUPVsVnf0asvMQDK4l67kC
 lBTEzpo1ImneE5CUxWXdg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4zklKAk9hkM=:UC3BAsdyr86cfPpY86NvZI
 v1L/IO1n9C3Nv9zUrXxHYInVo/VChv5XVvSuVZKNVZEWVyhoGBAOjLADbv/kuQzEu+p+kgl4i
 GtIqStPiiZ8FL7CW5M7AL4LQjYCxzbRmaUFzKdpkrZP2LisalBTbVzwij9NHBJeegiJR6fc82
 9/l8HIgw67UsfYD0iEOm4jGeMS3dSME87gvyaD9mQGNsiHU9Wzz24Z5f5LZR/pttXZr3c0jKN
 4tC+2weK5i2BvNb8p08W3Btd2aKFRlUv57pMcrqmUyMVcvg67YOglW/fYrRg/k/OvbdaEt0Vc
 Eotw/XbTorF80Z0oOIwhF95BJFE4fqAhesS/KR+FitwM2//xfHR5Eu8HUbhKjHoYCN+q+Oy63
 PgqGRkqpzeWH+qUWc4j9LM5733LN/9zerR0JxJJbJcr3/mf6X/IKCEAkNZHt8tXj2nK2VhG0W
 07u1m+Lj9UPzxN5ZknPLF2FmTPMGCAczlLkxPljsbzD7KaEbOZO3jk3UVcovPVaf0Ut0vGN2A
 aFj0+2inkdY8U9LTd9I6MPjN0WwJ571Px7hcD7OJRkbm597eXHjqygYPn1CHa3CEDL54MscLG
 yh2ytH2vW0VsUARRxvzgzpntzAEhoG0TIksXxoJRvarFIxsrWq4MFVomWJ0Od0hWeH6FCIFI1
 4mtUZCRG+qEgu+JD9F5+bLSTsbKThtJsvMxnwGlYJPez3Wb+Ob2IGRmvjbIsfJ8B2Ds5HGa9D
 RSIB1HMKoxmSyGP2OSeGXIyKFmj09NsjkTQuB4gxbIRc3ZbRD4HCvgXvaL0GOOcE2S1uTxEm8
 71Q1NWWBQfDVyXIrPx95Jjbg3E59iq3ahjVHbkw4l1KeLX38AM=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 1, 2020 at 1:44 PM Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
>
> Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
> isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
> the terminal slash for the two directories mISDN and hardware. Hence, all
> files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
> but were considered to be part of "THE REST".
>
> Rectify the situation, and while at it, also complete the section with two
> further build files that belong to that subsystem.
>
> This was identified with a small script that finds all files belonging to
> "THE REST" according to the current MAINTAINERS file, and I investigated
> upon its output.
>
> Fixes: 6d97985072dc ("isdn: move capi drivers to staging")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Arnd, please ack or even pick it.
> It is no functional change, so I guess you could simply pick in your own
> tree for minor fixes.

Thanks for fixing this,

Acked-by: Arnd Bergmann <arnd@arndb.de>
