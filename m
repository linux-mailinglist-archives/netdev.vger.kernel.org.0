Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A1218C170
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 21:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgCSUae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 16:30:34 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:35090 "EHLO
        script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbgCSUae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 16:30:34 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2020 16:30:32 EDT
X-DKIM: Courier DKIM Filter v0.50+pk-2017-10-25 mail.cs.helsinki.fi Thu, 19 Mar 2020 22:25:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.helsinki.fi;
         h=date:from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=dkim20130528; bh=VnkDG3KitidHP1UqN
        rOacPMm9utq+fSIYJuzQ20LCAs=; b=SlblTcqYnr5vGcT4pQsPltbSxC0Zqj5hk
        qYU6j+WLsHTM9I4f5USW5SJ/10dXnphaB+SK0CCNqPGyM/Y3SMzHaP1hPko6uZKa
        hpE3f299KZdFu38X2z2bqDmY/FfvvervF746Y32hC7pnR3qmfbej4sID5L5byM50
        0LVzsNciN0=
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
  (TLS: TLSv1/SSLv3,256bits,AES256-GCM-SHA384)
  by mail.cs.helsinki.fi with ESMTPS; Thu, 19 Mar 2020 22:25:23 +0200
  id 00000000005A00CF.000000005E73D533.0000385E
Date:   Thu, 19 Mar 2020 22:25:23 +0200 (EET)
From:   "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@cs.helsinki.fi>
X-X-Sender: ijjarvin@whs-18.cs.helsinki.fi
To:     David Miller <davem@davemloft.net>
cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: Re: [RFC PATCH 00/28]: Accurate ECN for TCP
In-Reply-To: <20200318.162958.1146893420208387579.davem@davemloft.net>
Message-ID: <alpine.DEB.2.20.2003192222320.5256@whs-18.cs.helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi> <20200318.162958.1146893420208387579.davem@davemloft.net>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=_script-14522-1584649524-0001-2"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_script-14522-1584649524-0001-2
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Mar 2020, David Miller wrote:

> From: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
> Date: Wed, 18 Mar 2020 11:43:04 +0200
>=20
> > Comments would be highly appreciated.
>=20
> Two coding style comments which you should audit your entire submission
> for:
>=20
> 1) Please order local variables in reverse christmas tree ordering (lon=
gest
>    to shortest long)

Does this apply also to the usual struct tcp_sock *tp =3D tcp_sk(sk); lin=
e
or can it be put first if there are some dependencies on it?

> 2) Please do not use the inline keyword in foo.c files, let the compile=
r
>    decide.

Thanks. I'll do those (I certainly removed some other bits I moved from
header to .c but missed a few it seems).=20

--=20
 i.
--=_script-14522-1584649524-0001-2--
