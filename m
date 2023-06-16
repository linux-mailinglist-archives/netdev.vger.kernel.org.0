Return-Path: <netdev+bounces-11513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6280F733631
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8166B1C20FCF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A97D182D2;
	Fri, 16 Jun 2023 16:35:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3A68F59
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B831C433C8;
	Fri, 16 Jun 2023 16:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686933330;
	bh=9WHjM9VXrkjIaIufT08irEDtCWmEn429IWbU2+liu/I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Dvj+xlvBnJYF5gUspWYhy0sY6iy+C1Hkm0tbFteBUZwdW2O8oqiXSzrvwUhKbqYD3
	 rEUO3/zwf+vBcDJtdYLayYgsXYeo/0/xiZ/FGNdvd4OQ6RZeZq4rL2VEHQSe3CHeel
	 +dtmn0/Ym3AKwC91jMpZTN2bCspol7HmKpJqTHFgRMWDT10V2uhN6EuOqC7hwZQynM
	 Dy4yf8jqXTENaQYygKSt+ZtVzrqOKny5a31c2ADZZOrgBi1dgvUbc9hIFBgQMIhlYC
	 UjbOiVjab2jt6IYmDQ7YtnSELoKPqTpmotwrsIIZqSpFQnsEFRvzEL4osFM71IMQD3
	 GmYeAZRfxKmbA==
Date: Fri, 16 Jun 2023 09:35:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ganesh Babu <ganesh.babu@ekinops.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Message-ID: <20230616093529.21fe1a0b@kernel.org>
In-Reply-To: <PAZP264MB406423636D35E139C50BCD2BFC58A@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
References: <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
	<20230328191456.43d2222e@kernel.org>
	<PAZP264MB406414BA18689729DDE24F3DFC659@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
	<20230502085718.0551a86d@kernel.org>
	<20230502105820.2c27630d@hermes.local>
	<PAZP264MB4064D9406001EB75D768D0E7FC449@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
	<PAZP264MB406423636D35E139C50BCD2BFC58A@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jun 2023 09:52:44 +0000 Ganesh Babu wrote:
> I would appreciate any feedback or updates on the status of patch.
> Thank you for your attention, and I look forward to hearing from you soon.

You can try reposting with the commit format fixed after 6.5-rc1 is
released. Make sure the commit messages answers _all_ the questions
and concerns raised. Read this before posting:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

