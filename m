Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26D6A8B1D6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfHMH6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:58:30 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43863 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfHMH6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 03:58:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id b11so5697173qtp.10;
        Tue, 13 Aug 2019 00:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EFwW5vEWPrVOOfArPqI1XRr3s+F6GRCdAPfriV5QxEQ=;
        b=JUmI8xYGWh3CKPyvuj/VF6Ys9u4BXyn6g60OSchVuUzmb/iXp2vu/YcdACoNmIK6z0
         QCNA6mer+INL120E82wphS3rwrfpe3J/GDUBUmhwe50r3pCepx0HquV97/+aiIbFvdPS
         CHEA3CcOhl+yHHSyGrxvE9y83vRrz9Bj0nm0SCCNs/vDrYHKEyFIWOMnyzxMdjk10eJw
         R85oLB66Zhx6TYJDjyOFqOgfybdCWtL8+h9lFnHFVudj7E73qBYKKGNo/Vu30esPKaWG
         kqETuKkl0EBWUMJa1gSu2Ha9EQHItg3udmCt5RF9mBm2BUpdwsvss8RBAYcBV7RK0aYJ
         0dUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EFwW5vEWPrVOOfArPqI1XRr3s+F6GRCdAPfriV5QxEQ=;
        b=M59QPPAp4/eGHWSLzXJDAy03GldBayK+5sQzE514hqcAST24uyYbpQd4JBE3qPFpwx
         wcA4BXIOh201IHrxAvvCozSk8uZDOyUDlj1/xOet17dTqKuGowgB2ueQNcMJFAWSERoh
         3bb+Yi48L1THjgBsNKtZnD9sRP6DcJ1vRLDutxn0OpzbgqXDlfFHr6lAVyYQ356iRkO2
         vDu5nMzQ2rYcrtQU08/lTJn/ttbPFjEJONENaMjv27Ud81TeT71i1FxzcVnEjNQW9Td5
         0Q2329pUhUgKx7bxz04VeNzz/pQ0N+jAT+0KRB0ZhtwRmZ1IfInP68i18KPSOWSEU0r0
         HxYA==
X-Gm-Message-State: APjAAAVFXMOAMO8wri0S8SJCyOdLZGjSjwaQh79Xxarv4rp6c4KxM5vx
        Fgg12WIzFL71N4oOQQHEwJetcB1mpoU+qFVXwN/o/g==
X-Google-Smtp-Source: APXvYqzpzJbcrIcENZ5WMlI0jI2ATOmIJTf5HYS5EaHJAq6c0w+Qqqaxg2NQzwmU0xE74E7QI8w4Bx3JalaoJct/D8g=
X-Received: by 2002:a0c:d4d0:: with SMTP id y16mr31969564qvh.191.1565683109384;
 Tue, 13 Aug 2019 00:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-4b663366246be1d1d4b1b8b01245b2e88ad9e706@kernel.org>
 <20190812221954.GA13314@codemonkey.org.uk>
In-Reply-To: <20190812221954.GA13314@codemonkey.org.uk>
From:   Jack Wang <xjtuwjp@gmail.com>
Date:   Tue, 13 Aug 2019 09:58:18 +0200
Message-ID: <CAD+HZHViF0SEbUmRJUoP7tjpYDfU2f8Ev0Gy1Ev9NN8hPV5hyQ@mail.gmail.com>
Subject: Re: tun: mark small packets as owned by the tap sock
To:     Dave Jones <davej@codemonkey.org.uk>
Cc:     Alexis Bauvin <abauvin@scaleway.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave Jones <davej@codemonkey.org.uk> =E4=BA=8E2019=E5=B9=B48=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=881:05=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Aug 07, 2019 at 12:30:07AM +0000, Linux Kernel wrote:
>  > Commit:     4b663366246be1d1d4b1b8b01245b2e88ad9e706
>  > Parent:     16b2084a8afa1432d14ba72b7c97d7908e178178
>  > Web:        https://git.kernel.org/torvalds/c/4b663366246be1d1d4b1b8b0=
1245b2e88ad9e706
>  > Author:     Alexis Bauvin <abauvin@scaleway.com>
>  > AuthorDate: Tue Jul 23 16:23:01 2019 +0200
>  >
>  >     tun: mark small packets as owned by the tap sock
>  >
>  >     - v1 -> v2: Move skb_set_owner_w to __tun_build_skb to reduce patc=
h size
>  >
>  >     Small packets going out of a tap device go through an optimized co=
de
>  >     path that uses build_skb() rather than sock_alloc_send_pskb(). The
>  >     latter calls skb_set_owner_w(), but the small packet code path doe=
s not.
>  >
>  >     The net effect is that small packets are not owned by the userland
>  >     application's socket (e.g. QEMU), while large packets are.
>  >     This can be seen with a TCP session, where packets are not owned w=
hen
>  >     the window size is small enough (around PAGE_SIZE), while they are=
 once
>  >     the window grows (note that this requires the host to support virt=
io
>  >     tso for the guest to offload segmentation).
>  >     All this leads to inconsistent behaviour in the kernel, especially=
 on
>  >     netfilter modules that uses sk->socket (e.g. xt_owner).
>  >
>  >     Fixes: 66ccbc9c87c2 ("tap: use build_skb() for small packet")
>  >     Signed-off-by: Alexis Bauvin <abauvin@scaleway.com>
>  >     Acked-by: Jason Wang <jasowang@redhat.com>
>
> This commit breaks ipv6 routing when I deployed on it a linode.
> It seems to work briefly after boot, and then silently all packets get
> dropped. (Presumably, it's dropping RA or ND packets)
>
> With this reverted, everything works as it did in rc3.
>
>         Dave
>
Thanks for reporting, Dave.

+cc stable
Just noticed, the patch has been backported to  4.14,4.19, 5.2

Regards,
Jack Wang
