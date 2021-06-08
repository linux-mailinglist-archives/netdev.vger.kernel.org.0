Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9FC39FB50
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhFHP5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbhFHP5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:57:38 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA23C061574;
        Tue,  8 Jun 2021 08:55:34 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id i10so32868705lfj.2;
        Tue, 08 Jun 2021 08:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aZh/KJwO8W1tFE9F48++OjyHYLEODwVik0fvHY5TiCo=;
        b=rjk4hJdu1uU/8uWY4e0Sl7ziWtWOg5iYymqnyRzCip+mRccItnyJcYInxiXjVydbD8
         BrQBldsl6aTZAN2JJpKDB4iau38AgYV/AVYnxDYA7jkaaoZ8VYuw0ZgCzSwjmeH4il7q
         MxOVIeBMrmjDroADas0r3YC0+HRUXdjZvj/aF6weP59aeCRaS0Fe61olQbRDvOpg8tDR
         IR8usPANQ3QW8CvtQyDSUmbXGXoowv3pzpq60TbVvja4nzSk3HFwAH7rJEO+ScMK1zyf
         sFwsXTH3PNP5xNUHCZL9VdzhWxydi6r7bQefGEYQDxIrmaCMBIVCfqiCZzeuvNgtwmKM
         wDKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aZh/KJwO8W1tFE9F48++OjyHYLEODwVik0fvHY5TiCo=;
        b=M02OAECjKHEejc8+ov8x1vEF72xXhEsWT4H/2AJJG29F6gA2f4hAa8MapwUC2FdKid
         JUNQrNTjEcemp4uXYRGeraisvvTLL+f0013DCRFPVbLj6cheTQl8HUIunDwmzQqxXf/I
         qIDEIheqqMuri0PDViE4DuE8c2XTD4EZakzbqhh0yIF9rbucB36hesrhi/7ROFSFKPfN
         W418kWpApAzR5hvwtm3j5I1KnVRhXkZMmZEWCW1VwiIRvq7dLu3l3fpafpD4TCXiNMXO
         1lfh1Jlgdj7Wc9Cbeb2augS5LQQuL2yAoXO4cNhtbbC3BtAvq8VlTLzihdZ36nCyfacE
         hk5g==
X-Gm-Message-State: AOAM533qKk6a9T9PKNexRn2WjE92su/iK5FGBecDqVmMqv/RUZRhicm5
        DrYmtK3g1tVpf4/HtdFxv+/rQwKoKRs=
X-Google-Smtp-Source: ABdhPJyN9SBB8qc0vj6SFooN4RdERXoRPeSCbob/3uV4XCr+o3nB2RQrAxs14c8fi4us4OEskObbJw==
X-Received: by 2002:a05:6512:3f81:: with SMTP id x1mr7872509lfa.426.1623167732643;
        Tue, 08 Jun 2021 08:55:32 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.86.136])
        by smtp.gmail.com with ESMTPSA id t24sm15300ljj.97.2021.06.08.08.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 08:55:32 -0700 (PDT)
Subject: Re: [PATCH net-next] sh_eth: Use
 devm_platform_get_and_ioremap_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
References: <20210608135718.3009950-1-yangyingliang@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <365de7ff-fb86-db19-0ad2-13355646c09b@gmail.com>
Date:   Tue, 8 Jun 2021 18:55:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210608135718.3009950-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 6/8/21 4:57 PM, Yang Yingliang wrote:

> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

  Is my understanding correct that you tried to convert the ravb driver too
(and failed)?

MBR, Sergei
