Return-Path: <netdev+bounces-11263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D406732524
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EA30281598
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE4762F;
	Fri, 16 Jun 2023 02:19:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F05627
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A1DC433C8;
	Fri, 16 Jun 2023 02:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686881972;
	bh=C6BZkAdFImXa0obp4bUZcgWjLoHJ21TXKfNo+GFl8WA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oTKCLIsnS2CCY4C+BfxmPEiDrPu2wnk3C3XrjP2PgTXg4/wTsFgzCTcOKnlLu4PbU
	 xAISmpmNl5YDLaQdP/ZtPzXGEbrta7Vdqw2p3m1TmUBGut4cUFLSzxZJQYDCT88vhl
	 Lqvh0aRJWor6cnl5R/BJM6ne7mqr/9obkcstkK/mpoQGghbdV0BrLKjuG+f2uqtphD
	 cbIRerLYjreCeLq0lHruAdOmT6IOuh3hlAroKwp9nvgV0TK/BC/WcZ1cTXtyn+HPO+
	 YCrjkhlTVmWtrVmrq1V9ikN4Li+bgRueuiRPQhOSbFsXmO5SuB0DCg2MCGUJ4iBkgG
	 8F/KXSMN5ajPA==
Date: Thu, 15 Jun 2023 19:19:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
 rust-for-linux@vger.kernel.org, aliceryhl@google.com, andrew@lunn.ch
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <20230615191931.4e4751ac@kernel.org>
In-Reply-To: <CANiq72nLV-BiXerGhhs+c6yeKk478vO_mKxMa=Za83=HbqQk-w@mail.gmail.com>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
	<20230614230128.199724bd@kernel.org>
	<CANiq72nLV-BiXerGhhs+c6yeKk478vO_mKxMa=Za83=HbqQk-w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Jun 2023 10:58:50 +0200 Miguel Ojeda wrote:
> On Thu, Jun 15, 2023 at 8:01=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> =
wrote:
> > I was hoping someone from the Rust side is going to review this.
> > We try to review stuff within 48h at netdev, and there's no review :S =
=20
>=20
> I think the version number got reset, but Tomonori had a couple
> versions on the rust-for-linux@vger list [2][3].
>=20
> Andrew Lunn was taking a look, and there were some other comments going o=
n, too.
>=20
> The email threading is broken in [2][3], though, so it may be easiest
> to use a query like "f:lunn" [4] to find those.
>=20
> [2] https://lore.kernel.org/rust-for-linux/01010188843258ec-552cca54-4849=
-4424-b671-7a5bf9b8651a-000000@us-west-2.amazonses.com/
> [3] https://lore.kernel.org/rust-for-linux/01010188a42d5244-fffbd047-446b=
-4cbf-8a62-9c036d177276-000000@us-west-2.amazonses.com/
> [4] https://lore.kernel.org/rust-for-linux/?q=3Df%3Alunn
>=20
> > My immediate instinct is that I'd rather not merge toy implementations
> > unless someone within the netdev community can vouch for the code. =20
>=20
> Yes, in general, the goal is that maintainers actually understand what
> is getting merged, get involved, etc. So patch submitters of Rust
> code, at this time, should be expected/ready to explain Rust if
> needed. We can also help from the Rust subsystem side on that.
>=20
> But, yeah, knowledgeable people should review the code.

All sounds pretty reasonable, thanks for the pointers.

TBH I was hoping that the code will be more like reading "modern C++"
for a C developer. I can't understand much of what's going on.

Taking an example of what I have randomly on the screen as I'm writing
this email:

+    /// Updates TX stats.
+    pub fn set_tx_stats(&mut self, packets: u64, bytes: u64, errors: u64, =
dropped: u64) {
+        // SAFETY: We have exclusive access to the `rtnl_link_stats64`, so=
 writing to it is okay.
+        unsafe {
+            let inner =3D Opaque::get(&self.0);
+            (*inner).tx_packets =3D packets;
+            (*inner).tx_bytes =3D bytes;
+            (*inner).tx_errors =3D errors;
+            (*inner).tx_dropped =3D dropped;
+        }
+    }

What is this supposed to be doing? Who needs to _set_ unrelated
statistics from a function call? Yet no reviewer is complaining
which either means I don't understand, or people aren't really=20
paying attention :(

> > You seem to create a rust/net/ directory without adding anything
> > to MAINTAINERS. Are we building a parallel directory structure?
> > Are the maintainers also different? =20
>=20
> The plan is to split the `kernel` crate and move the files to their
> proper subsystems if the experiment goes well.

I see.

> But, indeed, it is best if a `F:` entry is added wherever you think it
> is best. Some subsystems may just add it to their entry (e.g. KUnit
> wants to do that). Others may decide to split the Rust part into
> another entry, so that maintainers may be a subset (or a different set
> -- sometimes this could be done, for instance, if a new maintainer
> shows up that wants to take care of the Rust abstractions).

I think F: would work for us.

Are there success stories in any subsystem for getting a driver for
real HW supported? I think the best way to focus the effort would be=20
to set a target on a relatively simple device.

Actually Andrew is interested, and PHY drivers seem relatively simple..
/me runs away

