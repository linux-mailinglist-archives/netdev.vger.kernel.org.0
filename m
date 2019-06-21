Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B678E4E1C0
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 10:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfFUINx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 04:13:53 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37842 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfFUINx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 04:13:53 -0400
Received: by mail-wm1-f42.google.com with SMTP id f17so5600139wme.2
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 01:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=WhyLAZva/r2cez8LoenoDFIGn+MzHCpElAd/OkPgrWw=;
        b=Luphy+kFM0UPmTK0bK39X/4QumSMkusKiyRWhhBfbw48HUQ36N4xhKHm0JoAQFWcoH
         JM9q63icj4cx0EzGmOt8DIUwZWLcSUyjwN33mhwFeoYa4cD4fsWqcIxKEv+gBGEoKlkW
         FwCpLJlJ34KwR67YGUCNYPBIIjeEiV//Re11RdrRlzziIR5czEXDwIp15TDOkaNxvX12
         c+WjOyzHfuJ6qjJUV2ZSt8OF+PQkK6RnLkh1KRjFRQ3x58SSrjjucxd3z0hsrUcBKB5i
         zDcD56ot4SGmISXWv/3D7dNy5glWoquaQU0joFrkU2C600QI+2xaUORQf0wD/FXlIjv9
         j74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=WhyLAZva/r2cez8LoenoDFIGn+MzHCpElAd/OkPgrWw=;
        b=JRL9tlu7e3e7L9OC1GlIZ3ioCQ7NP70J2YNXj8hDYEsrjrfY0EBHUi9bOsntl6yujo
         tXBO+Z5g359HnwnKcUHSy67Ae2bVkH37xE1UAF7feV2mwJaFQnQAvfeUVGGKitb6soKH
         fG5boO+w+eHAoXHdO+RtANf/xNIeaAljbZV8Bk2PU3zjOBmNUVZNz01TIYtJG/wOYIAJ
         0zmZmeF54ADJ56Vpve80aHMbSzd+hZo3CPZrvNDmBwGA/3WvxXAv1EokDW1TAUgy0Ce9
         +3rU7VQk5zQFJLGAKINeDtr+LuRPJX89U2ODKt0p7leDEMpS/fOycgCEnOpZ94gisZ7J
         PCQg==
X-Gm-Message-State: APjAAAVBUrnO6M+p7B/qK6BLz5jjjMWIxz3i4U+1pLU+/CnpwLVljuT5
        oLe45OeiP/0Mqdcn3tnjSixrznousFWyw8e3mzak5QKtBp0OXBp43Vljcnt3QYaNAvcFgxUetxC
        Vq9E3p4RIZGi6I8+W7fo/DcX/6bqs3BM=
X-Google-Smtp-Source: APXvYqxh4jGrxWzsaC2OPifCCGEu1ASFTKDqGsvuaWrY4ez/z9cEUChAnGXHKGRvV7SgPbav7wlqxOFUdOah756Ck44=
X-Received: by 2002:a1c:343:: with SMTP id 64mr3181670wmd.116.1561104831110;
 Fri, 21 Jun 2019 01:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAHckoCwhR_TcOuhPHa8XuQeGjJC3=vcRWXcddjzV1nx6crC-wQ@mail.gmail.com>
In-Reply-To: <CAHckoCwhR_TcOuhPHa8XuQeGjJC3=vcRWXcddjzV1nx6crC-wQ@mail.gmail.com>
From:   Li Feng <fengli@smartx.com>
Date:   Fri, 21 Jun 2019 16:13:38 +0800
Message-ID: <CAHckoCzwYqbwfyQ07rAtNhWKXdAPOUym78ZiLrKYBYquMfYqNA@mail.gmail.com>
Subject: Re: Poor Loopback Interface Performance
To:     Storage Performance Development Kit <spdk@lists.01.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct CC netdev@vger.kernel.org.

Thanks,

Feng Li

Li Feng <fengli@smartx.com> =E4=BA=8E2019=E5=B9=B46=E6=9C=8821=E6=97=A5=E5=
=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=884:07=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi, SPDK & Netdev,
>
> When running fio with SPDK iscsi target,
> we find the localhost interface has a bad performance,
> contrast to access from the remote node.
> After upgrade the kernel to 5.1, this issue still exists.
>
>
> There are some fio data of 4k randread, QD=3D128, jobs =3D 1:
> iSCSI server run on the NODE1, fio run on NODE1 or NODE2.
>
> Fio +  localhost(NODE1) + openiscsi + SPDK + NVMe
> (3.10.0-693.11.6.el7)          62k
> Fio +  localhost(NODE1) + openiscsi + SPDK + NVMe (5.1 kernel)
>                 86k
> Fio + remote node(NODE2) + openiscsi + SPDK + NVMe
> (3.10.0-693.11.6.el7)    120k
>
> Try 1:
> Connect localhost target with another interface ip (e.g. 10.0.xx.yy),
> the performance is poor. The kernel driver could recognize this is a
> local access, and use loopback directly.
>
> Try 2:
> Setup a new namespace, and add another interface in this ns, and iSCSI
> target listen on this interface.
> Openiscsi connects from the current host, the performance is good.
>
> Question:
> 1. Is this a known issue about the loopback? Any workaround?
> 2. If this is no solution about loopback, how do we force the local
> interface(127.0.0.1, and other nic interfaces) over the wire, not
> directly pass in the host?
>
> Thanks,
> Feng Li

--=20
The SmartX email address is only for business purpose. Any sent message=20
that is not related to the business is not authorized or permitted by=20
SmartX.
=E6=9C=AC=E9=82=AE=E7=AE=B1=E4=B8=BA=E5=8C=97=E4=BA=AC=E5=BF=97=E5=87=8C=E6=
=B5=B7=E7=BA=B3=E7=A7=91=E6=8A=80=E6=9C=89=E9=99=90=E5=85=AC=E5=8F=B8=EF=BC=
=88SmartX=EF=BC=89=E5=B7=A5=E4=BD=9C=E9=82=AE=E7=AE=B1. =E5=A6=82=E6=9C=AC=
=E9=82=AE=E7=AE=B1=E5=8F=91=E5=87=BA=E7=9A=84=E9=82=AE=E4=BB=B6=E4=B8=8E=E5=
=B7=A5=E4=BD=9C=E6=97=A0=E5=85=B3,=E8=AF=A5=E9=82=AE=E4=BB=B6=E6=9C=AA=E5=
=BE=97=E5=88=B0=E6=9C=AC=E5=85=AC=E5=8F=B8=E4=BB=BB=E4=BD=95=E7=9A=84=E6=98=
=8E=E7=A4=BA=E6=88=96=E9=BB=98=E7=A4=BA=E7=9A=84=E6=8E=88=E6=9D=83.


