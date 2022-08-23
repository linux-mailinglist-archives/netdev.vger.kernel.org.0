Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC3C59ED85
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiHWUlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiHWUkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:40:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FB457567
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 13:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661286637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fsXMj/6hNU0e5tAGMLQtNIyftNI4ROUnRCyckBUdrAw=;
        b=HsnOc4JdFkRHOOdvouE0r8bkj/8c3vlPnWG9fWknrswlITxfvGw5YANJGwK3yqUzgCD1gs
        lBwXoGfkqbnEHzqYfQAvWvdtKZULia8ljek+Fg5pp2tFNNUMB4nRqq25CiUn52YWUBFRIj
        wGbkg95OiDIeJPk9fKyXb6U+O/+5y94=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-KV7nwgpXNDq20QYFR3O9MQ-1; Tue, 23 Aug 2022 16:30:31 -0400
X-MC-Unique: KV7nwgpXNDq20QYFR3O9MQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26964296A603;
        Tue, 23 Aug 2022 20:30:30 +0000 (UTC)
Received: from localhost (unknown [10.39.192.115])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 665021121315;
        Tue, 23 Aug 2022 20:30:29 +0000 (UTC)
Date:   Tue, 23 Aug 2022 16:30:27 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
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
Message-ID: <YwU443jzc/N4fV3A@fedora>
References: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
 <YwUnAhWauSFSJX+g@fedora>
 <20220823121852.1fde7917@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tW4PvRQqQXgDRL/h"
Content-Disposition: inline
In-Reply-To: <20220823121852.1fde7917@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tW4PvRQqQXgDRL/h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2022 at 12:18:52PM -0700, Jakub Kicinski wrote:
> On Tue, 23 Aug 2022 15:14:10 -0400 Stefan Hajnoczi wrote:
> > Stefano will be online again on Monday. I suggest we wait for him to
> > review this series. If it's urgent, please let me know and I'll take a
> > look.
>=20
> It was already applied, sorry about that. But please continue with
> review as if it wasn't. We'll just revert based on Stefano's feedback
> as needed.

Okay, no problem.

Stefan

--tW4PvRQqQXgDRL/h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmMFOOMACgkQnKSrs4Gr
c8hvlQgAo4gB0BkrZtfmmojZpiKE6Xq15IttUNkmuyZgxF8sLW3iBu9LtCiQDZU2
6sXR4GxAoAhr3tzo1KsUrMoc/hx2+Io9fLHLVLFZfFgnY52O3ipxSoKB3gE/DTfk
hCpzD4jW7BSIC1WImlqYOZ3kRdhxBxawrEF2hMRSnNS2ewSJJTNsJjrfmb/+te9e
kVb8naCagmAeznr1rOTXC+6xJlCQo9c5swxpxPGOpcFHGv71hxGDvxbvTB6omKXA
Z1sbgS37LGQ8J+gBXFZ8SMDKGC1bnRVVOFsioohZ43oFO0yzjjqqx/2s6+qZUcGH
CPYyhqwKD/oFfY/saOMIHCNnQkNV5w==
=Vfeh
-----END PGP SIGNATURE-----

--tW4PvRQqQXgDRL/h--

