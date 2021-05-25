Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E2E3903B8
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhEYOS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:18:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52997 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbhEYOST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:18:19 -0400
Received: from mail-vs1-f70.google.com ([209.85.217.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1llXrS-0000ay-QE
        for netdev@vger.kernel.org; Tue, 25 May 2021 14:16:46 +0000
Received: by mail-vs1-f70.google.com with SMTP id f20-20020a67d8940000b029022a675e6e86so12948035vsj.2
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 07:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CEFj1RvEdb/WJRzoXO6FeLVMZWd50iSXAawAzIpq6pM=;
        b=CRopSvsmv8fnKytcb8cUCBtSpnMDZNxZzVSZym5LcI0tWUkKMV+fZiH5Pj2Us3KU7V
         uczooiv2/I+g62o/5RpLnYehQZwnOJzVF6/bLFkrGgZbbcepsSomeudRGov+Ah2k1V20
         KSa3CUm0aJd+ufN4CJfApTqTlTNgAHUeCNLhokAYjZ7ATQ7vdEh5jfjPIrpRMRU92zX1
         mxbRfxyQPioyReHsn+O0kogCj0U7nQXjK5GlzysiWtc9NxLPZnTv+nu75UyLEmrJFX6n
         h4LA3uRtfLzJWiE9eZk1BnyakzVpldItkGORz8IAO06Y5Rfh1cE5pqwClrjQ5VvsGd6V
         TEpQ==
X-Gm-Message-State: AOAM530zIe4wqp2+ZUR54Pm+Ryrt6pahsG9+/t85EgdEBjbP2eF+O32/
        rygLVW1tW4NcEZihK8vlK+0lnmESpzDfjvwiNEGhmPlWTWfbbO6m6gS9WxrQ258BxTmUdBV+0eF
        DmNBMYpSUAsVIU+dxj7VYV0VL0O7gGCiwOA==
X-Received: by 2002:ab0:778c:: with SMTP id x12mr11204816uar.88.1621952205937;
        Tue, 25 May 2021 07:16:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGfLbNM1XKLM9CsGz7reNvREjkXh2l7hNJj0Pm2hGhox76uNxcWs9cOdYZhobM7V1TkjbWpQ==
X-Received: by 2002:ab0:778c:: with SMTP id x12mr11204793uar.88.1621952205824;
        Tue, 25 May 2021 07:16:45 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id s11sm1572166vsi.27.2021.05.25.07.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 07:16:45 -0700 (PDT)
Subject: Re: [PATCH] iwlwifi: add new pci id for 6235
To:     Alex Hung <alex.hung@canonical.com>, luciano.coelho@intel.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matti.gottlieb@intel.com, ihab.zhaika@intel.com,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210322071121.265584-1-alex.hung@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <e51b79ff-74fb-966a-cc5e-45b50bc19f04@canonical.com>
Date:   Tue, 25 May 2021 10:16:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322071121.265584-1-alex.hung@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/2021 03:11, Alex Hung wrote:
> lspci output:
> Network controller [0280]: Intel Corporation Centrino Advanced-N6235
>  [8086:088f] (rev 24)
>  Subsystem: Intel Corporation Centrino Advanced-N 6235 [8086:526a]
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alex Hung <alex.hung@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
