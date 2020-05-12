Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17531D028F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 00:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbgELWwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 18:52:44 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37821 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731237AbgELWwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 18:52:43 -0400
Received: by mail-oi1-f195.google.com with SMTP id r25so19762145oij.4;
        Tue, 12 May 2020 15:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5FBzZp56bANu3Wx9sZ32SCh5qkrb8Nm4Nl75uj+Ae0I=;
        b=GMKt47558LTSZ9oa++Q2TFOPH31j2QFKrwlor1I/WHKYk/wmzSLZ7iJRkJor0Imw+7
         0YTfD7Pb1ay095rQXiYu4s8AImhJ1loyKd7+Pz8TJC96SFX4Hc45HM7NrRofvAZ5nVLx
         lvRupP+iLwqkMGBO0hZXSOlfaKWpgniY+kIBAYgveUGn1Ua7450KUUSeuUNmCSvMyZIG
         pLeib6qnos3/l2/F4b1NrE+ba2Hmegum+Yq21nt+SVQJh2hy86RyNmzsUk2VoTgkaTB+
         UgTFLzyKtquL4UUaFgVLXDCuRXroImclmqzD9ZoEkR1QFIVWhruSDpjJyXJrwZdbxUNP
         dyAQ==
X-Gm-Message-State: AGi0PuaXJsArg1bFSSB+O2zhMimMCYqc6/GXzrOiqUrk/Ie0ykGqa41s
        JBqU2f/QulSEU3HP/3D71dZz1OSQMg==
X-Google-Smtp-Source: APiQypJQaSuX3FuHeKCjXTVCjYY5JwbECJgc/QtUSX/+8UnXsWlLqsGiIVhM10Vwt4afwEIYzgFCtg==
X-Received: by 2002:aca:e188:: with SMTP id y130mr26132679oig.179.1589323962634;
        Tue, 12 May 2020 15:52:42 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h24sm3791448otj.25.2020.05.12.15.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 15:52:41 -0700 (PDT)
Received: (nullmailer pid 23990 invoked by uid 1000);
        Tue, 12 May 2020 22:52:40 -0000
Date:   Tue, 12 May 2020 17:52:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Joyce Ooi <joyce.ooi@intel.com>
Cc:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 10/10] net: eth: altera: update devicetree bindings
 documentation
Message-ID: <20200512225240.GA18344@bogus>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
 <20200504082558.112627-11-joyce.ooi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504082558.112627-11-joyce.ooi@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 04:25:58PM +0800, Joyce Ooi wrote:
> From: Dalon Westergreen <dalon.westergreen@intel.com>
> 
> Update devicetree bindings documentation to include msgdma
> prefetcher and ptp bindings.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Dalon Westergreen <dalon.westergreen@intel.com>
> Signed-off-by: Joyce Ooi <joyce.ooi@intel.com>
> ---
> v2: no change
> ---
>  .../devicetree/bindings/net/altera_tse.txt         | 103 +++++++++++++++++----
>  1 file changed, 84 insertions(+), 19 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>

One nit below.

> 
> diff --git a/Documentation/devicetree/bindings/net/altera_tse.txt b/Documentation/devicetree/bindings/net/altera_tse.txt
> index 0b7d4d3758ea..2f2d12603907 100644
> --- a/Documentation/devicetree/bindings/net/altera_tse.txt
> +++ b/Documentation/devicetree/bindings/net/altera_tse.txt
> @@ -2,53 +2,86 @@
>  
>  Required properties:
>  - compatible: Should be "altr,tse-1.0" for legacy SGDMA based TSE, and should
> -		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based TSE.
> +		be "altr,tse-msgdma-1.0" for the preferred MSGDMA based TSE,
> +		and "altr,tse-msgdma-2.0" for MSGDMA with prefetcher based
> +		implementations.
>  		ALTR is supported for legacy device trees, but is deprecated.
>  		altr should be used for all new designs.
>  - reg: Address and length of the register set for the device. It contains
>    the information of registers in the same order as described by reg-names
>  - reg-names: Should contain the reg names
> -  "control_port": MAC configuration space region
> -  "tx_csr":       xDMA Tx dispatcher control and status space region
> -  "tx_desc":      MSGDMA Tx dispatcher descriptor space region
> -  "rx_csr" :      xDMA Rx dispatcher control and status space region
> -  "rx_desc":      MSGDMA Rx dispatcher descriptor space region
> -  "rx_resp":      MSGDMA Rx dispatcher response space region
> -  "s1":		  SGDMA descriptor memory
>  - interrupts: Should contain the TSE interrupts and it's mode.
>  - interrupt-names: Should contain the interrupt names
> -  "rx_irq":       xDMA Rx dispatcher interrupt
> -  "tx_irq":       xDMA Tx dispatcher interrupt
> +  "rx_irq":       DMA Rx dispatcher interrupt
> +  "tx_irq":       DMA Tx dispatcher interrupt
>  - rx-fifo-depth: MAC receive FIFO buffer depth in bytes
>  - tx-fifo-depth: MAC transmit FIFO buffer depth in bytes
>  - phy-mode: See ethernet.txt in the same directory.
>  - phy-handle: See ethernet.txt in the same directory.
>  - phy-addr: See ethernet.txt in the same directory. A configuration should
>  		include phy-handle or phy-addr.
> -- altr,has-supplementary-unicast:
> -		If present, TSE supports additional unicast addresses.
> -		Otherwise additional unicast addresses are not supported.
> -- altr,has-hash-multicast-filter:
> -		If present, TSE supports a hash based multicast filter.
> -		Otherwise, hash-based multicast filtering is not supported.
> -
>  - mdio device tree subnode: When the TSE has a phy connected to its local
>  		mdio, there must be device tree subnode with the following
>  		required properties:
> -
>  	- compatible: Must be "altr,tse-mdio".
>  	- #address-cells: Must be <1>.
>  	- #size-cells: Must be <0>.
>  
>  	For each phy on the mdio bus, there must be a node with the following
>  	fields:
> -
>  	- reg: phy id used to communicate to phy.
>  	- device_type: Must be "ethernet-phy".
>  
>  The MAC address will be determined using the optional properties defined in
>  ethernet.txt.
>  
> +- altr,has-supplementary-unicast:
> +		If present, TSE supports additional unicast addresses.
> +		Otherwise additional unicast addresses are not supported.
> +- altr,has-hash-multicast-filter:
> +		If present, TSE supports a hash based multicast filter.
> +		Otherwise, hash-based multicast filtering is not supported.
> +- altr,has-ptp:
> +		If present, TSE supports 1588 timestamping.  Currently only
> +		supported with the msgdma prefetcher.
> +- altr,tx-poll-cnt:
> +		Optional cycle count for Tx prefetcher to poll descriptor
> +		list.  If not present, defaults to 128, which at 125MHz is
> +		roughly 1usec. Only for "altr,tse-msgdma-2.0".
> +- altr,rx-poll-cnt:
> +		Optional cycle count for Tx prefetcher to poll descriptor
> +		list.  If not present, defaults to 128, which at 125MHz is
> +		roughly 1usec. Only for "altr,tse-msgdma-2.0".
> +
> +Required registers by compatibility string:
> + - "altr,tse-1.0"
> +	"control_port": MAC configuration space region
> +	"tx_csr":       DMA Tx dispatcher control and status space region
> +	"rx_csr" :      DMA Rx dispatcher control and status space region
> +	"s1":		DMA descriptor memory
> +
> + - "altr,tse-msgdma-1.0"
> +	"control_port": MAC configuration space region
> +	"tx_csr":       DMA Tx dispatcher control and status space region
> +	"tx_desc":      DMA Tx dispatcher descriptor space region
> +	"rx_csr" :      DMA Rx dispatcher control and status space region
> +	"rx_desc":      DMA Rx dispatcher descriptor space region
> +	"rx_resp":      DMA Rx dispatcher response space region
> +
> + - "altr,tse-msgdma-2.0"
> +	"control_port": MAC configuration space region
> +	"tx_csr":       DMA Tx dispatcher control and status space region
> +	"tx_pref":      DMA Tx prefetcher configuration space region
> +	"rx_csr" :      DMA Rx dispatcher control and status space region
> +	"rx_pref":      DMA Rx prefetcher configuration space region
> +	"tod_ctrl":     Time of Day Control register only required when
> +			timestamping support is enabled.  Timestamping is
> +			only supported with the msgdma-2.0 implementation.
> +
> +Optional properties:
> +- local-mac-address: See ethernet.txt in the same directory.
> +- max-frame-size: See ethernet.txt in the same directory.
> +
>  Example:
>  
>  	tse_sub_0_eth_tse_0: ethernet@1,00000000 {
> @@ -86,6 +119,11 @@ Example:
>  				device_type = "ethernet-phy";
>  			};
>  
> +			phy2: ethernet-phy@2 {
> +				reg = <0x2>;
> +				device_type = "ethernet-phy";
> +			};
> +
>  		};
>  	};
>  
> @@ -111,3 +149,30 @@ Example:
>  		altr,has-hash-multicast-filter;
>  		phy-handle = <&phy1>;
>  	};
> +
> +
> +	tse_sub_2_eth_tse_0: ethernet@1,00002000 {

What bus is this on? Usually a ',' like this is for a chip select 
number. If just a 64-bit address, then no comma.

> +		compatible = "altr,tse-msgdma-2.0";
> +		reg = 	<0x00000001 0x00002000 0x00000400>,
> +			<0x00000001 0x00002400 0x00000020>,
> +			<0x00000001 0x00002420 0x00000020>,
> +			<0x00000001 0x00002440 0x00000020>,
> +			<0x00000001 0x00002460 0x00000020>,
> +			<0x00000001 0x00002480 0x00000040>;
> +		reg-names = "control_port", "rx_csr", "rx_pref","tx_csr", "tx_pref", "tod_ctrl";
> +		interrupt-parent = <&hps_0_arm_gic_0>;
> +		interrupts = <0 45 4>, <0 44 4>;
> +		interrupt-names = "rx_irq", "tx_irq";
> +		rx-fifo-depth = <2048>;
> +		tx-fifo-depth = <2048>;
> +		address-bits = <48>;
> +		max-frame-size = <1500>;
> +		local-mac-address = [ 00 00 00 00 00 00 ];
> +		phy-mode = "sgmii";
> +		altr,has-supplementary-unicast;
> +		altr,has-hash-multicast-filter;
> +		altr,has-ptp;
> +		altr,tx-poll-cnt = <128>;
> +		altr,rx-poll-cnt = <32>;
> +		phy-handle = <&phy2>;
> +	};
> -- 
> 2.13.0
> 
