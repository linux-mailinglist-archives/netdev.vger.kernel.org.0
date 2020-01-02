Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CDF12E26F
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 05:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgABEyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jan 2020 23:54:00 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43794 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgABEyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jan 2020 23:54:00 -0500
Received: by mail-pg1-f196.google.com with SMTP id k197so21333943pga.10
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 20:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=secDav8DGOFYEDerfhV1bV/grbkbR0L39oGS10IQRrY=;
        b=ghpOUeoUIic9AtxBF35k2yCE3RB5Dr/sYJqaNQPNUim5KI0RROvAHpCSSjPvHwKJ7C
         5fnNFdQav7BAyO0LXi2vurdIPyfuoNHmZrdyEmZO54m4u7bY1sR0cQ7ieMMAwOjOQYtv
         ey2g4vHOOP33NQ1mwbgnkptW32vsL1FM/nQZS9txbq4ai5jcPB2T2vdZFDwBubX9hXeH
         +JXNdDXA6xi1jBoKtcxXjxTs2jGFJ99UrrgOtD+3+s2VVgIkORm9CMqbCJAePfyX76Ty
         IHS//lyn+z9xEOwtZPrP7JeTKDJOouLAgUyxOoZAd81r8MPqZ/aEBE7tRU9R3wpHGWL3
         pGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=secDav8DGOFYEDerfhV1bV/grbkbR0L39oGS10IQRrY=;
        b=eH741HROhr5qeMXlqZOk4AUHajnYOKWvbvOFa2BE8AZGuPR6ZJrtI2qzBlKxg0K+Ux
         a4efhP4Iw9rJg3h/+VP8R1w7HC7cHUG98Q+y6aa5aQiEPDc7JazqRZJ2ilLTMc94qb8j
         LRTyhXQ9JD/RIepgkixR1vU4mD+v6vgs5u2+52azbzJEdEP/ECVzAFrrUUDZSr2Nib6E
         FLnqpbgo1J9VjraXbPCSqfMVeG2in59nWmpP8kYvLSubDGXVo9KUXDSTTIDEWVCZkO/X
         poHpp5u3W6Dt1c5vRd+lveFk0HTmjeaG4KjRlZzdrEqi5Jwx6Rz+ZnDOHJzWdpKOzHnv
         drnQ==
X-Gm-Message-State: APjAAAXdDuwtvAxEjpaQDZO0Bdtbf+RDxlE/Suy0WQsHt9LNwJndjM9D
        f2Y2E4BYxVfg/ow+tYrlQRUOPk30
X-Google-Smtp-Source: APXvYqwlP01J6CcTPiWUMKZmX/+TkPpqDj47tASGwBMpvn015/YVF7Z7rGMEixd+H1DMLAtCyJfzEQ==
X-Received: by 2002:a63:1a19:: with SMTP id a25mr88826120pga.447.1577940839226;
        Wed, 01 Jan 2020 20:53:59 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l186sm57476344pge.31.2020.01.01.20.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jan 2020 20:53:58 -0800 (PST)
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali> <20191231180614.GA120120@splinter>
 <20200101011027.gpxnbq57wp6mwzjk@pali>
 <20200101173014.GZ25745@shell.armlinux.org.uk>
 <20200101180727.ldqu4rsuucjimem5@pali>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <da2191ec-b492-dfc5-95e9-d05e5f1fcf24@gmail.com>
Date:   Wed, 1 Jan 2020 20:53:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200101180727.ldqu4rsuucjimem5@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/1/2020 10:07 AM, Pali Rohár wrote:
> On Wednesday 01 January 2020 17:30:14 Russell King - ARM Linux admin wrote:
>> I think the most important thing to do if you're suffering problems
>> like this is to monitor and analyse packets being received from the
>> DSA switch on the host interface:
>>
>> # tcpdump -enXXi $host_dsa_interface
> 
> Hello Russell! Main dsa interface for me is eth0 and it does not see any
> incoming vlan tagged packets. (Except that sometimes for those 5 minutes
> periods it sometimes see them. And when tcpdump saw them also they
> arrived to userspace.)

Based on your description it sounds like there is possibly an address
learning issue, which is why the ATU patches that Russell mentioned
(latest I know are available at [1]) could come in handy.

[1]: https://github.com/vivien/linux/tree/dsa/debugfs

Since this is a DSA set-up, you could try a few things to isolate the
problems further:

- if you keep the same MAC address for wan and wan.10 does the problem
go away? If so, this could suggest that the DSA master network device
driver potentially has a problem with programming its receive filter for
other unicast MAC addresses than the default one (more on that below)

- if your DSA master supports receive VLAN filter offload
(NETIF_F_HW_VLAN_CTAG_FILTER) does it work better if you turn it off?

- does it help if you go back to a kernel before and not including v5.1
which does not have commit 061f6a505ac33659eab007731c0f6374df39ab55
("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation") or if you
can change your kernel, try something similar to [2] for mv88e6xxx and
see if it helps

[2]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e9bf96943b408e6c99dd13fb01cb907335787c61

Regarding the programing of MAC addresses happening through
ndo_set_rx_mode(), we should program static unicast and multicast
addresses when dev_{mc,uc}_sync() gets called similar to [3] because
those addresses are static in nature and the host stack can add/remove
them accordingly. This would help with aging as much as unknown/known
multicast traffic. I will try to cook something later this week.

[3]:
https://github.com/ffainelli/linux/commit/f91b53449e0346a8d7157e5a9225faaa810cbeab
--
Florian
