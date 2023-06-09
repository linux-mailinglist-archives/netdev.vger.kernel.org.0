Return-Path: <netdev+bounces-9594-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F7C0729F9C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5921928198E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5D519E77;
	Fri,  9 Jun 2023 16:05:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590FF17757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:05:36 +0000 (UTC)
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Jun 2023 09:05:33 PDT
Received: from node.akkea.ca (li1434-30.members.linode.com [45.33.107.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505A835A3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:05:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by node.akkea.ca (Postfix) with ESMTP id D9E464E200E;
	Fri,  9 Jun 2023 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
	t=1686325588; bh=LAlFToPdxEjfDDOxau4rnrHY/5HdHkZYkM3bM6GWhss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=THoZhJEcLFt2yQ73IygMtJS0dPoRZd3dAhP/UOyicRHfbLJ4/p84ZPM8/XKpT2Pqo
	 lEd42rn5GK7ZprF77LPoUZq6OS2G0VK4gM8yHLai6M4MC4HSKjyeB6rdXWz0NueQCl
	 VTwjMQhUTvLaE7zbXY6OIf9/v2B5D0j/byHFwUsQ=
X-Virus-Scanned: Debian amavisd-new at mail.akkea.ca
Received: from node.akkea.ca ([127.0.0.1])
	by localhost (mail.akkea.ca [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6LidfUErIBoC; Fri,  9 Jun 2023 15:46:28 +0000 (UTC)
Received: from www.akkea.ca (localhost [127.0.0.1])
	by node.akkea.ca (Postfix) with ESMTP id 505664E200C;
	Fri,  9 Jun 2023 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
	t=1686325588; bh=LAlFToPdxEjfDDOxau4rnrHY/5HdHkZYkM3bM6GWhss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=THoZhJEcLFt2yQ73IygMtJS0dPoRZd3dAhP/UOyicRHfbLJ4/p84ZPM8/XKpT2Pqo
	 lEd42rn5GK7ZprF77LPoUZq6OS2G0VK4gM8yHLai6M4MC4HSKjyeB6rdXWz0NueQCl
	 VTwjMQhUTvLaE7zbXY6OIf9/v2B5D0j/byHFwUsQ=
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 09 Jun 2023 08:46:28 -0700
From: Angus Ainslie <angus@akkea.ca>
To: =?UTF-8?Q?J=C3=A9r=C3=B4me_Pouiller?= <jerome.pouiller@silabs.com>
Cc: Kalle Valo <kvalo@kernel.org>, Ganapathi Kondraju
 <ganapathi.kondraju@silabs.com>, Marek Vasut <marex@denx.de>,
 linux-wireless@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>,
 Amol Hanwate <amol.hanwate@silabs.com>, Jakub Kicinski <kuba@kernel.org>,
 Johannes Berg <johannes@sipsolutions.net>, Martin Fuzzey
 <martin.fuzzey@flowbird.group>, Martin Kepplinger <martink@posteo.de>,
 Narasimha Anumolu <narasimha.anumolu@silabs.com>, Sebastian Krzyszkowiak
 <sebastian.krzyszkowiak@puri.sm>, Shivanadam Gude
 <shivanadam.gude@silabs.com>, Siva Rebbagondla <siva8118@gmail.com>,
 Srinivas Chappidi <srinivas.chappidi@silabs.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
In-Reply-To: <3166282.5fSG56mABF@pc-42>
References: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
 <112376890.nniJfEyVGO@pc-42> <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
 <3166282.5fSG56mABF@pc-42>
Message-ID: <50ab38c7104b99277bca512ba8f59255@akkea.ca>
X-Sender: angus@akkea.ca
User-Agent: Roundcube Webmail/1.3.17
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jérôme,

On 2023-06-09 08:10, Jérôme Pouiller wrote:
> 
> You are talking about this driver[1] I assume?
> 
> [1]: https://github.com/SiliconLabs/RS911X-nLink-OSD
> 
> [...]
>> In the meantime, since RSI neglected this driver for years, what would
>> be the suggestion for people who are stuck with the RSI WiFi hardware?
> 
> Unfortunately, my only suggestion is to use the downstream driver we
> mentioned above.

That driver isn't really a solution as it rarely applies cleanly to 
recent kernels.

The lack of proper commit messages also makes the changes opaque.

Cheers
Angus

