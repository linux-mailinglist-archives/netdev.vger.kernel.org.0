Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409CB307B1D
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhA1QhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:37:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36060 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbhA1Qgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:36:42 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611851760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cCkXezytlMBpgbEI/se8mQWEbQF6yu/Obce7Uy+IZAc=;
        b=IMt3H/Jq6RFwi01nYxx4boCTTNirgavcUSfVedqyftHhJSfSMo3BjCWFMf8tzetvZQg6ED
        WP8rK+x4V+OviULJmsAFSmLQVBkie5qBYKATVjZ4eZaognvvTMFoy6DR5uqlvHASCVc+Tn
        /ASSuOSD8dJ/sKtgCkI3kM1/LFn1ro6FKS3L0FlHxBz7+gqjSRZ5e+XaZGykeSl8vzDIN/
        yfrPZwj/a/oU/+IdxPYRMsif97rPIXs6kYOf1pxVATTgRicNpm/yFx6a1B+8EGvncnzopf
        QYinDVljrqHkOGNZ6QdOTw/c5qozLTymJihCgRi3MMpzBIMt+GWBczSkyFvkUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611851760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cCkXezytlMBpgbEI/se8mQWEbQF6yu/Obce7Uy+IZAc=;
        b=3FxwvRCGTRbt9kfmoYHMTHhtWsMA/r/di4Cw4Tqz1vDbXL83JHAeiojdTkELPut4Umq9bg
        GasMrRvf6DkoPNDg==
To:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Jan 28 [drivers/net/dsa/hirschmann/hellcreek_sw]
In-Reply-To: <677e11e9-573e-6459-8323-65fc32f213e7@infradead.org>
References: <20210128201131.608c16ee@canb.auug.org.au> <677e11e9-573e-6459-8323-65fc32f213e7@infradead.org>
Date:   Thu, 28 Jan 2021 17:35:58 +0100
Message-ID: <87o8h9qas1.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jan 28 2021, Randy Dunlap wrote:
> On 1/28/21 1:11 AM, Stephen Rothwell wrote:
>> Hi all,
>>=20
>> Changes since 20210127:
>>=20
>
>
> on i386:
>
> ERROR: modpost: "taprio_offload_get" [drivers/net/dsa/hirschmann/hellcree=
k_sw.ko] undefined!
> ERROR: modpost: "taprio_offload_free" [drivers/net/dsa/hirschmann/hellcre=
ek_sw.ko] undefined!
>
> Full randconfig file is attached.

Thanks for the config file. I've submitted a patch to fix it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmAS5+4ACgkQeSpbgcuY
8KZ5ShAAxcb9zdGrDElfmjSPsfBTQ9+yU96nez/uz1t8rkGGwhKvecs50j2hMEf5
X76jf+4gjXlZ2LXWlNsbTSGq1ay9X7U8ey4dauGF6O4utTnID5A93bAQgKcPBUN9
tijhXxCFWjmrn2SbOEDcS+OjjViapQSaOeojkSfxyN5O+jXLUPNbP6BDvOP+PoIc
Jniej8B03GBf3T9DcE2g9UwtIXfrR/DkMg/+57IjVIQT0vAxVs5nVH4Hs31MRLkS
DepRihC74QosuR3bw/w5SRduL3+K8bkC+BFdfudsDwVQxuXTlhVDuFa3LdPAQXg0
tw6ix5kljEgf8rBE3zEIHRIju/FMqogf01R24tyvbdL7GQQUoeHwZP4S1QlKKGh/
vKaE/ZQy4XJ9MvB5XrQdztUciElQ0swvi0SViGodcm4VuwWESWz2oo2ULQ0l7GX/
9AowpLsR1Lv0XIkc7+dLuF/+Ym4kk/4GlYiF+r8kb9F5c4ldtzyMP2Lo1hlYxlWw
x5vTn6vWnw9AKliZ7BKRhJa2SzO/hncKhgE5bhqe+SLgkc1jnvuq5OyIFXGX8eNY
RCNlV+pLE3hxd7lwHrN42l4VSrPplgASdHUYuq8a5nRYr1RApkkOG27deQ9k56s6
Ay1/1CKlQvPPNGvon/3uWPnY70PDQGswscWXbr8VaCDTsDk0MgI=
=brOp
-----END PGP SIGNATURE-----
--=-=-=--
