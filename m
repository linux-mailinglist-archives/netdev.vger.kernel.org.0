Return-Path: <netdev+bounces-1824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3DB06FF386
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0AD01C20F58
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44BF19E75;
	Thu, 11 May 2023 14:03:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31177369
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACD7C433D2;
	Thu, 11 May 2023 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683813811;
	bh=NvgptMXhoibVUzwMhVycsWLnIvK3fc/9CTGYWKNunNM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T2vpb78EXlrqTCLfdpy7FD2AruqhHuzlgr+rxt/4McJyAgp4jjUrdObAQWTHkFYN/
	 ak8q1lPAjB/dZ5msC10PFGQbxFfz5zqP+w2tFkw13wnj+WrJNRYdu0FFXXnFz3C7w/
	 FW5F96WWEkN+VJhqJ4yF17WdKwyjStqQ0eR0EzISDzxzMuWuUrsyg+35dCvtVSWuur
	 omqEGMbhrQ+w9wURS5faW9/pzGwRpaLqTsiQOHvYhUiV4jRliO7HK4dwQUASflE/wL
	 JfaU3ZyOa5WeEOwOhY5uqUIyzugJyZR/Xf19UkfPlD2TLTXU7692ZwleCUEzg3Bg5j
	 1r+JAhOFsn2ng==
Message-ID: <97dd1d05-cfc4-61aa-ac3e-cc1a662c63ed@kernel.org>
Date: Thu, 11 May 2023 16:03:24 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: cdns,macb: Add
 rx-watermark property
To: Pranavi Somisetty <pranavi.somisetty@amd.com>,
 nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, richardcochran@gmail.com, linux@armlinux.org.uk,
 palmer@dabbelt.com
Cc: git@amd.com, michal.simek@amd.com, harini.katakam@amd.com,
 radhey.shyam.pandey@amd.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
 <20230511071214.18611-2-pranavi.somisetty@amd.com>
Content-Language: en-US
From: Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20230511071214.18611-2-pranavi.somisetty@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/05/2023 09:12, Pranavi Somisetty wrote:
> watermark value is the minimum amount of packet data
> required to activate the forwarding process. The watermark
> implementation and maximum size is dependent on the device
> where Cadence MACB/GEM is used.
> 
> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>

Please use scripts/get_maintainers.pl to get a list of necessary people
and lists to CC.  It might happen, that command when run on an older
kernel, gives you outdated entries.  Therefore please be sure you base
your patches on recent Linux kernel.

You missed at least DT list (maybe more), so this won't be tested.
Please resend and include all necessary entries.

Best regards,
Krzysztof


