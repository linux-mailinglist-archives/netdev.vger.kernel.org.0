Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DA91B4A68
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDVQZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgDVQZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:25:50 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A45AC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:25:50 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id x25so3096346wmc.0
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BSBKJkoipTLZJAaAPh8G/dSFLtBiBGFjBleCFIJ3zow=;
        b=RS9DaT5G2NMOREPA/24Z77EcbxjK6d3KtamRrTdPRgd6O1nbKv91rYBdITLMtdkAjm
         uvfa4lkbb/rqd+mNe/WgGbUw4LxXzfKcHFDkR6+s/F42Ua6oURN5l+lnOcfFN4Fa8hZk
         SSyc3G0bQNqU0KNUQAMdajqJamoSDjeMTK6BstummyBnTeVXVGtr5gYfaC5KIDb/5q/4
         tTiz/p9eSW3rLx4Z4voJX4Iz0be2ZzrEHWlSOekoK3qQ8+l18maqsFk9uJE9/8LFFOao
         o3XcUSU43cLD4Fr7xD+dRIXC+KuEuj1ldTVGM7tZU7Y6hG1GI31fe8y7cUuBIhOP1dd9
         96lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BSBKJkoipTLZJAaAPh8G/dSFLtBiBGFjBleCFIJ3zow=;
        b=oXoNP8GA0XhDjtWw3bpgnfKZLxHTZvseP8A+S9+tmZXLImq+jxH/aijD9ln1eWFiIl
         gr21QPBnex1D4ZChfsowTej9qxk3svRgWUhNxj4166VHZceRdXI/Lp9T87Zr0/zdAjn3
         Ivz1YUytKAz7+xDj9EfsQv07ROke+NGqMf3Z6rEnlS/jzZw9ok5GiRqCZGhhNr4M5i7k
         HHwoafUPsPjqY/YssKRdIQT6CenW5xGuYfddl5n9E301l/hNSCj4g8R5+juEkB+lL509
         +9l/t3ZQU9DBAYQ1t7lH1QH/5jXiUKWwh6iSjJ+sWS1cEHikPmmyz0J56aon2jbUHlmt
         n1iA==
X-Gm-Message-State: AGi0PubqK0cEd8q6NFzfKb63j0aJCmwUo8C86ZhUEclF6g1U3KJet/nT
        zwtB5E9oNqBHOzTtIR6Mvpt1D0hItqU=
X-Google-Smtp-Source: APiQypKN4tzYuU1Nh3MVYPOfqWtEUHC25uV8rAG7PXvjk8l8nFARwwNsezD8ec1XPIBFWutCehjOXQ==
X-Received: by 2002:a1c:5a41:: with SMTP id o62mr11230185wmb.43.1587572749280;
        Wed, 22 Apr 2020 09:25:49 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id i25sm8397976wml.43.2020.04.22.09.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 09:25:48 -0700 (PDT)
Date:   Wed, 22 Apr 2020 17:25:46 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Joshua Abraham <j.abraham1776@gmail.com>
Cc:     qemu-devel@nongnu.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: AF_UNIX Monitor Device
Message-ID: <20200422162546.GJ47385@stefanha-x1.localdomain>
References: <CAMmOe3R6_Q7929+GOrk+G3_2+uj2BSs4jKP6h9VYD6FXcEOCwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JsihDCElWRmQcbOr"
Content-Disposition: inline
In-Reply-To: <CAMmOe3R6_Q7929+GOrk+G3_2+uj2BSs4jKP6h9VYD6FXcEOCwA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JsihDCElWRmQcbOr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 14, 2020 at 09:46:00PM -0400, Joshua Abraham wrote:
> Hello Stefan,
>=20
> This blog post [0] talks about the AF_VSOCK monitoring device
> (vsockmon) Stefan upstreamed into Linux a few years ago. It seems to
> me the same rationale for enabling packet captures for AF_VSOCK
> traffic applies to UNIX domain sockets as well. What do you think? I
> have a proof of concept patch for Linux for a unixmon capture device
> if you think this is a good idea.
>=20
> [0] https://blog.vmsplice.net/2017/07/packet-capture-coming-to-afvsock.ht=
ml

Sorry, I didn't see your email until now.

Unlike AF_VSOCK, AF_UNIX has no control packets so the capture would
only consist of the data which you can already see using strace(1).
So while you really need this feature in order to inspect AF_VSOCK
traffic you don't strictly need it for AF_UNIX.  Maybe that is why this
feature has never been implemented.

I suggest asking the Linux AF_UNIX and networking maintainers if this
feature could be merged.  I've CCed them.

Stefan

--JsihDCElWRmQcbOr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl6gcAoACgkQnKSrs4Gr
c8hH0Af/WUZO0rMijl5cr1eGF1hRlV5r5W9GmcqF6cBiEcPfoXwVy3W4YD1xBaoC
r+QXUpgk4sBq8vyDpN9Rgbh8KxKpRuurBtVTPGpp3/0KHrm2cvuCISt7uUqS1FL4
kvs8+mBnaYft48CCyOm7qvAmP/Hrar+MUZhE1gMvk2vom3I0whXDC5PxIOHKG1+q
ibDsoU6uAr0352PZHEsJbmfhWRil9Pnb/65JoIQTsmsYoEyEXYdGO4aV0K9Q9Pdk
kD2WWAsN3LOlSfk7m0zdyEaUY/P8Snn3k8zgvqQoybRcwp3eg/fkNdd7kYaOfq7B
2GIplUwIo2R1PTlQA1B+ldRo0jVqDw==
=Vub+
-----END PGP SIGNATURE-----

--JsihDCElWRmQcbOr--
