Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960C1193346
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCYWEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:04:14 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42041 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgCYWEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:04:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id h15so5405306wrx.9
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 15:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RRqAtKBBX462JsR+nJIDZwiVezw74cfKbhGGhDaChZc=;
        b=gisamVNkHB9I8y4//Zm0PkQHT35GinIuyMY0OSYadxi6ue07u1Qt4KaCw8UmBNJioL
         Okc+DdNWRoZ//BEGUuLoChXsAj4379cUufKjLKpSIaxm+44Nk1WoJmuRPzRFcVputyJ0
         Hs4i/QmloPg0Z7MAE8aujcp6mEKnVmn0veOVXirnEwHYooTRB9lbAwZ6bEy6UL3fliGM
         mO1EoshVO06+UO9bqQzEpF3ISMSGq0y1bGoGOuTIBkOvJoTicijaKPTpw9fJHfHQYEbi
         xZZLkEk8skpJfWnzP2kT1UtYlNNUK4nuHZUu3349HZoQgiFLhFORMtZ88IyEu6BgO31A
         WD4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RRqAtKBBX462JsR+nJIDZwiVezw74cfKbhGGhDaChZc=;
        b=YC6UdGEK5hHo4tFj8d1jfuN4tz9RLCp/xBUZSGVk07ndB+dXYneWyZFFB3i8roSAmg
         SE8qrx5jtcpufGlhj+17vkjF7pFZRGTRizQ8tphJpZQCQuoTcBXqX7SLze5oKeEXi1i3
         rmLaAcLZ6AThDiAX1xb5z3dkgjAHbNieA4xngNXb/y6UgcqOiCSbgfKLfKNH/lT1fwo/
         +kc5EH6eXZQaohuE7PJ1oFRhHAphDnfkPU07ZzelQDCBvhhH/fojjtM6iIBV3KjLPkMM
         U4YwXjz/233MlTK1Qk7LoABfLdZMEdhBpSonHjKylpWdpIEWDSAb+qwsNlulMbDikqXB
         vpGQ==
X-Gm-Message-State: ANhLgQ3PKhg6FGg5pInj33mX5VhKEwZvZYgDIv+Ozcs3P1EdKuCujNNv
        2emaasBOAIqoBtDP8DwUXNw=
X-Google-Smtp-Source: ADFU+vuxB+Nzy4XxLyYTdVvENRudGpcArMDCj0UnR6B13pUHEVHWVnbyW48M8vEK6fBOUSD842Qt9A==
X-Received: by 2002:adf:8164:: with SMTP id 91mr5489357wrm.422.1585173851878;
        Wed, 25 Mar 2020 15:04:11 -0700 (PDT)
Received: from [10.230.1.220] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id 61sm458476wrn.82.2020.03.25.15.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 15:04:11 -0700 (PDT)
Subject: Re: RFC: future of ethtool tunables (Re: [RFC][PATCH 1/2] ethtool:
 Add BroadRReach Master/Slave PHY tunable)
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Marek Vasut <marex@denx.de>,
        o.rempel@pengutronix.de, Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>,
        Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
References: <20200325101736.2100-1-marex@denx.de>
 <20200325164958.GZ31519@unicorn.suse.cz> <20200325215538.GB27427@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <2b3973d0-0c41-c986-5f72-e03a5fddce55@gmail.com>
Date:   Wed, 25 Mar 2020 15:04:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325215538.GB27427@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 2:55 PM, Andrew Lunn wrote:
>> What might be useful, on the other hand, would be device specific
>> tunables: an interface allowing device drivers to define a list of
>> tunables and their types for each device. It would be a generalization
>> of private flags. There is, of course, the risk that we could end up
>> with multiple NIC vendors defining the same parameters, each under
>> a different name and with slightly different semantics.
>  
> Hi Michal
> 
> I'm not too happy to let PHY drivers do whatever they want. So far,
> all PHY tunables have been generic. Any T1 PHY can implement control
> of master/slave, and there is no reason for each PHY to do it
> different to any other PHY. Downshift is a generic concept, multiple
> PHYs have implemented it, and they all implement it the same. Only
> Marvell currently supports fast link down, but the API is generic
> enough that other PHYs could implement it, if the hardware supports
> it.
> 
> I don't however mind if it gets a different name, or a different tool,
> etc.

BroadRReach is a standard feature that is available on other PHYs for
instance (Broadcom at least has it too) so defining a common name for
this particular tunable knob here would make sense.

If we are to create vendor/device specific tunables, can we agree on a
namespace to use, something like:

<vendor>:<device>:<parameter name>
-- 
Florian
