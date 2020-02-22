Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03C5169125
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 19:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgBVSGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 13:06:48 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41108 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgBVSGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 13:06:48 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so5621797ljc.8
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 10:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GBIxSIeZmeDMNIuD3/L4tNo0lsdugthZe8A+ZiKwsNU=;
        b=pv3F9y3+OT0H8xQLmYaVojz8GUG0opoKQ+jwNHqay+rxS+VwZGx6fv683ddYF7GAs+
         bklU9TDNvtruVUeDZq9Og0hh92ncVq4GATaY1vjCxtMi+RCqYZnpovILqZ5PZbxFj9Zm
         quQv/z2VtTAxdrDeqGZI6Tp9gwbwimdMdN8xvUl0GCIt40eaMcZgkjaPpilR7TniAKL8
         qTdy41GaI/3HApqI9eFLBsGeG5n93/vCVhUKgZqLsiRWu8KycHFvl8jmplg4RnBODxsd
         L9x9K8Umfb8J+dcgF2oTtP46n4cMnMFJHTtToz+di+1cjldzcw7hX0Jdjdmf1NuA/T/d
         SJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GBIxSIeZmeDMNIuD3/L4tNo0lsdugthZe8A+ZiKwsNU=;
        b=pNYJciKI78twiy6CjrD5oLUieh8GIP8aOC5l0lhbCRSoV7wIalr8KkFGvEdjBoZN63
         mvCon1jSifpya1jy9ALqSJK+sw7ChA5kovbHHXCc/cMe92xMBCK9xbJkjsyxRYNdXIXH
         5eXXlnl7J50Ho/mJvHNm6bSayfQDmshfvzaUXR34b+kXomGTU/3PY7ZFeLOxHiptzCdO
         4N9WQLdQ/F4a5lKVTs7VDFKtRkCZvf3I0dcR4VhEptwRHoPXvcdasGFd2NQMTbV1FEdu
         2H8po22+0Tsd5bganZL1M7O9RdzFO1+4te2DpREgJuPP2XEghwsOGsdkbRzb+IhntyWq
         9NlA==
X-Gm-Message-State: APjAAAW4K8yZWKCRdDUzVSDGdPi/lPC4fL5p/YERxq87Y+dukmarC/TV
        3Vnb9g29auSQdpwr5t4CAigiCw==
X-Google-Smtp-Source: APXvYqyvWJSQqBtILUCVcF2wX6xT0599tZsTh8hWakuWZ2eucs2bVjoe3wXtngSXRR3NSaMlJ3Lixw==
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr25878094lji.274.1582394805812;
        Sat, 22 Feb 2020 10:06:45 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:4621:26b8:f6bb:b31c:6567:7228])
        by smtp.gmail.com with ESMTPSA id i13sm3602020ljg.89.2020.02.22.10.06.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Feb 2020 10:06:44 -0800 (PST)
Subject: Re: [for-next PATCH 5/5] arm64: dts: ti: k3-j721e-mcu: add scm node
 and phy-gmii-sel nodes
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
References: <20200222120358.10003-1-grygorii.strashko@ti.com>
 <20200222120358.10003-6-grygorii.strashko@ti.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <f54c18c5-9c74-7853-1812-1b31d4160307@cogentembedded.com>
Date:   Sat, 22 Feb 2020 21:06:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20200222120358.10003-6-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 02/22/2020 03:03 PM, Grygorii Strashko wrote:

> Add DT node for MCU System Control module DT node and DT node for the TI
> J721E SoC phy-gmii-sel PHY required for Ethernet ports mode selection.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
> index 16c874bfd49a..9b3d10241a2e 100644
> --- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
> +++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
> @@ -34,6 +34,20 @@
>  		};
>  	};
>  
> +	mcu_conf: scm_conf@40f00000 {

   The devce names should be generic and it appears that DT spec even has has
a device name "syscon".

[...]

MBR, Sergei
