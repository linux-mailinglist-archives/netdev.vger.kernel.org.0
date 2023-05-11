Return-Path: <netdev+bounces-1780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62EE56FF20E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEDF4281778
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD411F949;
	Thu, 11 May 2023 13:02:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973881F920;
	Thu, 11 May 2023 13:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118FCC433EF;
	Thu, 11 May 2023 13:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683810166;
	bh=sObupSBzb6+eT7mNGEYA+/hRNFw5wsaKlXnIuXNdy5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RVOxalxkdwWrBjsYtYQ63s8k4vRZeetzuFLnCMMHu1l0y0ku45V4sccWrs4OJQwAk
	 LpGEsHjsMtazblUDgC8p5QNJYhlL5GSeHHV7xEH6uobuf1Sob4AmsyY7ydWyFOFmF4
	 Ogm8fTNhFKSMY78NRIS7gA402JKCWYWjG5CXUrY+u2uBNJ1jelcBodP6QAg/A96qp6
	 fswiO8lT4akdh8cyxsrmt6JqBjsQAPHJA68Cp02g12kXPHPEGaR8ZVnU0Ov2Si3fPx
	 lp64m4VTugJJZawoVLcq39THtEu7kYXA9PmVoLesE8scVoho3FPrvNgXSozd+hskpz
	 fpeEctTo/Dp6w==
Date: Thu, 11 May 2023 15:02:40 +0200
From: Simon Horman <horms@kernel.org>
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Shenwei Wang <shenwei.wang@nxp.com>, Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	imx@lists.linux.dev
Subject: Re: [PATCH v2 net 1/1] net: fec: using the standard return codes
 when xdp xmit errors
Message-ID: <ZFzncPmqH1C5HAyf@kernel.org>
References: <20230510200523.1352951-1-shenwei.wang@nxp.com>
 <20230511072452.umskoyoscsxgmcoo@soft-dev3-1>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511072452.umskoyoscsxgmcoo@soft-dev3-1>

On Thu, May 11, 2023 at 09:24:52AM +0200, Horatiu Vultur wrote:
> The 05/10/2023 15:05, Shenwei Wang wrote:
> > 
> > This patch standardizes the inconsistent return values for unsuccessful
> > XDP transmits by using standardized error codes (-EBUSY or -ENOMEM).
> 
> Shouldn't this patch target net-next instead of net? As Simon suggested
> here [1], or maybe is just me who misunderstood that part.
> Also it is nice to CC people who comment at your previous patches in all
> the next versions.
> 
> Just a small thing, if there is only 1 patch in the series, you don't
> need to add 1/1 in the subject.
> 
> [1] https://lore.kernel.org/netdev/20230509193845.1090040-1-shenwei.wang@nxp.com/T/#m4b6b21c75512391496294fc78db2fbdf687f1381
> 
> > 
> > Fixes: 26312c685ae0 ("net: fec: correct the counting of XDP sent frames")

Hi Shenwei,

I agree with Horatiu.

Also, this is not a fix. So it should not have a Fixes tag.

After waiting for further review please send a v3 with these updates.

pw-bot: cr

