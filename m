Return-Path: <netdev+bounces-3176-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83638705E31
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:38:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 403882812F4
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985CE17FF;
	Wed, 17 May 2023 03:38:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C08A17E0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A423C433EF;
	Wed, 17 May 2023 03:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684294717;
	bh=vht1TVOPwAXNcqVr525QamimhCThnaHZtxdMy/l4Kt0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c0Qq1wlacs6J9g9YaESXhj7H76YQwCkigal4tmFDQs7uk+OBjalHOoBsDe6I1t6JX
	 9Euu+QFLtTPHrhkTqzt3Vz6VAednqTVHzD83bLV5J4AMvb1I5Je75qpCvcmxhWHT5F
	 N+QQ+6TKc7G0iNko0dkLAv/uNK/UErgiIE0noGU8piBMdAqVd7FWz8pkPBAnT/2xRc
	 QCBUs7jB7VhWVP8ImfMP5PSrK3JBHslNFKu5iCvyLBl0LEDt6OvvI3QBJ9wqGaidIT
	 h4bnjMatT9eUPgWKvXVCn4RaEoqx5RakEF/2r5PNT0lbXzeFaMrCCBHHsjoSEJih0F
	 D20OBDvwQtb5A==
Date: Tue, 16 May 2023 20:38:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: netdev <netdev@vger.kernel.org>, Daniel Golle <daniel@makrotopia.org>
Subject: Re: Net related kernel panic caused by commit in
 next-20230512..next-20230515
Message-ID: <20230516203836.3ccfc734@kernel.org>
In-Reply-To: <58e55189-51b5-83c9-356c-90a20200cd01@arinc9.com>
References: <58e55189-51b5-83c9-356c-90a20200cd01@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 16 May 2023 17:42:44 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> I get a kernel panic on next-20230515 and next-20230516. next-20230512=20
> works fine. The panic log is attached.
>=20
> The device boots fine with CONFIG_NET disabled which made me think the=20
> netdev mailing list is the best place to report this.
>=20
> Tested on Bananapi BPI-R64 with this defconfig. The filesystem is=20
> Buildroot. The devicetree binary being fed to the bootloader is from=20
> next-20230515.
>=20
> https://github.com/arinc9/linux/commit/b4a048428ab6f380b4203598aa62635e21=
015095

Should be now fixed in net/main, by commit d6352dae0903 ("devlink: Fix
crash with CONFIG_NET_NS=3Dn")

