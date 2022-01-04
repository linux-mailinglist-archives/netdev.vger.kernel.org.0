Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F34484974
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 21:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiADUun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 15:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiADUum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 15:50:42 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D97CC061761;
        Tue,  4 Jan 2022 12:50:42 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id o12so84456985lfk.1;
        Tue, 04 Jan 2022 12:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=EjryExnOSq4dLeyWm3Isjwd0cUDTf9sRGTIsbX4M24E=;
        b=kEFms5/sg1qgwfm5lf7/gV3Ucwxf1Cy7AxcId4EODduFLNcpw1YadUNxqj1WFw4D3O
         6+JudO1H8looRWUeADN2f/1i9UZKES2VhI1aqdXZ6Ly5ENJB1lNvQyar5FjH2Ff8WLl6
         JpQMzuZlpkCnJWc6cLGepOunV6ooNnh6bBq7R/F6alQTZe4JpfviatMq/EQGTYNCviBX
         58ZvexEnx8B4WwZGLg+ngwdTJysUirolvjcS710dVD9y1eF++62+q8inJUfGO6YS2SUd
         MyQXBBu11J+86K1Y/BRpMpEUTHLitEt1hzKPz5pNj6lsn7h0nZGszf6UkuiQVNX2d3gN
         qaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EjryExnOSq4dLeyWm3Isjwd0cUDTf9sRGTIsbX4M24E=;
        b=647UPbciXo95QDawgQ33Hqb+mfb9snvJZ9VaKt9p5A7C57Hm5mtN3rnlM8XGUq3bJs
         Gdh4KUIKd9eG1ZfK2d9NrZEk4nA1mqp3df4JKk/2bCvh85jIlWrCSTG3u/3jtHLVNCTy
         iPhaRI3MVDCtr13CybvmM9OzjAKLb2Un1qaLs+K/2BJjApHGQ24fHAC+BHnBamEt9Bq+
         Zuz82oHkXAYr2XIklu0MOMb2sMrZesH9A0OHI1y3lhFSi+7u4ccB44ViVjwiJi9ICEhE
         /3l7vw9Bi/S9LoYPbfXEmShmVKUu7Hh7yA5tUQp9O9E2Gmqw4svlOpNgiSiruJnaIPfL
         XLHw==
X-Gm-Message-State: AOAM531++rO0VkVukMjNYE9P5tB+NlD14ikOt7EPiIXvxnPtQtrWZDP6
        /69+01hzB5iKyNf8Rpa+5HAHA5tmUQk=
X-Google-Smtp-Source: ABdhPJxhZKWcCcVetwFMJFuk7b2EQb8yFctry5Nz99KjfmvxXkUUMfQjTQlsNlbzRv9gPVjgSbA0Xw==
X-Received: by 2002:ac2:4892:: with SMTP id x18mr44383601lfc.457.1641329440403;
        Tue, 04 Jan 2022 12:50:40 -0800 (PST)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id h16sm1195480ljb.81.2022.01.04.12.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 12:50:40 -0800 (PST)
Message-ID: <49a2b78e-67a8-2e5c-f0c4-542851eabbf2@gmail.com>
Date:   Tue, 4 Jan 2022 21:50:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 3/5] dt-bindings: nvmem: allow referencing device defined
 cells by names
To:     Rob Herring <robh@kernel.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20211223110755.22722-1-zajec5@gmail.com>
 <20211223110755.22722-4-zajec5@gmail.com>
 <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
 <f173d7a6-70e7-498f-8a04-b025c75f2b66@gmail.com>
 <YdSrG3EGDHMmhm1Y@robh.at.kernel.org>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <YdSrG3EGDHMmhm1Y@robh.at.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4.01.2022 21:16, Rob Herring wrote:
> On Thu, Dec 23, 2021 at 10:58:56PM +0100, Rafał Miłecki wrote:
>> On 23.12.2021 22:18, Rob Herring wrote:
>>> On Thu, Dec 23, 2021 at 7:08 AM Rafał Miłecki <zajec5@gmail.com> wrote:
>>>>
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>
>>>> Not every NVMEM has predefined cells at hardcoded addresses. Some
>>>> devices store cells in internal structs and custom formats. Referencing
>>>> such cells is still required to let other bindings use them.
>>>>
>>>> Modify binding to require "reg" xor "label". The later one can be used
>>>> to match "dynamic" NVMEM cells by their names.
>>>
>>> 'label' is supposed to correspond to a sticker on a port or something
>>> human identifiable. It generally should be something optional to
>>> making the OS functional. Yes, there are already some abuses of that,
>>> but this case is too far for me.
>>
>> Good to learn that!
>>
>> "name" is special & not allowed I think.
> 
> It's the node name essentially. Why is using node names not sufficient?
> Do you have some specific examples?

I tried to explain in
[PATCH 1/5] dt-bindings: nvmem: add "label" property to allow more flexible cells names
that some vendors come with fancy names that can't fit node names.

Broadcom's NVRAM examples:
0:macaddr
1:macaddr
2:macaddr
0:ccode
1:ccode
2:ccode
0:regrev
