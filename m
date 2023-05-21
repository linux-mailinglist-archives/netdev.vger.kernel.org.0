Return-Path: <netdev+bounces-4087-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA1770AC47
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 06:03:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 383A1281096
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 04:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4E381C;
	Sun, 21 May 2023 04:03:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF091803
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 04:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDBAC433EF;
	Sun, 21 May 2023 04:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684641782;
	bh=tAL1e1CrhZKFhxrzTAaRdTpX97DGjoMXvtlZ/Guyg3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qOmd4822YlstRkGzmOQeiQ6MujYbRy6GTSeaJm0vJuGIjwwfsAFPN7fcm7nB3w9Tr
	 2PZ7MZrpm0KiaGQ/pYdYNZxjJU1vbHLSbTowJJxyvKTNyQfWKYU3iOTHYM4072mZDv
	 bj4Wg/1wBXbGZgrvbGYfPyjxGDHUkrXFvBXOZWj8JvPMef380QKRcUFNCsEXi+OSb7
	 FfpHeVvguvXVPCrKhae2AHSWQiUMTMTlJH9SkKBB0EG5+2CsfoRZa50Y+OyaDRnW43
	 50+Yh/+vNOpx0ok9b5x75ez4NkvANWZTApj7P7Ic4z08YIXshyHtbtAB1bK+QDYjSM
	 ugwGA4TcJ05gg==
Date: Sat, 20 May 2023 23:02:59 -0500
From: Bjorn Andersson <andersson@kernel.org>
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: agross@kernel.org, konrad.dybcio@linaro.org, linus.walleij@linaro.org, 
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, 
	richardcochran@gmail.com, manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org, 
	linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Add pinctrl support for SDX75
Message-ID: <7khdd4o2h2nwhopsziqdsjmbdfiehiax5mywbkrjr2fkzhcymz@4tastcouroqv>
References: <1684425432-10072-1-git-send-email-quic_rohiagar@quicinc.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684425432-10072-1-git-send-email-quic_rohiagar@quicinc.com>

On Thu, May 18, 2023 at 09:27:09PM +0530, Rohit Agarwal wrote:
> Hi,
> 
> Changes in v3:
>  - Addressing minor comments from Bhupesh related to reusing variable.
> 
> Changes in v2:
>  - Added a patch for updating the maintainers entry for pinctrl bindings.
>  - Some formatting issue at the end of the driver change.
> 
> This patch series adds pinctrl bindings and tlmm support for SDX75.
> 
> The series is rebased on linux-next and based on all the review and
> comments from different versions of [1].
> 
> [1] https://lore.kernel.org/linux-arm-msm/1681966915-15720-1-git-send-email-quic_rohiagar@quicinc.com/
> 

Reviewed-by: Bjorn Andersson <andersson@kernel.org>

Regards,
Bjorn

> Thanks,
> Rohit.
> 
> Rohit Agarwal (3):
>   dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
>   MAINTAINERS: Update the entry for pinctrl maintainers
>   pinctrl: qcom: Add SDX75 pincontrol driver
> 
>  .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          |  137 +++
>  MAINTAINERS                                        |    2 +-
>  drivers/pinctrl/qcom/Kconfig                       |   30 +-
>  drivers/pinctrl/qcom/Makefile                      |    3 +-
>  drivers/pinctrl/qcom/pinctrl-sdx75.c               | 1144 ++++++++++++++++++++
>  5 files changed, 1304 insertions(+), 12 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
>  create mode 100644 drivers/pinctrl/qcom/pinctrl-sdx75.c
> 
> -- 
> 2.7.4
> 

