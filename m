Return-Path: <netdev+bounces-1833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5BA6FF3F4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76FB62817BB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2F31B909;
	Thu, 11 May 2023 14:22:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CFD1F956
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:22:17 +0000 (UTC)
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E978DDB1
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:22:06 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 309701BF207;
	Thu, 11 May 2023 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1683814925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7BT/h+GhA+TjJi2bqrorTD3gHZoZEzafY+JCxBTaES8=;
	b=HGaXkwBSpCepwo4ciWSQs0xA6URFVp4b7fhggeCkX8WAN5zt5b/j7MSYBnAavjmTRclkQ6
	FMZEpZxqv3I/cEEfUUAJZ1pXXoj0bGCoHck8Ze6Sg/UXS3NvTuP0MGGVQ14jROvq13OQTG
	hy2D+Ac0eONLq7CDrLW369FhcRxVq5QEhlfsbjMUwRjHvOSj4oQ8GMG+4nhRP9LnQYEng1
	R0ukOMNimbu5a/Ax4L69DG/e5/H47L+0kjo8HynJ0YIIIb8JZEq0wCm2jbGbtGDZFIChay
	nWIVOvbwfaY0pyHBYErtAf3QbgXBBtPrleixkML/6w+8E0o125SdXzDfc/IMtg==
Date: Thu, 11 May 2023 16:22:03 +0200
From: =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, glipus@gmail.com,
 maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
 richardcochran@gmail.com, gerhard@engleder-embedded.com,
 thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
 robh+dt@kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 3/5] dt-bindings: net: phy: add
 timestamp preferred choice property
Message-ID: <20230511162203.5e9ebcf4@kmaincent-XPS-13-7390>
In-Reply-To: <20230511135631.dzszb4zen26mtsqq@skbuf>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
	<20230406173308.401924-4-kory.maincent@bootlin.com>
	<20230412131421.3xeeahzp6dj46jit@skbuf>
	<20230412154446.23bf09cf@kmaincent-XPS-13-7390>
	<20230429174217.rawjgcxuyqs4agcf@skbuf>
	<20230502111043.2e8d48c9@kmaincent-XPS-13-7390>
	<20230511131008.so5vfvnc3mrbfeh6@skbuf>
	<20230511152550.4de3da1f@kmaincent-XPS-13-7390>
	<20230511135631.dzszb4zen26mtsqq@skbuf>
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

On Thu, 11 May 2023 16:56:31 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Thu, May 11, 2023 at 03:25:50PM +0200, K=C3=B6ry Maincent wrote:

>=20
> I guess the general rule of thumb is - if a functionality can live outside
> the kernel or of the device tree, it's probably better that it does.

Ok it is clearer to me. Thanks for your explanation! Then I will drop the
device tree parameter.

