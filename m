Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275BDF6144
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfKIT4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:56:52 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32880 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKIT4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 14:56:52 -0500
Received: by mail-pg1-f193.google.com with SMTP id h27so6387081pgn.0;
        Sat, 09 Nov 2019 11:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=sLWE3rS63Cpkf+p4HwP4LC/KJ6xTAmv/RqA0nojUWoM=;
        b=fAdAhYgwJKwty7+hqYCuAAzC/oBBAUd7GqZD3SHIuzj+eqZNIYlDs/fxpiOa0T4JZc
         Z9+pJrjI1gxGklPWKQOYpBG76ru/KUvxodo43RasDGmLjzAsHsYmjHjrxIG2ll1IqfA4
         eZa1FieBQEzxYwTNawDzwTc3EoJEW1a4qxgDAfKIcmqGNpwdCuNr7IxZJz9y6Lv1hEYZ
         2qxBPO9Jc+126IrckZ4aXX0guMp1DDBTU9iczzUzONCL6OeTBPf9YcYrk5jcxxJ4gW92
         sBP2yuHaaL6LRJ4GtcyCJAYhcFMTBYcZT2CGMybJ2XsWjme64ZoIMCiGPpl1tOXH9xKC
         cNNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=sLWE3rS63Cpkf+p4HwP4LC/KJ6xTAmv/RqA0nojUWoM=;
        b=R6l2v62rID7Zepgp9b2x+VgUdHmx8rcOl2RVeMPq2caCbA5cCtSuoZ0IJ3wiKhRTO0
         cUJ9w2RbbJj/ZHUoSaU19iqGZ4AzggUUaqv8TRoBVeMG45YhKSRLUX4WIhp00VkBAKL1
         lTYOFBv3cHnlXuFdRFbJNEvXiyYviLGsiLtVhBYMOYK2q7L3OivuqNTyBnuBSm75oxh5
         OxsAh8fc0UFECcSiKY2SLI5XR2fFQ4KfoxQWegNVp2qv6fV3NHnnCo7zxwLLktj19wwP
         bLCviGGeEY88hS0bz2wntZIJ9Otvo0OhvJT4/T7U1e3azvyRY0x88+4Lx37/RJQQlhh1
         dijA==
X-Gm-Message-State: APjAAAXR4jlN++ufQ7TT8K/fGJTwvEEQOA00O1cSkFHUkNAuVrlHOdAk
        dMPPMcYX/sVPSW2PiTBWmtLe4HKbC+M7JQ==
X-Google-Smtp-Source: APXvYqwkpMtHuF6e0ZHz0Id4WN1/wzmYxymX9kUI/DmbK7uNv7OIWFpdllt3rhd3YEpuFVVABKIUAA==
X-Received: by 2002:a62:b616:: with SMTP id j22mr19597192pff.201.1573329409964;
        Sat, 09 Nov 2019 11:56:49 -0800 (PST)
Received: from [192.168.1.104] (c-76-21-111-180.hsd1.ca.comcast.net. [76.21.111.180])
        by smtp.gmail.com with ESMTPSA id f12sm9690619pfn.152.2019.11.09.11.56.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 11:56:49 -0800 (PST)
From:   Mark D Rustad <mrustad@gmail.com>
Message-Id: <A48EFA5D-56C6-404B-96FF-75736FCFD11E@gmail.com>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_5BF3661D-48DD-4761-9FE1-54AFC65DF771";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 2/2] IFC VDPA layer
Date:   Sat, 9 Nov 2019 11:56:46 -0800
In-Reply-To: <1572946660-26265-3-git-send-email-lingshan.zhu@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com
To:     Zhu Lingshan <lingshan.zhu@intel.com>
References: <1572946660-26265-1-git-send-email-lingshan.zhu@intel.com>
 <1572946660-26265-3-git-send-email-lingshan.zhu@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_5BF3661D-48DD-4761-9FE1-54AFC65DF771
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed

On Nov 5, 2019, at 1:37 AM, Zhu Lingshan <lingshan.zhu@intel.com> wrote:

> This commit introduced IFC operations for vdpa, which complys to
> virtio_mdev and vhost_mdev interfaces, handles IFC VF
> initialization, configuration and removal.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vhost/ifcvf/ifcvf_main.c | 605 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 605 insertions(+)
>  create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c
>
> diff --git a/drivers/vhost/ifcvf/ifcvf_main.c  
> b/drivers/vhost/ifcvf/ifcvf_main.c
> new file mode 100644
> index 0000000..7165457
> --- /dev/null
> +++ b/drivers/vhost/ifcvf/ifcvf_main.c
> @@ -0,0 +1,605 @@

<snip>

> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		if (!vf->vring[i].ready) {
> +			IFC_ERR(ifcvf->dev,
> +				"Failed to start datapath, vring %d not ready.\n", i);
> +			return -EINVAL;
> +		}
> +
> +		if (!vf->vring[i].size) {
> +			IFC_ERR(ifcvf->dev,
> +				"Failed to start datapath, vring %d size is zero.\n", i);
> +			return -EINVAL;
> +		}
> +
> +		if (!vf->vring[i].desc || !vf->vring[i].avail ||
> +			!vf->vring[i].used) {
> +			IFC_ERR(ifcvf->dev,
> +				"Failed to start datapath, "
> +				"invaild value for vring %d desc,"
> +				"avail_idx or usex_idx.\n", i);

Please don't break up the format string. Start it on the second line and  
let it run as long as it needs to. Also you will find that it is improperly  
spaced as it is. It makes it easier to grep the source to find the source  
of a message. The coding style has an explicit exception for such long  
lines for this reason.

Also, please don't put .'s on the end of log messages. It serves no purpose  
and just adds to the log, the binary size and the source size. There are  
quite a few of these.

<snip>

--
Mark Rustad, MRustad@gmail.com

--Apple-Mail=_5BF3661D-48DD-4761-9FE1-54AFC65DF771
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEE6ug8b0Wg+ULmnksNPA7/547j7m4FAl3HGf4ACgkQPA7/547j
7m5i5hAAp5HzGpa+FtAAiSu0nbqUTR1JdW8w3XQwR+PqLGPPDZm8o5j/NMowthPA
YwP3oJvINev2V6ibYRePdFg9mvgqjAII61RSaXeNuFxX8feBZU5k5+UzaOx9/zZp
rSafgIqKyEGiR5zSdoeK6GS852O18MAwKNmoc80vyARppI959f0D64rLjYi7ApOv
9PcQ5J0JQqlMmj7EeYM1cHnnCtxANbGu011291JjjpcsYlB173Ma0CVSPzcmnBjw
ZpRhiKhMaV8o0Pznc1b6NQIZMx7y+dGRYkaw7aeuJr9vCergpsJu4OVrp6nk8/1x
asxfx5qbmoZvpA7/WK+PDCORDZNwCxFjHIwmg8P8/PjqNgMHiZ98QsYS25YU8nm9
1ArgG5Op5ngmaYZ4npZu/5blWasJWIciWfWLdHTjv1ZLGUsafWlNDh7YzEVVPPtR
b+aT6s4MC+ttn0zJRYsuj7U+B0jr8PhfQQ8ng6EzbdQ5Aa1sBeR0nKxBpf/2KNsF
kCvJYQqBvrtOshq2SY/bryGqW1XNwE0W7ARhE9+UEjriQG3Qu2et6K3MNmDG31cS
cI41oSy41i6zsfwZwJKJl4Orgtr3Hz2G0aozyyqmKTrHlTUTQ/1Er4ol6oZlzrL+
gZhXDyihHwXikwjZTWqfRw9jFVV2WHpJQt59mjmLuXbAk8bR0FI=
=CTNy
-----END PGP SIGNATURE-----

--Apple-Mail=_5BF3661D-48DD-4761-9FE1-54AFC65DF771--
