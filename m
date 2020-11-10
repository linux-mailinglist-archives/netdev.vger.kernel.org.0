Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EE92ADABC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 16:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgKJPqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 10:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730473AbgKJPqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 10:46:35 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7691C0613CF;
        Tue, 10 Nov 2020 07:46:35 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f27so7104917pgl.1;
        Tue, 10 Nov 2020 07:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AcFM/EuVKbjv1pQYxCwt27+aZHf/0/KuF9UGqw/H5YY=;
        b=Vl8jOYw+K0/MsjQK6pkFeydne3AwS4B0fBt5MOsTt3qQI1CfRUXbDf655Aqb1LxjdH
         4eCrU70qRgmvSHNfGxbqo76RnrYLddvPp1MjpsU7BbnZl2DaRKUTrTknCXDnwPRz7DpM
         jP9QEg3Z8/XSn/QhnQhWYSDHcI7G6EuNVGqR3pGZEtqDbZ2EjjyEdW/aRyaDPVXNhQ6J
         YeOGGIMC/1/ur++2muPqjNg7khY7ZCN4enIaJTuY68iYJFlN9f1fRhe8eUxX2Txmc4qL
         YSsICC7iKOcKzQLAx/wG/lnUGYV9uOqqVPab8AjkLC50aDByVN27xhXFnJXsVe8XXjN7
         0o/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AcFM/EuVKbjv1pQYxCwt27+aZHf/0/KuF9UGqw/H5YY=;
        b=pddoYDNZ9RK5xhsQFMFxhiaV6ZFl5QSMMQU4cTi4bTXfhxAasPsErOVWiQ/Ndj0yGW
         oh6HJIDu+q3PjfviTBkMuZEjS94ZPK4SKzDmqzv6vrU4yEQORZYuxGC1oYsoaL1zoPy3
         Xgkb1nD9901AfZuLEYYVSikJqz0FQJnZ44YRAmq6cqpPFlxCDuNsJ9Bw1Nhs/abng1iv
         CUozWAswnb31izcDeP8DB12H554RaSoH4di/UNuutrk5UkGLeMgPzPmL3rXDC7AxAU9X
         VowBvZyyT8AZAfviLqb0R8+8lwVrOIWiTEt0mZvcydwl5DayVN3Y1vX7dxLQaMVRf/PR
         31Dg==
X-Gm-Message-State: AOAM533XD969b6oiae/xdGAHE6NSv007RZI98QDwqWXpwzJLErEULRZY
        IuTP7pkBS8czerFLYf/SxtE=
X-Google-Smtp-Source: ABdhPJy2wDnpRzvwvYIm+TyDlcXLiOmjA8iPxfSVvHbLDBUQ/UkV9CRDhlZ4g6ntt06FhO+KfTu1Vg==
X-Received: by 2002:a17:90a:fb90:: with SMTP id cp16mr298146pjb.232.1605023195251;
        Tue, 10 Nov 2020 07:46:35 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y9sm3198371pjj.8.2020.11.10.07.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 07:46:34 -0800 (PST)
Subject: Re: [PATCH 10/10] dt-bindings: net: dsa: b53: Add YAML bindings
To:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-11-f.fainelli@gmail.com> <871rh18i0y.fsf@kurt>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <caaf6b8d-c760-aca9-b23c-77357ec893f1@gmail.com>
Date:   Tue, 10 Nov 2020 07:46:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <871rh18i0y.fsf@kurt>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2020 5:21 AM, Kurt Kanzenbach wrote:
> On Mon Nov 09 2020, Florian Fainelli wrote:
>> From: Kurt Kanzenbach <kurt@kmk-computers.de>
>>
>> Convert the b53 DSA device tree bindings to YAML in order to allow
>> for automatic checking and such.
>>
>> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
>> ---
>>  .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
>>  .../devicetree/bindings/net/dsa/b53.yaml      | 249 ++++++++++++++++++
> 
> Maybe it should be renamed to brcm,b53.yaml to be consistent with the
> ksz and hellcreek bindings.

Certainly.
-- 
Florian
