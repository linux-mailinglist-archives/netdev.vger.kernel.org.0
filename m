Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC07424E1D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 09:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbhJGHdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 03:33:54 -0400
Received: from gecko.sbs.de ([194.138.37.40]:55269 "EHLO gecko.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232512AbhJGHdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 03:33:53 -0400
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id 1977VT5r023273
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 09:31:29 +0200
Received: from [167.87.4.198] ([167.87.4.198])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 1977VR5D005691;
        Thu, 7 Oct 2021 09:31:27 +0200
Subject: Re: [PATCH v4 2/6] arm64: dts: ti:
 am654-base-board/am65-iot2050-common: Disable mcan nodes
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, Nishanth Menon <nm@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211006055344.22662-1-a-govindraju@ti.com>
 <20211006055344.22662-3-a-govindraju@ti.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <c9907374-623b-e3eb-1be1-3c09a9f93674@siemens.com>
Date:   Thu, 7 Oct 2021 09:31:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211006055344.22662-3-a-govindraju@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.10.21 07:53, Aswath Govindraju wrote:
> AM654 base board and iot platforms do not have mcan instances pinned out.
> Therefore, disable all the mcan instances.
> 
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi | 8 ++++++++
>  arch/arm64/boot/dts/ti/k3-am654-base-board.dts     | 8 ++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
> index 65da226847f4..1e0112b90d9f 100644
> --- a/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
> +++ b/arch/arm64/boot/dts/ti/k3-am65-iot2050-common.dtsi
> @@ -646,6 +646,14 @@
>  	reset-gpios = <&wkup_gpio0 27 GPIO_ACTIVE_HIGH>;
>  };
>  
> +&m_can0 {
> +	status = "disabled";
> +};
> +
> +&m_can1 {
> +	status = "disabled";
> +};
> +
>  &pcie1_ep {
>  	status = "disabled";
>  };
> diff --git a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
> index cfbcebfa37c1..9043f91c9bec 100644
> --- a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
> +++ b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
> @@ -416,6 +416,14 @@
>  	status = "disabled";
>  };
>  
> +&m_can0 {
> +	status = "disabled";
> +};
> +
> +&m_can1 {
> +	status = "disabled";
> +};
> +
>  &mailbox0_cluster0 {
>  	interrupts = <436>;
>  
> 

For the IOT2050 part:

Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
