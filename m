Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB9723C92D
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 11:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgHEJak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 05:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbgHEJ3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 05:29:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DE8C06174A
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 02:29:41 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596619773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqL2+weFPW+fq5wCweTElsLWtgRo3rjxw3iNaHES5O0=;
        b=k5SgIgEtld+27EoxZX7SZZqMmp3J0qfv6gE5/mqVmiqyL8qNW/dEQ+annmDOIiQxSKYjHm
        YrQZK0LnTBITKd4aNyVxK9befirl+DuNcpmlj1iXEX0UhXrXyTCwMxWShotRVvX8ZbUW5L
        wIPmA4MCg+0yeoKPzmQoe5GiWMNtBE/Jc4uXXYQ7CY51hhb4wKA6DZ/1Jky83AA/s5JV+w
        raPb5HDfSGny2XeduaGzx1h4mR49Ekl1egODOSzXxLBO1brIGOMbXHei9g8HaEjOe7U72X
        dM35fUqc5WbAcETiOMwWq6D1E/bRXj/cvK4zxn5Ye7F0BXAeWm9VCU/7l20HXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596619773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqL2+weFPW+fq5wCweTElsLWtgRo3rjxw3iNaHES5O0=;
        b=pFnNW+3Kj2UtWtHGyzUOkuS9W6t2uuvFD78O8MfolEDzZHBPvNM5C74GQ9lCFXJ5gzV///
        N8i9eW63jbsWZkBQ==
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
In-Reply-To: <20200804231429.GW1551@shell.armlinux.org.uk>
References: <20200730080048.32553-1-kurt@linutronix.de> <20200730080048.32553-2-kurt@linutronix.de> <87lfj1gvgq.fsf@mellanox.com> <87pn8c0zid.fsf@kurt> <09f58c4f-dec5-ebd1-3352-f2e240ddcbe5@ti.com> <20200804210759.GU1551@shell.armlinux.org.uk> <45130ed9-7429-f1cd-653b-64417d5a93aa@ti.com> <20200804214448.GV1551@shell.armlinux.org.uk> <8f1945a4-33a2-5576-2948-aee5141f83f6@ti.com> <20200804231429.GW1551@shell.armlinux.org.uk>
Date:   Wed, 05 Aug 2020 11:29:32 +0200
Message-ID: <875z9x1lvn.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Aug 05 2020, Russell King - ARM Linux admin wrote:
> On Wed, Aug 05, 2020 at 01:04:31AM +0300, Grygorii Strashko wrote:
>> On 05/08/2020 00:44, Russell King - ARM Linux admin wrote:
>> > On Wed, Aug 05, 2020 at 12:34:47AM +0300, Grygorii Strashko wrote:
>> > > On 05/08/2020 00:07, Russell King - ARM Linux admin wrote:
>> > > > On Tue, Aug 04, 2020 at 11:56:12PM +0300, Grygorii Strashko wrote:
>> > > > >=20
>> > > > >=20
>> > > > > On 31/07/2020 13:06, Kurt Kanzenbach wrote:
>> > > > > > On Thu Jul 30 2020, Petr Machata wrote:
>> > > > > > > Kurt Kanzenbach <kurt@linutronix.de> writes:
>> > > > > > >=20
>> > > > > > > > @@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const s=
truct sk_buff *skb)
>> > > > > > > >     }
>> > > > > > > >     EXPORT_SYMBOL_GPL(ptp_classify_raw);
>> > > > > > > > +struct ptp_header *ptp_parse_header(struct sk_buff *skb, =
unsigned int type)
>> > > > > > > > +{
>> > > > > > > > +	u8 *data =3D skb_mac_header(skb);
>> > > > > > > > +	u8 *ptr =3D data;
>> > > > > > >=20
>> > > > > > > One of the "data" and "ptr" variables is superfluous.
>> > > > > >=20
>> > > > > > Yeah. Can be shortened to u8 *ptr =3D skb_mac_header(skb);
>> > > > >=20
>> > > > > Actually usage of skb_mac_header(skb) breaks CPTS RX time-stampi=
ng on
>> > > > > am571x platform PATCH 6.
>> > > > >=20
>> > > > > The CPSW RX timestamp requested after full packet put in SKB, but
>> > > > > before calling eth_type_trans().
>> > > > >=20
>> > > > > So, skb->data pints on Eth header, but skb_mac_header() return g=
arbage.
>> > > > >=20
>> > > > > Below diff fixes it for me.
>> > > >=20
>> > > > However, that's likely to break everyone else.
>> > > >=20
>> > > > For example, anyone calling this from the mii_timestamper rxtstamp=
()
>> > > > method, the skb will have been classified with the MAC header push=
ed
>> > > > and restored, so skb->data points at the network header.
>> > > >=20
>> > > > Your change means that ptp_parse_header() expects the MAC header to
>> > > > also be pushed.
>> > > >=20
>> > > > Is it possible to adjust CPTS?
>> > > >=20
>> > > > Looking at:
>> > > > drivers/net/ethernet/ti/cpsw.c... yes.
>> > > > drivers/net/ethernet/ti/cpsw_new.c... yes.
>> > > > drivers/net/ethernet/ti/netcp_core.c... unclear.
>> > > >=20
>> > > > If not, maybe cpts should remain unconverted - I don't see any rea=
son
>> > > > to provide a generic function for one user.
>> > > >=20
>> > >=20
>> > > Could it be an option to pass "u8 *ptr" instead of "const struct sk_=
buff *skb" as
>> > > input parameter to ptp_parse_header()?
>> >=20
>> > It needs to read from the buffer, and in order to do that, it needs to
>> > validate that the buffer contains sufficient data.  So, at minimum it
>> > needs to be a pointer and size of valid data.
>> >=20
>> > I was thinking about suggesting that as a core function, with a wrapper
>> > for the existing interface.
>> >=20
>>=20
>> Then length can be added.
>
> Actually, it needs more than that, because skb->data..skb->len already
> may contain the eth header or may not.
>
>> Otherwise not only CPTS can't benefit from this new API, but also
>> drivers like oki-semi/pch_gbe/pch_gbe_main.c -> pch_ptp_match()
>
> Again, this looks like it can be solved easily by swapping the position
> of these two calls:
>
>                         pch_rx_timestamp(adapter, skb);
>
>                         skb->protocol =3D eth_type_trans(skb, netdev);
>
>> or have to two have two APIs (name?).
>>=20
>> ptp_parse_header1(struct sk_buff *skb, unsigned int type)
>> {
>> 	u8 *data =3D skb_mac_header(skb);
>>=20
>> ptp_parse_header2(struct sk_buff *skb, unsigned int type)
>> {
>> 	u8 *data =3D skb->data;
>>=20
>> everything else is the same.
>
> Actually, I really don't think we want 99% of users doing:
>
> 	hdr =3D ptp_parse_header(skb_mac_header(skb), skb->data, skb->len, type)
>
> or
>
> 	hdr =3D ptp_parse_header(skb_mac_header(skb), skb->data + skb->len, type=
);
>
> because that is what it will take, and this is starting to look
> really very horrid.

True.

>
> So, I repeat my question again: can netcp_core.c be adjusted to
> ensure that the skb mac header field is correctly set by calling
> eth_type_trans() prior to calling the rx hooks?  The other two
> cpts cases look easy to change, and the oki-semi also looks the
> same.

I think it's possible to adjust the netcp core. So, the time stamping is
done via

 gbe_rxhook() -> gbe_rxtstamp() -> cpts_rx_timestamp()

The hooks are called in netcp_process_one_rx_packet(). So, moving
eth_type_trans() before executing the hooks should work. Only one hook
is registered.

What do you think about it?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8qe/wACgkQeSpbgcuY
8Kataw/9FDfZaYk11Wya3uAllKmm/wHiksAv3quK//F26UB/0MwmRPgllDmP/OM9
bwJnB3fAsveYATW8idsXjTaZYU4n++jF9ROPBaD5aF0549+mJQBK/7Lbvx1koLaa
Hio/cvZTAqA86/nj7VPqM1GvajLqT2zgc8fn/in7lnlKnJwI8T8k1fHDAqead2FE
q4RrSIhgtCbwgXj7Pk4cMJR0RVqnsu+3ULfEaLl2gWPVhj68AE9sPvi3WMHpdCpg
pidWbiUOTJTykbAvS6jbUbmCruvQZag0C3KJbLHNhIXdiNNk93bjH0xcFH00yRJi
lH+AIJv3gl3XUw1cIDdVQ7DJ3d4v7mhre7Gyb0IahVQlHrBaBU+ROaf9vzgGsVAy
S2h0jGfWCWUmRWfCenIX6dbu4yUeB+u7XU8wVM1VnWbPmJC+NexsTca+uvmxbKW3
ruUc0Ph0BnzK4OWCv0/1SRSsaQoIHfhSUFx7XmAVAwWD8oHCn4au9qd8bySePzi1
rIRIpE0L1y/ISQzLQclo7HZvyj1mL2dMY3GZ3rBhLZsvWWKysH9bjNCzWjaeTn4i
KN87Fq/w2fl99ekDjCdyXJyXTDI2oLaHkhwOhg7rl0iJDLuZEpcmZPRYgzZpfXI6
40qfLWbfaPS5y5sdK6nIvJLNfU8Z5KUELSy2C+pbj0c83X1qUXk=
=ADwt
-----END PGP SIGNATURE-----
--=-=-=--
