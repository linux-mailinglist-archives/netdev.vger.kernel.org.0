Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D81D60BE84
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 01:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiJXX0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 19:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiJXX0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 19:26:20 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64E82EA94E;
        Mon, 24 Oct 2022 14:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666647999;
        bh=iKTgfDoIE6UiOiVrNwpBfj8b16I2mBbHe7AmkJlk1L4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=iGuIKP9yZ+CRYrVew1NNnjmZ7cKj1HPQQ8ODSc7WOGKzk/CJvOVmGGQF3kwri7pov
         FwryWJlHfEQZByBFfxApCs+JhghD11EGvYSAD5kqIG1lmlARYgSbAxNHJKs32nmYO8
         u6qUgxAPb/JJeP6oYS9Z0fQShnRV8i4pxb3C9OpM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.75.40] ([80.245.75.40]) by web-mail.gmx.net
 (3c-app-gmx-bap55.server.lan [172.19.172.125]) (via HTTP); Mon, 24 Oct 2022
 16:45:40 +0200
MIME-Version: 1.0
Message-ID: <trinity-d2f74581-c020-4473-a5f4-0fc591233293-1666622740261@3c-app-gmx-bap55>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 24 Oct 2022 16:45:40 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
References: <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
 <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
 <Y1V/asUompZKj0ct@shell.armlinux.org.uk>
 <trinity-ac9a840b-cb06-4710-827a-4c4423686074-1666551838763@3c-app-gmx-bs01>
 <trinity-169e3c3f-3a64-485c-9a43-b7cc595531a9-1666552897046@3c-app-gmx-bs01>
 <Y1Wfc+M/zVdw9Di3@shell.armlinux.org.uk>
 <Y1Zah4+hyFk50JC6@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:kyHcw3FPKTYvo7tQ0dRRfaP5g86cy9/pBLBRRYb144WrPpKIiE0z+ipmmmiD2vVED2zCR
 GlQnUkHFMQhJS/cecoz+5bF42AiKgmS+arS3+7TyFVgHUNKI+YWzVEoPBWy6SKZ4c4/MMvjZsnC1
 0zWHtxRjESzQjt4HbOEKmM5M7F6sGsiIitAXyDMzBohNJ4xjO3HnanQjHUHbYMuKLVjMQp8ATP+S
 Z6jauN53KNlyP25g7uBjKzEPCmtLfQH2sQ/+bAInqwWMuHwetY6CmHcSPUsbAA5bPDJ9y5rBunCM
 jM=
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ef09e5V6ayg=:vMQyZQkoVZEA38iMgWjG/Q
 kS+2hDrkZ7Logx/3UWwRP6RbPwmFwiTfZrtCTrUmyntphw1Qo60q++R1Srw3GJwf4iwcsbck4
 N6rLxlbUPn6oet/IG/7KtYP4iUWdLpRYX68elg7wDwdF6CV85EnF6P6AsKr0xJEo4bcjSB3Ze
 QLRr30lFmCe4a4zP9sIiEiTzSB3o5LHSBX+qCDYW/IQ3utILOtowz0x0MPlGwlHuVfUW/DDP1
 NMXBylfRqwB0p2FV4PcHD7MhPUq4y3+Gp1AMJYVCy/wLTvBNVvIlA1J8LTc2wH540KTyM+2+O
 +UrwtFgxPxhYAkrsZclUKSaQLmYkr2i9tkaDirB4MSBtVH43CaJ6I6yvR8/WRh9MAs2fv+iZc
 r4SrL3pvYo85+8beFjEogT+8r2+H1va3hpEYsXYP5yvWaGaN45SLGEGl7uoAf3dTBdV+EZ4OK
 l6q4Yn0OEWOVqz7wqDotfwwpQZCdW3792FAkrTONn+5FtpLZEwm0QHYoB1F4nj4vdA/WUoWnX
 eRp/wtaZgtyVhLt2ZOGy9rzjwUFKC5aVfW8lIXXBGFkJt7ck6N7EeMp3msSAaQ+ZpIbTDk59q
 jMvPx6HN8obA6vQ8sa494DHJp0CGRZrsCrNxlp2MGLoEknS0Nxo42eglX4ZbkzeT0weVjfxC0
 YQjR+xdlKIH2IHOtjweRZM7UPv90Vhxp7qV3+smzIXV6Al2f3gjo9q22YwITX8RmD0eTif9n9
 vzVCaaYa5vl7yP7ZgB4G67SWrGEKhbIq+RLDBGnQN6kYzNzWbcBvYYmzWZNA8k/I2i/jQG7G3
 NAq/UOaVLk2T2lLymGWHB35sWtbK0VtLqgzRBiZa/tSphYwwtkJ5x26ZrnUn28tTG5Gf4DsTo
 Uu56zk/FkQ1NI9Nuupec83sSi+TbLcuH9ZzGSnpAZ8jtytIkvHpffui0f5ylY5ekMwGk/AM2Z
 0Q3PM6yIK0Y5r8PBuWTipxbl+7D4xYTJVKetgZtX5CbTWhdHT4gVmG2Y91sDH9CLrkMKFdraZ
 2XYHVphpa3YfpgPb492jg7ypkQAD6BkiJxITReQMC5CsQWWeB8Ty6Lvpy3pfGqAIZDAs64PTr
 hm5zoMA3RYouQiiYmY8gyL+MhTJqejMAA5xClJ3kHy5sunSE4CU6sXA1WDfmB9xt2kVE5CRmT
 D2piQ3q773BisyA8Joyev58UzWBrYIzlIlq7K99sAG3XNPZrFG6rzEJLXGcmr1tE8EKK8/1mW
 r6w79N7IJXHtyyFoZwxFrOV8SL9W5KvChzwK8/Kl+yx7Snxb6MQya3bbfiHGcAEQyHzep8dpT
 x0UhGKFZ
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi
> Gesendet: Montag, 24. Oktober 2022 um 11:27 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>

> Here's the combined patch for where I would like mtk_sgmii to get to.
>
> It looks like this PCS is similar to what we know as pcs-lynx.c, but
> there do seem to be differences - the duplex bit for example appears
> to be inverted.
>
> Please confirm whether this still works for you, thanks.

basicly Patch works, but i get some (1-50) retransmitts on iperf3 on first=
 interval in tx-mode (on r3 without -R), other 9 are clean. reverse mode i=
s mostly clean.
run iperf3 multiple times, every first interval has retransmitts. same for=
 gmac0 (fixed-link 2500baseX)

i notice that you have changed the timer again to 10000000 for 1000/2500ba=
seX...maybe use here the default value too like the older code does?

regards Frank
