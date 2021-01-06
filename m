Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABDE2EC2FC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbhAFSLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbhAFSLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 13:11:22 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A16C061575
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 10:10:42 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id 91so3247272wrj.7
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 10:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oM0Cuq3dSrYXojj/4DTPJrX2JjGCoSwtYzOYC5eENw4=;
        b=ujEcDF8Ia0kDg7IgQBZNJ2J4f8o7t1xrvelefCEZROp6CsQHtM9FF1lh0VM+nxxe6k
         6U6caE/IM9iAZrlG3xBqGQAHvA1sxP+FinFgYOdbnmTzETizTVkacwBi8LhMIRbkMoAs
         AgW3NjvAoAlhFb3dCA01Ejh0zdkEKkyLoO2516iGfvjbv40ldUucY4/LRld00FBXM62i
         QCfE+0Bz4LIymh5WxWJClS1djtdtLTTADq2rDK4sQI0ZaYNhuoryUAdbu/ET94xS0tIU
         DPFWmLhobd0oX21UqJbCjmKTDMqV0coKsBh1M1CbYvbGQ7W2YWDQ9x4FBQp+IWB/f7kq
         HDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oM0Cuq3dSrYXojj/4DTPJrX2JjGCoSwtYzOYC5eENw4=;
        b=UykkyDwkpIGrU/yZoFtMKUy6RlOuwt0STvl2g6mHHEEvlJpASDfSJWrZ+HtF4AMwcN
         SMofkXvUzBjBHQ8xrzMT1KqkU0pD557yIyKjzbsbnJ8UFVAjzI8h6l+rS/EMzFFonRSf
         QfT6w0QzGdR0foOUwd/WgfeZqjIBfumErjcCohXcYbklM7ATn7t+uTSMfOLh7Gbhpv1l
         cNq6C7KmuD9JMKTRRVp3V/WYHVMTjVhLLHNPDUjI28FWIrrohSuxyGwpZHiEWDTzA5wW
         CnWwR77Kt1xZL8mHIu77fdyi1OHHwNMLVkEnAzSAS5n5Z6mm+rgM5+Jksx57ZI5jWShq
         aoSg==
X-Gm-Message-State: AOAM530nJCwp4BpjibJGsVI5M4Y95HrI63YE4L1mNdLrCCPizXUm0KXD
        apFplx7xFnHlThUM4sbU/KTeJvsyE8s=
X-Google-Smtp-Source: ABdhPJwHF/r0tUtqWxpq3W+cMrNccobmNAQNHOmp+Ltw+QMxVgjvvN1t7v7LpczV8QLEMdnt8MMK1A==
X-Received: by 2002:adf:e443:: with SMTP id t3mr5344200wrm.366.1609956640658;
        Wed, 06 Jan 2021 10:10:40 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id o23sm4308788wro.57.2021.01.06.10.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 10:10:40 -0800 (PST)
Subject: Re: [PATCH net-next 0/3] r8169: small improvements
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
Message-ID: <8b5980de-2c6b-d2ca-e5ba-f93a839099c7@gmail.com>
Date:   Wed, 6 Jan 2021 19:10:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.01.2021 14:26, Heiner Kallweit wrote:
> This series includes a number of smaller improvements.
> 
> Heiner Kallweit (3):
>   r8169: replace BUG_ON with WARN in _rtl_eri_write
>   r8169: improve rtl_ocp_reg_failure
>   r8169: don't wakeup-enable device on shutdown if WOL is disabled
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 

Just saw that this series is marked "doesn't apply on net-next" in
patchwork. I checked and indeed there's a dependency on prior,
not yet applied series 
[PATCH net-next 0/2] r8169: improve RTL8168g PHY suspend quirk
Shall I resend once the first series is applied?
