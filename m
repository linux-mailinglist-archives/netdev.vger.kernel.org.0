Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B86A4986CE
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244597AbiAXRao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiAXRam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:30:42 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9ABC06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:30:42 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nn16-20020a17090b38d000b001b56b2bce31so474728pjb.3
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 09:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QiiowW0PsNdaZtX1xxt1I8nQW4Mb05CtwIps0o65cPA=;
        b=eTHgz2BcGVyt6w6L1Ncm0qbv6mxPhrAPUFi1UUlrtGJamMwIVBBQ2fAGtqx1O8D4we
         K+0V23COJT+vd4aod28fVcpQZn8648nDpATZv0Z0/CAkaxtCnSqO+PMtKq4pNjdUUU3S
         bOIyg4mUCfm1SfasVWfBrSVF/ntp77zOVVzEkDnMrPRfZdhiAI2dz+vNZTooqg3A2GlM
         bPXKlNT312EBeaHFkpnbjjMWTVPwkhA7/qLbB4DAzsQ8FfMBUuo83haRLUtonsod5nDz
         Qc5AJc3p9nAQzyTTACTeOuCzTF99nJCos9fq6zDCz5coiLtJmzCI06/2FpdPrDlHWuFI
         E12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QiiowW0PsNdaZtX1xxt1I8nQW4Mb05CtwIps0o65cPA=;
        b=CJ9EO1pB9uQ8nd5Pw/eB/JEuHvtCtMcbfDDavzjF+VjQYHjF9go8qp5faOVh5Tf1T6
         6LZhUXThiwt3c9LwprA4w9q7DNKV8OdAgdYJnLt4h0c/46TYK9Srx0KAusyGQFOrMpQH
         9dCM4jicEvCuyN2R5hw6xwbUjttuvUmqL2nFECmuk/tzSqDCbDk4GCssDSBM/Cvn4Yxy
         3CxnI+FWvf3MgoGErqewyeSAYYANzWgYG+UudjXPtY5tFBn3ZY1nJ2XW/QkSC7uYvs93
         PoU+jeECAW8juNXvq98yezNtY9DrJFrhpW0vCN3ylPQfZzbyszqEbspMkdrU6kckM/op
         hYXQ==
X-Gm-Message-State: AOAM533l8YdEnoGWFHwvwJNn9zUi9dzzI5FeBYrEqqaHYord4vxENToy
        qKJXd5aOnSURSRevaBXlnkg=
X-Google-Smtp-Source: ABdhPJwl6kNJK8SnlUReOar3XnXlLI5Cokj/RQYiOZkUuMZ5EA1kxU5+skX2nTsrlNXQRBpXGs2DMA==
X-Received: by 2002:a17:90a:8807:: with SMTP id s7mr2874398pjn.223.1643045441793;
        Mon, 24 Jan 2022 09:30:41 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u21sm17076720pfi.149.2022.01.24.09.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 09:30:41 -0800 (PST)
Message-ID: <f295ba3f-1e4c-8305-7da7-142ac34b5e10@gmail.com>
Date:   Mon, 24 Jan 2022 09:30:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
References: <20220121020627.spli3diixw7uxurr@skbuf>
 <CAJq09z5HbnNEcqN7LZs=TK4WR1RkjoefF_6ib-hFu2RLT54Nug@mail.gmail.com>
 <20220121185009.pfkh5kbejhj5o5cs@skbuf>
 <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
 <20220121224949.xb3ra3qohlvoldol@skbuf>
 <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
 <20220124153147.agpxxune53crfawy@skbuf>
 <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124165535.tksp4aayeaww7mbf@skbuf>
 <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220124172158.tkbfstpwg2zp5kaq@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/2022 9:21 AM, Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 09:01:20AM -0800, Florian Fainelli wrote:
>> On 1/24/2022 8:55 AM, Vladimir Oltean wrote:
>>> On Mon, Jan 24, 2022 at 08:46:49AM -0800, Jakub Kicinski wrote:
>>>> I thought for drivers setting the legacy NETIF_F_IP*_CSUM feature
>>>> it's driver's responsibility to validate the geometry of the packet
>>>> will work with the parser the device has. Or at least I think that's
>>>> what Tom was pushing for when he was cleaning up the checksumming last
>>>> (and wrote the long comment on the subject in skbuff.h).
>>>
>>> Sorry Jakub, I don't understand what you mean to say when applied to the
>>> context discussed here?
>>
>> I believe what Jakub meant to say is that if a DSA conduit device driver
>> advertises any of the NETIF_F_IP*_CSUM feature bits, then the driver's
>> transmit path has the responsibility of checking that the payload being
>> transmitted has a chance of being checksummed properly by the hardware. The
>> problem here is not so much the geometry itself (linear or not, number/size
>> of fragments, etc.) as much as the placement of the L2/L3 headers usually.
>>
>> DSA conduit network device drivers do not have the ability today to
>> determine what type of DSA tagging is being applied onto the DSA master but
>> they do know whether DSA tagging is in use or not which may be enough to be
>> overly compatible.
>>
>> It is not clear to me whether we can solve this generically within the DSA
>> framework or even if this is desirable, but once we have identified a
>> problematic association of DSA tagger and DSA conduit, we can always have
>> the DSA conduit driver do something like:
>>
>> if (netdev_uses_dsa(dev))
>> 	skb_checksum_help()
>>
>> or have a fix_features callback which does reject the enabling of
>> NETIF_F_IP*_CSUM if netdev_uses_dsa() becomes true.
> 
> Yes, but as you point out, the DSA master driver doesn't know what
> header/trailer format it's dealing with. We could use netdev_uses_dsa()
> as a very rough approximation, and that might work when we know that the
> particular Ethernet controller is used only in conjunction with a single
> type of DSA switch [from the same vendor], but I think we're just
> delaying the inevitable, which is to treat the case where an Ethernet
> controller can be a DSA master for more than one switch type, and it
> understands some protocols but not others.
> Also, scattering "if (netdev_uses_dsa(dev)) skb_checksum_help()" in
> DSA-unaware drivers (the common case) seems like the improper approach.
> We might end up seeing this pattern quite a lot, so DSA-unaware drivers
> won't be DSA-unaware any longer.
> It's still possible I'm misunderstanding something...

I don't think you are, and my crude proposal was just so we have it 
working, and then we can think about having it work fast.

A long time (but in the same galaxy) DSA used to set skb->protocol to 
the value of the DSA tagging protocol used (say ETH_P_EDSA), long before 
they were all consolidated within ETH_P_XDSA, but this would be breaking 
any checksum setting up that looks at skb->protocol to determine if it 
is IP, IPv6 or else, so in a way it might have done what we wanted it to 
do, but this was mostly by accident.

The tagger on transmit can definitively tell us via an out of band 
signaling what type of tagging protocol is being used and where it is 
located within the packet if necessary, and I suppose we can then update 
the DSA conduit in order to not ask the HW to checksum if this is deemed 
problematic. Doing that for every single packet transmitted however may 
not be very efficient given that usually we set-up one tagging protocol, 
then we set-up another one (possibly), but it won't change on a packet 
by packet basis. So maybe what we need to do is at the time we "connect" 
the tagger we inform the DSA master that from there on, all that is 
supposed to go through that interface will look that way, along with a 
description of the tagger offset and length?
-- 
Florian
