Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6583C2C6E1D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgK1BR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731493AbgK1AeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 19:34:10 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A63C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 16:34:08 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4CjXXj0PQhz1rvmJ;
        Sat, 28 Nov 2020 01:33:24 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4CjXXh0851z1qqkq;
        Sat, 28 Nov 2020 01:33:24 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 65FD6VgjMIqC; Sat, 28 Nov 2020 01:33:20 +0100 (CET)
X-Auth-Info: CbqdffanYyCXc+WHPh1hCvPuib5PnQxoZEuiOcbs3Yk=
Received: from jawa (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sat, 28 Nov 2020 01:33:20 +0100 (CET)
Date:   Sat, 28 Nov 2020 01:33:10 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on
 i.MX28 SoC
Message-ID: <20201128013310.38ecf9c7@jawa>
In-Reply-To: <20201127192931.4arbxkttmpfcqpz5@skbuf>
References: <20201125232459.378-1-lukma@denx.de>
        <20201126123027.ocsykutucnhpmqbt@skbuf>
        <20201127003549.3753d64a@jawa>
        <20201127192931.4arbxkttmpfcqpz5@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/C5XR20=XBldsSQIYbre9gH9"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/C5XR20=XBldsSQIYbre9gH9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

> On Fri, Nov 27, 2020 at 12:35:49AM +0100, Lukasz Majewski wrote:
> > > > - The question regarding power management - at least for my use
> > > > case there is no need for runtime power management. The L2
> > > > switch shall work always at it connects other devices.
> > > >
> > > > - The FEC clock is also used for L2 switch management and
> > > > configuration (as the L2 switch is just in the same, large IP
> > > > block). For now I just keep it enabled so DSA code can use it.
> > > > It looks a bit problematic to export fec_enet_clk_enable() to be
> > > > reused on DSA code.
> > > >
> > > > Links:
> > > > [0] - "i.MX28 Applications Processor Reference Manual, Rev. 2,
> > > > 08/2013" [1] -
> > > > https://github.com/lmajewski/linux-imx28-l2switch/commit/e3c7a6eab7=
3401e021aef0070e1935a0dba84fb5
> > > > =20
> > >
> > > Disclaimer: I don't know the details of imx28, it's just now that
> > > I downloaded the reference manual to see what it's about.
> > >
> > > I would push back and say that the switch offers bridge
> > > acceleration for the FEC. =20
> >
> > Am I correct, that the "bridge acceleration" means in-hardware
> > support for L2 packet bridging?
> >
> > And without the switch IP block enabled one shall be able to have
> > software bridging in Linux in those two interfaces? =20
>=20
> So if the switch is bypassed through pin strapping of sx_ena, then the
> DMA0 would be connected to ENETC-MAC 0, DMA1 to ENET-MAC 1, and both
> these ports could be driven by the regular fec driver, am I right?
> This is how people use the imx28 with mainline linux right now, no?

Yes. This is the current situation.

>=20
> When the sx_ena signal enables the switch, a hardware accelerator
> appears between the DMA engine and the same MACs.

Yes.

> But that DMA engine
> is still compatible with the expectations of the fec driver.

Yes. This is why I can reuse the fec_main.c driver.

> And the
> MACs still belong to the FEC.

Yes. I do use mdio communication between MAC and PHYs (by re-using FEC
driver code).

> So, at the end of the day, there are
> still 2 FEC interfaces.

I'm a bit confused with the above sentence. What do you mean "2 FEC
interfaces"?

There is the FEC driver (fec_main.c), which handles DMA0
management/setup and communication with PHYs via MDIO (the FEC driver
setups MDIO, link type, speed, provides info if link is up or down).

>=20
> Where I was going is that from a user's perspective, it would be
> natural to have the exact same view of the system in both cases, aka
> still two network interfaces for MAC 0 and MAC 1, they still function
> in the same way (i.e. you can still ping through them) but with the
> additional ability to do hardware-accelerating bridging, if the MAC 0
> and MAC 1 network interfaces are put under the same bridge.

At least on imx287 ENET-MAC1 needs MAC0 to be configured:
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freesca=
le/fec_main.c#L2065

Those two MACs are not fully independent - functionality of MAC1 is
reduced.

>=20
> Currently, you do not offer that, at all.
> You split the MTIP switch configuration between DSA and the FEC
> driver. But you are still not exposing networking-capable net devices
> for MAC 0 and MAC 1.

As fair as I can tell (and tested it) - it is possible to bring up
"lan{12}" interfaces with `ip l s lan{12}`

I would also like to set the static table with altering the FDB switch
memory/configuration. Access to it seems natural via lan{12} interfaces
(but of course could be possible from eth0).

Yes, I can send data via eth0 as I don't add tag to it. As pointed out
by Andrew - I could use VLAN tags (or play with FEC_FFEN register).

> You still do I/O through the DMA engine.

Yes, DMA0 is connected to MTIP port0 (input port from the imx28 SoC).
The MTIP port1 -> MAC0 and port2 -> MAC1

>=20
> So why use DSA at all? What benefit does it bring you? Why not do the
> entire switch configuration from within FEC, or a separate driver very
> closely related to it?

Mine rationale to use DSA and FEC:
- Make as little changes to FEC as possible

- Provide separate driver to allow programming FDB, MDB, VLAN setup.
  This seems straightforward as MTIP has separate memory region (from
  FEC) for switch configuration, statistics, learning, static table
  programming. What is even more bizarre FEC and MTIP have the same 8
  registers (with different base address and +4 offset :-) ) as
  interface to handle DMA0 transfers.

- According to MTIP description from NXP documentation, there is a
  separate register for frame forwarding, so it _shall_ also fit into
  DSA.


For me it would be enough to have:

- lan{12} - so I could enable/disable it on demand (control when switch
  ports are passing or not packets).

- Use standard net tools (like bridge) to setup FDB/MDB, vlan=20

- Read statistics from MTIP ports (all of them)

- I can use lan1 (bridged or not) to send data outside. It would be
  also correct to use eth0.

I'm for the most pragmatic (and simple) solution, which fulfill above
requirements.

>=20
> > > The fact that the bridge acceleration is provided by a
> > > different vendor and requires access to an extra set of register
> > > blocks is immaterial. =20
> >
> > Am I correct that you mean not important above (i.e. immaterial =3D=3D
> > not important)? =20
>=20
> Yes, sorry if that was not clear.

Ok. I was just not sure.

>=20
> > > To qualify as a DSA switch, you need to have
> > > indirect networking I/O through a different network interface.
> > > You do not have that. =20
> >
> > I do have eth0 (DMA0) -> MoreThanIP switch port 0 input
> > 			 |
> > 			 |----> switch port1 -> ENET-MAC0
> > 			 |
> > 			 |----> switch port2 -> ENET-MAC1 =20
>=20
> The whole point of DSA is to intercept traffic from a different and
> completely unaware network interface, parse a tag, and masquerade the
> packet as though it came on a different, virtual, network interface
> corresponding to the switch. DSA offers this service so that:
> - any switch works with any host Ethernet controller
> - all vendors use the same mechanism and do not reinvent the same
> wheel The last part is especially relevant. Just grep net/core/ for
> "dsa" and be amazed at the number of hacks there. DSA can justify
> that only by scale. Aka "we have hardware that works this way, and
> doesn't work any other way. And lots of it".

That is why I wanted to use FEC as "fixed-link" interface, so large
portion of it would be disabled (e.g. the ENET-MAC management for eth0).

>=20
> That being said, in your case, the network interface is not unaware of
> the switch at all.=20

Unfortunately, you are right here. FEC, MTIP, ENET-MAC are very closely
coupled.

> Come on, you need to put the (allegedly) switch's
> MAC in promiscuous mode, from the "DSA master" driver! Hardware
> resource ownership is very DSA-unlike in the imx28/vybrid model, it
> seems. This is a very big deal.

Ok.

>=20
> And there is no tag to parse. You have a switch with a DMA engine
> which is a priori known to be register-compatible with the DMA engine
> used for plain FEC interfaces. It's not like you have a switch that
> can be connected via MII to anything and everything. Force forwarding
> is done via writing a register, again very much unlike DSA, and
> retrieving the source port on RX is up in the air.

Yes. You are correct here.

>=20
> > > What I would do is I would expand the fec driver into
> > > something that, on capable SoCs, detects bridging of the ENET_MAC0
> > > and ENETC_MAC1 ports and configures the switch accordingly to
> > > offload that in a seamless manner for the user. =20
> >
> > Do you propose to catch some kind of notification when user calls:
> >
> > ip link add name br0 type bridge; ip link set br0 up;
> > ip link set lan1 up; ip link set lan2 up;
> > ip link set lan1 master br0; ip link set lan2 master br0;
> > bridge link
> >
> > And then configure the FEC driver to use this L2 switch driver? =20
>=20
> Yes, that can be summarized as:
> One option to get this upstream would be to transform fec into a
> switchdev driver, or to create a mtip switchdev driver that shares a
> lot of code with the fec driver. The correct tool for code sharing is
> EXPORT_SYMBOL_GPL, not DSA.

One more note - at least for imx28 you can have L2 switch or FEC, not
both.

Considering the above - you would recommend using the switchdev
framework for MTIP?

>=20
> > > This would also solve your
> > > power management issues, since the entire Ethernet block would be
> > > handled by a single driver. DSA is a complication you do not need.
> > > Convince me otherwise. =20
> >
> > From what I see the MoreThanIP IP block looks like a "typical" L2
> > switch (like lan9xxx), with VLAN tagging support, static and
> > dynamic tables, forcing the packet to be passed to port [*],
> > congestion management, switch input buffer, priority of
> > packets/queues, broadcast, multicast, port snooping, and even
> > IEEE1588 timestamps.
> >
> > Seems like a lot of useful features. =20
>=20
> I did not say that it is not a typical switch, or that it doesn't have
> useful features. I said that DSA does not help you. Adding a
> DSA_TAG_PROTO_NONE driver in 2020 is a no-go all around.

Ok. I see.

>=20
> > The differences from "normal" DSA switches:
> >
> > 1. It uses mapped memory (for its register space) for
> > configuration/statistics gathering (instead of e.g. SPI, I2C) =20
>=20
> Nope, that's not a difference.

Ok.

>=20
> > 2. The TAG is not appended to the frame outgoing from the "master"
> > FEC port - it can be setup when DMA transfers packet to MTIP switch
> > internal buffer. =20
>=20
> That is a difference indeed. Since DSA switches are isolated from
> their host interface, and there has been a traditional separation at
> the MAC-to-MAC layer (or MAC-to-PHY-to-PHY-to-MAC in weird cases), the
> routing information is passed in-band via a header in the packet. The
> host interface has no idea that this header exists, it is just traffic
> as usual. The whole DSA infrastructure is built around intercepting
> and decoding that.
>=20

Ok, so MTIP doesn't provide the core functionality for DSA out of the
box.

> > Note:
> >
> > [*] - The same situation is in the VF610 and IMX28:
> > The ESW_FFEN register - Bit 0 -> FEN
> >
> > "When set, the next frame received from port 0 (the local DMA port)
> > is forwarded to the ports defined in FD. The bit resets to zero
> > automatically when one frame from port 0 has been processed by the
> > switch (i.e. has been read from the port 0 input buffer; see Figure
> > 32-1). Therefore, the bit must be set again as necessary. See also
> > Section 32.5.8.2, "Forced Forwarding" for a description."
> >
> > (Of course the "Section 32.5.8.2" is not available)
> >
> >
> > According to above the "tag" (engress port) is set when DMA
> > transfers the packet to input MTIP buffer. This shall allow force
> > forwarding as we can setup this bit when we normally append tag in
> > the network stack.
> >
> > I will investigate this issue - and check the port separation. If it
> > works then DSA (or switchdev) shall be used? =20
>=20
> Source port identification and individual egress port addressing are
> things that should behave absolutely the same regardless of whether
> you have a DSA or a pure switchdev driver. I don't think that this is
> clear enough to you. DSA with DSA_TAG_PROTO_NONE is not the shortcut
> you're looking for. Please take a look at
> Documentation/networking/switchdev.rst, it explains pretty clearly
> that a switchdev port must still expose the same interface as any
> other net device.

Ok.

>=20
> > (A side question - DSA uses switchdev, so when one shall use
> > switchdev standalone?) =20
>=20
> Short answer: if the system-side packet I/O interface is Ethernet and
> the hardware ownership is clearly delineated at the boundary of that
> Ethernet port, then it should be DSA, otherwise it shouldn't.
>=20

Ok.

> But nonetheless, this raises a fundamental question, and I'll indulge
> in attempting to answer it more comprehensively.
>=20
> You seem to be tapping into an idea which has been circulating for a
> while,

There was only NXP's legacy driver (2.6.35), which added support for
MTIP switch. Up till then nobody tried to upstream it....

I do have this driver forward ported to v4.19.y:
https://github.com/lmajewski/linux-imx28-l2switch/commits/master

but its long term maintenance is at best awkward.

> and which can be also found in
> Documentation/networking/dsa/dsa.rst:
>=20
> -----------------------------[cut here]-----------------------------
>=20
> TODO
> =3D=3D=3D=3D
>=20
> Making SWITCHDEV and DSA converge towards an unified codebase
> -------------------------------------------------------------
>=20
> SWITCHDEV properly takes care of abstracting the networking stack
> with offload capable hardware, but does not enforce a strict switch
> device driver model. On the other DSA enforces a fairly strict device
> driver model, and deals with most of the switch specific. At some
> point we should envision a merger between these two subsystems and
> get the best of both worlds.
>=20
> -----------------------------[cut here]-----------------------------
>=20
> IMO this is never going to happen, nor should it.
> To unify DSA and switchdev would mean to force plain switchdev drivers
> to have a stricter separation between the control path and the data
> path, a la DSA. So, just like DSA has separate drivers for the switch,
> the tagging protocol and for the DSA master, plain switchdev would
> need a separate driver too for the DMA/rings/queues, or whatever, of
> the switch (the piece of code that implements the NAPI instance). That
> driver would need to:
> (a) expose a net device for the DMA interface
> (b) fake a DSA tag that gets added by the DMA net device, just to be
>     later removed by the switchdev net device.

I also thought for a while to append "tag" byte ind tag_*.c file and
then parse it (+ write FEC_FFEN) and remove when the DMA transfer is
setup. But this seems to be not the "simple solution".

> This is just for compatibility with what DSA _needs_ to do to drive
> hardware that was _designed_ to work that way, and where the
> _hardware_ adds that tag. But non-DSA drivers don't need any of that,
> nor does it really help them in any way! So why should we model
> things this way? I don't think the lines between plain switchdev and
> DSA are blurry at all. And especially not in this case. You should
> not have a networking interface registered to the system for DMA-0 at
> all, just for MAC-0 and MAC-1.

Indeed, there should be lan1, lan2 (and no eth0). Unfortunately, now
FEC driver without switch enabled (on e.g. imx28) only exports eth0.


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/C5XR20=XBldsSQIYbre9gH9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAl/BmsYACgkQAR8vZIA0
zr1WJwf+MntUPlF2soLM14MdRFY7Bzg7fzwyypNvyFcg6SeRp1dTRDhW44V9BCEn
eReLkMVpka1elfuMVrExeMb1TABXfItpwDtaz8H3YHK1x5NvT4ssYOCXB/DdMUFA
X2LdlqGwTM9FIDhXgy4X4FP/vUBwXrWbufxNatakxKcscEeZrNXgYuudcbyYmjKI
9kfN6i8lvRBTzbGCWE599rY67Bj36UKZy11UbAqa5I5qynRe5gLRImA42K3adrLf
v582i9sn/FifaOnLP2Sl1/BHytg6gigjmMMnS3Q5r6xVv7d/mALZeoDBrcbk3LyE
JuGZwiUa8yHWR5ive21aGG+UTX7kKw==
=ypGI
-----END PGP SIGNATURE-----

--Sig_/C5XR20=XBldsSQIYbre9gH9--
