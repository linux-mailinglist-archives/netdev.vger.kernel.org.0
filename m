Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6985BEC2
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfGAOyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:54:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50262 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfGAOyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 10:54:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id n9so4303587wmi.0;
        Mon, 01 Jul 2019 07:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CAXSIF6Ao3g4SuCwb5RSzByJ3Q/JacDT0Jn2E1kcim4=;
        b=vV0wO44KZqDziwzq3iRnqdyJDdA7zcKHMyjALa20OiZd2Ci2laoS0ILAuulyy/SSsa
         9zJzGSGle3y/YQ5lmhnTvY8Qobmy/oAC/Stk7bKFaDja/e4Y48k4D5iRBkZDqqCBGd8Y
         73qJfTbJt81QTHdmrK+KP8PbOtNPIG4U+xawb+Sz1OAYyIr0SDFcg2TM64vZHRQK771x
         uoB6p9fjQVCDITV/KB3pwXIum83iJ1J+cGX1Uini9VlwlB+QYsM0xf48QTiXbmIZcVtX
         dNsyL3XMPHLaMRgWYQIeUgz27ZKezCSpUIZfimoyzjaUBiw16SeQ99AtCvgofSnsef1r
         WKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CAXSIF6Ao3g4SuCwb5RSzByJ3Q/JacDT0Jn2E1kcim4=;
        b=SeKUxvs+PzVhdp1jzj5PJxo0dOCvB/dAgyTPc5jKS+hra+9nOPe/oK0G8+kP3+oEqt
         oapxWcL9UbfGSMXjyT+ddpYlrfmr1ud6U3OLWYy1AcLpMI8nGf4KgijfV+CmisMqe+Z1
         /QXDGsIDrtZV40MrxKeVGeXJafs5tLW+zyb9RlJvAWhykWsMEkZgf6MthbRYTMRA1ElU
         BKHFBNfo9fw9yCaASOfV3J6hgtStlCLddyeERnCvos2Y9wYxjvoZu6IfH3fMgzHH+OEp
         3JoCsvXizBujHxLaaKhbIi/W2Z3HU8GtLQU/wUVXtEHlaWNdaJ7UBzIc8lnpWLPG6yBx
         ONqA==
X-Gm-Message-State: APjAAAVhXw6jCrHexg6qm3pmKefaAFnZNeU5zKKsT94jy+IUNMnRU9MU
        oAohHyxW8fv1eHaunNB5rj0UZWaUdgOAJg==
X-Google-Smtp-Source: APXvYqzNw+l/hQ290ZZxE7dWlMt05RbBEfvm60/xqqW6qlfwCFjaO2VCtbx4Ol6vrWUk5mD2SswNow==
X-Received: by 2002:a1c:b146:: with SMTP id a67mr17097250wmf.124.1561992854086;
        Mon, 01 Jul 2019 07:54:14 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id 32sm22933497wra.35.2019.07.01.07.54.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 07:54:13 -0700 (PDT)
Date:   Mon, 1 Jul 2019 15:54:12 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 1/3] vsock/virtio: use RCU to avoid use-after-free on
 the_virtio_vsock
Message-ID: <20190701145412.GA11900@stefanha-x1.localdomain>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190628123659.139576-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20190628123659.139576-2-sgarzare@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2019 at 02:36:57PM +0200, Stefano Garzarella wrote:
> Some callbacks used by the upper layers can run while we are in the
> .remove(). A potential use-after-free can happen, because we free
> the_virtio_vsock without knowing if the callbacks are over or not.
>=20
> To solve this issue we move the assignment of the_virtio_vsock at the
> end of .probe(), when we finished all the initialization, and at the
> beginning of .remove(), before to release resources.
> For the same reason, we do the same also for the vdev->priv.
>=20
> We use RCU to be sure that all callbacks that use the_virtio_vsock
> ended before freeing it. This is not required for callbacks that
> use vdev->priv, because after the vdev->config->del_vqs() we are sure
> that they are ended and will no longer be invoked.

->del_vqs() is only called at the very end, did you forget to move it
earlier?

In particular, the virtqueue handler callbacks schedule a workqueue.
The work functions use container_of() to get vsock.  We need to be sure
that the work item isn't freed along with vsock while the work item is
still pending.

How do we know that the virtqueue handler is never called in such a way
that it sees vsock !=3D NULL (there is no explicit memory barrier on the
read side) and then schedules a work item after flush_work() has run?

Stefan

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0aHpQACgkQnKSrs4Gr
c8h3iggAyuubhQSWc2lhNVpR8Iy+q+vzwq6cn2HkKAJfd12b4HEHPiQthM2torlj
Bv8w164J+O/rOon9ZrilyvFEgF2NuQbHiyd7REvtp4tKyZow9wVqj4VT2s0CIxAM
5w3ijDBYRXnC2YmnnjJLJb/xhmkrjboxZcX7BuPjNbsNtkxcVer9KlOZOp9tjL7N
OYm4hhy/aHydI1SwBIbVYNvyWGvjhpZqYixHr2uOB/Xd/kisVztQoJE77oRPD6IS
3kScisIJxoNurY1izyyJfSI0OJ+chyeGNLeR/NzvMGiPRUeEIZCC/Z2jGGBGD7WU
re2dtf93pyrxquVVa7nd39azFSXO3w==
=NQ6E
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
