Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA1E55AD
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfJYVNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:13:41 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46861 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfJYVNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:13:41 -0400
Received: by mail-oi1-f193.google.com with SMTP id c2so2492628oic.13;
        Fri, 25 Oct 2019 14:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YsHXnqwoM7wQXF0uPaovfdPHuECAxo/T6mEqOx5c+dY=;
        b=d5n/hl88X3WT/lDSfXeXeT7eh88OeCGJXh8DRG3bf/6br3ocb/wuas+P+uO5Lb3nbw
         DPjWOGbTZlvh5mTFAO4IO+vImTbmuJ5tNUrRaOg98/5mIIOkNGhaouW8CVGujBOB2jjg
         VbZRAR5dfuu8UZ27vhgKAqADN7gKY6Dy9B3xPwuP/7+TJUeR8/kVXH6gJ8s01CzUqhN9
         XqgtCuX8+Jau/J2Th0uMDWgg7HuxN+IruTh4GMaWknCIOzE8QR0itD02xgSCIPsjVm1d
         Syd86ZMT9UBjAv2+HIiiz1iACDvvaXRpQJ8KdYnLThigdYv8wXuX9rkgJw1Ls42prPLe
         QRNg==
X-Gm-Message-State: APjAAAU7tpQIs/Z2bDboLH0G3FwCCcelOfp4pPvbDRYrJxzaVPUbCw7D
        tfW6+Qfe/pt4cuJ/Re94eg==
X-Google-Smtp-Source: APXvYqwE4WNyEIPHUmWISUbe3EXRa308MBi5x/EUd8BbYKV1jvLUEmP2vAxDgTjVnSwi+WqgYLFnXA==
X-Received: by 2002:aca:1e0e:: with SMTP id m14mr4801375oic.72.1572038019693;
        Fri, 25 Oct 2019 14:13:39 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n4sm875917oic.2.2019.10.25.14.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 14:13:38 -0700 (PDT)
Date:   Fri, 25 Oct 2019 16:13:38 -0500
From:   Rob Herring <robh@kernel.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        devicetree@vger.kernel.org, letux-kernel@openphoenux.org,
        linux-mmc@vger.kernel.org, kernel@pyra-handheld.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 01/11] Documentation: dt: wireless: update wl1251 for
 sdio
Message-ID: <20191025211338.GA20249@bogus>
References: <cover.1571510481.git.hns@goldelico.com>
 <741828f69eca2a9c9a0a7e80973c91f50cc71f9b.1571510481.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <741828f69eca2a9c9a0a7e80973c91f50cc71f9b.1571510481.git.hns@goldelico.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 08:41:16PM +0200, H. Nikolaus Schaller wrote:
> The standard method for sdio devices connected to
> an sdio interface is to define them as a child node
> like we can see with wlcore.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> ---
>  .../bindings/net/wireless/ti,wl1251.txt       | 26 +++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> index bb2fcde6f7ff..88612ff29f2d 100644
> --- a/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
> @@ -35,3 +35,29 @@ Examples:
>  		ti,power-gpio = <&gpio3 23 GPIO_ACTIVE_HIGH>; /* 87 */
>  	};
>  };
> +
> +&mmc3 {
> +	vmmc-supply = <&wlan_en>;
> +
> +	bus-width = <4>;
> +	non-removable;
> +	ti,non-removable;
> +	cap-power-off-card;
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&mmc3_pins>;

None of the above are really relevant to this binding.

> +
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	wlan: wl1251@1 {

wifi@1

> +		compatible = "ti,wl1251";
> +
> +		reg = <1>;
> +
> +		interrupt-parent = <&gpio1>;
> +		interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;	/* GPIO_21 */
> +
> +		ti,wl1251-has-eeprom;
> +	};
> +};
> -- 
> 2.19.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
