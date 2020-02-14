Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04CEB15E9B1
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394572AbgBNRIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:08:34 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35626 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391876AbgBNRIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 12:08:32 -0500
Received: by mail-pf1-f193.google.com with SMTP id y73so5188887pfg.2;
        Fri, 14 Feb 2020 09:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l+1UldF7bwhP9kWms7XTKjK9vXu+YuuV5LGnlbnK2T8=;
        b=LKpxOrglZ1aolVFZ9P47/57EJpuO8xDeDSwBXosrRopajWEaG4j7D/zq3Bm3/PDU0D
         z/8+nkioe4fu5blQVAZGenWIxYSz7xf0u64Ate42COsYloDP4aQS4nh5chEn//jdZdan
         ANKB7v/KtGJ3DkCOo2bwXP1wAsNK4P2wESvtaod+QoD9Gjwkhi8vOSN/70XERQ2YdwNv
         r7eTgoH8+WM0a6pJl1IqCf5yMDudQS+w5xDYvTDP1zGL17wbwFXmMNlQeV8LP9Wm5xVV
         n5d9hwqCmnK3O0pyWEG5oZyzZNqqGyf7PAp0/sK8sUVoLK9LAgzJ7i6sR2W4OyrLkeWf
         JT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=l+1UldF7bwhP9kWms7XTKjK9vXu+YuuV5LGnlbnK2T8=;
        b=gW6XxpuFHxBeSL5wIzTlWi/f0vmjb+rUpK60ThYjBxIk/M6gYA6pcL+n5v8q6EwDla
         u59mdjH9vPz00BZgZlmkQAphWkeO74FNspcoHX8usY92f106vXNAkd0djXBoSPk5ZgxF
         w/F49w/m94URpUOYi23SCcepDtfLPVsXWYgKlF/TqRzf0Svft0mXcdZiwaKOQzIo9Lsf
         JrpoUtOxzJ33fHiJoMccvJo5GcG68QYFUZYOxJqpFxg7ng3UAZpRNxoCp4sfysYpUphs
         ax6AepBB91A9ip6Up4NoKGrArcRsS1uTVHxSuNJzLTt8tOxp1BiHz+EiaoZ+p6k+iOkE
         Fzeg==
X-Gm-Message-State: APjAAAWEzXFkbfGCFLD4j6Qvju5ulIg9BKfk8fpPwunvokM/S2JNHjXW
        bichIDMORgTcAAhuqpzwfnWTl14s
X-Google-Smtp-Source: APXvYqxePEbEHHNkY/5133bTKC90bcI4TFcwbeRjDclQVTgTvo2vbjSIJOwO6jaFsnXBZuX0VtfNhA==
X-Received: by 2002:a63:a707:: with SMTP id d7mr4369253pgf.390.1581700111446;
        Fri, 14 Feb 2020 09:08:31 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v8sm7356799pfn.172.2020.02.14.09.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 09:08:30 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: b53: Ensure the default VID is untagged
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20200213191015.7150-1-f.fainelli@gmail.com>
 <CA+h21hqVWc6Tis12oJsfgXtsW2mJr0qUFu28G3qjMf-sOJWAwg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <ab4e0ce1-dd48-8c1b-8753-a400dfcb38ec@gmail.com>
Date:   Fri, 14 Feb 2020 09:08:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CA+h21hqVWc6Tis12oJsfgXtsW2mJr0qUFu28G3qjMf-sOJWAwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2020 2:36 AM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Thu, 13 Feb 2020 at 21:10, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> We need to ensure that the default VID is untagged otherwise the switch
>> will be sending frames tagged frames and the results can be problematic.
>> This is especially true with b53 switches that use VID 0 as their
>> default VLAN since VID 0 has a special meaning.
>>
>> Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
>> Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  drivers/net/dsa/b53/b53_common.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>> index 449a22172e07..f25c43b300d4 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
>> @@ -1366,6 +1366,9 @@ void b53_vlan_add(struct dsa_switch *ds, int port,
>>
>>                 b53_get_vlan_entry(dev, vid, vl);
>>
>> +               if (vid == b53_default_pvid(dev))
>> +                       untagged = true;
>> +
>>                 vl->members |= BIT(port);
>>                 if (untagged && !dsa_is_cpu_port(ds, port))
>>                         vl->untag |= BIT(port);
>> --
>> 2.17.1
>>
> 
> Don't you mean to force untagged egress only for the pvid value of 0?

The default VID (0 for most switches, 1 for 5325/65) is configured as
pvid during b53_configure_vlan() so when we get a call to port_vlan_add
with VID == 0 this is coming exclusively from
dsa_slave_vlan_rx_add_vid() since the bridge will never program a VID <
1. When dsa_slave_vlan_rx_add_vid() calls us, we do not have any VLAN
flags set in the object.
-- 
Florian
