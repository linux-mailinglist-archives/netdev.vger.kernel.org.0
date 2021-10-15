Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A5B42FE4B
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbhJOWoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbhJOWoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:44:07 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07B0C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 15:42:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so10323601pjb.5
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 15:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+JT4uWJe2lAG86rhYFZpxUZYD/s5UxqcXEsRxu1qbeI=;
        b=Nv/AGEPSbXBo63/4eWX/P9Gd17yYMCFz5yEFKB3eRN1VN0NBEQhjcTDqkKs7+kRqIW
         U6t6dbcJJGXFAOyaOsJ5PktrzJGauHcwUhuAxmaF9UojsBJEVbNVdLOqOE1Mrm957XLU
         7BtRCdJ7JdtY1rN081B+2M+feG1Oa18P2aI7NI3+U+4zbOBCYewyP96Dk64wo1I1sKqP
         endkKY6PwuNvDyIHWyFzO82ftBjxrdbUfjOIaqHXfax5jSRuppDBKoWkoSkzQdBVbEIg
         1j4XnfF5kfIyLfo6qKVVTu02n7wiML/KLtJjLPBDopothaAZxt4EnNs4ctZAPXXjHT3h
         U0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+JT4uWJe2lAG86rhYFZpxUZYD/s5UxqcXEsRxu1qbeI=;
        b=M7waD0wqdlOankNi6YVYaP/93c3NIZRcgITh2jFeuWmmfqR9CVrOkJJfxxPBVkMOQp
         myyawxLTbreFrAU1aat4r7vhnfFkEV4XCb+uIwbdNE74vkFqjX0WjFZmx21PTtPMPRDg
         9kYJGXGg9T3olnVaSH8bGpcYe182OT/RW2QylPiVxWfvnSy0mz0dkCtAv+KFVR8oTQUd
         HSQYOF1IrhaZUS+9r5nbOSsJ9plV5sapvkh0/zbL49okxwYAZOrqG/fKckNnjbKaroiC
         v4yCKKZy23hryAPJWdVgqJqISORY+TFsNrK1dCAbGH7178pRojfVMqbxSFq1nXNSVeoZ
         cK3w==
X-Gm-Message-State: AOAM532ZpWManjMCaSGUSLeakXtVHrmsJLbLZDpFccgHmvQkAoWn6PhN
        5FJq56JDKuLBl/ermZrdthmsfPm6B+A=
X-Google-Smtp-Source: ABdhPJyv69Qxgjsue4v7s8P1XtEJP16BOTe+sfds9KiZn6V30EEEONy5P143THsBk77g8+4oGABHxw==
X-Received: by 2002:a17:902:e8c9:b0:13d:dae7:1d5b with SMTP id v9-20020a170902e8c900b0013ddae71d5bmr13210369plg.39.1634337719759;
        Fri, 15 Oct 2021 15:41:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d60sm11857742pjk.49.2021.10.15.15.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 15:41:59 -0700 (PDT)
Subject: Re: KSZ8041 errata - linux patch
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20211012035650.GA10335@francesco-nb.int.toradex.com>
 <09cc480a-eaa6-48cf-859c-48387f448e2f@csgroup.eu>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <697dc669-c733-d1e4-6559-432b2ef9400d@gmail.com>
Date:   Fri, 15 Oct 2021 15:41:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <09cc480a-eaa6-48cf-859c-48387f448e2f@csgroup.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 2:36 AM, Christophe Leroy wrote:
> Hello
> 
> Le 12/10/2021 à 05:56, Francesco Dolcini a écrit :
>> Hello,
>> I found out that in 2016 you tried to push a patch to fix a KSZ8041
>> errata [1],
>> what was the final conclusion on that? We have a similar patch in our
>> kernel
>> and I think that this should be really merged upstream.
>>
>> [1]
>> https://lore.kernel.org/all/2ee9441d-1b3b-de6d-691d-b615c04c69d0@gmail.com/
>>
>>
> 
> I think I never got any answer to my last mail and it stoped there,
> without any conclusion I guess.

Yes sorry looks like I should have answered that better. Being on the
side of caution makes sense to me.

> 
> I can't see my patch in netdev patchwork so I guess it's been discarded.

Yes it certainly was.

> 
> If you have a patch feel free to submit it.

Yes please do.
-- 
Florian
