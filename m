Return-Path: <netdev+bounces-1856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B46A56FF532
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC3B91C20E41
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:55:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3F236D;
	Thu, 11 May 2023 14:55:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E49629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAFAC433EF;
	Thu, 11 May 2023 14:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683816934;
	bh=TWVGAxdHC0hEH9C5Zgy4ygLuKrZWu81JJ74/YHgVR/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UJo4LBA/AyV+tsgQfyOtA5TItg8VVAfeGU147YVCYktv7zP3scUD4pdlG3RrSpyOu
	 l4kzUWwucf6OgfJ4VCBZS2Kd0yQKlwLwUBesVPZpgktWhlytQXYe4n/TGBgue8kcr7
	 j00zitPSAyvxzEGxdGTAY5vbcVzUI1EthNmkstuMvxlqp+sBm7qTVliE8R3/ZnKl5T
	 BIgKgUnuUeQTReoioNroLla9Ofa1/YLxSYwP++n+61x75W5dyrdTQyyZlYRDp8p72Z
	 GgHO8+bBXLct6fQntES+MB/xrpqzM9TbXKItw0W1R6UnuOtnRxnMNfwNWMLmoGxTHl
	 yehTU+ByqseiQ==
Date: Thu, 11 May 2023 07:55:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>, Vadim
 Fedorenko <vadfed@meta.com>, Jonathan Lemon <jonathan.lemon@gmail.com>,
 Paolo Abeni <pabeni@redhat.com>, "Olech, Milena" <milena.olech@intel.com>,
 "Michalik, Michal" <michal.michalik@intel.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
 <mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
 <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230511075532.6de7381c@kernel.org>
In-Reply-To: <ZFygo47TtTdb8IQa@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-2-vadfed@meta.com>
	<ZFOe1sMFtAOwSXuO@nanopsycho>
	<20230504142451.4828bbb5@kernel.org>
	<ZFTap8tIHWdbzGwp@nanopsycho>
	<MN2PR11MB4664357BAEC609040CF480C69B749@MN2PR11MB4664.namprd11.prod.outlook.com>
	<ZFygo47TtTdb8IQa@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 10:00:35 +0200 Jiri Pirko wrote:
>> It seems the name and type is needed. Without type generation scripts fails.
>> For now fixed with having only name/type on subset attributes.  
> 
> Okay. Jakub, any idea why "type" is needed here?

I don't remember.

