Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E024A51F8
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbfIBIjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:39:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38479 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729870AbfIBIjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:39:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id l11so4263623wrx.5;
        Mon, 02 Sep 2019 01:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=84tNa0LJ5qNP8ceq2AHt9GMRkk+XoKF4Wbr0EYQvIpE=;
        b=JE+rTGDd3vfb9wVcnjiTAQ6VJuKqNZw1kp4lvjPYJQleCdZutoksvcSMrlbLlijgCD
         eA0G7FMldjru0uK1XH4l74xGOPEmK3pJ1sPHZkOIrZr4BS6wnRxvwBqRoz9XiIQerESa
         jX+iX5JReRbNpB+qIm2TIK6sWuVMsKA0S0XMYbWYNcj2+SuMNh2YzUcPN3Ivu6DSSW3b
         rT05eDiPQfsvIDsgAW75tfQ1C52HqBA7opRcNIzA1Vmi/6sQ/3QfMZ+3+lgjZDe3fbDE
         oOkXpLo2mcwKwq9a0L+APjev3rJXds2O1xredJzBH0qz936K/dnrmcjHVT3Q0ByGdP97
         xxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=84tNa0LJ5qNP8ceq2AHt9GMRkk+XoKF4Wbr0EYQvIpE=;
        b=FYWDRnhcv8JMIpaGwtRaGbDlr553sJ5NDhPk7C7p0BWT89JtVuqWzqiGEdFBKBvfjh
         7mV84UEFxqR99nNWFk2e/CsSHWAMq8gdrd3K8zkFUfzuywC1zbd71pYeqyYD7rurTmkv
         bLXhWlKQBvqEBq0j4aDWzuXZLqwGY+Dgn4F7/H+ZeXii17ZG0AabURdUPlo4IhJ/yy5c
         DCNrSEPtkcPdhFnEwI7DXJuUaOK1KJhZEviolenb/n+MDWrbScqO3wb03wYgpHA1LtIT
         35iO+Vq4QDGQ/KoMpPBciiNRudLmEquKJuffXLbLuO2Eqvq/fw9ygtODSej8WX4ACzSW
         nalA==
X-Gm-Message-State: APjAAAUa3TR6P6WNRmjlMyBi0uV8bk5q+4AGELDARMO4QbZbJCOGC1ll
        D1BiLc86foYVMuOkxvxdRVE=
X-Google-Smtp-Source: APXvYqw8kmUFZTdml86OFk4ExnbC4on8hvb43jeEB+SHfHs0C2+GnjIN7wyw+xxJ23zIcyfbPlXgSw==
X-Received: by 2002:a5d:6a45:: with SMTP id t5mr33771273wrw.228.1567413555153;
        Mon, 02 Sep 2019 01:39:15 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b18sm17854812wro.34.2019.09.02.01.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 01:39:14 -0700 (PDT)
Date:   Mon, 2 Sep 2019 09:39:12 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/5] vsock/virtio: limit the memory used per-socket
Message-ID: <20190902083912.GA9069@stefanha-x1.localdomain>
References: <20190717113030.163499-1-sgarzare@redhat.com>
 <20190717113030.163499-2-sgarzare@redhat.com>
 <20190729095956-mutt-send-email-mst@kernel.org>
 <20190830094059.c7qo5cxrp2nkrncd@steredhat>
 <20190901024525-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20190901024525-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 01, 2019 at 02:56:44AM -0400, Michael S. Tsirkin wrote:
> On Fri, Aug 30, 2019 at 11:40:59AM +0200, Stefano Garzarella wrote:
> > On Mon, Jul 29, 2019 at 10:04:29AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 17, 2019 at 01:30:26PM +0200, Stefano Garzarella wrote:
> > > > Since virtio-vsock was introduced, the buffers filled by the host
> > > > and pushed to the guest using the vring, are directly queued in
> > > > a per-socket list. These buffers are preallocated by the guest
> > > > with a fixed size (4 KB).
> > > >=20
> > > > The maximum amount of memory used by each socket should be
> > > > controlled by the credit mechanism.
> > > > The default credit available per-socket is 256 KB, but if we use
> > > > only 1 byte per packet, the guest can queue up to 262144 of 4 KB
> > > > buffers, using up to 1 GB of memory per-socket. In addition, the
> > > > guest will continue to fill the vring with new 4 KB free buffers
> > > > to avoid starvation of other sockets.
> > > >=20
> > > > This patch mitigates this issue copying the payload of small
> > > > packets (< 128 bytes) into the buffer of last packet queued, in
> > > > order to avoid wasting memory.
> > > >=20
> > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > >=20
> > > This is good enough for net-next, but for net I think we
> > > should figure out how to address the issue completely.
> > > Can we make the accounting precise? What happens to
> > > performance if we do?
> > >=20
> >=20
> > Since I'm back from holidays, I'm restarting this thread to figure out
> > how to address the issue completely.
> >=20
> > I did a better analysis of the credit mechanism that we implemented in
> > virtio-vsock to get a clearer view and I'd share it with you:
> >=20
> >     This issue affect only the "host->guest" path. In this case, when t=
he
> >     host wants to send a packet to the guest, it uses a "free" buffer
> >     allocated by the guest (4KB).
> >     The "free" buffers available for the host are shared between all
> >     sockets, instead, the credit mechanism is per-socket, I think to
> >     avoid the starvation of others sockets.
> >     The guests re-fill the "free" queue when the available buffers are
> >     less than half.
> >=20
> >     Each peer have these variables in the per-socket state:
> >        /* local vars */
> >        buf_alloc        /* max bytes usable by this socket
> >                            [exposed to the other peer] */
> >        fwd_cnt          /* increased when RX packet is consumed by the
> >                            user space [exposed to the other peer] */
> >        tx_cnt 	        /* increased when TX packet is sent to the other=
 peer */
> >=20
> >        /* remote vars  */
> >        peer_buf_alloc   /* peer's buf_alloc */
> >        peer_fwd_cnt     /* peer's fwd_cnt */
> >=20
> >     When a peer sends a packet, it increases the 'tx_cnt'; when the
> >     receiver consumes the packet (copy it to the user-space buffer), it
> >     increases the 'fwd_cnt'.
> >     Note: increments are made considering the payload length and not the
> >     buffer length.
> >=20
> >     The value of 'buf_alloc' and 'fwd_cnt' are sent to the other peer in
> >     all packet headers or with an explicit CREDIT_UPDATE packet.
> >=20
> >     The local 'buf_alloc' value can be modified by the user space using
> >     setsockopt() with optname=3DSO_VM_SOCKETS_BUFFER_SIZE.
> >=20
> >     Before to send a packet, the peer checks the space available:
> >     	credit_available =3D peer_buf_alloc - (tx_cnt - peer_fwd_cnt)
> >     and it will send up to credit_available bytes to the other peer.
> >=20
> > Possible solutions considering Michael's advice:
> > 1. Use the buffer length instead of the payload length when we increment
> >    the counters:
> >   - This approach will account precisely the memory used per socket.
> >   - This requires changes in both guest and host.
> >   - It is not compatible with old drivers, so a feature should be negot=
iated.
> > 2. Decrease the advertised 'buf_alloc' taking count of bytes queued in
> >    the socket queue but not used. (e.g. 256 byte used on 4K available in
> >    the buffer)
> >   - pkt->hdr.buf_alloc =3D buf_alloc - bytes_not_used.
> >   - This should be compatible also with old drivers.
> >=20
> > Maybe the second is less invasive, but will it be too tricky?
> > Any other advice or suggestions?
> >=20
> > Thanks in advance,
> > Stefano
>=20
> OK let me try to clarify.  The idea is this:
>=20
> Let's say we queue a buffer of 4K, and we copy if len < 128 bytes.  This
> means that in the worst case (128 byte packets), each byte of credit in
> the socket uses up 4K/128 =3D 16 bytes of kernel memory. In fact we need
> to also account for the virtio_vsock_pkt since I think it's kept around
> until userspace consumes it.
>=20
> Thus given X buf alloc allowed in the socket, we should publish X/16
> credits to the other side. This will ensure the other side does not send
> more than X/16 bytes for a given socket and thus we won't need to
> allocate more than X bytes to hold the data.
>=20
> We can play with the copy break value to tweak this.

This seems like a reasonable solution.  Hopefully the benchmark results
will come out okay too.

Stefan

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1s1TAACgkQnKSrs4Gr
c8gLsQf/X+M+3+I6vdXaOQqa3p6XuU6eKcoPYS3AZKsgf2/Hu7lfjlaFu1me49Qx
eoM5VhsaVIzCfF7TJgUthcFsoG+nAc1sc+TPm16rBnDArLUHGMrny6LTZHGmkvi2
HxnjGjLD/1CNxeeyL3HDyyzkKtG32surnGULXLKqW/599PQxHDq+QXSWysC8QTX7
MKE3vc7zIpRh7PiXbPdh4IH8UUeHdEbdYrRoaK0uiXN47vUFOUdM1t8iMG1u/C8t
8X3f/wnHGl7Z6k+QH/3SMme3xihN0/F/TQW8PqyZdUMB7I+X5URicB4ECRpQ3dgE
c0cux2rhFpAIui9MpqD7+fagnhksmw==
=wVO3
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
