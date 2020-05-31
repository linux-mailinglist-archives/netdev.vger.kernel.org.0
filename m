Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA7F1E962D
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 09:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgEaH5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 03:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgEaH5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 03:57:10 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F517C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:57:10 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v19so7834671wmj.0
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 00:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UchOIBOQTzC0ZJPrQjgtp+0inHkAaIl3vsK+Fjw+lHI=;
        b=tZ/GtBxQC7b0H/I+mSpRMjUodUEM9LPKyKYSz25EpNBQdaAUd9vXPiyzaGx1LfkDDX
         JmDzrHKmAVA4yDC1uyXBwJzuwH23Z6ZyOaAzmm15Ir2dc5oCTyUELJTj6Q3PHLvf3cOJ
         Nnq6KgNcaU6H8QzS5R9/BgfbpRwAIAN/VtXfdahD9BiOkLMb8jHtKdBtyOCbu/lbxCKF
         84b98H/MnKV2RpfnPj+izuodXNMMCnZltRpW1j6kaijJCWHbu8rcYffFOhcacuTUkWJD
         VbWsyleCIcn01XjkyqtgDdCfr1z2B4b08yJWLVhrYEPLbT3vqBoLiJ3WWjLOrt7RkFQ3
         FmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UchOIBOQTzC0ZJPrQjgtp+0inHkAaIl3vsK+Fjw+lHI=;
        b=dZT/jqEjKm++iYHAqdjkdtlWrlZwOqIlHnBMRMaFGBideXsHpNQp8Ujte0aXxJ2vgX
         Whr2KfgOALp8eYCbYEi+mEwHN6bOeBM6e/+xbqPaAL0mQiAiieMBD8KYbRnGGvBFkMWk
         T0Uk+EIDjbGUU4TmXQkHbe4VSO3u6CIAma1iHhTEExxGuNfO89YJvgPKpcnnp1Arw09F
         0Pi5bbkW2kuyX+07av9evr8ta1on5etY+cq93fxc4194n8a9apbf6c4xDStqDu20hZCi
         dkwJ6OWoeK/5WTs3T9W1WZJQf3b43XMHTQ7lDk1teDHLwWdz+7uGgbL4XENzA5XEgrCD
         3M9A==
X-Gm-Message-State: AOAM530VfG7VDAqwlSUz8o/4orZ2WKOoR2DmlzO/Ane9yPTA5i6fqfgL
        EiS3g+7gnh9A1yE6RGd4qrlr9fma
X-Google-Smtp-Source: ABdhPJx5tPbPKLKMLowtMIE2csBQN8Rnnx6oowjqxtndjKV4ldt29A4e6OiREVLxPmzc0/OQLBmf+Q==
X-Received: by 2002:a7b:cc0e:: with SMTP id f14mr16287462wmh.39.1590911829138;
        Sun, 31 May 2020 00:57:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:a5a8:2d13:1520:7eae? (p200300ea8f235700a5a82d1315207eae.dip0.t-ipconnect.de. [2003:ea:8f23:5700:a5a8:2d13:1520:7eae])
        by smtp.googlemail.com with ESMTPSA id s8sm13543669wrm.96.2020.05.31.00.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2020 00:57:08 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] r8169: change driver data type
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
 <29eabcd4-fd77-58f8-3091-acc607949e28@gmail.com>
 <20200530221717.400033de@hermes.lan>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ccf8a37b-203c-8b54-958e-757d3e9088e5@gmail.com>
Date:   Sun, 31 May 2020 09:57:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530221717.400033de@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.05.2020 07:17, Stephen Hemminger wrote:
> On Sat, 30 May 2020 23:54:36 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> Change driver private data type to struct rtl8169_private * to avoid
>> some overhead.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
> 
> Are you sure about this. Using netdev_priv() is actually at a fixed
> offset from netdev, and almost always the compiler can optimize and
> use one register.  Look at the assembly code difference of what you
> did.
> 
When saying overhead I had the source code in mind. With regard to
the generated code you're right, however no hot path is touched here.
