Return-Path: <netdev+bounces-7135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A960C71A395
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 632902817FA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E8634CEF;
	Thu,  1 Jun 2023 16:03:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691F4BA2F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB0AC433D2;
	Thu,  1 Jun 2023 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685635391;
	bh=g7Jl5yrwpXlNDhMxhubxbj3MMq91RwrWaao0HlEgncI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IW7dhn4BQ1nsKxaOjLM/rYG2xMimBeJkbyGd0kKInYao5NND70+CKY97V2zzYPy1y
	 LNchgIWLDuT8qoa59syvz0WsTifHSvzZOk8IeMuZE7z/TfpJ61+bdPjKcSOLVsAuFh
	 DaYIDJvIBiAnX9POMxzImDzLRzAuFe0iIhi8bpjgEVQMFUfpXllqRpfUfBAXiqeQ8H
	 o4f4/3VjXSH8Z1RmJn11c6Z+v+Nz5WeKonEgx3W80pOhkqIIFG/bj0+1vl13/2640b
	 ubgdEpabuU5kJ1YJH+URUgPIAVhR3KyyKTf8GwcoOE97ms0SGLc+VvHfT4cBKCBYte
	 jWV2IhkXRJovQ==
Date: Thu, 1 Jun 2023 09:03:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Justin Chen <justin.chen@broadcom.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, bcm-kernel-feedback-list@broadcom.com,
 florian.fainelli@broadcom.com, Daniil Tatianin <d-tatianin@yandex-team.ru>,
 Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <20230601090310.167e81b2@kernel.org>
In-Reply-To: <ZHi/aT6vxpdOryD8@corigine.com>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
	<ZHi/aT6vxpdOryD8@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 17:55:21 +0200 Simon Horman wrote:
> + Daniil Tatianin <d-tatianin@yandex-team.ru>, Andrew Lunn <andrew@lunn.ch>
>   as per ./scripts/get_maintainer.pl --git-min-percent 25 net/ethtool/ioctl.c

Sorry to chime in but always prefer running get_maintainer on the patch
rather than a file path. File path misses stuff like Fixes tags.
If it was up to me that option would have been removed :(

