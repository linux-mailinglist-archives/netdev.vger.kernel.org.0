Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D83458F006
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiHJQES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiHJQD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:03:56 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FAA6582C;
        Wed, 10 Aug 2022 09:03:53 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qn6so16718317ejc.11;
        Wed, 10 Aug 2022 09:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=AOVR+FZiSzTKEgE6QjcPCLhOAklIanQVpyFR+Tk5+Ik=;
        b=IEnFjBXSdoKMopYXDcDI4lVjhzlB6jUuBmYf1RtMJNog/YTNe3lI0/QEy4faFrfaIu
         prT1UYqaeoc7hPPDqrTXsJLE05czMC5d790YC1+TyBsogiLVkqIMxOcXC9AEOmTKE5xC
         vMjo3bBe6x4DWPPzfZnUwu0xsdMYHF+RPwGEeA2WM1ni+J5EkxG7vJYCYc3AuHXGELMR
         XLF+3yRmfyHKgiOHPaPIHakoSGaqi58UvzWOb1fl+y4ZeNv/8hAult4BeXIsOVGmVCx5
         1Irgjolf/rPj953oAkYtf+2sz4bT0qU3s+tBotncsn9VqY4N0b/EcaLU+J2kXXBB1NKX
         egug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=AOVR+FZiSzTKEgE6QjcPCLhOAklIanQVpyFR+Tk5+Ik=;
        b=2XoDFswM/kVwxjfvyKFExs75E1GfwgwRa3CJN7WRr645wIIYg8lRJDVODkODC+MYS8
         FoFZFLK6QpxdXSGsuE/kr+Gak/0fF0ukclqKThNuPSTwKi5WdT1bGk+GfxKF25u7mwAf
         +lK40+PtI/v06D8QqjEM6qyVneXC4yZ20a7JJZy0mKPQ/BjmWbu6yP5P2MaXzxAgPKo+
         T7SmYNl3jBZ+U7HDtvpafrIqUre2LAGbeQEtaR+S4UVzfm+9X4h0mtvxA7CtIn4i/btI
         xgHvvnrZLKC+G9vpoPm8AIOtSZpcDK4ZBOC/xN/fur1GB7mNALltpyCCXyK++vBQ1V/h
         P8zw==
X-Gm-Message-State: ACgBeo1K5xehTKu1rX6bXZI0qdoWZrXzSuyjNck4HrvQ8M7A2idR1bOg
        ybSPoS/7fk0VdhLF5ZQNIrY=
X-Google-Smtp-Source: AA6agR64XA+40H/MjnCQFOVB+71sI7xUxFta5WUhOvUuRQ6/A3czn2HWx4U3FOa3gGghDLXb2p2qkw==
X-Received: by 2002:a17:907:a063:b0:730:750b:bb62 with SMTP id ia3-20020a170907a06300b00730750bbb62mr20899007ejc.612.1660147432187;
        Wed, 10 Aug 2022 09:03:52 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id et13-20020a056402378d00b0043ba24a26casm7677455edb.23.2022.08.10.09.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 09:03:21 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree@xilinx.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-net-drivers@amd.com,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Shannon Nelson <snelson@pensando.io>,
        Simon Horman <simon.horman@corigine.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
References: <20220805165850.50160-1-ecree@xilinx.com>
 <20220805184359.5c55ca0d@kernel.org>
 <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com>
 <20220808204135.040a4516@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <572c50b0-2f10-50d5-76fc-dfa409350dbe@gmail.com>
Date:   Wed, 10 Aug 2022 17:02:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220808204135.040a4516@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2022 04:41, Jakub Kicinski wrote:
>>> AFAIK there's no "management PF" in the Linux model.  
>>
>> Maybe a bad word choice.  I'm referring to whichever PF (which likely
>>  also has an ordinary netdevice) has administrative rights over the NIC /
>>  internal switch at a firmware level.  Other names I've seen tossed
>>  around include "primary PF", "admin PF".
> 
> I believe someone (mellanox?) used the term eswitch manager.
> I'd use "host PF", somehow that makes most sense to me.

Not sure about that, I've seen "host" used as antonym of "SoC", so
 if the device is configured with the SoC as the admin this could
 confuse people.
I think whatever term we settle on, this document might need to
 have a 'Definitions' section to make it clear :S

>>> What is "the PCIe controller" here? I presume you've seen the
>>> devlink-port doc.  
>>
>> Yes, that's where I got this terminology from.
>> "the" PCIe controller here is the one on which the mgmt PF lives.  For
>>  instance you might have a NIC where you run OVS on a SoC inside the
>>  chip, that has its own PCIe controller including a PF it uses to drive
>>  the hardware v-switch (so it can offload OVS rules), in addition to
>>  the PCIe controller that exposes PFs & VFs to the host you plug it
>>  into through the physical PCIe socket / edge connector.
>> In that case this bullet would refer to any additional PFs the SoC has
>>  besides the management one...
> 
> IMO the model where there's a overall controller for the entire device
> is also a mellanox limitation, due to lack of support for nested
> switches
Instead of "the PCIe controller" I should probably say "the local PCIe
 controller", since that's the wording the devlink-port doc uses.

> Say I pay for a bare metal instance in my favorite public could. 
> Why would the forwarding between VFs I spawn be controlled by the cloud
> provider and not me?!
> 
> But perhaps Netronome was the only vendor capable of nested switching.

Quite possibly.  Current EF100 NICs can't do nested switching either.

>>>> + - PFs and VFs with other personalities, including network block devices (such
>>>> +   as a vDPA virtio-blk PF backed by remote/distributed storage).  
>>>
>>> IDK how you can configure block forwarding (which is DMAs of command
>>> + data blocks, not packets AFAIU) with the networking concepts..
>>> I've not used the storage functions tho, so I could be wrong.  
>>
>> Maybe I'm way off the beam here, but my understanding is that this
>>  sort of thing involves a block interface between the host and the
>>  NIC, but then something internal to the NIC converts those
>>  operations into network operations (e.g. RDMA traffic or Ceph TCP
>>  packets), which then go out on the network to access the actual
>>  data.  In that case the back-end has to have network connectivity,
>>  and the obvious™ way to do that is give it a v-port on the v-switch
>>  just like anyone else.
> 
> I see. I don't think this covers all implementations. 

Right, I should probably make it more clear that this isn't the only
 way it could be done.
I'm merely trying to make clear that things that don't look like
 netdevices might still have a v-port and hence need a repr.

> "TX queue attached to" made me think of a netdev Tx queue with a qdisc
> rather than just a HW queue. No better ideas tho.

Would adding the word "hardware" before "TX queue" help?  Have to
 admit the netdev-queue interpretation hadn't occurred to me.

>> (And it looks like the core uses `c<N>` for my `if<N>` that you were
>>  so horrified by.  Devlink-port documentation doesn't make it super
>>  clear whether controller 0 is "the controller that's in charge" or
>>  "the controller from which we're viewing things", though I think in
>>  practice it comes to the same thing.)
> 
> I think we had a bit. Perhaps @external? The controller which doesn't
> have @external == true should be the local one IIRC. And by extension
> presumably in charge.

Yes, and that should work fine per se.  It's just not reflected in the
 phys_port_name string in any way, so legacy userland that relies on
 that won't have that piece of info (but it never did) and probably
 assumes that c0 is local.

-ed
