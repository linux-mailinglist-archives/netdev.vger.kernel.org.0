Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB1B4AF9E0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiBISWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiBISWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:22:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776F6C0613C9;
        Wed,  9 Feb 2022 10:22:57 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644430974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A86IBeeLUSrWGQ06+Ga1gd252D1ZKm4v5y6HcJDp4gc=;
        b=NjhPDVKNu3q7zNIPAbO+9JO+JYLbwPbMxylaMclZr7OtpkTIFzS4vUBT3O7RHaL8qA3R64
        7KSJ/hfa+XIWxy7AWTE1XErauo4hfNKqscphhz/e53XOjU6JDUgc4VAtF2uxPDcAB2IiJK
        DNDFSLcxpjED/Ip0fv6aEcc+5+w5ck3ttF/mt9WfgGnk7ikTUBJeflrh7FDwpOocHXXw/s
        00jN5dMSUtphwbglgnqnRNLUNzDomwrkqRIEcv6vexJVQeyiZ4wA5DyjTOye+WPALZhwBk
        SJvvI+qZi0NeVHzBBmVy4GZt8UQpfy6NhLO52RIfPSmx7b6E/42olDXTUJS+Mw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644430974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A86IBeeLUSrWGQ06+Ga1gd252D1ZKm4v5y6HcJDp4gc=;
        b=7belRedt8Nsd8BWn7/JW4Opy7hSjI57EpyXJqZbf8xl2cdFuRoUwEjDD3wJVzyXOh7U6N4
        BhG10VGadnCm4HAg==
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vinschen@redhat.com" <vinschen@redhat.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-02-07
In-Reply-To: <699b8636cafcfa82a99cf290e3cffbab91b6afbb.camel@intel.com>
References: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
 <20220208211305.47dc605f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87sfssv4nj.fsf@kurt>
 <699b8636cafcfa82a99cf290e3cffbab91b6afbb.camel@intel.com>
Date:   Wed, 09 Feb 2022 19:22:53 +0100
Message-ID: <877da32936.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed Feb 09 2022, Anthony L. Nguyen wrote:
> On Wed, 2022-02-09 at 09:13 +0100, Kurt Kanzenbach wrote:
>> Hi Tony,
>>=20
>> On Tue Feb 08 2022, Jakub Kicinski wrote:
>> > On Mon,=C2=A0 7 Feb 2022 15:32:44 -0800 Tony Nguyen wrote:
>> > > Corinna Vinschen says:
>> > >=20
>> > > Fix the kernel warning "Missing unregister, handled but fix
>> > > driver"
>> > > when running, e.g.,
>> > >=20
>> > > =C2=A0 $ ethtool -G eth0 rx 1024
>> > >=20
>> > > on igc.=C2=A0 Remove memset hack from igb and align igb code to igc.
>> >=20
>> > Why -next?
>
> As the original submission was targeting -next, I carried that forward.
> Since the warning said it was handled, I thought it was ok to go there.
>
>> Can we get these patches into net, please? The mentioned igc problem
>> exists on v5.15-LTS too.
>
> I'll follow the igc patch and submit a request to stable when it hits
> Linus' tree.

OK, thanks!

> For igb, as it sounds like things are working, just not
> with the preferred method, so I don't plan on sending that to stable.
> Or is there an issue there that this patch needs to go to stable as
> well?

igb is fine, as it uses the memset() approach.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmIEBn0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgvkhD/sEUO6Gfy/o4//6cn3b/MU4zBBqew/c
AWoQPoLcDhN8v6zgeva6ZFBw/mQjBS1af2V2iY5PZp13iO8xz2dMtmdYOT0i9zzD
M3/spGJir+kbEP8iHkYkZaLuBw7OuMS20xS40LAmDwOE5i22Ho779ZxbI8WTj1xP
ibuOjwnwSye7sE7+fmsoRV0KXsnvW7Zz2jqq8fY78l+ODLyDLCzgySKKIFzCaLmf
K1pi2MZVdDzoIb9ilk/EYfODxapKfUn53+gwEmuRtfH5aB4bwhqKua+HOlHz4IkT
c+ZuhGDn2S/FsFlgR0K4068vWl6U6PgQQXtrFU9i4FatLDcXZC6A8yGLYXCxDgYN
YJ+ERt0Aju9KCK3f165IxOexisYBA6zsJXGpDRQSQg/URxv4zQyzMEjKxpqUBqbX
mT4rID6IXZY+roCBeW2GjHhIHg4XwBGK0Ba0lB049aqorcdm3qsBZsDIriyRu2ty
up7A/x5zBNjF/ZgqZ9bYtIWWx0DF5/faFsJ8wNr6tFw+QR5671M6XeZrEOPzKuGJ
xRf7B33ZX91gwk1/bfGAdkxmqxOwIraU8GFEzXlxkyKv4sOoogH25pVA9KaqSXeR
g88lFglPwzNoAvMODN0hlIrXZ+Ut8WqbTtkeuZy8ZwhZUvGGXPGQp0RA0Au07A5S
zy4UnivtentrtQ==
=Qbx6
-----END PGP SIGNATURE-----
--=-=-=--
