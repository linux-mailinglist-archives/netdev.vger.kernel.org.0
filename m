Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BE21B769D
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgDXNL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgDXNLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 09:11:25 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D41CC09B046
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:11:24 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 198so7654025lfo.7
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=G2uXfV2zQ6YcJDE/jPT/znzd8EhGd4IlBIY8GlaqseU=;
        b=boaoa6QxxZN3lCBv5P/sBvwVlfHCoZjiR0gPpaqf3dyoRwSHGfxFtQStzuk++J/6To
         4n5I0Jvx6fc19Pv+X2xswYOFxMK3keWFmkmu4j8r60wq9yJeXq1wqyMxR2WUlB0Fv38R
         Sk68/ReojCiQxUbN0FG1hf2ZUMLZLX0F3+EAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G2uXfV2zQ6YcJDE/jPT/znzd8EhGd4IlBIY8GlaqseU=;
        b=RdN/weTrHMWXYCZKFR6TPU28MoeSDpSfmubU4wjQJHlivOUA9i7czCijBjSCBWtQfe
         H1nqQA7vsAnEL+asjLD/KCwh1gB3J4vit8r6LQWAFe90KHRjZDbsWqO9Kyzi/gJRiZyA
         V4jot2Z8sGeDMrXXgAITQNkVVTR+4Q6TS8uuiZWfcAIvpZZ1ra3klUNJauEyqs1FEZ9B
         eZ/KqWjyKhYBBiSGCKWboqdWEVfITbV8H4w3ODPwvXiOGtjR0wG2yGZW7owykY/qWrOd
         YdxTJDZVmgD+g7PlIBsrCI2SjkvepUlvftLLJlOfEpyo3HwphqrwdMmakdTW2JbnF6X3
         NiRg==
X-Gm-Message-State: AGi0PuaGBWaZs+CXKpagu1QHDhbimXXth91ZTzoq5+YcBXj/rV2ZtIGa
        vqY32dO3jNXHA+wI4sKYBZVU/g==
X-Google-Smtp-Source: APiQypLSz5FyzC47Rafs0O51HZGYwp2jhTj+lYOAvYPKJ5wYmLjjuBz8V0lWiSfO0U29zYw8ZGkO3A==
X-Received: by 2002:a05:6512:3081:: with SMTP id z1mr6229213lfd.102.1587733882939;
        Fri, 24 Apr 2020 06:11:22 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id e186sm4551183lfd.83.2020.04.24.06.11.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 06:11:21 -0700 (PDT)
Subject: Re: [PATCH net-next v3 02/11] bridge: mrp: Update Kconfig
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200422161833.1123-1-horatiu.vultur@microchip.com>
 <20200422161833.1123-3-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <cfbeabee-8df5-3a50-b43f-8833723b8ed9@cumulusnetworks.com>
Date:   Fri, 24 Apr 2020 16:11:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422161833.1123-3-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2020 19:18, Horatiu Vultur wrote:
> Add the option BRIDGE_MRP to allow to build in or not MRP support.
> The default value is N.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/Kconfig | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
> index e4fb050e2078..51a6414145d2 100644
> --- a/net/bridge/Kconfig
> +++ b/net/bridge/Kconfig
> @@ -61,3 +61,15 @@ config BRIDGE_VLAN_FILTERING
>  	  Say N to exclude this support and reduce the binary size.
>  
>  	  If unsure, say Y.
> +
> +config BRIDGE_MRP
> +	bool "MRP protocol"
> +	depends on BRIDGE
> +	default n
> +	help
> +	  If you say Y here, then the Ethernet bridge will be able to run MRP
> +	  protocol to detect loops
> +
> +	  Say N to exclude this support and reduce the binary size.
> +
> +	  If unsure, say N.
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

