Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54378223648
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgGQHyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 03:54:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38828 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgGQHyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 03:54:10 -0400
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594972448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GfOuu1y/yDM23nPkfSir6Mn6kETT/LtX5j4cXzo7Xmk=;
        b=QWtGGoYEPKpoeg9uM7uGVLA7zDGUSSLvOXOYaN9lNgSWdtun+Rz4gPab11sUWrXeG1UARU
        QZrhqas4qQR8eDv1WawlmSbzI1Nj13fbZSap0NbPqiZnruLSzYAGhtYtwRdStVCB/bLw4i
        IOAxCMnJ02ErecN/GVq4s0ADkvV6tfBYjrRM2MYXRJZjTAZmYzPwPbaBrh4n2o1EQJT5pb
        d3HDQiCEgxtWb6G3N3AcOHy7kphKT4cXhnaNyV/3M1y/2MwY+cxoaSWW3VNBBJaRfdIY3P
        hTVT0Rj440q/06Ur2ky+VKD8BlbDkO4gdcQuA1Pt9EibLDmWeFEaaLGoSePxjQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594972448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GfOuu1y/yDM23nPkfSir6Mn6kETT/LtX5j4cXzo7Xmk=;
        b=nt37ipTp6t6Rvopy6uGzjrx7ebCRGta7UaOO62X6+s8NT4YLLJijsqbJIS04xEIMQb52xw
        JISytNW14BT6TODA==
To:     Richard Cochran <richardcochran@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
In-Reply-To: <20200716204832.GA1385@hoboy>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk> <20200716204832.GA1385@hoboy>
Date:   Fri, 17 Jul 2020 09:54:07 +0200
Message-ID: <874kq6mva8.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Richard,

On Thu Jul 16 2020, Richard Cochran wrote:
> On Tue, Jul 14, 2020 at 05:26:28PM +0100, Russell King wrote:
>
>> With this driver, there appears to be three instances of a ptp_header()
>> like function in the kernel - I think that ought to become a helper in
>> generic code.
>
> Yes, and the hellcreek DSA driver will add yet another.  I'll be happy
> if patches that refactor everything this magically appear!

I'll post the next version of the hellcreek DSA driver probably next
week. I can include a generic ptp_header() function if you like in that
patch series. But, where to put it? ptp core or maybe ptp_classify?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8RWR8ACgkQeSpbgcuY
8KbdHBAAtGJXFcJ73r+Z2cay6NF7xtLTpDelTFoHWhHui11D2lHX0K3omXSs8yNW
6nV/K92auzTxcns0ZL9KzFpLWkrMa/O1C5w+rK5skjl600/fNRUj5gF0B4uigwDU
Zn5ebE4XaBTYjsVGTdwQhb2ZAiBC+KY3ckCzTxDDnWjLVSV5NM44hykYGKPuKI1A
4aMP9y/+ez2L3nmZXBY0pBCFvSsjiCg2u5hC6awl6wvaaQ74OzD3tA114jzpcrCi
mb7EBMQoD2TyMd2L1IRv1bkA0DjnrP5gNho1mra+oHMxJF82GYYG2oqY+rlCyWGC
Cchsw5iutelrNIivScVOO77zK56BhsbaqoX2poLqp/0xDGy6NHK+Vv7nFFD+e00J
E1m8X/O2XcWu6+eaOswPlw5DvVT7kr6XTxYBAXTKn+TeB8sbCJzp0CziSCG8zR8K
G3W9ghJqdtpTHX4X/V7QOUYX11+ymnw4r/1KD2qn+J0GUv+QfJy2cb/cQLV+YkWV
N1DknQEXXZUrX5eWqVSEFuc4Vr/sqNcf69bwKB8imbEPb97r4+aBrxHxQ0v3+rUD
89k8ft72SAcqFCIq5840bzjnGP6bo0f67fqxznXs+3w1MW3im3lUWH5OispR/jly
hJPUSX6eN8W9TKec3/sFtlG77lXASMNwYEYigdvR+eog+vWccwU=
=CU20
-----END PGP SIGNATURE-----
--=-=-=--
