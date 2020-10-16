Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA48E290A0C
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410929AbgJPQ40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410921AbgJPQ4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 12:56:25 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB02AC061755;
        Fri, 16 Oct 2020 09:56:25 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d23so1595317pll.7;
        Fri, 16 Oct 2020 09:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1LFSgmI1+3+q3qHcEVi2fTpHvPU1hp/D33HWCvyJhrk=;
        b=hCxBcYzTkOhkKs4GXc3AmnXHuv4RC1wC5jN6Mi36b07hflfy1MN6N6URB4l06wYE2O
         Zhc8PcbpiqW740li2zYVDUiLtwRKFpKikNt0fb41Mk3xlHGkI9T7iFpLPNp/to/VIrcq
         BMjdtSRGunDLw0IYZbqzhLw4Q11TY3dhbWuF3xvabaBioM3uZuJDT7gGZc2hKdhtkaes
         o1aLd2tdU/gTh/Gto2boiWZ8mmAE2UZnVbYIV9c1GO9HTWmu5EogKj00th5K++i/59ts
         wWELQPSLGMIIUpBQ9gVVFTPiv8ThROZq7NA0ZUZeuiTU0sKN3je2ifmAwp+FH4eK2HEp
         jQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=1LFSgmI1+3+q3qHcEVi2fTpHvPU1hp/D33HWCvyJhrk=;
        b=aqo6gjnIpzlU7eZOVVV4dZ1HiYfGVAe24QW4JKR0glTFjXXEjVCd8GkTPazF7SS1T6
         Y+SxhITjIN4TcqjIXJa605rFep6W51223DfD7+oqhIluTrPH2m3YLIwO1sSYifv/hhqh
         ZWmVUwJL9md4LrGBtmjZn3I3882ufC5E+Ewa0K7yVj2BYXax2yPZ3hiOkEnWkFlvpufu
         FtR46VMbflHkQnvxjxbla2V0eDq7Q3RzDhzqJn6ntuJPzvJ6ZisNpSkl4joE38pO/zOp
         AeI5zmRxMheHRjsWU0NiTZS7tQCtOxMdhuR4TzosUtBo4JlKe94geey+RD9tlAir1v/y
         OxgQ==
X-Gm-Message-State: AOAM532WMZ52EuH51Gk/8ja2nNNLQHguFolWLaVjZFs9OJ8J/XKcIF2q
        YD4/+nI8SI1d7vuHkKNr2CVAvNNzrig=
X-Google-Smtp-Source: ABdhPJwIlvuaZmd7ixP1Kb9M2Jj8uAO6vW0X+17OApd9jNS8KDS1RQIwxT50V9G7qEAaLXbqgyVpFA==
X-Received: by 2002:a17:90a:7d16:: with SMTP id g22mr4914970pjl.135.1602867384968;
        Fri, 16 Oct 2020 09:56:24 -0700 (PDT)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gi20sm3711514pjb.28.2020.10.16.09.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 09:56:24 -0700 (PDT)
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
To:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
References: <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt> <20201006113237.73rzvw34anilqh4d@skbuf>
 <87wo037ajr.fsf@kurt> <20201006135631.73rm3gka7r7krwca@skbuf>
 <87362lt08b.fsf@kurt> <20201011153055.gottyzqv4hv3qaxv@skbuf>
 <87r1q4f1hq.fsf@kurt> <87sgaee5gl.fsf@kurt>
 <20201016154336.s2acp5auctn2zzis@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <6cf8acc5-a6aa-5e77-f0a3-09d7d7af1a82@gmail.com>
Date:   Fri, 16 Oct 2020 09:56:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016154336.s2acp5auctn2zzis@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/20 8:43 AM, Vladimir Oltean wrote:
> On Fri, Oct 16, 2020 at 02:11:06PM +0200, Kurt Kanzenbach wrote:
>> When VLAN awareness is disabled, the packet is still classified with the
>> pvid. But, later all rules regarding VLANs (except for the PCP field)
>> are ignored then. So, the programmed pvid doesn't matter in this case.
> 
> Ok, clear now.
> 
>> The only way to implement the non-filtering bridge behavior is this
>> flag. However, this has some more implications. For instance when
>> there's a non filtering bridge, then standalone mode doesn't work
>> anymore due to the VLAN unawareness. This is not a problem at the
>> moment, because there are only two ports. But, later when there are more
>> ports, then having two ports in a non-filtering bridge and one in
>> standalone mode doesn't work. That's another limitation that needs to be
>> considered when adding more ports later on.
> 
> Well, then you have feedback to bring to the hardware engineers when
> switches with more than 2 user ports will be instantiated.
> 
>> Besides that problem everything else seem to work now in accordance to
>> the expected Linux behavior with roper restrictions in place.
> 
> Ok, that's great.

I probably missed parts of this long discussion, but for this generation
of switches, does that mean that you will only allow a bridge with
vlan_filtering=1 to be configured and also refuse toggling of
vlan_filtering at run time?
-- 
Florian
