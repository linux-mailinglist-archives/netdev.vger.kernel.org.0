Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718FF268250
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 03:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgINBjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 21:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgINBjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 21:39:17 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22241C06174A;
        Sun, 13 Sep 2020 18:39:17 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s14so479694pju.1;
        Sun, 13 Sep 2020 18:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=atho485JIxPAEFW2Y+PZCl5HEMdeWE72t8mqg0Pgg84=;
        b=a2KaodzH51Q+KzizcpQjn17fBgC9O+N7s2KiBxCrV7UXvTXyLH1j1dr2fuXoXSyF7q
         KaU0LmBIXcoRrVYN0r7J44dnzSSj/yjC9U4ZYlpSeoCxgwuVe88qhWXklYSbJNUkbF/A
         akSGGm9PpUQfvnWMRuGubrv7pOTzH6XMPNTykhR0lP9Igh9jNEeue21SBMweT/F56d60
         raub9kif+xoaaVWWCa96I16DUCtGMaHWicqF6L2zQVfZW60tifJJHIz/ozIJ6pOVQ6Zx
         zkLco8vl7lgJETPlRy8L3iRR7QWylM4Y+1rWGGZ7oPeEK5jtfy+t8yrYNkZmri5H/y3X
         8Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=atho485JIxPAEFW2Y+PZCl5HEMdeWE72t8mqg0Pgg84=;
        b=fQ8smUj6AnQn+aviso+rhPez15JHeAc03MX6Euokn41eVMe5rPWisR5Q4wAq2qpCu4
         WmGFrjssaKMQN05CRicZO2SkochlfRQRNG+onzUqof6UT/6XfKvDmmJKQrxvYdEC/5ZB
         bsf+vlKOI+9BkR3IsRfT0og66jmvCQBRGBuHuidT5kpSIQIC/Ew5giOfcmjDdeKSZADc
         NY2UySMTE1BLx08h1Mij4tm5ScR293Ke51MyIgcvs7tFkLMGJ/mNNbqou55DiWAd6Lza
         9ZZR5DdWudbVLsDLmSlbfGEaPDTb4RcaBN8ED6X4WyBhxopQAfmJJbYaUYxFXIZtCqaM
         GB5Q==
X-Gm-Message-State: AOAM5311/Jvd7stZx9RfwkKBgSdBMKYUlKCY4kxaIYKiD66aeGSxtNkl
        KnOYF6BK8R9tA0eqti4dA/Y=
X-Google-Smtp-Source: ABdhPJwy6lpZJGc377LjMTyAMDFIH9VKkPcP+hhWsmB50nIR9IMju8EwMygtBvRCyoAHWVQgSprDhw==
X-Received: by 2002:a17:90a:d304:: with SMTP id p4mr12343481pju.138.1600047556656;
        Sun, 13 Sep 2020 18:39:16 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id i17sm8458370pfa.2.2020.09.13.18.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2020 18:39:15 -0700 (PDT)
Subject: Re: [PATCH v2 12/14] habanalabs/gaudi: Add ethtool support using
 coresight
To:     Oded Gabbay <oded.gabbay@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        Omer Shpigelman <oshpigelman@habana.ai>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
 <20200912144106.11799-13-oded.gabbay@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <50824927-c173-4ab9-1cde-1a55ff27c4a8@gmail.com>
Date:   Sun, 13 Sep 2020 18:39:14 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200912144106.11799-13-oded.gabbay@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2020 7:41 AM, Oded Gabbay wrote:
> From: Omer Shpigelman <oshpigelman@habana.ai>
> 
> The driver supports ethtool callbacks and provides statistics using the
> device's profiling infrastructure (coresight).

Is there any relationship near or far with ARM's CoreSight:

https://developer.arm.com/ip-products/system-ip/coresight-debug-and-trace

if not, should you rename this?
-- 
Florian
