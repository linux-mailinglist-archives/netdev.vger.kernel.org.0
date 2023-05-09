Return-Path: <netdev+bounces-1182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FEEE6FC82D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 523DE281331
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7254E182DB;
	Tue,  9 May 2023 13:45:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922596116
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76013C433EF;
	Tue,  9 May 2023 13:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683639930;
	bh=zEUVAoHrpVYYSxcWbL+KScVMBrzScmaR4gXa7ee18JE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dvcKgDSvHpZi0y+H0co8lb+3gdpMGgzkj+DIdtzJ0I4W7WVPG9nrwfFI4DIfnX9W0
	 rA9GvzBNvWjdJxc4ofBHIguzHNSpH+inyFreBsq/aB1PVN6coHzJchaIonom5DZw9S
	 cQCdyQIgo73QdFE1toqiBLZhnE6bt4fq8Tllz/vw9eo+y1DelqVm53IfKj/Ud4uqZX
	 fTCs07S0csUxzZ56Qq6ML0YZVLPuPWbUphAXDEvx1lAlNnAyGfLyTaD7//z4u9//wq
	 0d6PSVZ1fF6/C0Yo9/dYvDdgrcK7OKXGlv6M40XC3uEyYa47cox6esy5euWBX5zcib
	 Ov89a5Y0BL0xg==
Date: Tue, 9 May 2023 16:45:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: pcs: xpcs: fix incorrect number of interfaces
Message-ID: <20230509134525.GO38143@unreal>
References: <E1pwLr2-001Ms2-3d@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwLr2-001Ms2-3d@rmk-PC.armlinux.org.uk>

On Tue, May 09, 2023 at 12:50:04PM +0100, Russell King (Oracle) wrote:
> In synopsys_xpcs_compat[], the DW_XPCS_2500BASEX entry was setting
> the number of interfaces using the xpcs_2500basex_features array
> rather than xpcs_2500basex_interfaces. This causes us to overflow
> the array of interfaces. Fix this.
> 
> Fixes: f27abde3042a ("net: pcs: add 2500BASEX support for Intel mGbE controller")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/pcs/pcs-xpcs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

