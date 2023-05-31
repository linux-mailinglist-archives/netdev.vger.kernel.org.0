Return-Path: <netdev+bounces-6816-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A2EA7184F5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:28:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0CE62814AF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B760416409;
	Wed, 31 May 2023 14:28:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D4014A9B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F035BC433EF;
	Wed, 31 May 2023 14:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685543323;
	bh=dmsku/PyJ1dbGSPcHj5Y9b7BGuOB5tka8lgRkNRcWSQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FUeAVLU2YddJZB+KBo+JH2Sfas+A7t0ItarvV4dAjPiX1GxKHIRgZr9UtaimU/I6W
	 YmyQ5HztyLVoJgMcSbrjfESa6/K3LwdeZmS6yqPN5FJAXEZGPIUREXuAn5Y0WIIT3G
	 +GsgUncu+SkHd9A7rnRSBVYNyH6CUoh+A/YRdULdWokHk8hTtkDM0tI13X7Wr/Fl6q
	 1T050993WaZZ5W0gPaU7zbxbGk2N6H33Fh74VJV1BR92dwLcIZd9JnPwPGDm7gIxXx
	 WMum8aL3n8GQn37oxf6Oty9y0G/gyN9rMlsitarSbazwR3w8tZm4K1z//lWyFyjPGs
	 mfnezplQVsKNQ==
Message-ID: <13135dfb-cf59-4711-ac63-a4384ab31873@kernel.org>
Date: Wed, 31 May 2023 08:28:42 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2-next v2 2/8] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Content-Language: en-US
To: Petr Machata <petrm@nvidia.com>,
 Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org,
 UNGLinuxDriver@microchip.com
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-2-9f38e688117e@microchip.com>
 <87leh75aek.fsf@nvidia.com> <20230531083141.ijtwsfxa3javczdf@DEN-LT-70577>
 <87o7m04tq5.fsf@nvidia.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <87o7m04tq5.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/23 5:26 AM, Petr Machata wrote:
> It doesn't make sense on its own, but it also does not get sent on its
> own, but together with the following patches. Its role is to set stage.
> 
> dcb_app_print_filtered() should first stop assuming the callback prints
> a colon. So you have one patch where the colon moves from the callback
> to _print_filtered(). That's a clean, behavior-neutral change that
> should be trivial to review. Then next patch introduces the callback.
> Which at that point should likewise be tidy, focused and easy to review,
> because it will only deal with the new callback.

agreed. code should evolve in a way that makes it easy to review.

