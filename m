Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A8FB8D8
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 20:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKMT3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 14:29:34 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36798 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfKMT3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 14:29:34 -0500
Received: by mail-ed1-f66.google.com with SMTP id f7so2876857edq.3
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 11:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9BwEwINuK66+tSJiA9QO/8c5pKyX5uqqG4YrYurUSoo=;
        b=gt5zcKRjdDZgzE2UvRFUvKGYjBNs2CTm2QLUimtIjk1rrSoGtOJEulZyQbcJTXp09u
         LlYjZ8IaeORBewOcAa3UQR50oCaysNxUEE7c+2LjgS6Pp7Tpm29Jyrj9vEYipmXZIuHC
         HKXosOtdnRK0vCfag9SqmdPNxoMojG/U/Cd0fc5wLfVd5swqktPGc+pz4O1cPL3E+n7F
         9Q+nEpYyHoXy89BVmKEkd5V2imYKjGS7k3lWcSa1Jwb+CFcvWZKYIlvAvhAYFXVC+4mK
         tABXCaoQL7vsEIlaCfGAqi+QDqkLZdlgVzROsx/4RZwKKBd5zB9hyu1UgIxWvmwkFqAB
         LnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9BwEwINuK66+tSJiA9QO/8c5pKyX5uqqG4YrYurUSoo=;
        b=f+nyEsPtjE0z2LtdIHneIzaXrsNDmHnxc4hMxaiKo/QPld0f2zDfAVdKemV34aeWwF
         qmcTknuN8hHiABwJ+EUTW27k0PNgjsOhYes+5vx/JDNcREPu+pBBXwaSyd1hK7208YQz
         vqotUQTVJETJMX01xps75DfGpFQ0T0U6mnoVAya1QNFZsPLWnvbEOov9VEESKfXaWj05
         R15K1p/KvEhFKJ4KpwJxXVhxFoOY0A2BfW71xHp7Ay6AkiBkorXEVJx/p0uHo1AitHBn
         yO7x7PrAvjwNXmpEc090xRb1TbzeupiwlxEdSVIm59eSV3C6mg+z+a83PgCOu2KL5Ws4
         pGiw==
X-Gm-Message-State: APjAAAUQmzRvtrQ1nj3ASBfiKmLINCj2VruBLhOKa6SiBGVfPjJcjKYg
        DKuAna6AkNTjo25mTYrLc40ub6XJ
X-Google-Smtp-Source: APXvYqzgLxw7zTnC6C/cSvKTSGmbE0tD98e3KM0wo9JuDnJgio6Fx3WORYUYw6vIpAjohQfNnRlkrw==
X-Received: by 2002:a17:906:6d05:: with SMTP id m5mr4438919ejr.102.1573673369822;
        Wed, 13 Nov 2019 11:29:29 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i18sm80962ejc.69.2019.11.13.11.29.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Nov 2019 11:29:29 -0800 (PST)
Subject: Re: Offloading DSA taggers to hardware
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <CA+h21hqte1sOefqVXKvSQ6N7WoTU3BH7qKpq3C7pieaqSB6AFg@mail.gmail.com>
 <20191113165300.GC27785@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <6d53f29d-21ab-21e6-ce94-0b69d3c3cf9f@gmail.com>
Date:   Wed, 13 Nov 2019 11:29:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191113165300.GC27785@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 8:53 AM, Andrew Lunn wrote:
> Hi Vladimir
> 
> I've not seen any hardware that can do this.

Such hardware exists ant there was a prior attempt at supporting that:

http://linux-kernel.2935.n7.nabble.com/PATCH-net-next-0-3-net-Switch-tag-HW-extraction-insertion-td1162606.html

> There is an Atheros/Qualcom integrated SoC/Switch where the 'header' is actually
> just a field in the transmit/receive descriptor. There is an out of
> tree driver for it, and the tag driver is very minimal. But clearly
> this only works for integrated systems.

It can work between discrete components in premise, it just is unlikely
because of the flexibility of DSA to mix and match MAC and switches and
having different vendors on either end. Of course, even between the same
vendor, the right hand rarely talks to the left hand, so it only has to
be the work of someone who knows both ends.

> 
> The other 'smart' features i've seen in NICs with respect to DSA is
> being able to do hardware checksums. Freescale FEC for example cannot
> figure out where the IP header is, because of the DSA header, and so
> cannot calculate IP/TCP/UDP checksums. Marvell, and i expect some
> other vendors of both MAC and switch devices, know about these
> headers, and can do checksumming.

This is probably to be blamed to the fact that most Ethernet switch
tagging protocols did not assign themselves an EtherType, otherwise they
just could do that checksumming. In fact, this even trip up controllers
that are from the same vendor:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a40061ea2e39494104602b3048751341bda374a1

> 
> I'm not even sure there are any NICs which can do GSO or LRO when
> there is a DSA header involved.

Similarly to VLAN devices, would not this be done at the DSA virtual
device level instead?

> 
> In the direction CPU to switch, i think many of the QoS issues are
> higher up the stack. By the time the tagger is involved, all the queue
> discipline stuff has been done, and it really is time to send the
> frame. In the 'post buffer bloat world', the NICs hardware queue
> should be small, so QoS is not so relevant once you reach the TX
> queue. The real QoS issue i guess is that the slave interfaces have no
> idea they are sharing resources at the lowest level. So a high
> priority frames from slave 1 are not differentiated from best effort
> frames from slave 2. If we were serious about improving QoS, we need a
> meta scheduler across the slaves feeding the master interface in a QoS
> aware way.
> 
> In the other direction, how much is the NIC really looking at QoS
> information on the receive path? Are you thinking RPS? I'm not sure
> any of the NICs commonly used today with DSA are actually multi-queue
> and do RPS.

Same hardware as presented above can deliver frames to the desired
switch output queue:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d156576362c07e954dc36e07b0d7b0733a010f7d

> 
> Another aspect here might be, what Linux is doing with DSA is probably
> well past the silicon vendors expected use cases. None of the 'vendor
> crap' drivers i've seen for these SOHO class switches have the level
> of integration we have in Linux. We are pushing the limits of the
> host/switch interfaces much more then vendors do, and so silicon
> vendors are not so aware of the limits in these areas? 

Maybe, but vendors support many basic things we still don't like
controlling broadcast storm suppression (commonly requested feature),
offloading QoS properly etc. etc. What we have achieved so far is IMHO a
solid framework, but there are still many, many features unsupported.

> But DSA is being successful, vendors are taking more notice of it, and maybe with
> time, the host/switch interface will improve. NICs might start
> supporting GSO/LRO when there is a DSA header involved? Multi-queue
> NICs become more popular in this class of hardware and RPS knows how
> to handle DSA headers. But my guess would be, it will be for a Marvell
> NIC paired with a Marvell Switch, Broadcom NIC paired with a Broadcom
> switch, etc. I doubt there will be cross vendor support.
> 
> 	Andrew
> 


-- 
Florian
