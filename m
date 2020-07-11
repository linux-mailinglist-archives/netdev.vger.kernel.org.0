Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C32921C327
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 10:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgGKIXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 04:23:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33699 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728080AbgGKIXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 04:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594455813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JWZc4C758CGaQ7kXP65ZxsN+MDs4VksrbvIUzURHM4=;
        b=fIUosOHnGs8QAb+KB3sXcZCkUe9lAWgS9sGu9FqBfuR7gqPM4kr38GQa2g6K0KW1vkSL1N
        FfeYNHXwmkyzqZwQg5IYho0CCA8ZI2GjKTKmEJRQ7rkye52FQhnVM7Dpnb7vfcNSweApPB
        khTBMSIxoqcKy61zpZVm7kXTsELBjmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-shM6vVWLPsCKbBcbh1p3Cw-1; Sat, 11 Jul 2020 04:23:29 -0400
X-MC-Unique: shM6vVWLPsCKbBcbh1p3Cw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B4D6800C64;
        Sat, 11 Jul 2020 08:23:27 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46BE52DE6B;
        Sat, 11 Jul 2020 08:23:20 +0000 (UTC)
Date:   Sat, 11 Jul 2020 10:23:18 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Joe Perches <joe@perches.com>
Cc:     brouer@redhat.com,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        mchehab+huawei@kernel.org, robh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] MAINTAINERS: XDP: restrict N: and K:
Message-ID: <20200711102318.28ce29d6@carbon>
In-Reply-To: <28a81dfe62b1dc00ccc721ddb88669d13665252b.camel@perches.com>
References: <87tuyfi4fm.fsf@toke.dk>
        <20200710190407.31269-1-grandmaster@al2klimov.de>
        <28a81dfe62b1dc00ccc721ddb88669d13665252b.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 12:37:47 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2020-07-10 at 21:04 +0200, Alexander A. Klimov wrote:
> > Rationale:
> > Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp465"
> > which has nothing to do with XDP.
> >=20
> > Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> > ---
> >  Better?
> >=20
> >  MAINTAINERS | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 1d4aa7f942de..735e2475e926 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -18708,8 +18708,8 @@ F:	include/trace/events/xdp.h
> >  F:	kernel/bpf/cpumap.c
> >  F:	kernel/bpf/devmap.c
> >  F:	net/core/xdp.c
> > -N:	xdp
> > -K:	xdp
> > +N:	(?:\b|_)xdp
> > +K:	(?:\b|_)xdp =20
>=20
> Generally, it's better to have comprehensive files lists
> rather than adding name matching regexes.

I like below more direct matching of the files we already know are XDP
related. The pattern match are meant to catch drivers containing XDP
related bits.

(small typo in your patch below)

> Perhaps:
> ---
>  MAINTAINERS | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 16854e47e8cb..2e96cbf15b31 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18763,13 +18763,19 @@ M:	John Fastabend <john.fastabend@gmail.com>
>  L:	netdev@vger.kernel.org
>  L:	bpf@vger.kernel.org
>  S:	Supported
> -F:	include/net/xdp.h
> +F:	Documentation/networking/af_xdp.rst
> +F:	include/net/xdp*
>  F:	include/trace/events/xdp.h
> +F:	include/uapi/linux/if_xdp.h
> +F:	include/uapi/linux/xdp_diag.h
>  F:	kernel/bpf/cpumap.c
>  F:	kernel/bpf/devmap.c
>  F:	net/core/xdp.c
> -N:	xdp
> -K:	xdp
> +F:	net/xdp/
> +F:	samples/bpf/xdp*
> +F:	tools/testing/selftests/bfp/*xdp*
                               ^^^^=20
Typo, should be "bpf"

> +F:	tools/testing/selftests/bfp/*/*xdp*
> +K:	(?:\b|_)xdp(?:\b|_)
> =20
>  XDP SOCKETS (AF_XDP)
>  M:	Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

