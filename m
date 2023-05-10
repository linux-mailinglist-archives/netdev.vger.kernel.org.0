Return-Path: <netdev+bounces-1491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 379776FDFAB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F36A528101A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440A814A93;
	Wed, 10 May 2023 14:08:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3951720B54
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:08:40 +0000 (UTC)
Received: from fgw21-7.mail.saunalahti.fi (fgw21-7.mail.saunalahti.fi [62.142.5.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793BB121
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:08:35 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTP
	id 262a7a7a-ef3c-11ed-abf4-005056bdd08f;
	Wed, 10 May 2023 17:08:33 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Wed, 10 May 2023 17:08:33 +0300
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: andy.shevchenko@gmail.com, agross@kernel.org, andersson@kernel.org,
	konrad.dybcio@linaro.org, linus.walleij@linaro.org,
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	richardcochran@gmail.com, manivannan.sadhasivam@linaro.org,
	linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v6 3/4] pinctrl: qcom: Refactor generic qcom pinctrl
 driver
Message-ID: <ZFulYdpI9a2vvbWK@surfacebook>
References: <1683718725-14869-1-git-send-email-quic_rohiagar@quicinc.com>
 <1683718725-14869-4-git-send-email-quic_rohiagar@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683718725-14869-4-git-send-email-quic_rohiagar@quicinc.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 10, 2023 at 05:08:44PM +0530, Rohit Agarwal kirjoitti:
> Reuse the generic pingroup struct from pinctrl.h in msm_pingroup
> along with the macro defined.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Thank you!

> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
> Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>

-- 
With Best Regards,
Andy Shevchenko



