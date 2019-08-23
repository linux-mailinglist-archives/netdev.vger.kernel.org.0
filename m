Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5889B8E7
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfHWXap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:30:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44027 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfHWXao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 19:30:44 -0400
Received: by mail-pg1-f196.google.com with SMTP id k3so6583837pgb.10;
        Fri, 23 Aug 2019 16:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oMdHJyuMlhg4AGNOSEwKfXz3L8EV2TQ5UGMBnZRsz4Q=;
        b=PjfflJPxIox3EMcarZPIbEQ3PlVLfogiEgiOcM3MzF5DAVCxM1WWvoVSEAxD5jEVOg
         y4Yr5SP/TFv0UcXGB+XeaXC/zNm9PTQtiJNTc1iimIXYtzJmXR33fKcrDtEo4/ZVLHHn
         +M/IiJbtifs1dl/Ht44oI1SR5/lMbRWs9dqLGrANy2afCjGUP9oIhFkOnUkS4844h0VU
         t0hZxr0QDZqn/hIwfllAqG2PMR7EcppNn7jZ75aRV6SrtzRSYruZyPyJiIV5e7jS7Kco
         k7fGA+j9E+esluiHvWlOsqJovSzQ4T81yXLb33POT8A8ptZyWTC5t16OFCVA0jonDtBS
         iwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=oMdHJyuMlhg4AGNOSEwKfXz3L8EV2TQ5UGMBnZRsz4Q=;
        b=BVntlPSdUrUPlOEMaCP4cr9QeJROmI0MuhB3LS6R4L5HyEWIK3HkgUfDVurGzuJZF1
         kOy4vsaHogtzRPDNwaQ9Vt3x2xvPRNaYgVh2hspm9Aq/w/J1Yq/EML5YZsLPrcdZRpKz
         yLTOAV84mV8/56Z/y0g+A/h9+qdsC9fU6uyQ1FuPvsLz2NI+FAvHHFcbrHVtl8UmGDV0
         1pONuU1TRnNcN/OTmVHYk4Hr216A7I9OxWLpUcEs/4Cq6OJEJ0/5u5N/PK3xerQMz+tf
         dpAaBlp+zYvXE2bJqRPVTLEJ8Du9tXZop3TNPhKTXQAA+bSzHAUAhwQzg+V853ZR/9ak
         uPcw==
X-Gm-Message-State: APjAAAUHHAyCqCL4xQQCZHoEahXQgP2tdsJ+RCwtNN4AVChyiNZnh2co
        q+HcSCAhEvzHtpbJacDBojs=
X-Google-Smtp-Source: APXvYqyXqo9pvtu5PXXT4VhcNt4sWoW27VGROdyvI1Dl8VZMCdCL9ecruH1IUWBXjg8O5Hi6ehJjpQ==
X-Received: by 2002:a63:5b23:: with SMTP id p35mr5953678pgb.366.1566603043286;
        Fri, 23 Aug 2019 16:30:43 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b13sm3411086pjz.10.2019.08.23.16.30.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 16:30:42 -0700 (PDT)
Subject: Re: [PATCH 1/3] net: Add HW_BRIDGE offload feature
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <1566500850-6247-1-git-send-email-horatiu.vultur@microchip.com>
 <1566500850-6247-2-git-send-email-horatiu.vultur@microchip.com>
 <20190822200817.GD21295@lunn.ch>
 <20190823123929.ta4ikozz7jwkwbo2@soft-dev3.microsemi.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <afde1b82-2e4c-5b93-ff31-83cb80a0f7bd@gmail.com>
Date:   Fri, 23 Aug 2019 16:30:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190823123929.ta4ikozz7jwkwbo2@soft-dev3.microsemi.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 5:39 AM, Horatiu Vultur wrote:
> The 08/22/2019 22:08, Andrew Lunn wrote:
>> External E-Mail
>>
>>
>>> +/* Determin if the SW bridge can be offloaded to HW. Return true if all
>>> + * the interfaces of the bridge have the feature NETIF_F_HW_SWITCHDEV set
>>> + * and have the same netdev_ops.
>>> + */
>>
>> Hi Horatiu
>>
>> Why do you need these restrictions. The HW bridge should be able to
>> learn that a destination MAC address can be reached via the SW
>> bridge. The software bridge can then forward it out the correct
>> interface.
>>
>> Or are you saying your hardware cannot learn from frames which come
>> from the CPU?
>>
>> 	Andrew
>>
> Hi Andrew,
> 
> I do not believe that our HW can learn from frames which comes from the
> CPU, at least not in the way they are injected today. But in case of Ocelot
> (and the next chip we are working on), we have other issues in mixing with
> foreign interfaces which is why we have the check in
> ocelot_netdevice_dev_check.
> 
> More important, as we responded to Nikolay, we properly introduced this
> restriction for the wrong reasons.
> 
> In SW bridge I will remove all these restrictions and only set ports in
> promisc mode only if NETIF_F_HW_BRIDGE is not set.
> Then in the network driver I can see if a foreign interface is added to
> the bridge, and when that happens I can set the port in promisc mode.
> Then the frames will be flooded to the SW bridge which eventually will
> send to the foreign interface.

Is that really necessary? Is not the skb->fwd_offload_mark as well as
the phys_switch_id supposed to tell that information to the bridge already?
-- 
Florian
