Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E9C59A316
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354393AbiHSRQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354336AbiHSRQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:16:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290B8146CEA;
        Fri, 19 Aug 2022 09:36:06 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gi31so3299337ejc.5;
        Fri, 19 Aug 2022 09:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=KvbU7AEM3P1kiK22wMymuDfWO9LXDaUuh1fQIZ26tNA=;
        b=FdXlU0gzRt6erznD6gpPx/MehHWfEad++r8GXzxJDykNbmDNj1FOI6M8vkxuRM9g5b
         xgtLPniKbgKQFGmgOB/AzRYGSnZvYYNJ2JBHDqspeIaEEPD2pBJtd/VegHooAIhlcBd7
         ipR0QtH5RXEFo1JPgqFIWvZFEyEhKlLyM8KneRhfn/pc63GN2LeiGvoYE7KrNjVqcrZ9
         XzkMt4hjG2/yLcj+TvhyKSLBwqjE4tFVMdmv/P/PZkLrWc1/qZ0bQ7MO9ZFJgYHhPDta
         wwJLi5EtbiotA7jDlaO4qTX8yjY58cufj5sRp29pn31JDpUMzo5JBp2AqddC4nCWSD2/
         CcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=KvbU7AEM3P1kiK22wMymuDfWO9LXDaUuh1fQIZ26tNA=;
        b=S6DtiV+66CjA+ZtpeDjLPqFUmcezBis1MUaMZZ19tP0G5bHgRZX3lhStH2wMZ7fDQo
         W+qoI05I35xAaxR6WCZymN7CKBObO6uY2DV8wHvNkokbr6PQT3TtF/v6UQ07fp3+kugY
         pQuevYjQyq9jF7zGsDR88HgcmNSVkIg9p5+du27jBNFwefeTyVROrzuFaDRoN76zIq2m
         x0myNhirD5E2L2aS2my249Uq66ZcypN7t7BPUTytLSYYPM4bMytd74xEfxZxCL97N4+U
         gKdTQmb/QD8pEOH45hMwFZQ9M1McArbO0ibonchDewdwijoqovqXAl9fTFZR2vaeTGw0
         12xw==
X-Gm-Message-State: ACgBeo1gqzOQVpK0x0YbckklXN2EA9UA1J3oPh8yg96zP61ZIvEiHoqp
        OxCfI+E9wQ0Ph/JeX3ag+sE=
X-Google-Smtp-Source: AA6agR7WlZ4ATXEetm82mEiU+twgsx0JNGuOlwom8NSsv9TbnEHtWJPJpilMT39bBr5WvWSJd4UE1w==
X-Received: by 2002:a17:906:d550:b0:733:8e1a:f7 with SMTP id cr16-20020a170906d55000b007338e1a00f7mr5408071ejc.580.1660926964549;
        Fri, 19 Aug 2022 09:36:04 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id kv24-20020a17090778d800b00731335b7ceasm2586032ejc.14.2022.08.19.09.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 09:36:04 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Parav Pandit <parav@nvidia.com>,
        "ecree@xilinx.com" <ecree@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers@amd.com" <linux-net-drivers@amd.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
References: <20220815142251.8909-1-ecree@xilinx.com>
 <PH0PR12MB5481AD558AD7A17928D78081DC6D9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <e64b17e8-6aef-fcba-0626-07ff2ca9e0d8@gmail.com>
Date:   Fri, 19 Aug 2022 17:36:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB5481AD558AD7A17928D78081DC6D9@PH0PR12MB5481.namprd12.prod.outlook.com>
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

On 18/08/2022 17:44, Parav Pandit wrote:
> A _whole_ network function is represented today using 
> a. netdevice represents representee's network port
> 
> b. devlink port function for function management

So, at the moment I'm just trying to document the current consensus,
 but where I plan to go _after_ this doc is building the case that
 devlink port as it exists today mixes in too much networking
 configuration that really belongs in the representor.  The example
 that motivated this for me is that setting the MAC address of the
 representee is currently a devlink port function operation, but
 this has nothing to do with the PCIe function and everything to do
 with the network port, so logically it should be an operation on
 the representor.  (I intend to develop a patch making it such, once
 we're all on the same page.)

I think a general rule is — would this operation make sense on a non-
 networking SR-IOV device?  If not, then it shouldn't be in devlink
 port.  E.g. why is port splitting a devlink port operation and not
 an operation on the port representor netdev?

> s/master PF/switchdev function

switchdev function might actually be the best name suggestion yet.
I like it.

> Please add text that,
> Packets transmitted by the representee and when they are not offloaded, such packets are delivered to the port representor netdevice.

That's exactly what
>> packets
>> +   transmitted to the representee which fail to match any switching rule
>> should
>> +   be received on the representor netdevice.
says.  (Although my choice of preposition — 'to', rather than 'by'
 — was less than clear.)

>> +What functions should have a representor?
>> +-----------------------------------------
>> +
>> +Essentially, for each virtual port on the device's internal switch,
>                                                                             ^^^^
> You probably wanted to say master PF internal switch here.
> 
> Better to word it as, each virtual port of a switchdev, there should be...

Hmm idk, I feel like "switchdev" has the connotation of "the software
 object inside the kernel representing the switch" rather than "the
 switch itself".

>> + - Other PFs on the local PCIe controller, and any VFs belonging to them.
> Local and/or external PCIe controllers.
That's literally the next bullet point.

>> + - PFs and VFs on other PCIe controllers on the device (e.g. for any
>> embedded
>> +   System-on-Chip within the SmartNIC).
Do I need to use the word "external" to make it more obvious?

>> + - PFs and VFs with other personalities, including network block devices
>> (such
>> +   as a vDPA virtio-blk PF backed by remote/distributed storage), if their
>> +   network access is implemented through a virtual switch port.
>> +   Note that such functions can require a representor despite the
>> representee
>> +   not having a netdev.
> This looks a big undertaking to represent them via "netdevice".
> Mostly they cannot be well represented by the netdevice.

The netdevice isn't supposed to represent the vDPA block device.  Rather
 it represents the switch port that the block device is using.

> In some cases, such vDPA devices are affiliated to the switchdev, but they use one or multiple of its ports.

If the block device uses multiple switch ports, then it should have
 multiple representors, one for each port, so that each switch port can
 be configured in the standard way.

Configuration of the block device itself is of course through separate
 interfaces which are common to non-switchdev virtual block devices.

>> + - Subfunctions (SFs) belonging to any of the above PFs or VFs, if they have
>> +   their own port on the switch (as opposed to using their parent PF's port).
> Not sure why the text has _if_ for SF and not for the VF.
> Do you see a SF device in the kernel that doesn't have their own port, due to which there is _if_ added?

This document is meant to cover situations that vendors are likely to
 find themselves in, not just those that have already been encountered.
It is plausible, at least to me, that a vendor might decide to implement
 subfunctions at a filtering rather than a switching level (i.e. it's
 just a bundle of queue pairs and you use something like ethtool NFC to
 direct traffic to it).  And if that happens, I don't want them to read
 my doc and (wrongly) think that they still need reprs for such SFs.
(The corresponding situation is far less likely to arise for VFs,
 because there's a clear understanding across the industry that VFs
 should look to their consumer like self-contained network devices,
 which implies transparent switching.)

>> +How are representors created?
>> +-----------------------------
>> +
>> +The driver instance attached to the master PF should enumerate the
>> +virtual ports on the switch, and for each representee, create a
>> +pure-software netdevice which has some form of in-kernel reference to
>> +the PF's own netdevice or driver private data (``netdev_priv()``).
> Today a user can create new virtual ports. Hence, these port represnetors and function representors are created dynamically without enumeration.
> Please add text describing both ways.

Again, this is addressed in the next sentence after you quoted:
>> +If switch ports can dynamically appear/disappear, the PF driver should
>> +create and destroy representors appropriately.

> For mlx5 case a representor netdevice has real queue from which tx/rx DMA happens from the device to/from network.
> It is not entirely pure software per say.
> Hence, "pure-software" is misleading. Please drop that word.

The rep dev doesn't own the BAR.  Everything it has it gets from
 the PF.  That's why it shouldn't SET_NETDEV_DEV, which is what I
 mean by "pure-software".

>> +The operations of the representor netdevice will generally involve
>> +acting through the master PF.  For example, ``ndo_start_xmit()`` might
>> +send the packet through a hardware TX queue attached to the master PF,
>> +with either packet metadata or queue configuration marking it for delivery
>> to the representee.
> Sharing/not sharing TX and RX queue among representor netdevices is not yet well established.

But in either case the hw TXQ will have been created out of the
 PF's BAR(s) (there's no other PCIe function/aperture to poke at
 the hardware from), that's what I mean by "attached to".  If you
 have a clearer way to word that I'm all ears.

>> +
>> +How are representors identified?
>> +--------------------------------
>> +
>> +The representor netdevice should *not* directly refer to a PCIe device (e.g.
>> +through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
>> +representee or of the master PF.
> This isn't true.
> Representor netdevices are connected to the switchdev device PCI function.

In some but not all existing drivers.
Note that I said "should not", not "does not".

> Without linking to PCI device, udev scriptology needs to grep among thousands of netdevices and its very inefficient.

It's a control plane operation, is efficiency really a prime
 concern?  If so, surely the right thing is to give
 /sys/class/net/$REP_DEV/ a suitably-named symlink to
 /sys/class/net/$SWITCH_DEV, performing the same role as the
 phys_switch_id matching without the global search, rather than
 a semantically-invalid PCIe device link.

>> +There are as yet no established conventions for naming representors
>> +which do not correspond to PCIe functions (e.g. accelerators and plugins).
> Netdevice represents the networking port of the function.

No, it represents any networking port on the switch.  Whether
 that has a PCIe function or not.
(The doc title, "Network Function Representors", is deliberately
 phrased to be interpretable as about "network functions" in the
 sense of NFV, rather than "networking PCIe functions".  An
 entire network function (in the NFV sense) could be implemented
 in hardware, in which case it would have a switch port and thus
 representor, but no PCIe function — it terminates traffic inside
 the device rather than sending it over the PCIe bus to a driver
 in the host or a VM.)

-ed
