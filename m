Return-Path: <netdev+bounces-1983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B736FFD73
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C01C01C21090
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F8B18C18;
	Thu, 11 May 2023 23:45:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DAF3FDF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8F1C433EF;
	Thu, 11 May 2023 23:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683848714;
	bh=mi+RppI1xPmKTuMJIR8MHZyivO+TPEPXVXYn9BuiJNM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YOsg8sLbAEyqUi+M6RiOL9dwZTneV6pqytvd9+LLW/w0jNoQKFYVtTaxgqn1uq5R/
	 skEg0rUpjI6zE/3Te/f0C7cldLtjFrMperZoQ2pyMHQ3OzmKmm2k0+6VavA3TRtvwC
	 bS3pUeQN88xDrZkEurhFV5VmUsowHg7AxYaebgC4t/JlNux75NugxSOwRVYvQdM+2t
	 aw8aD1mH23rwAgOB+52XxEQBSPS9t6+dih2EaX9C6kEc7EF/VNYFlF3emepng2Y7La
	 fFugA0gmN0y1N0j58bwNRC1UiRGA2VVDlvY54uINV5mI605myzMBPtEkMVL+CevGmC
	 UWmFefNtyGJGQ==
Date: Thu, 11 May 2023 16:45:12 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev
 <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, kvalo@kernel.org, Johannes Berg
 <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: exclude wireless drivers from netdev
Message-ID: <20230511164512.0cbf3940@kernel.org>
In-Reply-To: <639C8EA4-1F6E-42BE-8F04-E4A753A6EFFC@holtmann.org>
References: <20230511160310.979113-1-kuba@kernel.org>
	<639C8EA4-1F6E-42BE-8F04-E4A753A6EFFC@holtmann.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 11 May 2023 18:50:15 +0200 Marcel Holtmann wrote:
> I didn=E2=80=99t know such an option existed,

Same, I was looking for something unrelated in MAINTAINERS yesterday:
https://lore.kernel.org/all/20230511020204.910178-1-kuba@kernel.org/
and I noticed the X: entries in Documentation :)

> can we do the same for Bluetooth?

SG, I'll give folks a couple of days to object to this one,=20
and it goes thru send a similar one for Bluetooth.

