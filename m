Return-Path: <netdev+bounces-8988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0A97267AF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C3E91C20E47
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB51238CB3;
	Wed,  7 Jun 2023 17:43:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1971772E;
	Wed,  7 Jun 2023 17:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBDCC433D2;
	Wed,  7 Jun 2023 17:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686159831;
	bh=pZcTVLLiIRL735nUNe2nRR+4NmAQlsIK40zLI6qlujk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=si6CZLulOOFQBwBLvCrGPujNsZgJJv/o7yK0rUP061dgsOcNkqrtpIFMXnEBrHssV
	 vksE/O1f8ba1i6P8FaMH41D2MBI2e1xzfrsocFKuRcY+AMFSq9ZOFyl+/+MohsfCjG
	 LqWncXg5pnJSlsfUnC2ECdCdDpRGn+RHw85Zv/C2FgSaKdbOieW5yf5iGQzeeqNG0+
	 EgudZmd16HbPkMVmNTjYX+F5Kft7RBWe7QP3bFHSY8yP/6vR8ayv/66yOEfriHqMYY
	 zZEZnav0PSAgb7IB+pG0bw7n8/vL/Rv1toWKRgHUfxqL7xOphTlctNJ0gQIuxMbdjy
	 gJD5Pw6uPfJUw==
Date: Wed, 7 Jun 2023 10:43:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Subject: Re: [PATCH v2 0/2] Add MHI Endpoint network driver
Message-ID: <20230607104350.03a51711@kernel.org>
In-Reply-To: <20230607171153.GA109456@thinkpad>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
	<20230607094922.43106896@kernel.org>
	<20230607171153.GA109456@thinkpad>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 22:41:53 +0530 Manivannan Sadhasivam wrote:
> > In any case, I'm opposed to reuse of the networking stack to talk
> > to firmware. It's a local device. The networking subsystem doesn't
> > have to cater to fake networks. Please carry:
> > 
> > Nacked-by: Jakub Kicinski <kuba@kernel.org>
> > 
> > if there are future submissions.  
> 
> Why shouldn't it be? With this kind of setup one could share the data connectivity
> available in the device with the host over IP tunneling. If the IP source in the
> device (like modem DSP) has no way to be shared with the host, then those IP
> packets could be tunneled through this interface for providing connectivity to
> the host.
> 
> I believe this is a common usecase among the PCIe based wireless endpoint
> devices.

We can handwave our way into many scenarios and terrible architectures.
I don't see any compelling reason to merge this.

