Return-Path: <netdev+bounces-6741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B0E717B71
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95D631C20E6C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5938C14E;
	Wed, 31 May 2023 09:11:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC9D7E1
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95457C433D2;
	Wed, 31 May 2023 09:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685524312;
	bh=dF+I5mL0Q8plAB+9FBUAtkmdRhndhxU6IkZbc2o3sws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BQ2n96TvBTG3hCT+uNITL88gMPQbauET5d0JhFouMdJLm6DTPns3uWRrHmVzAj285
	 qkaISQWcPp0oakWTUq0IDwOJbZ/gtMDLD3YlVZ3FFmmWPYzEVAyPlX8RL+/JB1Jqcs
	 wMZhJ7EVr2cG/b5Zf+oXw0cfyhjd8WAHkQUYH4eg4AkT54OPDQDGbwt1Am7U4X3hpF
	 Ln09x4i7u9txQKbpkgHQWBCIk8tscmrsMppq8hI67F7n4tqxykbeLJIkx6+h3OXot5
	 gbVhV5/PGMAaOKND+jGAQBCBVlDBcVz1iXzBElxYx1aTctYQoiAeICJTsx+KSo+kaa
	 dSZF3WVxo5y4g==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1q4Hs3-0000w0-Ip; Wed, 31 May 2023 11:11:56 +0200
Date: Wed, 31 May 2023 11:11:55 +0200
From: Johan Hovold <johan@kernel.org>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: Re: [PATCH 0/2] Bluetooth: fix bdaddr quirks
Message-ID: <ZHcPW2Utn4rQWIu5@hovoldconsulting.com>
References: <20230424133542.14383-1-johan+linaro@kernel.org>
 <ZHYHRW-9BN4n4pPs@hovoldconsulting.com>
 <CABBYNZ+ae5h-KdAKwvCRNyDPB3W4nzyuEBzPdw72-8DLb9BAsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZ+ae5h-KdAKwvCRNyDPB3W4nzyuEBzPdw72-8DLb9BAsw@mail.gmail.com>

On Tue, May 30, 2023 at 01:06:01PM -0700, Luiz Augusto von Dentz wrote:
> On Tue, May 30, 2023 at 7:25 AM Johan Hovold <johan@kernel.org> wrote:
> > On Mon, Apr 24, 2023 at 03:35:40PM +0200, Johan Hovold wrote:

> > > These patches fixes a couple of issues with the two bdaddr quirks:

> > Any further comments to this series, or can this one be merged for 6.5
> > now?
> 
> Looks like this was removed from Patchwork since it has passed 30 days
> without updates, could you please resend it so CI can pick it up and
> test it again.

Both series resent:

	https://lore.kernel.org/lkml/20230531085759.2803-1-johan+linaro@kernel.org/
	https://lore.kernel.org/lkml/20230531090424.3187-1-johan+linaro@kernel.org/

Getting both of these, or at least the first one, into 6.4 would of
course be even better.

Thanks.

Johan

