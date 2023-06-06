Return-Path: <netdev+bounces-8625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5383724E8A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6677C2810BA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E01294D7;
	Tue,  6 Jun 2023 21:13:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3FFFBED
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 21:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCA1C433D2;
	Tue,  6 Jun 2023 21:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686085995;
	bh=R04WYpn2Yn/2CI+p7yTj26c1Zcz5H3XWzXyGd969w1w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tOG3vGI9CgA0P3q+XPd+npFBCvAWDee15veR3ePiUB38NyTVaDsylmOE9W5kBD2dQ
	 KdI02sONG/xZUDqGgMumQBY3dj0HyWwo7pt0KjVTVPvFwWKgpUAc+7U2fiMClvgIt5
	 GWnngAINtxCsYptJG2NMhOpgHQKyPcWknASBOfY+UavKOYmnNpsbdZSeUrfntKgcFs
	 4p1id2yuXh+I3ymYAUvW9t2U0aC00+PczG7iDLXb3Il1lZl5bccEK/Gnb5EMMZEXp7
	 GaxLdL/4uRCFisAcGYJl5E9TYZ6fdjLaZXXw34kpddMRLQlv0q3vPZtq7m6sWKiQH0
	 vg4BKJMDC9TAw==
Date: Tue, 6 Jun 2023 14:13:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: <wei.fang@nxp.com>, <claudiu.manoil@nxp.com>, <vladimir.oltean@nxp.com>,
 <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: enetc: correct the indexes of highest and 2nd
 highest TCs
Message-ID: <20230606141314.7d82d9ad@kernel.org>
In-Reply-To: <ZH+MBdlRAybwqFo8@boxer>
References: <20230606084618.1126471-1-wei.fang@nxp.com>
	<ZH+MBdlRAybwqFo8@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jun 2023 21:41:57 +0200 Maciej Fijalkowski wrote:
> On Tue, Jun 06, 2023 at 04:46:18PM +0800, wei.fang@nxp.com wrote:
> > From: Wei Fang <wei.fang@nxp.com>  
> 
> if you are a sender then you could skip line above.

Git generates it because the From in the headers does not have the
names, just the email addr. It's better to keep it.

