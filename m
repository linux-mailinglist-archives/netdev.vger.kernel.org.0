Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577EC219F10
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 13:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGIL03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 07:26:29 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43806 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726433AbgGIL0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 07:26:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594293983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gB/jRVI1prkorpTFE+RHZKDPeMWYsL/X1nUnMDyfQyk=;
        b=CGGCNjnLC4h2RTL67ePKs4V0L55vHK4ut6n64WrSlOY0T6vx1WeMwGFxtAkAL9Te9k5ERp
        qy5sc09yHNXXtDnZLFOJR6OpywTu3jOwvmg8NBlL4s+t1ZbQAfQmhqvtfJkn+daqO3Jo59
        UyZ4txQLBTs7U9EzUozaWQE3k+KOwEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-Vlh-uILLPiGVKrj3BhSYyQ-1; Thu, 09 Jul 2020 07:26:18 -0400
X-MC-Unique: Vlh-uILLPiGVKrj3BhSYyQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13A0B800EB6;
        Thu,  9 Jul 2020 11:26:16 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9918290E63;
        Thu,  9 Jul 2020 11:26:11 +0000 (UTC)
Date:   Thu, 9 Jul 2020 13:26:07 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Jonathan Corbet <corbet@lwn.net>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        mchehab+samsung@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: XDP (eXpress Data
 Path)
Message-ID: <20200709132607.7fb42415@carbon>
In-Reply-To: <2aefc870-bf17-9528-958e-bc5b76de85dd@al2klimov.de>
References: <20200708135737.14660-1-grandmaster@al2klimov.de>
        <20200708080239.2ce729f3@lwn.net>
        <2aefc870-bf17-9528-958e-bc5b76de85dd@al2klimov.de>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 20:58:39 +0200
"Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:

> Am 08.07.20 um 16:02 schrieb Jonathan Corbet:
> > On Wed,  8 Jul 2020 15:57:37 +0200
> > "Alexander A. Klimov" <grandmaster@al2klimov.de> wrote:
> >  =20
> >>   Documentation/arm/ixp4xx.rst | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-) =20
> >=20
> > That's not XDP; something went awry in there somewhere. =20
>
> RoFL. Now as you said it I... noticed it at all... (*sigh*, the curse of
> automation) and I absolutely agree with you. But I've literally no idea...

Yes, we know that scripts/get_maintainer.pl gives false positives for
XDP, but we choose this to capture drivers that implement XDP.

As you can see here, the chip name IXDP425 contains "XDP", which is why
it matches...

=20
> =E2=9E=9C  linux git:(master) perl scripts/get_maintainer.pl --nogit{,-fa=
llback}=20
> --nol 0003-Replace-HTTP-links-with-HTTPS-ones-XDP-eXpress-Data-.patch
> Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION)
> Alexei Starovoitov <ast@kernel.org> (supporter:XDP (eXpress Data Path))
> Daniel Borkmann <daniel@iogearbox.net> (supporter:XDP (eXpress Data Path))
> "David S. Miller" <davem@davemloft.net> (supporter:XDP (eXpress Data Path=
))
> Jakub Kicinski <kuba@kernel.org> (supporter:XDP (eXpress Data Path))
> Jesper Dangaard Brouer <hawk@kernel.org> (supporter:XDP (eXpress Data Pat=
h))
> John Fastabend <john.fastabend@gmail.com> (supporter:XDP (eXpress Data=20
> Path))
> =E2=9E=9C  linux git:(master) cat=20
> 0003-Replace-HTTP-links-with-HTTPS-ones-XDP-eXpress-Data-.patch
>  From 40aee4678ab84b925ab21581030a2cc0b988fbf9 Mon Sep 17 00:00:00 2001
> From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
> Date: Wed, 8 Jul 2020 08:00:39 +0200
> Subject: [PATCH] Replace HTTP links with HTTPS ones: XDP (eXpress Data Pa=
th)
>=20
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
>=20
> Deterministic algorithm:
> For each file:
>    If not .svg:
>      For each line:
>        If doesn't contain `\bxmlns\b`:
>          For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>              If both the HTTP and HTTPS versions
>              return 200 OK and serve the same content:
>                Replace HTTP with HTTPS.
>=20
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>   Documentation/arm/ixp4xx.rst | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/arm/ixp4xx.rst b/Documentation/arm/ixp4xx.rst
> index a57235616294..d94188b8624f 100644
> --- a/Documentation/arm/ixp4xx.rst
> +++ b/Documentation/arm/ixp4xx.rst
> @@ -119,14 +119,14 @@ http://www.gateworks.com/support/overview.php
>      the expansion bus.
>=20
>   Intel IXDP425 Development Platform
> -http://www.intel.com/design/network/products/npfamily/ixdpg425.htm
> +https://www.intel.com/design/network/products/npfamily/ixdpg425.htm
>=20
>      This is Intel's standard reference platform for the IXDP425 and is
>      also known as the Richfield board. It contains 4 PCI slots, 16MB
>      of flash, two 10/100 ports and one ADSL port.
>=20
>   Intel IXDP465 Development Platform
> -http://www.intel.com/design/network/products/npfamily/ixdp465.htm
> +https://www.intel.com/design/network/products/npfamily/ixdp465.htm
>=20
>      This is basically an IXDP425 with an IXP465 and 32M of flash instead
>      of just 16.
> --
> 2.27.0


--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

