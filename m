Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB052DBE4A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 11:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgLPKIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 05:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgLPKIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 05:08:22 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FACC061794;
        Wed, 16 Dec 2020 02:07:41 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CwrQw3zDXz9sRR;
        Wed, 16 Dec 2020 21:07:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1608113260;
        bh=eys2iDvQWXhlskfSyu0BqgYMhF4CxnhdAShc/4Mwwjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fxOqCzC72U5xcvOdVO58UtHgJYvf0kdbaMlI47QcxTGScuSbntwqE1GqtjIjUhSDR
         y2L0aragUYyrwy3MWj4kiYkSIPGuNqdRn+R11kEIXkGGmr7Zbiad1E4ay6f34uc6aR
         kkOQYpSNvGzDe2XKcO7JHfSLsg+LK2MpSr0OhSkn+gL3FzyNYYyBI4TA2W1aycfFuo
         NWT8iFuDmHsDrJo+Urbl8HJnYuo4HvYEAvTuJFIV5bOJXGxkNGKFSg2mD9WeiXxB1f
         ukJli8LrBZPMXWF5rMHdIaApFx3qRGDMix7CzY175aeR5r7UTewQuXpPPwCqRyAdzM
         QsFTRwetER4ag==
Date:   Wed, 16 Dec 2020 21:07:35 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Steven French <Steven.French@microsoft.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Cabrero <scabrero@suse.de>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: linux-next: build failure after merge of the
 net-next tree
Message-ID: <20201216210735.2893dd92@canb.auug.org.au>
In-Reply-To: <SN6PR2101MB1069AC2DC98C74F7C2A71EA3E4C59@SN6PR2101MB1069.namprd21.prod.outlook.com>
References: <SN6PR2101MB1069AC2DC98C74F7C2A71EA3E4C59@SN6PR2101MB1069.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/k=SOkQNbulSYBAiBWT9Iq=s";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/k=SOkQNbulSYBAiBWT9Iq=s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Wed, 16 Dec 2020 02:21:26 +0000 Steven French <Steven.French@microsoft.c=
om> wrote:
>
> I applied your patch to the tip of my tree (cifs-2.6.git for-next) -
> hopefully that makes it easier when I sent the PR in a day or two for
> cifs/smb3 changes.

I think you have just made your tree fail to build as nla_strscpy does
not exist in your tree ... Just remove that commit and tell Linus about
the necessary change and he can add it to the merge.

And, no, rebasing your tree in Linus', or even doing a merge with
Linus' tree is not really a reasonable option at this point.

--=20
Cheers,
Stephen Rothwell

--Sig_/k=SOkQNbulSYBAiBWT9Iq=s
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/Z3GcACgkQAVBC80lX
0GyD8AgAoca4Oa1T0GMS3kD+CbviFxAKIdMWbBq3KuREiX0WVk3NM0QoKjN55VNG
rXRqbyfamtKTJyfbXlY/mIY/kpH1TeM/+2uWxcTSgRN7GLJKdQ8B6u4apwaH7UEz
/gubxqAtc5nXglLKe29m5xzEMtv3YIpqbM/ghaq7av5nio8ldtxTPCvIzlQhu3v+
NSsgh1ckrARls/Iik2qqlF2mM+Z+/GPEGsFnVbtz7P4K2NhoH4f1qi7DIdtLH2j8
/oPFNzLeKenICyKFxKLS7R/va5AcSFK4f89ON4jpkd4xCv83th+fDoqdLsBSxMnt
pyKH//cAGzTT2W0SYvFRWQ7DDmay6Q==
=s4Tf
-----END PGP SIGNATURE-----

--Sig_/k=SOkQNbulSYBAiBWT9Iq=s--
