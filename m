Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF43231C1E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgG2Jby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgG2Jbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:31:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3291C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 02:31:53 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596015112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8B3mdGbWCwi5b7RBCFnp9w7c8RBaH7yHPDCKnZknLS4=;
        b=fc0SEaOADQvLVhV9GuM+YVYXwZ0Vs9U275jANLizylHFCvOpfaiUJGXxxToeNJf57Bed9w
        e6lMJ3FdMFybEXOlsHIvBVAfJLhJR3dLiI8m3SjY4aNNO225pG0NfayruKWN2U44HNhCCa
        zQ5PHm2yT4u9Ursj5KZO1HVlbANe7bVd5YfXJ8yObOLbTm5mfmQDBARCXpX23D/RslKdlR
        KRT/7ydZBkLYlZLpnJzbf8KUch5LwM3S8Dl23MV+hx7UoTN5s414oXyWNQKx7h4Y314Uj5
        UXqPkbmYMp0pogQdhzeRQLlOwMXVbG+ne34Yyqv1rdAMqt2BwUxv6fsfw0TBNA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596015112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8B3mdGbWCwi5b7RBCFnp9w7c8RBaH7yHPDCKnZknLS4=;
        b=duuE+PA7atZC/i/EwryAHLHnin3wCvyNdNN32ccEvWpgwXuog88plh7FiEAsWYIixL+4pR
        Y5yRBNwLOOTYwMDQ==
To:     David Miller <davem@davemloft.net>
Cc:     richardcochran@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        grygorii.strashko@ti.com, ivan.khoronzhuk@linaro.org,
        zou_wei@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/9] ptp: Add generic header parsing function
In-Reply-To: <20200728.174718.450581528353482552.davem@davemloft.net>
References: <20200727090601.6500-1-kurt@linutronix.de> <20200728.174718.450581528353482552.davem@davemloft.net>
Date:   Wed, 29 Jul 2020 11:31:51 +0200
Message-ID: <87y2n2acqg.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Jul 28 2020, David Miller wrote:
> It looks like some mlxsw et al. issues wrt. which header is expected at
> skb->data when certain helper functions are invoked need to be resolved
> still.

Yes, the length check needs to be sorted out first. So, please don't
merge this version.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8hQgcACgkQeSpbgcuY
8KbbfxAAoy0PpKRS/O3EnbqM/q5gfZmPt65AsXIxvBFApJ+tPQ0c4SRUUFbEcQSj
zuXPwWBiDu7ephpOSkholndOK9GvejdUhNe49nUeU1JZe9ntxCRqhcFL/g1ZsRCM
U2F8FrBmwNWnE+vbqkJKgUMDDAOXrGi8IjSlQOW+Z+49ZTTfE2cBRbkXH8MTr05A
BhdS390TmB5z9RWrrSlz0tL5UKIiEgV9gGLHFFEaqN1i7LnF8/4oRbBp/sEuPIwo
PyytNUctpyXDoCcuznV2+f4lg1glshL+0aQJ4H60q62oLhh7TLDettBrKkV22S7s
SlahsdqQqETLUAuJf6QBo+TjK8pgMv63tyJfXJlvNZtLnIEPbt+UMUXaZz5EoPn2
LPdo/qJmdiLsDesgQbq0FwUxQpbxN5wttYk0aykRSzf4uQ8B8ijg1rbELSiv4s5X
oIICEdLRFQwLCWCUjyU723azSGHURhMF+h76NZhPEGzIeEG3efq9kX8Cb7bgjTOX
9NI5BMx9fm8pJJDrirQZkv8RqusGq2F7369QU1RZy7mCUnGLnPnV5t6uCbcypZKU
dpCRpf3TceejjutanyYD2UFgSoCekzst/fvaRY4eNA0sMNTZuHwSFzbl41po8slZ
aFf4p7lHuLzemMYkg1We22hsJ+hjxE+Ws6hwObr6Y71xvIC56G4=
=yIkL
-----END PGP SIGNATURE-----
--=-=-=--
