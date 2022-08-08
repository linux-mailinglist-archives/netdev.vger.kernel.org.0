Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701F658CF4E
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbiHHUov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiHHUou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:44:50 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711F010FDF;
        Mon,  8 Aug 2022 13:44:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id m4so18740296ejr.3;
        Mon, 08 Aug 2022 13:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=opsDwzoRjAdoeksfOD/1s6YQJAEIbn2thcdP2iHAMcc=;
        b=QkaetPnFZdT0USzgoPFagkAh9jk7ARMpMjqUkVJsnJMN0QX8Ui88vQ2JZgbyHVS552
         1u7D68n0ttMJ778VTSLmaN3/SKYM5p7FhTSp2emr/adYhluovrLWpYcIXxc7aZUeG4C5
         FTPCFLe5AeH2B/myxfGqXHuEQtJRyX5JFBdo1hxteltFnBKBi9ZXPo3N+2kotxrcfQyl
         hJbWM0NqIK4QSH3114g2N61SElSShb65KNplrWdOmxYrBGQOjkRI9DE8SeaW+P3chsrT
         vVhroNBs9xgxFiYTUfmEaCHXsDx2Qw3fnj0sx9YXugjUkrSE3Ga6BXXpLGn6VL2mtF0n
         oZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=opsDwzoRjAdoeksfOD/1s6YQJAEIbn2thcdP2iHAMcc=;
        b=x3Es2+T2WRDxfs29Q8Nfk2LrF0pGCJFEJE7D61qZwNAk97YKeRhj/O1yvU/L1HgC03
         9ptjh85/QDht5YTHxUVRg5qBaM6gJ142Rj7LVnXmEBEpEPdrwsGMzIiWQyPXGs2WulRD
         8DJYRvW6U4ve2O69uKJRIDJ1bph8jb0vO6FoPBMmNTaKpm0qU8tUhcJsgIA+UlxqplyE
         8vSD/yFOZTgjj3Do9IDYnhwNgp4yZ0B2MJjwy9HlXoRCCTuLe17eefZdftZIjZomqBEN
         hPN2yfM3LIYB7Y8YWFRSqE2qF+vrB9DXTereeYFNByViYDxxbpMUfBuZlgm5rAX0gzIx
         Rihg==
X-Gm-Message-State: ACgBeo0PgEejz1TXs/qtCtD8WyyOdTwTITTLT7yFBXPKOgejuP7INgLH
        1wP2y8UHkg9uhaYgzXo/DBM=
X-Google-Smtp-Source: AA6agR6nHAiCY8jDq9TrnJzCBu9IP4+nD35wCSvpbrndOxS6mgaflp4FdXB+2PPpctf540slC9Xbag==
X-Received: by 2002:a17:907:a064:b0:730:726f:c62c with SMTP id ia4-20020a170907a06400b00730726fc62cmr15085566ejc.86.1659991486784;
        Mon, 08 Aug 2022 13:44:46 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p10-20020a05640243ca00b0043a7293a03dsm5003870edc.7.2022.08.08.13.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 13:44:46 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Jakub Kicinski <kuba@kernel.org>, ecree@xilinx.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-net-drivers@amd.com, Jacob Keller <jacob.e.keller@intel.com>,
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
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <71af8654-ca69-c492-7e12-ed7ff455a2f1@gmail.com>
Date:   Mon, 8 Aug 2022 21:44:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220805184359.5c55ca0d@kernel.org>
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

On 06/08/2022 02:43, Jakub Kicinski wrote:
> On Fri, 5 Aug 2022 17:58:50 +0100 ecree@xilinx.com wrote:
>> +Network function representors provide the mechanism by which network functions
>> +on an internal switch are managed. They are used both to configure the
>> +corresponding function ('representee') and to handle slow-path traffic to and
>> +from the representee for which no fast-path switching rule is matched.
> 
> I think we should just describe how those netdevs bring SR-IOV
> forwarding into Linux networking stack. This section reads too much
> like it's a hack rather than an obvious choice. Perhaps:
> 
> The representors bring the standard Linux networking stack to IOV
> functions. Same as each port of a Linux-controlled switch has a
> separate netdev, each virtual function has one. When system boots 
> and before any offload is configured all packets from the virtual
> functions appear in the networking stack of the PF via the representors.
> PF can thus always communicate freely with the virtual functions. 
> PF can configure standard Linux forwarding between representors, 
> the uplink or any other netdev (routing, bridging, TC classifiers).

Makes sense, yes.

>> +1. It is used to configure the representee's virtual MAC, e.g. link up/down,
>> +   MTU, etc.  For instance, bringing the representor administratively UP should
>> +   cause the representee to see a link up / carrier on event.
> 
> I presume you're trying to start a discussion here, rather than stating
> the existing behavior. Or the "virtual MAC" means something else than I
> think it means?

Virtual MAC in the sense that the VF (or whatever) is presented with the
 illusion that it owns a MAC on the wire whereas really it's just a port
 on a virtual switch.  So it has a link state, MAC address, MAC stats,
 probably other things I've forgotten about.
Link state following the VF rep is from [1], I just assumed that mlx had
 in fact implemented that.  (I haven't implemented it for sfc ef100.)
 Hopefully Mellanox folks can clarify what they see as the current design?
I was trying to describe the concept behind that in a more general way;
 my intuition is that this model can be applied to more than just the
 link state.  (Though we saw what a mess I made the first time I tried to
 apply this to the MAC address...)

>> +What functions should have a representor?
>> +-----------------------------------------
>> +
>> +Essentially, for each virtual port on the device's internal switch, there
>> +should be a representor.
>> +The only exceptions are the management PF (whose port is used for traffic to
>> +and from all other representors) 
> 
> AFAIK there's no "management PF" in the Linux model.

Maybe a bad word choice.  I'm referring to whichever PF (which likely
 also has an ordinary netdevice) has administrative rights over the NIC /
 internal switch at a firmware level.  Other names I've seen tossed
 around include "primary PF", "admin PF".

>> and perhaps the physical network port (for
>> +which the management PF may act as a kind of port representor.  Devices that
>> +combine multiple physical ports and SR-IOV capability may need to have port
>> +representors in addition to PF/VF representors).
> 
> That doesn't generalize well. If we just say that all uplinks and PFs
> should have a repr we don't have to make exceptions for all the cases
> where that's the case.

We could, but AFAIK that's not how existing drivers behave.  At least
 when I experimented with a mlx NIC a couple of years ago I don't
 recall it creating a repr for the primary PF or for the physical port,
 only reprs for the VFs.

>> + - Other PFs on the PCIe controller, and any VFs belonging to them.
> 
> What is "the PCIe controller" here? I presume you've seen the
> devlink-port doc.

Yes, that's where I got this terminology from.
"the" PCIe controller here is the one on which the mgmt PF lives.  For
 instance you might have a NIC where you run OVS on a SoC inside the
 chip, that has its own PCIe controller including a PF it uses to drive
 the hardware v-switch (so it can offload OVS rules), in addition to
 the PCIe controller that exposes PFs & VFs to the host you plug it
 into through the physical PCIe socket / edge connector.
In that case this bullet would refer to any additional PFs the SoC has
 besides the management one...

>> + - PFs and VFs on other PCIe controllers on the device (e.g. for any embedded
>> +   System-on-Chip within the SmartNIC).

... and this bullet to the PFs the host sees.

>> + - PFs and VFs with other personalities, including network block devices (such
>> +   as a vDPA virtio-blk PF backed by remote/distributed storage).
> 
> IDK how you can configure block forwarding (which is DMAs of command
> + data blocks, not packets AFAIU) with the networking concepts..
> I've not used the storage functions tho, so I could be wrong.

Maybe I'm way off the beam here, but my understanding is that this
 sort of thing involves a block interface between the host and the
 NIC, but then something internal to the NIC converts those
 operations into network operations (e.g. RDMA traffic or Ceph TCP
 packets), which then go out on the network to access the actual
 data.  In that case the back-end has to have network connectivity,
 and the obvious™ way to do that is give it a v-port on the v-switch
 just like anyone else.

>> +An example of a PCIe function that should *not* have a representor is, on an
>> +FPGA-based NIC, a PF which is only used to deploy a new bitstream to the FPGA,
>> +and which cannot create RX and TX queues.
> 
> What's the thinking here? We're letting everyone add their own
> exceptions to the doc?

It was just the only example I could come up with of the more general
 rule: if it doesn't have the ability to send and receive packets over
 the network (directly or indirectly), then it won't have a virtual
 port on the virtual switch, and so it doesn't make sense for it to
 have a representor.
No way to TX = nothing will ever be RXed on the rep; no way to RX = no
 way to deliver anything you TX from the rep.  And nothing for TC
 offload to act upon either for the same reasons.

>>  Since such a PF does not have network
>> +access through the internal switch, not even indirectly via a distributed
>> +storage endpoint, there is no switch virtual port for the representor to
>> +configure or to be the other end of the virtual pipe.
> 
> Does it have a netdev?

No.  But per the bit about block devices above, that's not a sufficient
 condition; PFs that terminate network traffic inside the hardware to
 implement some other functionality can have a v-switch port (and thus
 need a repr) despite not having a netdev either.
(Also, you *could* have a PF with a netdev that only talks to some kind
 of NOC and isn't connected to the v-switch, in which case that PF
 *wouldn't* have a repr.  But that seems sufficiently perverse that I
 didn't think it worth mentioning in the doc.)

>> For example, ``ndo_start_xmit()`` might send the
>> +packet, specially marked for delivery to the representee, through a TX queue
>> +attached to the management PF.
> 
> IDK how common that is, RDMA NICs will likely do the "dedicated queue
> per repr" thing since they pretend to have infinite queues.

Right.  But the queue is still created by the driver bound to the mgmt
 PF, and using that PF for whatever BAR accesses it uses to create and
 administer the queue, no?
That's the important bit, and the details of how the NIC knows which
 representee to deliver it to (dedicated queue, special TX descriptor,
 whatever) are vendor-specific magic.  Better ways of phrasing that
 are welcome :)

>> +How are representors identified?
>> +--------------------------------
>> +
>> +The representor netdevice should *not* directly refer to a PCIe device (e.g.
>> +through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
>> +representee or of the management PF.
> 
> Do we know how many existing ones do? 

Idk.  From a quick look on lxr, mlx5 and ice do; as far as I can tell
 nfp/flower does for "phy_reprs" but not "vnic_reprs".  nfp/abm does.

My reasoning for this "should not" here is that a repr is a pure
 software device; compare e.g. if you build a vlan netdev on top of
 eth0 it doesn't inherit eth0's device.
Also, at least in theory this should avoid the problem with OpenStack
 picking the wrong netdevice that you mentioned in [2], as this is
 what controls the 'device' symlink in sysfs.

>> + - ``pf<N>``, PCIe physical function index *N*.
>> + - ``vf<N>``, PCIe virtual function index *N*.
>> + - ``sf<N>``, Subfunction index *N*.
> 
> Yeah, nah... implement devlink port, please. This is done by the core,
> you shouldn't have to document this.

Oh huh, I didn't know about __devlink_port_phys_port_name_get().
Last time I looked, the drivers all had their own
 .ndo_get_phys_port_name implementations (which is why I did one for
 sfc), and any similarity between their string formats was purely an
 (undocumented) convention.  TIL!
(And it looks like the core uses `c<N>` for my `if<N>` that you were
 so horrified by.  Devlink-port documentation doesn't make it super
 clear whether controller 0 is "the controller that's in charge" or
 "the controller from which we're viewing things", though I think in
 practice it comes to the same thing.)

>> +Setting an MTU on the representor should cause that same MTU to be reported to
>> +the representee.
>> +(On hardware that allows configuring separate and distinct MTU and MRU values,
>> +the representor MTU should correspond to the representee's MRU and vice-versa.)
> 
> Why worry about that?

I just wanted to make clear that because the representor and
 representee are opposite ends of a virtual link, the latter is seen
 'mirrored' for these kinds of configuration operations.
(This makes sense because e.g. the representor's MRU is the largest
 packet that the representee can send and still have it delivered to
 the representor, thus it's the representee's MTU at least for the
 slow path.)

Thanks for the thorough review!
I've already learned some things, which was part of my objective in
 writing up this doc ;-)
-ed

[1]: https://legacy.netdevconf.info/1.2/slides/oct6/04_gerlitz_efraim_introduction_to_switchdev_sriov_offloads.pdf
[2]: https://lore.kernel.org/all/20220728113231.26fdfab0@kernel.org/
