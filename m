Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CD52E9332
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 11:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbhADKUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 05:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbhADKUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 05:20:36 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2978C061793;
        Mon,  4 Jan 2021 02:19:55 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y23so18788035wmi.1;
        Mon, 04 Jan 2021 02:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cshuBm7yB0Z3cSiR7jcnuEYzCYnzDpnl22WbZG/ju9A=;
        b=M3Ngc5/MMNzyhU8I5x5YBEM7KEyJ85Y0XLmLQEYrJWsFHN5N8VXe8Z5MPFYwnuMrMi
         Hx/9Mpra2YpHPrZqELXd73hWlIY1XRevN88LOhXt/adUP5lVVlBhj5VnV87P+RePmuu3
         /TxKZ1oCnspXNA+t3jR/wrELwh2BuSY7bWFn2E/79tRNqFoewT5tm7XidnRDq7zPg7Q2
         khd0qeLDq3dGyBhVMs4alfzPYBZOOpeshQQ1oolYQHB4q8SS84uIKrKeG5sjd96cYb9M
         3166FELfa+cTzCd1qV4jEU6jT4zvv7+XkmPr/gbsNiRm2SPSO8V58fKTXkJR8anaqW2Q
         W6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cshuBm7yB0Z3cSiR7jcnuEYzCYnzDpnl22WbZG/ju9A=;
        b=j3+93wUe0snB+zLeb2wmZzy2h95ySsP17I62uZJbppXRRFkzD++bvPrwMvx59+j7i3
         1WBa8oTy6FiFiu2j1Dl2VFq1w6LfTZNV9g8LbqWY5z1kADHNhSgGxa07wxKPW5Di2MLa
         AroobeCy1yZfp4ihO9QRQ1wRKgaSEhE4acyfTTOFQ+j9Phti4bQHm4tfT2rGQT7lmgAU
         SmtDcPiz85uOP2nPgd+4hhZe9pw7X3Qa2DM2oePPsaXGAWRr7uzFrerRgNGpPDY3FDxo
         xGMfwrnqfWR3C6U34W5YX5UdBVay+Do6fehvw3m70s5CQ+aYNa6zUrLavqFZw2c809vG
         15IA==
X-Gm-Message-State: AOAM532rUC+qn8fcGwXFApt6OPfQHyqN4OpC7tFct46Y6cYieuK3PJik
        NOJZZJMIjnKNKacRHJQxwkA=
X-Google-Smtp-Source: ABdhPJwOuLImjmAuXi0UyWjGYMZg6gZNFDNyltiw/uCmka2l2gwaY0RUZ3EWHJG5F8u9t7/5Zt9cRw==
X-Received: by 2002:a1c:e246:: with SMTP id z67mr26166545wmg.166.1609755594674;
        Mon, 04 Jan 2021 02:19:54 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id b9sm35686661wmd.32.2021.01.04.02.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:19:53 -0800 (PST)
Date:   Mon, 4 Jan 2021 10:19:52 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2] vhost/vsock: add IOTLB API support
Message-ID: <20210104101952.GA344891@stefanha-x1.localdomain>
References: <20201223143638.123417-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20201223143638.123417-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 23, 2020 at 03:36:38PM +0100, Stefano Garzarella wrote:
> This patch enables the IOTLB API support for vhost-vsock devices,
> allowing the userspace to emulate an IOMMU for the guest.
>=20
> These changes were made following vhost-net, in details this patch:
> - exposes VIRTIO_F_ACCESS_PLATFORM feature and inits the iotlb
>   device if the feature is acked
> - implements VHOST_GET_BACKEND_FEATURES and
>   VHOST_SET_BACKEND_FEATURES ioctls
> - calls vq_meta_prefetch() before vq processing to prefetch vq
>   metadata address in IOTLB
> - provides .read_iter, .write_iter, and .poll callbacks for the
>   chardev; they are used by the userspace to exchange IOTLB messages
>=20
> This patch was tested specifying "intel_iommu=3Dstrict" in the guest
> kernel command line. I used QEMU with a patch applied [1] to fix a
> simple issue (that patch was merged in QEMU v5.2.0):
>     $ qemu -M q35,accel=3Dkvm,kernel-irqchip=3Dsplit \
>            -drive file=3Dfedora.qcow2,format=3Dqcow2,if=3Dvirtio \
>            -device intel-iommu,intremap=3Don,device-iotlb=3Don \
>            -device vhost-vsock-pci,guest-cid=3D3,iommu_platform=3Don,ats=
=3Don
>=20
> [1] https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg09077.html
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>=20
> The patch is the same of v1, but I re-tested it with:
> - QEMU v5.2.0-551-ga05f8ecd88
> - Linux 5.9.15 (host)
> - Linux 5.9.15 and 5.10.0 (guest)
> Now, enabling 'ats' it works well, there are just a few simple changes.
>=20
> v1: https://www.spinics.net/lists/kernel/msg3716022.html
> v2:
> - updated commit message about QEMU version and string used to test
> - rebased on mst/vhost branch
>=20
> Thanks,
> Stefano
> ---
>  drivers/vhost/vsock.c | 68 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 65 insertions(+), 3 deletions(-)

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/y68gACgkQnKSrs4Gr
c8jFlggAxynl8f/xErtZe/4q3P7uG8fRfOuje/XSlmzcxtlgQOv+t7r/vKjWzGwb
ZJ52k6PN1dlbuQHyBf1TDre9nNqW17YteqL+em0hfvynsHV6WREOpJPLnVcbOWkF
/vMadG9PxDkagfVN7ZOEzeLewJM4ZxAjYaZe9ADM2aq6MoxhiC4oCICmOK2UBbu3
t/bVIhCL/cZs0nMO5cGfpz8u0ZenAiVPsXmbEiynMhhFd1pNWu1XsB6BGqJgZ4oJ
1BvYrA3RWKmvq/EK15JIKzHJrNuP5mh0bGrWKXOj4ubUTRYnjVMWfwtfDpjKUlGB
W77zh8Sm5xfKTDndtPmChInD+yd2iQ==
=9iMg
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
