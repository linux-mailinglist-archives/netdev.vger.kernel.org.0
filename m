Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BA6FB906
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKMTk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:40:57 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41205 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfKMTk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:40:57 -0500
Received: by mail-ed1-f67.google.com with SMTP id a21so2887170edj.8
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 11:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DaKmNeaZTUmMXg+aAXCkfPsTOB1ZHIDO9i9w9wEfCOw=;
        b=LPKMhQx6fkfPZ4xRSInEhkZ22YzKkBmxd4NbEZLQGgoPJuaJgXJvBE6UUFdIE40l2L
         gQ2qVAqdZR4fhJpygmyniYFskFEoWDrvlgJVzntqSK0I9fzZD4XuuAIwo8ulntd1gjbQ
         2fHd/PWB88lhtnKN5iotmOxv0Gr4d4C4JdEg45nQg6Ek2L3SdMYSbAAl/HqvzAiGPRXj
         9FJ7Y4CYGgTf/BD9DHGe92RHmJUgVfWF45UY//EeXavmkQZamX5iU0ZJ8pbmEIId46c6
         aN22Lcg2Y8+syJY3qHTzVxVo67e4oycoZW0Hk77heRpMct9KISlRCanK/q58MUu+K1jO
         FzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DaKmNeaZTUmMXg+aAXCkfPsTOB1ZHIDO9i9w9wEfCOw=;
        b=rxx6/lqKeXOook++mQYQivLQ4t6a9awjBHSneqGHpn3qlsrbbR/HX6uLsSPzL6IA0I
         alPLHSG3cw/XzmnQohwSH+YdoKoI/ViDT6aMLD7rbf4RE7fLUU5ReX28UPi0TWJmeKcy
         UIGy54l7nZiEy1Kwr/wGAEpvEQIVspOgokql0lcNCSr+4BaIN56LOiqZfxDr3aRSDfKj
         yzC8J9bLGQg0amMIC4zSYVzWDX8yJXNErxB6s720TaUM+7uViHSbgDBzUe39yxu6za+9
         U9xDnMdyrCS+wIFmdsXP6y4VejrA3Ul4khSF/PXYdXGHkhRYi7v55OXIZGmq77qrK4gG
         tFHw==
X-Gm-Message-State: APjAAAVldHcy0bmbXJ0rO8bU4711K83iRcb035lIp/5IqThSTQqK+ERK
        qflssYgmeXgbehCJ/nWMYM4/j6qG
X-Google-Smtp-Source: APXvYqwOJsonlaob5sHdKxCA5ip7yW7nv9gfIfak5CJTLujp1xQ1IKS3yfGsOe+xk213qFjb7LYqPw==
X-Received: by 2002:aa7:c3d0:: with SMTP id l16mr5643326edr.18.1573674052775;
        Wed, 13 Nov 2019 11:40:52 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y7sm285769edb.97.2019.11.13.11.40.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 11:40:52 -0800 (PST)
Subject: Re: Offloading DSA taggers to hardware
To:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <6fbc4127-ab67-3898-8eaa-409c3209a2e2@gmail.com>
Date:   Wed, 13 Nov 2019 11:40:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 4:40 AM, Vladimir Oltean wrote:
> DSA is all about pairing any tagging-capable (or at least VLAN-capable) switch
> to any NIC, and the software stack creates N "virtual" net devices, each
> representing a switch port, with I/O capabilities based on the metadata present
> in the frame. It all looks like an hourglass:
> 
>   switch           switch           switch           switch           switch
> net_device       net_device       net_device       net_device       net_device
>      |                |                |                |                |
>      |                |                |                |                |
>      |                |                |                |                |
>      +----------------+----------------+----------------+----------------+
>                                        |
>                                        |
>                                   DSA master
>                                   net_device
>                                        |
>                                        |
>                                   DSA master
>                                       NIC
>                                        |
>                                     switch
>                                    CPU port
>                                        |
>                                        |
>      +----------------+----------------+----------------+----------------+
>      |                |                |                |                |
>      |                |                |                |                |
>      |                |                |                |                |
>   switch           switch           switch           switch           switch
>    port             port             port             port             port
> 
> 
> But the process by which the stack:
> - Parses the frame on receive, decodes the DSA tag and redirects the frame from
>   the DSA master net_device to a switch net_device based on the source port,
>   then removes the DSA tag from the frame and recalculates checksums as
>   appropriate
> - Adds the DSA tag on xmit, then redirects the frame from the "virtual" switch
>   net_device to the real DSA master net_device
> 
> can be optimized, if the DSA master NIC supports this. Let's say there is a
> fictional NIC that has a programmable hardware parser and the ability to
> perform frame manipulation (insert, extract a tag). Such a NIC could be
> programmed to do a better job adding/removing the DSA tag, as well as
> masquerading skb->dev based on the parser meta-data. In addition, there would
> be a net benefit for QoS, which as a consequence of the DSA model, cannot be
> really end-to-end: a frame classified to a high-priority traffic class by the
> switch may be treated as best-effort by the DSA master, due to the fact that it
> doesn't really parse the DSA tag (the traffic class, in this case).

The QoS part can be guaranteed for an integrated design, not so much if
you have discrete/separate NIC and switch vendors and there is no agreed
upon mechanism to "not lose information" between the two.

> 
> I think the DSA hotpath would still need to be involved, but instead of calling
> the tagger's xmit/rcv it would need to call a newly introduced ndo that
> offloads this operation.
> 
> Is there any hardware out there that can do this? Is it desirable to see
> something like this in DSA?

BCM7445 and BCM7278 (and other DSL and Cable Modem chips, just not
supported upstream) use drivers/net/dsa/bcm_sf2.c along with
drivers/net/ethernet/broadcom/bcmsysport.c. It is possible to offload
the creation and extraction of the Broadcom tag:

http://linux-kernel.2935.n7.nabble.com/PATCH-net-next-0-3-net-Switch-tag-HW-extraction-insertion-td1162606.html

(this was reverted shortly after because napi_gro_receive() occupies the
full 48 bytes skb->cb[] space on 64-bit hosts, I have now a better view
of solving this though, see below).

In my experience though, since the data is already hot in the cache in
either direction, so a memmove() is not that costly, it was not possible
to see sizable throughput improvements at 1Gbps or 2Gbps speeds because
the CPU is more than capable of managing the tag extraction in software,
and that is the most compatible way of doing it.

To give you some more details, the SYSTEMPORT MAC will pre-pend an 8
byte Receive Status Block, word 0 contains status/length/error and word
1 can contain the full 4byte Broadcom tag as extracted. Then there is a
(configurable) 2byte gap to align the IP header and then the Ethernet
header can be found. This is quite similar to the
NET_DSA_TAG_BRCM_PREPEND case, except for this 2b gap, which is why I am
wondering if I am not going to introduce an additional tagging protocol
NET_DSA_TAG_BRCM_PREPEND_WITH_2B or whatever side band information I can
provide in the skb to permit the removal of these extraneous 2bytes.

On transmit, we also have an 8byte transmit status block which can be
constructed to contain information for the HW to insert a 4byte Broadcom
tag, along with a VLAN tag, and with the same length/checksum insertion
information. TX path would be equivalent to not doing any tagging, so
similarly, it may be desirable to have a separate
NET_DSA_TAG_BRCM_PREPEN value that indicates that nothing needs to be
done except queue the frame for transmission on the master netdev.

Now from a practical angle, offloading DSA tagging only makes sense if
you happen to have a lot of host initiated/received traffic, which would
be the case for either a streaming device (BCM7445/BCM7278) with their
ports either completely separate (DSA default), or bridged. Does that
apply in your case?
-- 
Florian
