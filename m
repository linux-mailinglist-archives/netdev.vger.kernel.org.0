Return-Path: <netdev+bounces-458-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2FB6F76FA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:27:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69EEF1C214D5
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3261156D8;
	Thu,  4 May 2023 20:27:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B683156C0
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 20:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11AAC433D2;
	Thu,  4 May 2023 20:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683232062;
	bh=OibrI2sQXPTEySu7ns9/uWCTEEglAJHiieCCCAkCdl4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iQwuawPHTLugedtJxUuF9P1oagmM4vrotAh4Na347EJD78F++M6O+OBx1IWNv/5Or
	 2gdsRnm3a/YugdPV3gzsdlxMef9WMPGv79DJLpttz1PkyRBLUTUguotfe8817caK7d
	 bGD+a/DMSIS3WMLCosyAWVYt+H4Kn8BbBRZhFs847jFLmLDC4gz+FdybtJvHxaEfJD
	 RLnTm98svLty66/B3D3JhGTcEP9xiEd+CepgxpYTP2z4Tj3ElKmmaNmZMRoszVvf3O
	 vNO0OsPigPqJAes06d3ONonYifl/WHYwcDjBcHtZEuV8fwO43XzrWECoA4cLwU0fcE
	 j6s8WcYGJ+yZg==
Date: Thu, 4 May 2023 13:27:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jiri Pirko <jiri@resnulli.us>, Arkadiusz Kubalewski
 <arkadiusz.kubalewski@intel.com>, Jonathan Lemon
 <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>, Milena Olech
 <milena.olech@intel.com>, Michal Michalik <michal.michalik@intel.com>,
 linux-arm-kernel@lists.infradead.org, Vadim Fedorenko
 <vadim.fedorenko@linux.dev>, poros@redhat.com, mschmidt@redhat.com,
 netdev@vger.kernel.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Message-ID: <20230504132740.30e19bba@kernel.org>
In-Reply-To: <ZFOUmViuAiCaHBfc@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
	<20230428002009.2948020-3-vadfed@meta.com>
	<ZFOUmViuAiCaHBfc@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 May 2023 13:18:49 +0200 Jiri Pirko wrote:
> >diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
> >index e188bc189754..75eeaa4396eb 100644
> >--- a/include/uapi/linux/dpll.h
> >+++ b/include/uapi/linux/dpll.h
> >@@ -111,6 +111,8 @@ enum dpll_pin_direction {
> > 
> > #define DPLL_PIN_FREQUENCY_1_HZ		1
> > #define DPLL_PIN_FREQUENCY_10_MHZ	10000000
> >+#define DPLL_PIN_FREQUENCY_10_KHZ	10000
> >+#define DPLL_PIN_FREQUENCY_77_5_KHZ	77500  
> 
> This should be moved to patch #1.
> please convert to enum, could be unnamed.

+1, you can't edit the YNL-generated files at all.

