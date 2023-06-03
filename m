Return-Path: <netdev+bounces-7622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB10720E0A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01588281A74
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E2F7494;
	Sat,  3 Jun 2023 06:08:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C69259A
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 06:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D427C433EF;
	Sat,  3 Jun 2023 06:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685772520;
	bh=6C5Ad8Vs2W1sQLRUdPV2kmQSXkQ/J9DS/IHQjyCI7zY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IharSvm8QDTpSOxCcwfhSaUOg0a+3lJq+hKSr8VFk3VrfrETfKFzkX3hnPBBF+yD1
	 M9JmcSdp0JBupvYS41VEuHRKZ/YPRdDPuCKkcdGjOvM/ihczcwhwxg4W3br2ReyKys
	 aNAop1qjjB82xEyQ20kuKonCrwZ+XmUConKgk0vo+ZnomACYXXOD/Twp4l5RvNAHI5
	 fCrGsiSVGT7ai1mCANvGQc52iLbkKhpHjtE+1qYzII6/B3CiHBYhdCm1FH4zjVvHdu
	 dTqkor/Y1I4Rpt90PnjLoTVcsIchSQcOVmv81d8gEjLZlFRtn4MqTCigk/fOgjHmwb
	 AOcSsNrdMNqIw==
Date: Fri, 2 Jun 2023 23:08:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Amritha Nambiar <amritha.nambiar@intel.com>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
 davem@davemloft.net, sridhar.samudrala@intel.com
Subject: Re: [net-next/RFC PATCH v1 4/4] netdev-genl: Add support for
 exposing napi info from netdev
Message-ID: <20230602230839.64530697@kernel.org>
In-Reply-To: <ZHoPBYx2lZJ+i1LC@corigine.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
	<168564136118.7284.18138054610456895287.stgit@anambiarhost.jf.intel.com>
	<ZHoPBYx2lZJ+i1LC@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 2 Jun 2023 17:47:17 +0200 Simon Horman wrote:
> This feels like it should be two patches to me.
> Though it is not something I feel strongly about.

+1 I'd put the YAML and what's generated from it in one patch, 
and the hand-written code in another.

