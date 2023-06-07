Return-Path: <netdev+bounces-8674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6556725282
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:45:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BB2A1C20C9D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DF47EE;
	Wed,  7 Jun 2023 03:45:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADAD7C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40975C4339B;
	Wed,  7 Jun 2023 03:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686109502;
	bh=23b85ddF74DRpHqNGxTgfBMNcy0hEkGn39jASt7LXGY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KozwMzbBcxqF3yspohCRX5N5zMV5Za8U22w+oHAcz4yDr/yx1eMfv3Zq40lwSaijF
	 x0eJyRdVwKLJ5NPv9mpvUfstSDXmaXlFVfo34sWCVZGru8tfdtocvayA4TeNF9Idp9
	 UyUJaAe2AgbYmC4GdN/M3yHcRS3KEZ79wX8Oe5mQV0F5bXNFUWoWC8zS5WELlJj4Dj
	 obSKgYeqc9TnlFJn/AMk5GftaUWN2PwejIPzl3Z2Tyd2ZANoYWY7TGLx4enOa1SO9U
	 GoyaGShdEoxet7hftBuqRs9b9NwWeZs0dDCSJDgrh48NEQnUJO8oyI1tmKgKo6XNim
	 D7EnPd94tiBww==
Date: Tue, 6 Jun 2023 20:45:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com, florian.fainelli@broadcom.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v6 3/6] net: bcmasp: Add support for ASP2.0
 Ethernet controller
Message-ID: <20230606204500.04083bd8@kernel.org>
In-Reply-To: <024a6733-f552-c538-2b59-26058c750d66@broadcom.com>
References: <1685657551-38291-1-git-send-email-justin.chen@broadcom.com>
	<1685657551-38291-4-git-send-email-justin.chen@broadcom.com>
	<20230602235859.79042ff0@kernel.org>
	<956dc20f-386c-f4fe-b827-1a749ee8af02@broadcom.com>
	<20230606171605.3c20ae79@kernel.org>
	<8601be87-4bcb-8e6b-5124-1c63150c7c40@broadcom.com>
	<20230606185453.582d3831@kernel.org>
	<024a6733-f552-c538-2b59-26058c750d66@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 19:33:13 -0700 Justin Chen wrote:
> >> Not netdevs per se, but packets can be redirected to an offload
> >> co-processor.  
> > 
> > How is the redirecting configured?
> 
> Through filters that can be programmed by the Host cpu or co-processor.

How are the filter programmed by the host (in terms of user API)?

