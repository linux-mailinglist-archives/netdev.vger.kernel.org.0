Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC69362BD0
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhDPXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:10:33 -0400
Received: from mx6.ucr.edu ([138.23.62.71]:61980 "EHLO mx6.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbhDPXKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 19:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1618614607; x=1650150607;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc:content-transfer-encoding;
  bh=SygSNkbaMWX+V8Hor2+klt+qQPcK1BBeqBQmRHhHQYs=;
  b=hfBx80i82I1UjX3B1TuC1Sk2HV02ZZRd3CeiGbyGcIz6Oc5SdnFRUaVF
   FpL2zocs6u7WMp780ok0AxeFD1JVSbjH0J5/0UhnZhkzAnoohyggJVTdn
   0IJSHCrKrwcZlYqUDmGUcsDh/eLsa4tkix99hcy0O44IYZRvuBl7rJM4H
   eK3xAg3tjgQZYBB3E2k4sLiDBIP9aCFhVHqUCcjhU0gP2POXnloxDIk8j
   XSYCOYSUeZBErYHFX+WSCRjV2tc5sMHMtmD5XPJo5R+EFX5g/1Ma6MTC9
   cazGKsHBKbr/NpWUGP8fOaOhLZA5AS5Nr0UpUOyjAcLy4QfgisvJ8mHGP
   A==;
IronPort-SDR: EoTx2b0HPiOnRcajdvQpt0+GQrh5xi2mNrKE5bHPUg+2M0OVjxaTuX5vKBN9Q6U2noLW31IMTh
 FNm9D/vX48mHQwQr5sCMLSJQ8dSpImP7FA+eFOMSRQOjGGNLvz/BBBWjY9VHi1mBq6qEcAYOu5
 LuIKzkT5yWjFdNhadgvFyhfX78M5F40xIM0Lfm7HCOe37cKA4DR2bLZysFie1yEuKHKvJrH1Bt
 90cjpivxbznfzaANiRt3+NBG0osEIvaA0oVs7kN+xu/u8MUIW2iyPwbfZ+YwDtry926C/mYHSt
 8XM=
X-IPAS-Result: =?us-ascii?q?A2EcAAD1GHpgf8WmVdFaHAEBAQEBAQcBARIBAQQEAQFAg?=
 =?us-ascii?q?T4HAQELAYN3a4RDiCSJTwOaa4F8AgkBAQEPNAQBAYRQAoF0AiU0CQ4CAwEBA?=
 =?us-ascii?q?QMCAwEBAQEBBgEBAQEBAQUEAQECEAEBboUXRoI4KQGDbAEBAQMSEQRSEBYNA?=
 =?us-ascii?q?gImAgIiEgEFARwGARIihVcFoDGBBD2LMX8zgQGIDgEJDYFEEn0qAYcChCiCK?=
 =?us-ascii?q?ieCJ4FJgyqHWYJhBIJILIEtEIESAiMBSYEZAQEBj3WLYIF/gSCbDAEGAoJ1G?=
 =?us-ascii?q?Z0GI4ERo20BlRqeLkKEYhAjgTFmgS4zGiV/BmeBS1AZDlaNVRaOSyQvOAIGC?=
 =?us-ascii?q?gEBAwmMMV0BAQ?=
IronPort-PHdr: A9a23:yWzEaBVo2tTPUuqhwHDbBlSNFTfV8KxsVTF92vIco4ILSbyq+tHYB
 Gea288FpGHAUYiT0f9Yke2e6/mmBTVRp8/Q7TtdLdRlbFwssY0uhQsuAcqIWwXQDcXBSGgEJ
 vlET0Jv5HqhMEJYS47UblzWpWCuv3ZJQk2sfQV6Kf7oFYHMks+5y/69+4HJYwVPmTGxfa5+I
 A+5oAnMssQam5ZuJ6IxxxfGoHZFe/ldyH91K16Ugxvy/Nq78oR58yRXtfIh9spAXrv/cq8lU
 7FWDykoPn4s6sHzuhbNUQWA5n0HUmULiRVIGBTK7Av7XpjqrCT3sPd21TSAMs33SbA0Ximi7
 7tuRRT1hioLKyI1/WfKgcFrkqlVvAyuqAB+w47MYYGaKvx+fr/GfdgHQWZNR9tdWzBdDo+5a
 YYEEugPMvtCr4TlqFQOoxmxCwmiCu3s1zFGmGP506Ih3uQ9CAHLxhAsE84SvHnWqtj+KaccU
 fqyzKnN1TjNau1Z2Dfg6IPVdR4uu/eMVq93fMrSzEkgDQXFgkmMpYD4JD6Vy/gCs3KB4+V+S
 O2vlncqpgdsqTeg2skikJPGhp4Jyl/a7yV5xp44KcO2RUN5Y9OoDpVeuj+GOodrXs4vQW9lt
 Sc+x7AYupO1fDYGxZYmyhLBafGKfZSF7xH+WOqMLjl1mnJodK+9ihu07EOuyfX8W9Gq3FpWq
 idJiNrBu3AX2xDO68WKS+Fx8lql1DuN0Q3Y9/tKLloulaXBLp4s2rswlp0OvkvdBiL2g0D2j
 LOOdkUj5+io9/zrYrX4qZ+YMI95kgT+Pb4vmsy7GOg4MwwOU3WC9eSyybHu+U/0TK9Fjv0xl
 anZv5TaKtoBqqGlBA9V154v6xe5Dzi4zNQVhWcLIE5BdR6djIXkO0vCLO35APq+mVigjTNmy
 vLeMr3kGJrNL3zDkLn7fbZ67k5R0AkzzdVF6JJSFr0NPO//V1TstNPEFB81KRK7zPv6CNllz
 IMRRXqPArOFMKPVqVKI4PwgI/WRa4ALpjbwMOYl5/Hwgn8jg1Mdfrem3YERaH+mGvRqOUKZY
 WDjgoRJLWBf9AY3UuHvoFGLTzNWY3G8Q+Q66y1xQNaqBJnOQ6ihiaKM2SO8EIEQYG1aXBTEW
 2bvbIWKRvUNQCaTJNJx1z0cS+bnTJUun1n6pQjhy7R6LOv8/iweqIKm1cBruavUjx5ksXQ+A
 9+U02yXSUl3k3kOSjtw27pw6wQpxkyK0aVihdRbGMZV6vcPVR01Y9qU7eV5Ftq6eQPKf9GSS
 1fuFta7CzgZTd8rxdIKJUFnFIPxoArE2n+JDq4I35mCAtRg8afV2SCpfu5gwGyA2aU82Qp1C
 vBTPHGr0/YsvzPYAJTExgDAz/7CSA==
IronPort-HdrOrdr: A9a23:5SyFgahglFQGWgk9iQST46O6SXBQX5l13DAbvn1ZSRFFG/Gwvc
 rGpoVj6TbfjjENVHY83e2aMK6bTn/GsbJz648dPbCtNTOWw1eABodk8Ifk3nncCzTzn9QtrZ
 tIXqBiBLTLfD1HpOng5g3QKadD/PCm9+SSif7a3zNRS2hRGsJdxiNYLireLUFsXglBAvMCda
 a0wsZcvTKvdTA2Q62Adx04dtPOrdHKi57qCCRub3UawTKDgj+y5LnxHwLw5HcjeglSyrQv+3
 WtqX2f2oyftZiAu3nh/l6WwZATvNf60NNMCIi3l8AJJlzX5zqAVcBOXbuNuTxwjcOOzBIRkN
 fKqwo9JMgb0RnsV1Dwjx3q1QztlAwr9man81mFmnHuyPaXeBsKT/FMj45YbRfVgnBN0u1B7A
 ==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="208520892"
Received: from mail-il1-f197.google.com ([209.85.166.197])
  by smtpmx6.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Apr 2021 16:10:05 -0700
Received: by mail-il1-f197.google.com with SMTP id q7-20020a056e0215c7b029013ea7521279so7826738ilu.11
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 16:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=88l6LtIMEUkNEl8C8zUnABwqKqB7A3kmZqHpeOxBRYE=;
        b=C8fYBlbo1QwsnHXcv/R/wy1zyl04XDYmokLTQbrTEIzLgdidSsxBUtjLVFaFFHlhe+
         O9P+0DOWBMC6xuJa5oplbXFhlzbJlu5tfpsSepYqw2tz4qlHevH1F9QzP9E6lZvVsoug
         PKnQiGnaPA59CKX2h1QnA07x+LMmsfp3h4xfcydGgqFnvFoeMZoECXLRZZIl8ozWjZpT
         T08JmcpMCc4oK112Kjb6WwWuLu9yFeuEjH0kpj8xn/FYJau15C0zk1vMfE6hNQitMQ8H
         5PnVhQ33g46CrMKh4KUvW/jHuLgAFBOJ5kDcIrBdKif3FkAp/xp1QiN8wLkWJk7xx9hT
         ZILQ==
X-Gm-Message-State: AOAM531JBHcouFgf04C8Ij/2IBW9HpJEM+xgjzDEoKcXss4z3Ys+Xr7z
        CerIQ/uKnYr/ljsYUd8qzb7iZBaPCQa6uhC4g3KpJJD/hULG4F80lYf1ubc52NCKWlN3i27gnid
        phl/ojOJ4rwggC58LCJ426X09mQTxAItkng==
X-Received: by 2002:a02:cd8a:: with SMTP id l10mr6330826jap.6.1618614603275;
        Fri, 16 Apr 2021 16:10:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwr3lRhtzJhnotRcEiH9yE2xvDqRZNCg0O7GzDAlSpbmryVC+AZKvJOlbYNg9721M4RtF/iUB9NGCO+dvXKuiE=
X-Received: by 2002:a02:cd8a:: with SMTP id l10mr6330804jap.6.1618614602890;
 Fri, 16 Apr 2021 16:10:02 -0700 (PDT)
MIME-Version: 1.0
References: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
In-Reply-To: <02917697-4CE2-4BBE-BF47-31F58BC89025@hxcore.ol>
From:   Keyu Man <kman001@ucr.edu>
Date:   Fri, 16 Apr 2021 16:09:52 -0700
Message-ID: <CAMqUL6YL_c138shGm7qZjA9jbOS3V6qx_k4E=+f0TGkVXOBfbQ@mail.gmail.com>
Subject: PROBLEM: DoS Attack on Fragment Cache
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

    My name is Keyu Man. We are a group of researchers from University
of California, Riverside. Zhiyun Qian is my advisor. We found the code
in processing IPv4/IPv6 fragments will potentially lead to DoS
Attacks. Specifically, after the latest kernel receives an IPv4
fragment, it will try to fit it into a queue by calling function

    struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void
*key) in net/ipv4/inet_fragment.c.

    However, this function will first check if the existing fragment
memory exceeds the fqdir->high_thresh. If it exceeds, then drop the
fragment regardless whether it belongs to a new queue or an existing
queue.
    Chances are that an attacker can fill the cache with fragments
that will never be assembled (i.e., only sends the first fragment with
new IPIDs every time) to exceed the threshold so that all future
incoming fragmented IPv4 traffic would be blocked and dropped. Since
there is no GC mechanism, the victim host has to wait for 30s when the
fragments are expired to continue receiving incoming fragments
normally.
    In practice, given the 4MB fragment cache, the attacker only needs
to send 1766 fragments to exhaust the cache and DoS the victim for
30s, whose cost is pretty low. Besides, IPv6 would also be affected
since the issue resides in inet part.
    This issue is introduced in commit
648700f76b03b7e8149d13cc2bdb3355035258a9 (inet: frags: use rhashtables
for reassembly units) which removes fqdir->low_thresh, and GC worker
as well. We would kindly request to bring GC workers back to the
kernel to prevent the DoS attacks.

    Looking forward to hear from you

    Thanks,

Keyu Man


On Fri, Apr 16, 2021 at 3:58 PM Keyu Man <kman001@ucr.edu> wrote:
>
> Hi,
>
>
>
>     My name is Keyu Man. We are a group of researchers from University of=
 California, Riverside. Zhiyun Qian is my advisor. We found the code in pro=
cessing IPv4/IPv6 fragments will potentially lead to DoS Attacks. Specifica=
lly, after the latest kernel receives an IPv4 fragment, it will try to fit =
it into a queue by calling function
>
>
>
>     struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key=
) in net/ipv4/inet_fragment.c.
>
>
>
>     However, this function will first check if the existing fragment memo=
ry exceeds the fqdir->high_thresh. If it exceeds, then drop the fragment re=
gardless whether it belongs to a new queue or an existing queue.
>
>     Chances are that an attacker can fill the cache with fragments that w=
ill never be assembled (i.e., only sends the first fragment with new IPIDs =
every time) to exceed the threshold so that all future incoming fragmented =
IPv4 traffic would be blocked and dropped. Since there is no GC mechanism, =
the victim host has to wait for 30s when the fragments are expired to conti=
nue receive incoming fragments normally.
>
>     In practice, given the 4MB fragment cache, the attacker only needs to=
 send 1766 fragments to exhaust the cache and DoS the victim for 30s, whose=
 cost is pretty low. Besides, IPv6 would also be affected since the issue r=
esides in inet part.
>
> This issue is introduced in commit 648700f76b03b7e8149d13cc2bdb3355035258=
a9 (inet: frags: use rhashtables for reassembly units) which removes fqdir-=
>low_thresh, and GC worker as well. We would gently request to bring GC wor=
ker back to the kernel to prevent the DoS attacks.
>
> Looking forward to hear from you
>
>
>
>     Thanks,
>
> Keyu Man
