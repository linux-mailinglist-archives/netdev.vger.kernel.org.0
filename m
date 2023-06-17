Return-Path: <netdev+bounces-11684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3BB0733EB5
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DFCD2818C8
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38B74C7E;
	Sat, 17 Jun 2023 06:28:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B0111C
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCB2C433C8;
	Sat, 17 Jun 2023 06:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686983311;
	bh=1v8XsSds2AENh5sRYYNo49hls3ex26v3/B0ncB1VCZU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hoFx6y8PVvbFWH2VKfmlGJNzmtHGvr88sZshrVFqGBZCq23s9qHycuonvYfjWcios
	 4PICKKiZthzSFvC4RjSwgw/eOEexjU3EOP9eh65vmZF7XjZ6tl7iKC/+prAf5gHKvi
	 XT0OLfbjOc+k9Ems0SPnqZe9LDwsNAbojOS30CCCD6SE1ZPQJ+0Cf+93bDEAc4F3ZJ
	 SCs6boWO32CaVNBJgovuufaZcMZGG/kb269y5Ro4lMjpuMzuJBgsiYoX7q4zm8SKDT
	 UxXOLLuVMD/72RissyWx2FZuHS+1yel7v6djETyS2GypbnAWh6G9lv1wkCjjkSdPVL
	 mmD3noE1yvA0g==
Date: Fri, 16 Jun 2023 23:28:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Keith
 Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, Boris Pismenny <boris.pismenny@gmail.com>
Subject: Re: [PATCH 4/4] net/tls: implement ->read_sock()
Message-ID: <20230616232830.4eec19c3@kernel.org>
In-Reply-To: <20230614062212.73288-5-hare@suse.de>
References: <20230614062212.73288-1-hare@suse.de>
	<20230614062212.73288-5-hare@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 08:22:12 +0200 Hannes Reinecke wrote:
> Implement ->read_sock() function for use with nvme-tcp.

please take tls_rx_reader_lock() :S
-- 
pw-bot: cr

