Return-Path: <netdev+bounces-8837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE1B725F5C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 575B81C20E15
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B063445C;
	Wed,  7 Jun 2023 12:28:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4234443
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:28:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260641BDD;
	Wed,  7 Jun 2023 05:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=vxfTgYTvjR4vsAsLPKP9hbUFFvdO+Zok6LWfAdaicIg=; b=SSAAPddHZLuJBrekKRW6gfcc6u
	kOxdHDKm/ctCPmObxy9qDVRIXmnYXyvn8H0v8svQKEP8biL+dtKir/K0APW0DagJ84EiaEAR/MAYu
	5WaGRZUaATym8UIazJyEDaiqgh97HJ7WOvjXn97ECYkKzjhRvisGMSPuXlGpyQdDkH74=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q6sH6-00F90C-Ul; Wed, 07 Jun 2023 14:28:28 +0200
Date: Wed, 7 Jun 2023 14:28:28 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add MHI Endpoint network driver
Message-ID: <15c88e23-9a7f-4a8f-8337-8ab9d2485a18@lunn.ch>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <c769c95d-e8cb-4cf6-a41a-9bef5a786bb1@lunn.ch>
 <20230607065652.GA5025@thinkpad>
 <CAMZdPi-xJAj_eFvosVTmSzA99m3eYhrwoKPfBk-qH87yZzNupQ@mail.gmail.com>
 <20230607074118.GD5025@thinkpad>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607074118.GD5025@thinkpad>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > Yes, so there is already a drivers/net/wwan directory for this, in
> > which there are drivers for control and data path, that together
> > represent a given 'wwan' (modem) entity. So the generic mhi_net could
> > be moved there, but the point is AFAIU, that MHI, despite his name, is
> > not (more) used only for modem, but as a generic memory sharing based
> > transport protocol, such as virtio. It would then not be necessarily
> > true that a peripheral exposing MHI net channel is actually a modem?
> > 
> 
> Agree, mhi_*_net drivers can be used by non-modem devices too as long as they
> support MHI protocol.

O.K. I was just trying to avoid cluttering up the directory. But if
this is shared code, not actual drivers, this is fine.

Are there more features yet to be implemented? Would it make sense to
create a mhi directory?

       Andrew

