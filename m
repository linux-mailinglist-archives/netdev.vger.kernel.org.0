Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A71F831
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfEOQJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:09:35 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:42868 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfEOQJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 12:09:35 -0400
Received: by mail-pl1-f172.google.com with SMTP id x15so91542pln.9
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 09:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pwkvs2hdOjoHkHDXBWPAGLUIiVOYRWfjxY1wZmEBFzU=;
        b=CEjS7R3l7nEAKvxXCUNsAEaEXpyULf3YP7oiUIUyKt/g/IVk0J17KUAev4W6l5yLDq
         kaF2kYHmojZA7Ztcracld59xJuQf/b4zBrTfKAYSkkDCVzqUfC7suAR3kiNgcV3hVMXW
         GApYjhuNmNPvGASTNTvJAI9SM8CJcQw51eUO4AyU86egiKt2V+1BAv6TIISF+Lbc0mRd
         ZOF8WbhZhFbKOaUifzw0EsT+vxWfvR5Hp7Ta+op0KINJIbtz+guWj/yNGT7buGTHei4b
         1NzGC1WGa0uD+GXbrvttlfSMtBW6Vk2Q8GacErIsSqMaQS4PQvEmqqXXIMNC443XXEDT
         t+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Pwkvs2hdOjoHkHDXBWPAGLUIiVOYRWfjxY1wZmEBFzU=;
        b=OGwAHsrQXCDTtcYQTJeYZUOs5Vj9LD+P8gebaUHl1ns4paILREg8gVQqSJe2j9BUIi
         Rj7Oyybp6AIv2Uup/ZsLPEBEraOqvG3FJ/Z0y/N1sRCWPBWzykm+Yt8yX8/AMxp6c/aU
         GkUTG0lB1iWfoL4YoFezMhXQPRUyn9LdNKhFWlBcmHph3+uCbhnU1Q2qW7A35cNPX0Sd
         SifUHFXXqhoGZjeaBPivDtICID7jZ9setRXNeB2G4p3cnGvU022aGICHIJqEoGdl8Uaq
         ggnrYPCa6hu+S3yzIFl4ie1CwkdHGXhm9b3wrkEBuopD4PqeBVOGyg/IOCJtdPEVno+c
         9++Q==
X-Gm-Message-State: APjAAAWvYsRbo9kYhMzfloyPQQ5j20HBtaq4JUOQCIzRtCfojiKha3On
        Oz/EdWFWuJAIUuik8GglRaE=
X-Google-Smtp-Source: APXvYqz0NB/b0vi26AKvNxv8tjtH7hzZ54O4vh3WtMnvt75CzbMAOGVqPzYg767454TLasTYI+DFsQ==
X-Received: by 2002:a17:902:d892:: with SMTP id b18mr282706plz.216.1557936573859;
        Wed, 15 May 2019 09:09:33 -0700 (PDT)
Received: from [10.67.49.52] ([192.19.223.250])
        by smtp.googlemail.com with ESMTPSA id 135sm4738925pfb.97.2019.05.15.09.09.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 09:09:32 -0700 (PDT)
Subject: Re: dsa: using multi-gbps speeds on CPU port
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20190515143936.524acd4e@bootlin.com>
 <20190515132701.GD23276@lunn.ch> <20190515160214.1aa5c7d9@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <35daa9e7-8b97-35dd-bc95-bab57ef401cd@gmail.com>
Date:   Wed, 15 May 2019 09:09:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515160214.1aa5c7d9@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/19 7:02 AM, Maxime Chevallier wrote:
> Hi Andrew,
> 
> On Wed, 15 May 2019 15:27:01 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>> I think you are getting your terminology wrong. 'master' is eth0 in
>> the example you gave above. CPU and DSA ports don't have netdev
>> structures, and so any PHY used with them is not corrected to a
>> netdev.
> 
> Ah yes sorry, I'm still in the process of getting familiar with the
> internals of DSA :/
> 
>>> I'll be happy to help on that, but before prototyping anything, I wanted
>>> to have your thougts on this, and see if you had any plans.  
>>
>> There are two different issues here.
>>
>> 1) Is using a fixed-link on a CPU or DSA port the right way to do this?
>> 2) Making fixed-link support > 1G.
>>
>> The reason i decided to use fixed-link on CPU and DSA ports is that we
>> already have all the code needed to configure a port, and an API to do
>> it, the adjust_link() callback. Things have moved on since then, and
>> we now have an additional API, .phylink_mac_config(). It might be
>> better to directly use that. If there is a max-speed property, create
>> a phylink_link_state structure, which has no reference to a netdev,
>> and pass it to .phylink_mac_config().
>>
>> It is just an idea, but maybe you could investigate if that would
>> work.
> 
> Ok I see what you mean, this would allow us to get rid of the phydev
> built from the fixed-link, and the .adjust_link call. I'll prototype
> that, thanks for the hint.

Vladimir mentioned a few weeks ago that he is considering adding support
for PHYLIB and PHYLINK to run without a net_device instance, you two
should probably coordinate with each other and make sure both of your
requirements (which are likely the same) get addressed.
-- 
Florian
