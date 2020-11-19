Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B932B9C36
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgKSUmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:42:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58474 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726172AbgKSUmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 15:42:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605818536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pgYqjANhFZVw2xsV1NPryI63UVScbHN7GEpAwzgrcBA=;
        b=YkZZUcOhgjbqs0dFE0fdahNBR14lida7kIYW/rmHr9+vJ90U798AZTbjFM+deEMxf7nySg
        +ls01ctKa+HN8ivadiNpwHVnVo2M2BXIdTM9ONWBOdbDbKIoA9W91f0PaZ67SeQZE/dZfv
        DWXuIBB9ux2rOtiSnoG/AkSSXI+RUiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-J2xKKEZ6OOWubPMcg1L6iQ-1; Thu, 19 Nov 2020 15:42:10 -0500
X-MC-Unique: J2xKKEZ6OOWubPMcg1L6iQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C76F11005D5C;
        Thu, 19 Nov 2020 20:42:04 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7DFF810016F4;
        Thu, 19 Nov 2020 20:41:56 +0000 (UTC)
Date:   Thu, 19 Nov 2020 21:41:55 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joe Perches <joe@perches.com>, Guenter Roeck <linux@roeck-us.net>,
        Tao Ren <rentao.bupt@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com, brouer@redhat.com
Subject: Re: XDP maintainer match (Was  [PATCH v2 0/2] hwmon: (max127) Add
 Maxim MAX127 hardware monitoring)
Message-ID: <20201119214155.5285e2d2@carbon>
In-Reply-To: <20201119095928.01fd10e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
        <20201118232719.GI1853236@lunn.ch>
        <20201118234252.GA18681@taoren-ubuntu-R90MNF91>
        <20201119010119.GA248686@roeck-us.net>
        <20201119012653.GA249502@roeck-us.net>
        <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201119173535.1474743d@carbon>
        <088057533a9feb330964bdab0b1b8d2f69b7a22c.camel@perches.com>
        <20201119095928.01fd10e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 09:59:28 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 19 Nov 2020 09:09:53 -0800 Joe Perches wrote:
> > On Thu, 2020-11-19 at 17:35 +0100, Jesper Dangaard Brouer wrote: =20
> > > On Thu, 19 Nov 2020 07:46:34 -0800 Jakub Kicinski <kuba@kernel.org> w=
rote:   =20
> >  =20
> > > I think it is a good idea to change the keyword (K:), but I'm not sure
> > > this catch what we want, maybe it does.  The pattern match are meant =
to
> > > catch drivers containing XDP related bits.
> > >=20
> > > Previously Joe Perches <joe@perches.com> suggested this pattern match,
> > > which I don't fully understand... could you explain Joe?
> > >=20
> > > =C2=A0=C2=A0(?:\b|_)xdp(?:\b|_)   =20
> >=20
> > This regex matches only:
> >=20
> > 	xdp
> > 	xdp_<anything>
> > 	<anything>_xdp_<anything>
> > 	<anything>_xdp
> >  =20
> > > For the filename (N:) regex match, I'm considering if we should remove
> > > it and list more files explicitly.  I think normal glob * pattern
> > > works, which should be sufficient.   =20
> >=20
> > Lists are generally more specific than regex globs. =20
>=20
> Checking like Alexei did it seems Joe's version is faster and better:
>=20
> $ git grep -l -E "[^a-z0-9]xdp[^a-z0-9]" | wc -l
> 295
> $ git grep -l -E '(\b|_)xdp(\b|_)' | wc -l
> 297
> $ time git grep -l -E '(\b|_)xdp(\b|_)' > /tmp/a

Okay, I guess this is the pattern you want: '(\b|_)xdp(\b|_)'

=20
> Joe would you like to send a patch, or should I?

As you noticed I already send out a patch, I can send a new with your
pattern, as it seems to be faster.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

