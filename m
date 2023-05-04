Return-Path: <netdev+bounces-457-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 502446F76EB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 714E71C21658
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D892C127;
	Thu,  4 May 2023 20:20:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C40156CD
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F98C433EF;
	Thu,  4 May 2023 20:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683231602;
	bh=/t6l1LC6nVpi0cfB8LI0t8hsEbE4BDH3MfapO5h+/TM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ld1oUD6YGmlaF3yDcVfvBXO111WZ5RSc1iLeFvYlfM6AbrKoYpAg7TYQJdNKxF+B0
	 YWzsBjWdW7919DXXYl2/eIukm6v+QTrkGkqMnLMn1gBPwnj54bcF27y6/TiyC/2UqS
	 vfQ/cT859h1gut6dUOHmARDK19P8agWr346epKeBQCcw+6qhY+4D3Bym1S7xosl5au
	 hLTPuxZ5PNkBVOYUDR4Dm4RPa4s4IxNywYuKm9bUkRj45cm4FTfHiyksEzqOAlNQhs
	 6/KQIYFWaHySY15hhK/y5OCtFKGCH11QAJSUQBXpjd/9Sqqf0EUcNEG2De3p+qHuMc
	 JrZfEb2o+w6Vg==
Date: Thu, 4 May 2023 13:20:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
 netdev@vger.kernel.org, alex.williamson@redhat.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 shannon.nelson@amd.com, drivers@pensando.io
Subject: Re: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO
 driver
Message-ID: <20230504132001.32b72926@kernel.org>
In-Reply-To: <ZFPq0xdDWKYFDcTz@nvidia.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
	<20230422010642.60720-3-brett.creeley@amd.com>
	<ZFPq0xdDWKYFDcTz@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 14:26:43 -0300 Jason Gunthorpe wrote:
> This indenting scheme is not kernel style. I generally suggest people
> run their code through clang-format and go through and take most of
> the changes. Most of what it sugges for this series is good
> 
> This GNU style of left aligning the function name should not be
> in the kernel.

FTR that's not a kernel-wide rule. Please scope your coding style
suggestions to your subsystem, you may confuse people.

