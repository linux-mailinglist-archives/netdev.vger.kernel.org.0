Return-Path: <netdev+bounces-185-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EF86F5BA0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:57:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EDB51C20F4C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71BEC107BC;
	Wed,  3 May 2023 15:57:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DCA3C27
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 15:57:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C507D4EDC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683129444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EsRGaMSxZjGqbf3q0iORiAelbSECfaHX9TLV8VF714c=;
	b=VnDtV3Iiv/P+pA+TkrIioldI0a0VmRaCRxHnsmDmaW64bIaeDUJFVAUXRZUYg15lIEjLEF
	RJW0SKwE46pvgO1J9oSjt/aXYDBU8Hqbf8v6F9L7pdKH1p5TDXbfz2SaDsyn5/hBAlWuaH
	Ce/+N2ZDGdSqyXCz+fAdd+Xj0V8yKuw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-Y74Qo4mXOkq_L3_B2qHs3Q-1; Wed, 03 May 2023 11:57:20 -0400
X-MC-Unique: Y74Qo4mXOkq_L3_B2qHs3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 053FB18E5372;
	Wed,  3 May 2023 15:57:20 +0000 (UTC)
Received: from localhost (unknown [10.39.193.0])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 770804020962;
	Wed,  3 May 2023 15:57:19 +0000 (UTC)
Date: Wed, 3 May 2023 09:39:13 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <20230503133913.GF757667@fedora>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
 <20230502201418.GG535070@fedora>
 <ZDt+PDtKlxrwUPnc@bullseye>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="g/fPiS3p8CdrynfS"
Content-Disposition: inline
In-Reply-To: <ZDt+PDtKlxrwUPnc@bullseye>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


--g/fPiS3p8CdrynfS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 16, 2023 at 04:49:00AM +0000, Bobby Eshleman wrote:
> On Tue, May 02, 2023 at 04:14:18PM -0400, Stefan Hajnoczi wrote:
> > On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >=20
> > > When virtqueue_add_sgs() fails, the skb is put back to send queue,
> > > we should not deliver the copy to tap device in this case. So we
> > > need to move virtio_transport_deliver_tap_pkt() down after all
> > > possible failures.
> > >=20
> > > Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
> > > Cc: Stefan Hajnoczi <stefanha@redhat.com>
> > > Cc: Stefano Garzarella <sgarzare@redhat.com>
> > > Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > ---
> > >  net/vmw_vsock/virtio_transport.c | 5 ++---
> > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_=
transport.c
> > > index e95df847176b..055678628c07 100644
> > > --- a/net/vmw_vsock/virtio_transport.c
> > > +++ b/net/vmw_vsock/virtio_transport.c
> > > @@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct=
 *work)
> > >  		if (!skb)
> > >  			break;
> > > =20
> > > -		virtio_transport_deliver_tap_pkt(skb);
> > > -		reply =3D virtio_vsock_skb_reply(skb);
> > > -
> > >  		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(=
skb)));
> > >  		sgs[out_sg++] =3D &hdr;
> > >  		if (skb->len > 0) {
> > > @@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct=
 *work)
> > >  			break;
> > >  		}
> > > =20
> > > +		virtio_transport_deliver_tap_pkt(skb);
> > > +		reply =3D virtio_vsock_skb_reply(skb);
> >=20
> > I don't remember the reason for the ordering, but I'm pretty sure it was
> > deliberate. Probably because the payload buffers could be freed as soon
> > as virtqueue_add_sgs() is called.
> >=20
> > If that's no longer true with Bobby's skbuff code, then maybe it's safe
> > to monitor packets after they have been sent.
> >=20
> > Stefan
>=20
> Hey Stefan,
>=20
> Unfortunately, skbuff doesn't change that behavior.
>=20
> If I understand correctly, the problem flow you are describing
> would be something like this:
>=20
> Thread 0 			Thread 1
> guest:virtqueue_add_sgs()[@send_pkt_work]
>=20
> 				host:vhost_vq_get_desc()[@handle_tx_kick]
> 				host:vhost_add_used()
> 				host:vhost_signal()
> 				guest:virtqueue_get_buf()[@tx_work]
> 				guest:consume_skb()
>=20
> guest:deliver_tap_pkt()[@send_pkt_work]
> ^ use-after-free
>=20
> Which I guess is possible because the receiver can consume the new
> scatterlist during the processing kicked off for a previous batch?
> (doesn't have to wait for the subsequent kick)

Yes, drivers must assume that the device completes request before
virtqueue_add_sgs() returns. For example, the device is allowed to poll
the virtqueue memory and may see the new descriptors immediately.

I haven't audited the current vsock code path to determine whether it's
possible to reach consume_skb() before deliver_tap_pkt() returns, so I
can't say whether it's safe or not.

Stefan

--g/fPiS3p8CdrynfS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRSZAEACgkQnKSrs4Gr
c8jkvQgAmVX4WzYQDdtxMkSMB4j8ozN7cpcaVR90gu/OuPUKIV8FhCpymBqzgaWO
igJ5x5l1PsTrEB7b644n/bz4SUPOYJiekJeLOGCw22PIwowWVkG0zvvkJMVxLvCG
JdnOYVeoTHYn74n5GHn19eEj8DaPn/451P5zQh5f3AX7ZF4PFhDe6UdZN8iexfZ2
X+sbT+m61lc65n8Chkmd0yBrsDXKKgPDr5EtsSiyD+gUabYhQGrnnzxBk0lt8WbB
C985ZeXbxybJLduNHrSJBSA532rCNP2p4UJiHETArnIhuh+ynsxPOy46WGuKaJKh
xCf3AAd2UkLp1SRmpjL7WZmozD0aBA==
=gU1d
-----END PGP SIGNATURE-----

--g/fPiS3p8CdrynfS--


