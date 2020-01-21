Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDA41440C7
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgAUPoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:44:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35650 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728829AbgAUPoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 10:44:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579621463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aGpIqNbCvMcpdr0cjmLt5ZmO+ZAY0ko49nTUnYtu3aY=;
        b=POAKap409ruTdH0E9g6sxGgO6nnpTw2X1GW+PLdwapzwmRL5ajWCpnkC7JpmXBnYv69Fjp
        K232q7FJ15Ia3h+Q8+5tjhTICYLV8CZoPhZqbwXRZWU+eEoAUslUMMJ4rrSc8bxORLxHNy
        3RVjXVFGWPKd6x5Cy6VX1b3c9jIuWaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-Ama62vsxPCS7wfmPuYKoyA-1; Tue, 21 Jan 2020 10:44:19 -0500
X-MC-Unique: Ama62vsxPCS7wfmPuYKoyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBE64107ACC7;
        Tue, 21 Jan 2020 15:44:17 +0000 (UTC)
Received: from localhost (ovpn-117-223.ams2.redhat.com [10.36.117.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5537C1001B0B;
        Tue, 21 Jan 2020 15:44:13 +0000 (UTC)
Date:   Tue, 21 Jan 2020 15:44:12 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
Message-ID: <20200121154412.GC641751@stefanha-x1.localdomain>
References: <20200120.100610.546818167633238909.davem@davemloft.net>
 <20200120101735.uyh4o64gb4njakw5@steredhat>
 <20200120060601-mutt-send-email-mst@kernel.org>
 <CAGxU2F6VH8Eb5UH_9KjN6MONbZEo1D7EHAiocVVus6jW55BJDg@mail.gmail.com>
 <20200120110319-mutt-send-email-mst@kernel.org>
 <CAGxU2F5=DQJ56sH4BUqp_7rvaXSF9bFHp4QkpLApJQK0bmd4MA@mail.gmail.com>
 <20200120170120-mutt-send-email-mst@kernel.org>
 <CAGxU2F4uW7FNe5xC0sb3Xxr_GABSXuu1Z9n5M=Ntq==T7MaaVw@mail.gmail.com>
 <20200121135907.GA641751@stefanha-x1.localdomain>
 <20200121093104-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20200121093104-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2020 at 09:31:42AM -0500, Michael S. Tsirkin wrote:
> On Tue, Jan 21, 2020 at 01:59:07PM +0000, Stefan Hajnoczi wrote:
> > On Tue, Jan 21, 2020 at 10:07:06AM +0100, Stefano Garzarella wrote:
> > > On Mon, Jan 20, 2020 at 11:02 PM Michael S. Tsirkin <mst@redhat.com> =
wrote:
> > > > On Mon, Jan 20, 2020 at 05:53:39PM +0100, Stefano Garzarella wrote:
> > > > > On Mon, Jan 20, 2020 at 5:04 PM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> > > > > > On Mon, Jan 20, 2020 at 02:58:01PM +0100, Stefano Garzarella wr=
ote:
> > > > > > > On Mon, Jan 20, 2020 at 1:03 PM Michael S. Tsirkin <mst@redha=
t.com> wrote:
> > > > > > > > On Mon, Jan 20, 2020 at 11:17:35AM +0100, Stefano Garzarell=
a wrote:
> > > > > > > > > On Mon, Jan 20, 2020 at 10:06:10AM +0100, David Miller wr=
ote:
> > > > > > > > > > From: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > > > > > Date: Thu, 16 Jan 2020 18:24:26 +0100
> > > > > > > > > >
> > > > > > > > > > > This patch adds 'netns' module param to enable this n=
ew feature
> > > > > > > > > > > (disabled by default), because it changes vsock's beh=
avior with
> > > > > > > > > > > network namespaces and could break existing applicati=
ons.
> > > > > > > > > >
> > > > > > > > > > Sorry, no.
> > > > > > > > > >
> > > > > > > > > > I wonder if you can even design a legitimate, reasonabl=
e, use case
> > > > > > > > > > where these netns changes could break things.
> > > > > > > > >
> > > > > > > > > I forgot to mention the use case.
> > > > > > > > > I tried the RFC with Kata containers and we found that Ka=
ta shim-v1
> > > > > > > > > doesn't work (Kata shim-v2 works as is) because there are=
 the following
> > > > > > > > > processes involved:
> > > > > > > > > - kata-runtime (runs in the init_netns) opens /dev/vhost-=
vsock and
> > > > > > > > >   passes it to qemu
> > > > > > > > > - kata-shim (runs in a container) wants to talk with the =
guest but the
> > > > > > > > >   vsock device is assigned to the init_netns and kata-shi=
m runs in a
> > > > > > > > >   different netns, so the communication is not allowed
> > > > > > > > > But, as you said, this could be a wrong design, indeed th=
ey already
> > > > > > > > > found a fix, but I was not sure if others could have the =
same issue.
> > > > > > > > >
> > > > > > > > > In this case, do you think it is acceptable to make this =
change in
> > > > > > > > > the vsock's behavior with netns and ask the user to chang=
e the design?
> > > > > > > >
> > > > > > > > David's question is what would be a usecase that's broken
> > > > > > > > (as opposed to fixed) by enabling this by default.
> > > > > > >
> > > > > > > Yes, I got that. Thanks for clarifying.
> > > > > > > I just reported a broken example that can be fixed with a dif=
ferent
> > > > > > > design (due to the fact that before this series, vsock device=
s were
> > > > > > > accessible to all netns).
> > > > > > >
> > > > > > > >
> > > > > > > > If it does exist, you need a way for userspace to opt-in,
> > > > > > > > module parameter isn't that.
> > > > > > >
> > > > > > > Okay, but I honestly can't find a case that can't be solved.
> > > > > > > So I don't know whether to add an option (ioctl, sysfs ?) or =
wait for
> > > > > > > a real case to come up.
> > > > > > >
> > > > > > > I'll try to see better if there's any particular case where w=
e need
> > > > > > > to disable netns in vsock.
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Stefano
> > > > > >
> > > > > > Me neither. so what did you have in mind when you wrote:
> > > > > > "could break existing applications"?
> > > > >
> > > > > I had in mind:
> > > > > 1. the Kata case. It is fixable (the fix is not merged on kata), =
but
> > > > >    older versions will not work with newer Linux.
> > > >
> > > > meaning they will keep not working, right?
> > >=20
> > > Right, I mean without this series they work, with this series they wo=
rk
> > > only if the netns support is disabled or with a patch proposed but no=
t
> > > merged in kata.
> > >=20
> > > >
> > > > > 2. a single process running on init_netns that wants to communica=
te with
> > > > >    VMs handled by VMMs running in different netns, but this case =
can be
> > > > >    solved opening the /dev/vhost-vsock in the same netns of the p=
rocess
> > > > >    that wants to communicate with the VMs (init_netns in this cas=
e), and
> > > > >    passig it to the VMM.
> > > >
> > > > again right now they just don't work, right?
> > >=20
> > > Right, as above.
> > >=20
> > > What do you recommend I do?
> >=20
> > Existing userspace applications must continue to work.
> >=20
> > Guests are fine because G2H transports are always in the initial networ=
k
> > namespace.
> >=20
> > On the host side we have a real case where Kata Containers and other
> > vsock users break.  Existing applications run in other network
> > namespaces and assume they can communicate over vsock (it's only
> > available in the initial network namespace by default).
> >=20
> > It seems we cannot isolate new network namespaces from the initial
> > network namespace by default because it will break existing
> > applications.  That's a bummer.
> >=20
> > There is one solution that maintains compatibility:
> >=20
> > Introduce a per-namespace vsock isolation flag that can only transition
> > from false to true.  Once it becomes true it cannot be reset to false
> > anymore (for security).
> >=20
> > When vsock isolation is false the initial network namespace is used for
> > <CID, port> addressing.
> >=20
> > When vsock isolation is true the current namespace is used for <CID,
> > port> addressing.
> >=20
> > I guess the vsock isolation flag would be set via a rtnetlink message,
> > but I haven't checked.
> >=20
> > The upshot is: existing software doesn't benefit from namespaces for
> > vsock isolation but it continues to work!  New software makes 1 special
> > call after creating the namespace to opt in to vsock isolation.
> >=20
> > This approach is secure because whoever sets up namespaces can
> > transition the flag from false to true and know that it can never be
> > reset to false anymore.
> >=20
> > Does this make sense to everyone?
> >=20
> > Stefan
>=20
> Anything wrong with a separate device? whoever opens it decides
> whether netns will work ...

Your idea is better.  I think a separate device is the way to go.

Stefan

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4nHEwACgkQnKSrs4Gr
c8gkWwf/WeCAFZA1kVaNgYa9wb5dO/ZohzbFkQbRphAk6cwcdO9bkkOoly99gEGb
zrr+mXxKZvzG+U4bsc3D9bLQr1UQ8GiD1YPBslgyTDZ72X1dWu2/11lPabgdTxhZ
SOFycWHK6sVsKUEA4Jiq7bwHqOzIez5cA+EOF3bmZCju1kcAFptyNpAnvopZt5AY
ZzEIqTDSm8p/GCVJmaJE4JzkzJM5mFzCSH73QeW0IGoUJ6C6ZbyvAOmXtEnFifwt
WxK4ok5OubA9Eadoo3x9tcr16to11ZV2aXVroS6Q96DCP8Vc3FHepAzEhgbjBw+O
bHtQCEDC6+JB3SWCmoWoX7qSts4OWg==
=HgEd
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--

