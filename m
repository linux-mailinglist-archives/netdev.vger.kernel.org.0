Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C392B2B1403
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgKMBut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:50:49 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21329 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgKMBut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 20:50:49 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605232207; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=JVN6i00fIw9oTGVyR3tWAXZG87KNlL405oRwS18W3s2yvOejlL67LuNLH0RL4mYU4PPLGf+NcNIV5wQMJL6e6dbuSEPutH4pOl2PoTl/8XmmmIB6QFs6BXRdCo8oFOOr+3mX9DQALe6GCxO2TsBsupN3OWwiMMs5znbNt3zJbt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605232207; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=kXj3vK7g3qlNy7BhovDLyuAQcTyd7DXq6f2uK8FasKs=; 
        b=C9SukEpVSwhFN8eHfYIZXiK+M30DB8zht2uGTDirOqS/sCKrAfgr7R8wlxDSU++bkSqRYAF5JVtu1hI09LLyI5hZjRumlp8qI8hbdoM75/0LoxBlxGCb14Yda3amx+aOtO4Tdek9gFJBlyE0HCnT3C8c32dmHWkR6WpXrseBiH0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605232207;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=kXj3vK7g3qlNy7BhovDLyuAQcTyd7DXq6f2uK8FasKs=;
        b=Q4Y2seRXtMKp6FeDEJyEg+KTPEvzlFZzSScdP0RAbirkxY4KOX132JmLG43TQh95
        HJfWmKMSK56k3+g0ZPTmS/BDC1LPSSRaYMwdH5XQ44UECCOuczztkunXcneYEH/0Q03
        bHdNnL2+JVheU3R2Et57eI3IIC6bJlhqfcerzRbk=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605232200583113.95955939267355; Fri, 13 Nov 2020 02:50:00 +0100 (CET)
Date:   Fri, 13 Nov 2020 02:50:00 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Hideaki Yoshifuji" <hideaki.yoshifuji@miraclelinux.com>
Cc:     "kuba" <kuba@kernel.org>, "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175bf4b8b86.dba0173e131152.3554549396274308531@shytyi.net>
In-Reply-To: <CAPA1RqDgKfcDqSOM+1TV=EesU1rynt6Z=EqbTur1Q6Xt=YvxpQ@mail.gmail.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net> <CAPA1RqDgKfcDqSOM+1TV=EesU1rynt6Z=EqbTur1Q6Xt=YvxpQ@mail.gmail.com>
Subject: Re: [PATCH net-next V3] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

---- On Thu, 12 Nov 2020 17:55:08 +0100 Hideaki Yoshifuji <hideaki.yoshifuj=
i@miraclelinux.com> wrote ----

 > Hi,=20
 > =20
 > 2020=E5=B9=B411=E6=9C=8813=E6=97=A5(=E9=87=91) 0:46 Dmytro Shytyi <dmytr=
o@shytyi.net>:=20
 > >=20
 > > Variable SLAAC: SLAAC with prefixes of arbitrary length in PIO (random=
ly=20
 > > generated hostID or stable privacy + privacy extensions).=20
 > > The main problem is that SLAAC RA or PD allocates a /64 by the Wireles=
s=20
 > > carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 vi=
a=20
 > > SLAAC is required so that downstream interfaces can be further subnett=
ed.=20
 > > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, a=
nd=20
 > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to=20
 > > Load-Balancer and /72 to wired connected devices.=20
 > > IETF document that defines problem statement:=20
 > > draft-mishra-v6ops-variable-slaac-problem-stmt=20
 > > IETF document that specifies variable slaac:=20
 > > draft-mishra-6man-variable-slaac=20
 > >=20
 > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>=20
 > > Reported-by: kernel test robot <lkp@intel.com>=20
 > > ---=20
 > =20
 > > -       write_lock_bh(&idev->lock);=20
 > > +       int ret;=20
 > > +#if defined(CONFIG_ARCH_SUPPORTS_INT128)=20
 > > +       __int128 host_id;=20
 > > +       __int128 net_prfx;=20
 > :=20
 > =20
 > No, this does not help anything.=20
 > Please do not rely on __int128.=20

[Dmytro] Understood. Thank you.

 > --yoshfuji=20
 >=20
