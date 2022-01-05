Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEF04858D3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243295AbiAETE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243276AbiAETE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:04:27 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19598C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 11:04:27 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j16so302505pll.10
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 11:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l8VvPS6lCyPlbXouxv2JnwXYxLAW06jmJ3HQTEX+tOc=;
        b=Wq9ZhGG2I7pF/rDFMHcc+P65xazvUcB0YEJGVygc8gQK9ecZzYjTLF23quaYVF7xTu
         xe7Any3SAdKOlX5UiQrPdurKtthUtvvqCjhp2sKIeJuyHNc23uzAJmohcEdnUbueyx2p
         nd6V51kJtBVvYSg7GOu8OugmbdGVa1ac/jY1xhkmmjmESQviGPqxiMdVUSMOCnhl2co+
         7pkSkgahy0ZG6AgwuEL/0I/ifKeA1rPlpR4r9+6Segtc6OfaG7IGLmjvnvTGE7mtftCY
         3AIoZRABXwkErod2DaG4ZG3soLwFviAOuHPL1KrVGMw2aMOrUAn7WAGuC08H0NQ7ege6
         n1Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8VvPS6lCyPlbXouxv2JnwXYxLAW06jmJ3HQTEX+tOc=;
        b=u+M6tFLRKFY1aPIT7Ony6Z5gK+dCVvgnlHEcBZSsMjjJPDkULxHPM7pG8LT2REC1y9
         mw2BkfywBkpqHpjtfuRicOtsgqI2LJCx28luCQRaO6edEh9gkl7eciMCDR4oYXE9nRUt
         PIEvXvACCkXNCKs9+pCvpdHdDVBVs6RzQ0t5Ukp08chZUoPerOoR3onS7Sc6FElno650
         gtPXO4Qfu2yNRP9Kfb/e25mYSMZVIbrIqkO70fuyayhs9imixfrHvGah7lA605qMKd37
         +4yqs7OZr1KGyav7IfDpEO9K3hsKPpoIE1kyTUjln99BVnXapJdycCVWao4Cey12ybhw
         5aRg==
X-Gm-Message-State: AOAM530CZ4fBAMdEqIfkNn3jcz14zevQc906bm4JO6uHgtm5lJMutyd1
        oFqlfnmAGt/k/IEss3LkXJg=
X-Google-Smtp-Source: ABdhPJzV1BfDK1VQOM1D0ihc6lZEN1gw3St2/g+HuAH5rIsTR6nl0QSGKZ2l6EQLNVeX7xVqI1Zp2Q==
X-Received: by 2002:a17:90b:1b46:: with SMTP id nv6mr5718428pjb.161.1641409466579;
        Wed, 05 Jan 2022 11:04:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w5sm44322667pfu.214.2022.01.05.11.04.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 11:04:26 -0800 (PST)
Subject: Re: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
 <f6d50994-6022-be0f-4df2-1dc3c8199c09@gmail.com>
 <20220105185901.hprorcjw6api4bwc@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cadbfac7-0f20-baaf-d559-d9fe62f08856@gmail.com>
Date:   Wed, 5 Jan 2022 11:04:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105185901.hprorcjw6api4bwc@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 10:59 AM, Vladimir Oltean wrote:
> On Wed, Jan 05, 2022 at 10:39:04AM -0800, Florian Fainelli wrote:
>> On 1/5/22 5:21 AM, Vladimir Oltean wrote:
>>> This series contains changes that do the following:
>>>
>>> - struct dsa_port reduced from 576 to 544 bytes, and first cache line a
>>>   bit better organized
>>> - struct dsa_switch from 160 to 136 bytes, and first cache line a bit
>>>   better organized
>>> - struct dsa_switch_tree from 112 to 104 bytes, and first cache line a
>>>   bit better organized
>>>
>>> No changes compared to v1, just split into a separate patch set.
>>
>> This is all looking good to me. I suppose we could possibly swap the
>> 'nh' and 'tag_ops' member since dst->tag_ops is used in
>> dsa_tag_generic_flow_dissect() which is a fast path, what do you think?
> 
> pahole is telling me that dst->tag_ops is in the first cache line on
> both arm64 and arm32. Are you saying that it's better for it to take
> dst->nh's place?

Sorry it stuck in my head somehow based upon patch 7's pahole output
that tag_ops was still in the second cache line when the after clearly
shows that it moved to the first cache line. No need to add additional
changes then, thanks!
-- 
Florian
