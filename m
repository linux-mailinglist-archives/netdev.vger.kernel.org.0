Return-Path: <netdev+bounces-8834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F748725F4C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:26:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C664280FB3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF8F34454;
	Wed,  7 Jun 2023 12:26:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFB813AD6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:26:25 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC231FDF;
	Wed,  7 Jun 2023 05:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Jr+xg2ifRRVhPjCfW2O7H0sIHcq4ucFfwT2EMs2VVTE=; b=2z8/1eUIu0eed8kJ/uXWr08jvx
	Xam4MlAiQ55jRHKUtQ8okSusP1RUXmzcKVaZIEL60WAjgyRq/pWhXxYhUjM4XpfUhfy/z+9hd5sJj
	h//tAkzPEvewHhtUpEwPqAqpjkOs9lsoVbOW1WwWcBehjokAldnb9S4QgytaYofRxaTA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q6sEY-00F8yM-R8; Wed, 07 Jun 2023 14:25:50 +0200
Date: Wed, 7 Jun 2023 14:25:50 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Jeffrey Hugo <quic_jhugo@quicinc.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	loic.poulain@linaro.org
Subject: Re: [PATCH 3/3] net: mhi: Increase the default MTU from 16K to 32K
Message-ID: <f96d4956-6b69-4809-9461-9157e32b3865@lunn.ch>
References: <20230606123119.57499-1-manivannan.sadhasivam@linaro.org>
 <20230606123119.57499-4-manivannan.sadhasivam@linaro.org>
 <b8a25a70-8781-8b82-96d8-bc1ecf2d5468@quicinc.com>
 <20230607065809.GB5025@thinkpad>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607065809.GB5025@thinkpad>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 12:28:09PM +0530, Manivannan Sadhasivam wrote:
> On Tue, Jun 06, 2023 at 07:50:23AM -0600, Jeffrey Hugo wrote:
> > On 6/6/2023 6:31 AM, Manivannan Sadhasivam wrote:
> > > Most of the Qualcomm endpoint devices are supporting 32K MTU for the
> > > UL (Uplink) and DL (Downlink) channels. So let's use the same value
> > > in the MHI NET driver also. This gives almost 2x increase in the throughput
> > > for the UL channel.

You say here 'Most'. What happens on those which do not support 32K?
Do the packets get dropped and it turns into a black hole?

   Andrew

