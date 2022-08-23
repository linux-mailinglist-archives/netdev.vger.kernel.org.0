Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC9959ECFB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbiHWUBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiHWUB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:01:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F6B7E334
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661282056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lf4lftfoYaSkjrGheHP3w/cy0mbiwD/FcUC/oTLQSG8=;
        b=WHW1FD1B9hV+QKXJGXqjw/oGx7+zJG549LwnBXKInX/KmapehPpvpkVlKIOAttGMV+vhFk
        Uiyo+orv7EPqGH/SJuY0TV/LpW5Qelr+tTzu3Efia+bsJmnu2Ap8MNkgEKetScKN4AcAwD
        0kIqbRt2f97uXkhGPfAMBjuNDMxUqzg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-4g7CuzW_Mrue8FfFDcjs-g-1; Tue, 23 Aug 2022 15:14:13 -0400
X-MC-Unique: 4g7CuzW_Mrue8FfFDcjs-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 700411C13941;
        Tue, 23 Aug 2022 19:14:12 +0000 (UTC)
Received: from localhost (unknown [10.39.192.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2A032166B26;
        Tue, 23 Aug 2022 19:14:11 +0000 (UTC)
Date:   Tue, 23 Aug 2022 15:14:10 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: Re: [PATCH net-next v4 0/9] vsock: updates for SO_RCVLOWAT handling
Message-ID: <YwUnAhWauSFSJX+g@fedora>
References: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MY0QU7bnoDA4DEoQ"
Content-Disposition: inline
In-Reply-To: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MY0QU7bnoDA4DEoQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2022 at 05:21:58AM +0000, Arseniy Krasnov wrote:
> Hello,
>=20
> This patchset includes some updates for SO_RCVLOWAT:
>=20
> 1) af_vsock:
>    During my experiments with zerocopy receive, i found, that in some
>    cases, poll() implementation violates POSIX: when socket has non-
>    default SO_RCVLOWAT(e.g. not 1), poll() will always set POLLIN and
>    POLLRDNORM bits in 'revents' even number of bytes available to read
>    on socket is smaller than SO_RCVLOWAT value. In this case,user sees
>    POLLIN flag and then tries to read data(for example using  'read()'
>    call), but read call will be blocked, because  SO_RCVLOWAT logic is
>    supported in dequeue loop in af_vsock.c. But the same time,  POSIX
>    requires that:
>=20
>    "POLLIN     Data other than high-priority data may be read without
>                blocking.
>     POLLRDNORM Normal data may be read without blocking."
>=20
>    See https://www.open-std.org/jtc1/sc22/open/n4217.pdf, page 293.
>=20
>    So, we have, that poll() syscall returns POLLIN, but read call will
>    be blocked.
>=20
>    Also in man page socket(7) i found that:
>=20
>    "Since Linux 2.6.28, select(2), poll(2), and epoll(7) indicate a
>    socket as readable only if at least SO_RCVLOWAT bytes are available."
>=20
>    I checked TCP callback for poll()(net/ipv4/tcp.c, tcp_poll()), it
>    uses SO_RCVLOWAT value to set POLLIN bit, also i've tested TCP with
>    this case for TCP socket, it works as POSIX required.
>=20
>    I've added some fixes to af_vsock.c and virtio_transport_common.c,
>    test is also implemented.
>=20
> 2) virtio/vsock:
>    It adds some optimization to wake ups, when new data arrived. Now,
>    SO_RCVLOWAT is considered before wake up sleepers who wait new data.
>    There is no sense, to kick waiter, when number of available bytes
>    in socket's queue < SO_RCVLOWAT, because if we wake up reader in
>    this case, it will wait for SO_RCVLOWAT data anyway during dequeue,
>    or in poll() case, POLLIN/POLLRDNORM bits won't be set, so such
>    exit from poll() will be "spurious". This logic is also used in TCP
>    sockets.
>=20
> 3) vmci/vsock:
>    Same as 2), but i'm not sure about this changes. Will be very good,
>    to get comments from someone who knows this code.
>=20
> 4) Hyper-V:
>    As Dexuan Cui mentioned, for Hyper-V transport it is difficult to
>    support SO_RCVLOWAT, so he suggested to disable this feature for
>    Hyper-V.
>=20
> Thank You

Hi Arseniy,
Stefano will be online again on Monday. I suggest we wait for him to
review this series. If it's urgent, please let me know and I'll take a
look.

Thanks,
Stefan

> Arseniy Krasnov(9):
>  vsock: SO_RCVLOWAT transport set callback
>  hv_sock: disable SO_RCVLOWAT support
>  virtio/vsock: use 'target' in notify_poll_in callback
>  vmci/vsock: use 'target' in notify_poll_in callback
>  vsock: pass sock_rcvlowat to notify_poll_in as target
>  vsock: add API call for data ready
>  virtio/vsock: check SO_RCVLOWAT before wake up reader
>  vmci/vsock: check SO_RCVLOWAT before wake up reader
>  vsock_test: POLLIN + SO_RCVLOWAT test
>=20
>  include/net/af_vsock.h                       |   2 +
>  net/vmw_vsock/af_vsock.c                     |  33 +++++++-
>  net/vmw_vsock/hyperv_transport.c             |   7 ++
>  net/vmw_vsock/virtio_transport_common.c      |   7 +-
>  net/vmw_vsock/vmci_transport_notify.c        |  10 +--
>  net/vmw_vsock/vmci_transport_notify_qstate.c |  12 +--
>  tools/testing/vsock/vsock_test.c             | 108 +++++++++++++++++++++=
++++++
>  7 files changed, 162 insertions(+), 17 deletions(-)
>=20
>  Changelog:
>=20
>  v1 -> v2:
>  1) Patches for VMCI transport(same as for virtio-vsock).
>  2) Patches for Hyper-V transport(disabling SO_RCVLOWAT setting).
>  3) Waiting logic in test was updated(sleep() -> poll()).
>=20
>  v2 -> v3:
>  1) Patches were reordered.
>  2) Commit message updated in 0005.
>  3) Check 'transport' pointer in 0001 for NULL.
>=20
>  v3 -> v4:
>  1) vsock_set_rcvlowat() logic changed. Previous version required
>     assigned transport and always called its 'set_rcvlowat' callback
>     (if present). Now, assignment is not needed.
>  2) 0003,0004,0005,0006,0007,0008 - commit messages updated.
>  3) 0009 - small refactoring and style fixes.
>  4) RFC tag was removed.
>=20
> --=20
> 2.25.1

--MY0QU7bnoDA4DEoQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmMFJwIACgkQnKSrs4Gr
c8hfpwgAq+JCoPsR72mnMAiJ64hEeR7VU4PB29fifgVsNdmttit01L8f3u3rwcJg
aOcR8aXEJUbQJAcQxrN9nslgW+L9L6UzDUaKGNzWXK4f3a+CBXFA0zMRnJY6/n0l
vyYbjXb2DqlDhpC/PwjcmQ9QSrcMA35wXqYcIH1AXrk7i1poAM0IzjsTnVr7i8TQ
C8D8wkDEzHrQRLjdBN0zrQsIvbVByhkFYF/QhQJBr/rNJokjX9JdkOb5fmAWuedB
GxktTsPfLFov5AIdgtcBhRD5iNeJyLsNh5YIULcweMdbpV3DWRr1umpPk/yzjcD5
77HdnXIblY58tqlO1bC9+eMpMTVhRw==
=OvOp
-----END PGP SIGNATURE-----

--MY0QU7bnoDA4DEoQ--

