Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580D44A9E44
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377061AbiBDRrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241900AbiBDRrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:47:48 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C517C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 09:47:48 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u130so5727943pfc.2
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 09:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lhpvEWeSFUEAZeHd3s9WYijm4dL6IvaJQGi10BKsQRw=;
        b=EFHH5LBlpSkwBsmPMXQpRVcfSwGDD70ze99wgcmHje0Yqmoh4fxzOKLYu9Fz4PRjOj
         oZZHrySr5I8el6AHAURhxz6OCaQJMILX3lHgDMf7JVRzOVtWe9TPP4qqmpFBMNG5ElqB
         /bKoIlt3vnLkgW11tdIJNqQbN4fR3rcbiA0d2khjbV15aTi9KtN6z4GQJltYzaDdMURb
         ny/hkLElIdKAEt151WEfmJdCVSAGXG8bpPDJFII2+jHipGJ+1C6ABAW9l1kQLcEkoOJN
         n/ijQtNEIBFfdfLodNQcvLqjdzXB3sb2gWmWM1rN3HgHXbR6h2l7k/S8MYIwDtXDu7dI
         Emdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lhpvEWeSFUEAZeHd3s9WYijm4dL6IvaJQGi10BKsQRw=;
        b=ZmVzSg217pggYX/iRlkU2rVoi+FZD8p2ZyiGmQF6JHIKj94M7opNG8cxHvDIfrEVar
         jFL19ZDZPZqDUKGUE5PQaMDmElq4g7ZPdCFkryybJg6w9tFxQQgiTq5wZlTWI0Uhd9Ua
         Ar+JOHe0mfP/C+xBb9BmGqwCtMnUA6kdDbadzjTByveAc0mUfGMWOht5ltp/UtCTfDvt
         vhnV3Ti+w4j2hcl45nnvv0vSivTPrOzKSWhW3vJbt3QY9QTLkdiKh2h+kojMLQ29Wj3c
         ROYR5uKecqTPfi9LM1s0kypX9FwzgksU+iPCdF/wZ/pn/49ulugIja5Ey9Eb9PgLL3zu
         Y9oQ==
X-Gm-Message-State: AOAM533JQTEnEN95ARTrkwSQJGlCY6XXpioSMlO9JAPFeYMp3yT3+QhM
        OhwoNrNQ3hoUES2XaQDMNYs=
X-Google-Smtp-Source: ABdhPJz7+FAZn/m/pkf+8Rejy7zg6hYwasGHgPFqNFYSYcUu7C8Y6H+wSWHZg3C3VQyl/a5yFb+Z3Q==
X-Received: by 2002:a62:7a42:: with SMTP id v63mr4123476pfc.61.1643996867867;
        Fri, 04 Feb 2022 09:47:47 -0800 (PST)
Received: from [10.230.2.160] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id nk11sm2700727pjb.55.2022.02.04.09.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 09:47:47 -0800 (PST)
Message-ID: <6d54004e-f6e7-97c3-a0fc-6a83c162175d@gmail.com>
Date:   Fri, 4 Feb 2022 09:47:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: dsa: realtek: don't default Kconfigs to y
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
References: <20220204155927.2393749-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220204155927.2393749-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/2022 7:59 AM, Jakub Kicinski wrote:
> We generally default the vendor to y and the drivers itself
> to n. NET_DSA_REALTEK, however, selects a whole bunch of things,
> so it's not a pure "vendor selection" knob. Let's default it all
> to n.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
