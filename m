Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF519B4FF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfHWRA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 13:00:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42362 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfHWRA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 13:00:28 -0400
Received: by mail-pf1-f196.google.com with SMTP id i30so6823110pfk.9
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 10:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQpJv7fWuKN+FNLf4y+ICNRigH9KH0TwKqGXOplF2pw=;
        b=reC6ZSelWkvKiJoSNiSbYuiJ3Wpr8y/tsRMdXZldOg95Omqe/4yg8fcVjIbGw7vqxJ
         T4ij/EAyoz+n0uSVUJvL+EmZ7MqNOeL2hplkvgFn/BuOWPQlaQfLov+P1oKgh5e2B6P9
         hmkj6sUeaOKhkazyvTh9JC21wmuE2IIzfuUfNTflk//Ael7y/oC6BpPdhdCdfKST0SMv
         yzLfk0AZQZduoJzLRIztyJxLarMHNBp0NcxGpgjRhBVBKpuaRUKJ2gcjuR8zOw8Co7wG
         o3ZcI8AyuKtUGbEVHEvs53Oee/77sNHSEGKn1W0s8RNUCsuXgE9LKPd4hU48ZnkuKnDp
         cLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mQpJv7fWuKN+FNLf4y+ICNRigH9KH0TwKqGXOplF2pw=;
        b=GcuJfF6+JNagUNPRZ2gCrfWri3aQN5WDo/dGpCY/MDIh0eUG8IcpkN2NuDdMDDouG1
         PrnODgZTrivxUC0M0+RR4lkxuhHep5EtsH+svY6SU6zS3n0OIL6PCVc65CHO/pTYh41D
         eMCRBz+hg8MgnTL7CN+cyS0N6PU++MDB4t47DpfFWtVrF2Iy0EUrT9K9FORhCgtYMYlY
         16dAHMHgUjAfOpEmXQH8ceBaHpfHFpyguxSJj6+oQrXi6Hnt0eC41FRLGh+qqTUK4bQ+
         K0dTqrMlnc1VTYNFuVlbAfCfAMm74ar1nptvNiXtt62RbkZJeNcqIph51nyg/Ma5iBCK
         XZog==
X-Gm-Message-State: APjAAAVdYjE2Qc18G8CTDd73ZAkMZuB/+0oRmIlts0h+PSfhEFs+kr57
        HhoP4i2oXjWgsKmcHCvzo2Q=
X-Google-Smtp-Source: APXvYqwmZ99J+GqRz2MfQfcLRWi2U+FiSwSpeyzGWnNUSAH8AE9sOl8Q+b8z3OQ9NdU1HLn5/xTNYg==
X-Received: by 2002:a65:4189:: with SMTP id a9mr4696064pgq.399.1566579627590;
        Fri, 23 Aug 2019 10:00:27 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e13sm3299894pff.181.2019.08.23.10.00.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 10:00:26 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] net: dsa: clear VLAN flags for CPU port
To:     Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
 <20190822201323.1292-7-vivien.didelot@gmail.com>
 <aee63928-a99e-3849-c8b4-dee9b660247c@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <3c88db34-464a-1ab7-a525-66791faad698@gmail.com>
Date:   Fri, 23 Aug 2019 10:00:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <aee63928-a99e-3849-c8b4-dee9b660247c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 4:51 PM, Vladimir Oltean wrote:
> On 8/22/19 11:13 PM, Vivien Didelot wrote:
>> When the bridge offloads a VLAN on a slave port, we also need to
>> program its dedicated CPU port as a member of the VLAN.
>>
>> Drivers may handle the CPU port's membership as they want. For example,
>> Marvell as a special "Unmodified" mode to pass frames as is through
>> such ports.
>>
>> Even though DSA expects the drivers to handle the CPU port membership,
>> they are unlikely to program such VLANs untagged, and certainly not as
>> PVID. This patch clears the VLAN flags before programming the CPU port.
>>
>> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
>> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
>> ---
>>   net/dsa/slave.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>> index 8267c156a51a..48df48f76c67 100644
>> --- a/net/dsa/slave.c
>> +++ b/net/dsa/slave.c
>> @@ -332,6 +332,12 @@ static int dsa_slave_vlan_add(struct net_device
>> *dev,
>>       if (err)
>>           return err;
>>   +    /* We need the dedicated CPU port to be a member of the VLAN as
>> well.
>> +     * Even though drivers often handle CPU membership in special ways,
>> +     * CPU ports are likely to be tagged, so clear the VLAN flags.
>> +     */
>> +    vlan.flags = 0;
>> +
> 
> How does this work exactly?
> If I run 'sudo bridge vlan add vid 1 dev swp4 pvid untagged', then the
> CPU port starts sending VLAN-tagged traffic. I see this in tcpdump on
> the DSA master port, but if I tcpdump on swp4, the VLAN tag is removed.
> Who is doing that?

If vlan.flags = 0, then it does not have either BRIDGE_VLAN_INFO_PVID or
BRIDGE_VLAN_INFO_UNTAGGED which means the VLAN should be programmed
tagged on the CPU.

Since swp4 is part of the same VLAN, but has it configured PVID
untagged, the tag is removed, that sounds about what I would expect to
see...
-- 
Florian
