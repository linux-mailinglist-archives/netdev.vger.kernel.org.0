Return-Path: <netdev+bounces-1795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA096FF2C2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:26:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62B981C20E74
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DBAE17739;
	Thu, 11 May 2023 13:26:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D631F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:26:35 +0000 (UTC)
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54F812085
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:25:59 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id C588E1BF20A;
	Thu, 11 May 2023 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1683811552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l9PY7mDL1sv/OsaTXw+3WsDF8udRzPE8U0ChKI/wPEA=;
	b=nEuX5teov/t4DZnU63BblG8/qkD8FTzekFv6WvDZ+R+2pmagrv1wju1dlBrgBE0383LVSf
	Opvr3M38iV8NGZNvNnAnpsVyCjaHDx3H0KeHFMRtSFwDFtK9ZDo5V47BuedaqlOVzgmME4
	qnSr2CvE28sqi6YfzBj8B7ogJZjrr55qwXaJm41rMgTB9yT1Jydzt+49j5Ec9sNxzaNRb6
	TMfIZWbh6EfJFyYc/pl1YQn8SrDcY6VMmbzSTqRQZ/AaTKWvXk2HRmdjPYG4iXNA8qDEOm
	Icor4hA9uOrHR0SQIgKugTsK7YkoXyCZaWwlhYR+3bbTv+9pM91nkWpI6RnqtQ==
Date: Thu, 11 May 2023 15:25:50 +0200
From: =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
 maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add
 timestamp preferred choice property
Message-ID: <20230511152550.4de3da1f@kmaincent-XPS-13-7390>
In-Reply-To: <20230511131008.so5vfvnc3mrbfeh6@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-4-kory.maincent@bootlin.com>
	<20230412131421.3xeeahzp6dj46jit@skbuf>
	<20230412154446.23bf09cf@kmaincent-XPS-13-7390>
	<20230429174217.rawjgcxuyqs4agcf@skbuf>
	<20230502111043.2e8d48c9@kmaincent-XPS-13-7390>
	<20230511131008.so5vfvnc3mrbfeh6@skbuf>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 11 May 2023 16:10:08 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Tue, May 02, 2023 at 11:10:43AM +0200, K=C3=B6ry Maincent wrote:
> > If a future PHY, featured like this TI PHYTER, is supported in the futu=
re
> > the default timestamp will be the MAC and we won't be able to select the
> > PHY by default.
> > Another example is my case with the 88E151x PHY, on the Russell side wi=
th
> > the Macchiatobin board, the MAC is more precise, and in my side with a
> > custom board with macb MAC, the PHY is more precise. Be able to select =
the
> > prefer one from devicetree is convenient. =20
>=20
> If convenience is all that there is, I guess that's not a very strong
> argument for putting something in the device tree which couldn't have
> been handled by user space through an init script, and nothing would
> have been broken as a result of that.

The user may not and don't need to know which hardware timestamping is bett=
er.
He just want to use the best one by default without investigation and
benchmarking.
It is more related to the hardware design of the board which should be
described in the devicetree, don't you think? Of course it should not break
anything and if it does, well then let the user select it in userspace.
But if you really think my point is irrelevant then I will drop this featur=
e.

