Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C831DBBD7
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 19:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgETRpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 13:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETRpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 13:45:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A9FC061A0E;
        Wed, 20 May 2020 10:45:44 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r3so2141275wrn.11;
        Wed, 20 May 2020 10:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D5JmNuIcmWj9PJckcf8PZ/y227AtBQpRXD26DETlfQQ=;
        b=iV6TViiaeKUAaE1Vp3z17NyAtjiakBJxGDTJ8bc3Q9Ory99wDaqi93QLrL5Ncga3m7
         uDBZGQHgLOz/tcewEnQd83/lpEe7dOsMLbGer9wbl+Wyg0dwnn3tALYnKYMmiwtFSGpv
         zT3d163IIZz0dQbsCWzlO7lZ+gHBAcGEG/rNtjP5PWMzCD6hhiErrVFYOWKR2KwnhoeQ
         AgxMtCPGcSlOK+EbIy13pfY8bcS+SVhq8mkacjoCqcwH8eckb/9bg2NdPsZ0VCd4hh+Y
         4H7V09G7jPauzLnzjK+IWw4+fqKcboC2rOEUkwAlS+9e9jlM8fiyT2D5BlYlQ1xO6U8J
         0BWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D5JmNuIcmWj9PJckcf8PZ/y227AtBQpRXD26DETlfQQ=;
        b=L5xvHvJ2Nt8DOI3bNfnpzCU8LPB2e5ZJmEHcS3jGqayB9EzNsI1QkJM1oBy3EzNrYh
         Gbb7bBnXnw2TOYiSqW1YmCiR0PTQZOPhc7uUzlvGthyuJ6GDtGwb64sEuMkb3MruvBiS
         2vk0TG5UyK/qsro+S7nTHoww6go6Nv94Qzt39UaAtE1w9kgcGv+wwewlTfPxnH6Adr7W
         PTl5FYADfpXeAlw8QZSn1Rhnq4U5O5Habx3ydcj+pr1MfTo2pgapzmHENRSHZ/hu5ixd
         G1mJ3f0tbqZcDsvSWIOKH+Re3M0v1twJV7mLEJSEEIaAfPyehCLx0UkZjvwxMHlFnY9E
         OAQQ==
X-Gm-Message-State: AOAM532iHwJGXcGXJ2p6rK4kA2H8DytuNV8EEEhTldelC+x+F15DW9CS
        zx8A0REoOurJLRwJdVvnNswxqad8
X-Google-Smtp-Source: ABdhPJy6YY7aNDIxqKO4ABtmYK5jM9e9Y3VrQ7CcJdC4/mpJ5nC5Ouh8zCBe5DQbFoWS0+LOcM7nNA==
X-Received: by 2002:adf:e441:: with SMTP id t1mr4597279wrm.347.1589996743033;
        Wed, 20 May 2020 10:45:43 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q144sm3946631wme.0.2020.05.20.10.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 10:45:41 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Dan Murphy <dmurphy@ti.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com> <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
 <20200520164313.GI652285@lunn.ch>
 <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <41101897-5b29-4a9d-0c14-9b8080089850@gmail.com>
Date:   Wed, 20 May 2020 10:45:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/2020 10:20 AM, Dan Murphy wrote:
> Andrew/Florian
> 
> On 5/20/20 11:43 AM, Andrew Lunn wrote:
>>> I am interested in knowing where that is documented.  I want to RTM I
>>> grepped for a few different words but came up empty
>> Hi Dan
>>
>> It probably is not well documented, but one example would be
>>
>> Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>
>> says:
>>
>>        # RX and TX delays are added by the MAC when required
>>        - rgmii
>>
>>        # RGMII with internal RX and TX delays provided by the PHY,
>>        # the MAC should not add the RX or TX delays in this case
>>        - rgmii-id
>>
>>        # RGMII with internal RX delay provided by the PHY, the MAC
>>        # should not add an RX delay in this case
>>        - rgmii-rxid
>>
>>        # RGMII with internal TX delay provided by the PHY, the MAC
>>        # should not add an TX delay in this case
>>
>>        Andrew
> 
> OKI I read that.  I also looked at a couple other drivers too.
> 
> I am wondering if rx-internal-delay and tx-internal-delay should become
> a common property like tx/rx fifo-depth
> > And properly document how to use it or at least the expectation on use.

Yes they should, and they should have an unit associated with the name.
-- 
Florian
