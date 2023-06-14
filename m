Return-Path: <netdev+bounces-10754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E92073023C
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:47:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C51528149F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0061779CB;
	Wed, 14 Jun 2023 14:47:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D747F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB20DC433C9;
	Wed, 14 Jun 2023 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686754059;
	bh=YBvoPI/IEVtbY5FNxrgQvaHMUweYY58AfZfxW/FUfzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e3LNvXuGGMNQtEoM1FFIbIMA86EOKQwXEt+3tALeKxbJwddDvByyh87z716lOdEGC
	 ay6V6UsAWKdIpfQeOHUTj6uRCRuxoBSQ/ETGAidKLmmAZaEKJNYu7cWBppubt22OZZ
	 qs7CsgD6eYxPn/6tp8A8zc/IMx9Wwqni4eq6r2HIflQzfEAn2bw6+gBVmE50N1J2VT
	 xdtONfXgAZr/MN4pOsv/pIk3cO5LxiMXaxi73cLALIFbTrJFx3D++N+lWZ75xNd4yO
	 zo3zVf4keiHIC1Lp+4V1UkRY9UGYRsboF0z0HH6nx3D0gBBtowUDJNQ1wU4JmuqIAX
	 iiI/VHltBNFtQ==
Date: Wed, 14 Jun 2023 07:51:00 -0700
From: Bjorn Andersson <andersson@kernel.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 24/26] arm64: dts: qcom: sa8775p-ride: enable the SerDes
 PHY
Message-ID: <20230614145100.xgkme7or7k2i552d@ripper>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-25-brgl@bgdev.pl>
 <0a57a9ad-67ab-cf1a-9bb7-c645de833450@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a57a9ad-67ab-cf1a-9bb7-c645de833450@linaro.org>

On Tue, Jun 13, 2023 at 09:02:23PM +0200, Konrad Dybcio wrote:
> 
> 
> On 12.06.2023 11:23, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > 
> > Enable the internal PHY on sa8775p-ride.
> > 
> > Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > ---
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> 
> ---
> 
> Bjorn, Krzysztof.. I was thinking whether we should even be disabling
> such hardware by default..
> 

I'm in favor of keeping the configuration as generic/common/simple as
possible. So I like your suggestion.

Regards,
Bjorn

> Things that reside on the SoC and have no external dependencies could
> be left enabled:
> 
> pros:
> - less fluff
> - we'd probably very quickly fix the missing PM calls
> - possibly less fw_devlink woes if we fail to get rid of references to
>   the disabled component?
> 
> cons:
> - boot times
> - slightly more memory usage
> 
> Konrad
> >  arch/arm64/boot/dts/qcom/sa8775p-ride.dts | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> > index ab767cfa51ff..7754788ea775 100644
> > --- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> > +++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dts
> > @@ -355,6 +355,10 @@ &qupv3_id_2 {
> >  	status = "okay";
> >  };
> >  
> > +&serdes_phy {
> > +	status = "okay";
> > +};
> > +
> >  &sleep_clk {
> >  	clock-frequency = <32764>;
> >  };

