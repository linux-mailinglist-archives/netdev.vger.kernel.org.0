Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8243B104F5B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKUJfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:35:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34272 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUJfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:35:03 -0500
Received: by mail-wr1-f66.google.com with SMTP id t2so3529091wrr.1;
        Thu, 21 Nov 2019 01:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZGBH8au92eRUZnEPs71VbpK8gTvHx2as+XDVL4G8p5c=;
        b=RQMfQYNTUiKORtkurvhl+zlmqW6i2LOgyoavWGAxBYFRjs1x/V7VYG77WSTY3VRfgg
         qV5qw6eq6E+Bp0N5zKmm7ya3ShQEVONdaNr4y2brrmkP1OwSPcetNdxRNbQEBKjdUtED
         oHlJcAVv7PrDXSJ0R3Ed4qRqqdcPJu5qIyrcnhFIIJsnhShjUiFYx47yIUIiBzZVlzPe
         n6Ra60+vxZvv53FXe63RHcADjI/4SF1d2nX9Vpq+W4Mx75O56Yr2PFjz4C0OK03bEw75
         68qo/x3u7yVjPyLORf7F8Ozq6KlPTthOj1zc1qRx4idnr+I2V5DbgHLNwcE+CdaVfzhK
         W7mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZGBH8au92eRUZnEPs71VbpK8gTvHx2as+XDVL4G8p5c=;
        b=UJA7OcyJKuVxxgT/K+rWUn4ElvEgVcgrzKNnwC2FzTqJ6yh9EWkOI0UsoTHc7eu6lm
         7Yu5zYPp+t7vwZ6dk3Kv3Lg3jNdvN/Yn5Wbr5JzlQOvRSOXHPsMkLHwQiKnBX03qKxYL
         HRPfRyapB7qEp3+MGeYXhd5+fbOdERQ+7R8JkudtWEyyZD907Tt2qbvvzh8ljtgczMt2
         RWCzG1wYwZ6ypc+ycoqEDzBki3rIW0R54BWOFsSysSACA4NC8LZG9V0QwGPuq3oHnPSZ
         CfWjo/D5zczzsM8QH17/DitA1ZS8prDcSREwBCL8q855ZRAV3nCygWHIx9e2bq/3gjLd
         okzQ==
X-Gm-Message-State: APjAAAXuT5YbN9qaKaREUgOvXdiDZVZk3+Z7gIxeZLcDUp4zoBFzYoE5
        /Dpk8P14EJjr7sjrxIutQkM=
X-Google-Smtp-Source: APXvYqyJMxet4XYjUxprEHdfDptf7OeeSXc3aHltx2r2yhe48bUYKHoKuape6jSz58WOzX8nscMlBg==
X-Received: by 2002:adf:f084:: with SMTP id n4mr9197280wro.369.1574328900838;
        Thu, 21 Nov 2019 01:35:00 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id y19sm2371455wmd.29.2019.11.21.01.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 01:34:59 -0800 (PST)
Date:   Thu, 21 Nov 2019 09:34:58 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 4/6] vsock: add vsock_loopback transport
Message-ID: <20191121093458.GB439743@stefanha-x1.localdomain>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-5-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20191119110121.14480-5-sgarzare@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2019 at 12:01:19PM +0100, Stefano Garzarella wrote:

Ideas for long-term changes below.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 760049454a23..c2a3dc3113ba 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17239,6 +17239,7 @@ F:	net/vmw_vsock/diag.c
>  F:	net/vmw_vsock/af_vsock_tap.c
>  F:	net/vmw_vsock/virtio_transport_common.c
>  F:	net/vmw_vsock/virtio_transport.c
> +F:	net/vmw_vsock/vsock_loopback.c
>  F:	drivers/net/vsockmon.c
>  F:	drivers/vhost/vsock.c
>  F:	tools/testing/vsock/

At this point you are most active in virtio-vsock and I am reviewing
patches on a best-effort basis.  Feel free to add yourself as
maintainer.

> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> new file mode 100644
> index 000000000000..3d1c1a88305f
> --- /dev/null
> +++ b/net/vmw_vsock/vsock_loopback.c
> @@ -0,0 +1,217 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * loopback transport for vsock using virtio_transport_common APIs
> + *
> + * Copyright (C) 2013-2019 Red Hat, Inc.
> + * Author: Asias He <asias@redhat.com>
> + *         Stefan Hajnoczi <stefanha@redhat.com>
> + *         Stefano Garzarella <sgarzare@redhat.com>
> + *
> + */
> +#include <linux/spinlock.h>
> +#include <linux/module.h>
> +#include <linux/list.h>
> +#include <linux/virtio_vsock.h>

Is it time to rename the generic functionality in
virtio_transport_common.c?  This doesn't have anything to do with virtio
:).

> +
> +static struct workqueue_struct *vsock_loopback_workqueue;
> +static struct vsock_loopback *the_vsock_loopback;

the_vsock_loopback could be a static global variable (not a pointer) and
vsock_loopback_workqueue could also be included in the struct.

The RCU pointer is really a way to synchronize vsock_loopback_send_pkt()
and vsock_loopback_cancel_pkt() with module exit.  There is no other
reason for using a pointer.

It's cleaner to implement the synchronization once in af_vsock.c (or
virtio_transport_common.c) instead of making each transport do it.
Maybe try_module_get() and related APIs provide the necessary semantics
so that core vsock code can hold the transport module while it's being
used to send/cancel a packet.

> +MODULE_ALIAS_NETPROTO(PF_VSOCK);

Why does this module define the alias for PF_VSOCK?  Doesn't another
module already define this alias?

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3WWkIACgkQnKSrs4Gr
c8jBuAgAg4roCliY5QrKSBc2swUmpdqgthCa2WBtvGuV40W4kMS8BoWa4ACU8uGA
uxOG2+bM919Qiu+LpwTdm4RrQ5Vxk78KUZsHGdTrHxF7tZvg6J9ojjZGc3DkO/zr
ndGHNu05QTeEetAhPg13rpZmYe0WDgR6NTP4cWlpFRxWjBk46laAbA04xLXDN/NF
fgt/nh2LL5k9CWbNFuPKwzm5qudh7OAojBGmk1dfeBnZCLZB4U7AF1zdDB8CJssG
YJ2zcbuKUptctXc8reETVJOxwDXzpvwiQgpIp1blJC+Z3Thdn5vJDxlzefjBLYyL
/DyzsL2ZvpFLxvf62uE+xEAQeXa0Jg==
=lA3N
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
