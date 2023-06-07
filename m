Return-Path: <netdev+bounces-8995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A502F72683A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D67BD1C20D8F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B72438CDE;
	Wed,  7 Jun 2023 18:15:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B12C34D75
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 18:15:47 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EA62135;
	Wed,  7 Jun 2023 11:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=rwP8NTNH2Q6n+MZ4JXwJhAX1XWocWHZPOYyXpdS4lqo=; b=PU0wKnZrtgQMRYj6qfniT+fCgX
	EZoZx2Xq7hCpCJj4j5OyMiAswAY8aXr9hpojQ3NQbAOXAcMDl0FPospMxECWN+XHfScyVUWulkU7S
	gxPn4MDtiHw/sQAgSq07hylEU+Aims6XtAZozTokdfVNfzxMTZ9Yg6HfTBW6DbzeTgAU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q6xf2-00FB1U-1k; Wed, 07 Jun 2023 20:13:32 +0200
Date: Wed, 7 Jun 2023 20:13:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	loic.poulain@linaro.org
Subject: Re: [PATCH v2 0/2] Add MHI Endpoint network driver
Message-ID: <eb4b45ab-1f51-47e9-a286-a9e26461ebed@lunn.ch>
References: <20230607152427.108607-1-manivannan.sadhasivam@linaro.org>
 <20230607094922.43106896@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607094922.43106896@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 09:49:22AM -0700, Jakub Kicinski wrote:
> On Wed,  7 Jun 2023 20:54:25 +0530 Manivannan Sadhasivam wrote:
> > This series adds a network driver for the Modem Host Interface (MHI) endpoint
> > devices that provides network interfaces to the PCIe based Qualcomm endpoint
> > devices supporting MHI bus (like Modems). This driver allows the MHI endpoint
> > devices to establish IP communication with the host machines (x86, ARM64) over
> > MHI bus.
> > 
> > On the host side, the existing mhi_net driver provides the network connectivity
> > to the host.
> 
> Why are you posting the next version before the discussion on the
> previous one concluded? :|
> 
> In any case, I'm opposed to reuse of the networking stack to talk
> to firmware. It's a local device. The networking subsystem doesn't
> have to cater to fake networks. Please carry:
> 
> Nacked-by: Jakub Kicinski <kuba@kernel.org>

Remote Processor Messaging (rpmsg) Framework does seem to be what is
supposed to be used for these sorts of situations. Not that i know
much about it.

     Andrew

