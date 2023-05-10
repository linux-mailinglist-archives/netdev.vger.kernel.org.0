Return-Path: <netdev+bounces-1494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BDAA6FDFDC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CFFF281155
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8457D12B9E;
	Wed, 10 May 2023 14:19:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E4312B74
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:19:36 +0000 (UTC)
Received: from fgw20-7.mail.saunalahti.fi (fgw20-7.mail.saunalahti.fi [62.142.5.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD743A82
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:19:33 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTP
	id ada8b924-ef3d-11ed-b3cf-005056bd6ce9;
	Wed, 10 May 2023 17:19:30 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Wed, 10 May 2023 17:19:30 +0300
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: andy.shevchenko@gmail.com, agross@kernel.org, andersson@kernel.org,
	konrad.dybcio@linaro.org, linus.walleij@linaro.org,
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	richardcochran@gmail.com, manivannan.sadhasivam@linaro.org,
	linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v6 4/4] pinctrl: qcom: Add SDX75 pincontrol driver
Message-ID: <ZFun8m5y-r0yUHhq@surfacebook>
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683718725-14869-5-git-send-email-quic_rohiagar@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683718725-14869-5-git-send-email-quic_rohiagar@quicinc.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 10, 2023 at 05:08:45PM +0530, Rohit Agarwal kirjoitti:
> Add initial Qualcomm SDX75 pinctrl driver to support pin configuration
> with pinctrl framework for SDX75 SoC.
> While at it, reordering the SDX65 entry.

...

> +#define FUNCTION(n)							\
> +	[msm_mux_##n] = {						\
> +			.func = PINCTRL_PINFUNCTION(#n,			\
> +					n##_groups,			\
> +					ARRAY_SIZE(n##_groups))		\
> +			}

But don't you now have MSM_PIN_FUNCTION() macro?

-- 
With Best Regards,
Andy Shevchenko



