Return-Path: <netdev+bounces-10448-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DDC872E8CD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03E7428110C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D91E23C74;
	Tue, 13 Jun 2023 16:48:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE3833E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D8AC433D9;
	Tue, 13 Jun 2023 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686674915;
	bh=nl/W3Q5PKp3pIeKr90vfqNQelE8R4o1ky8sNp8iSBdI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BGWWMUFEO4rtvc6uP4WysvGT3WSjFKWdMdG0TziuBczr+XLjOOz7cCLgIDlR11Lyv
	 z9uk/y7gm+nllQERwxn0qYRM3Bj7mQYZ8JxLNleg9WDMnS3nct0j5XlozgGXhW/bQD
	 LydwUbkP7cZonUJgExyvJtuDgnQNW3Uu63uH4r4GtyTamXXMGs2BD9K+1sd1uFyOE+
	 fycckSmRBV0Jw31xCopn0j5siwDxuualTAbzi0ESaP7VtQyLD9hVJQfV0557TCqUO7
	 Y+U3u1vnRXnQVNZjWxdfdxfAnX9c35dOBPtkry4C+Y/U882ZYV2VwK3hHbgVZiEW+M
	 T8xBDk8BqsCtw==
Date: Tue, 13 Jun 2023 09:48:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: mkubecek@suse.cz, danieller@nvidia.com, netdev@vger.kernel.org,
 linux@armlinux.org.uk, andrew@lunn.ch
Subject: Re: [PATCH ethtool-next v2 2/2] cmis: report LOL / LOS / Tx Fault
Message-ID: <20230613094834.3b2740fc@kernel.org>
In-Reply-To: <ZIgbdYe289TsKhHi@shredder>
References: <20230613050507.1899596-1-kuba@kernel.org>
	<20230613050507.1899596-2-kuba@kernel.org>
	<ZIgbdYe289TsKhHi@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 13 Jun 2023 10:32:05 +0300 Ido Schimmel wrote:
> On Mon, Jun 12, 2023 at 10:05:07PM -0700, Jakub Kicinski wrote:
> > Report whether Loss of Lock, of Signal and Tx Faults were detected.
> > Print "None" in case no lane has the problem, and per-lane "Yes" /
> > "No" if at least one of the lanes reports true.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>

Thank you!

