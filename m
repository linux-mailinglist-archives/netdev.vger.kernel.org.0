Return-Path: <netdev+bounces-6634-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D781717276
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06A11C20DEB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2F5A2C;
	Wed, 31 May 2023 00:33:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26752A23
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E112C433EF;
	Wed, 31 May 2023 00:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685493210;
	bh=jDKf2BOhV0iXksWjHDTqHnclajRzaEijKxq3NDH0Gyw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=guEiyPG8h6wqvKgeFVqz8PMfI+7RLp937amHmy6Ku/hxYLs+5BX6RTVBQhIO9wJ+m
	 2AzOejGAx8vRyiDObgPhG6U7irxHXr/e6QXy3vzeZujrA+csI8MqIkWfvNANEEci/X
	 U2QSiPyV6qJu1nFkUA9BOS458eI/IBl8z0b3NN1XL1C+avh2dquQYVQgUjzE7uFFs3
	 QiMfOaNsC/T7hUonK1cQ1rOTkxmGqjkVjSfdOmWidKQiN5iVdc9z7d8ZYYgoxSttXL
	 Bj4BGSollvJ1iGvxtVGQa309s/iIRQwDflnvhcRED/321un5EEVaFYS/WyIMgOfWyq
	 7iBK6GF3zFkog==
Date: Tue, 30 May 2023 17:33:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alex Elder <alex.elder@linaro.org>
Cc: Bert Karwatzki <spasswolf@web.de>, Alex Elder <elder@linaro.org>, Simon
 Horman <simon.horman@corigine.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: ipa: Use the correct value for
 IPA_STATUS_SIZE
Message-ID: <20230530173329.0fba5ec5@kernel.org>
In-Reply-To: <694f1e23-23bb-e184-6262-bfe3641a4f43@linaro.org>
References: <7ae8af63b1254ab51d45c870e7942f0e3dc15b1e.camel@web.de>
	<ZHWhEiWtEC9VKOS1@corigine.com>
	<2b91165f667d3896a0aded39830905f62f725815.camel@web.de>
	<3c4d235d-8e49-61a2-a445-5d363962d3e7@linaro.org>
	<8d0e0272c80a594e7425ffcdd7714df7117edde5.camel@web.de>
	<f9ccdc27-7b5f-5894-46ab-84c1e1650d9f@linaro.org>
	<dcfb1ccd722af0e9c215c518ec2cd7a8602d2127.camel@web.de>
	<694f1e23-23bb-e184-6262-bfe3641a4f43@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 18:43:54 -0500 Alex Elder wrote:
> > IPA_STATUS_SIZE was introduced in commit b8dc7d0eea5a as a replacement
> > for the size of the removed struct ipa_status which had size
> > sizeof(__le32[8]). Use this value as IPA_STATUS_SIZE.  
> 
> If the network maintainers can deal with your patch, I'm
> OK with it.  David et al if you want something else, please
> say so.

It's not correctly formatted. There are headers in the email body.

