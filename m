Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A9C23D598
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 04:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgHFCwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 22:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHFCwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 22:52:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3E4C061574
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 19:52:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y206so13839365pfb.10
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 19:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IJMAOHeQNoaDd0uyAglEK8aSh2Ec1gYdeIGp//guHiw=;
        b=ZcYMMTnWKbG2LU++wybm2P0JdkldmGfhZiC8I5T8syYYJx8+KoSC31NYiZ4cUQDhjn
         XZNsZjJIBJnSoGvDydS/LFgEv2XCxLptr0/HbO7sq+rMwJ6etH1X3D+4+sscM9p21O8T
         WZZ/VuBUjumxlb6EFYmm7eH/8eWaEhV8JvFBQrX+w7kLatY0/KS36PICmvc6HRYuuI52
         SA7vagHEpnJlolzJ3goy7emJW/vFRlPZVoFjuJ1XMH09I+N/d3z0EVH8e9vj5GeAqyl0
         unRr9W4TI7pwP00SYB6Utv/W9gKpqpBDMj4XRchoLbeuEnuHwRtUyDgyNjM8hotCwsLj
         ay5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IJMAOHeQNoaDd0uyAglEK8aSh2Ec1gYdeIGp//guHiw=;
        b=PkX+W9gQfrNm+l50sh/qyOp+aZx2750MmZC8rak+sZ1zwvjazff30zV4aXSmPmIEAE
         zPMQ/9T9hP7Qdmv40YVX3pFZF0kaO8vOukaHM/kHaGpkad5cvmEUbxTS0Uyu3aqdCqhJ
         ahMU64atuK1lUUR8nYYQWbrrAYX9fDK0/cFj6LCh1DDxnZujImwBvqugg2hCAWn0h48E
         Wj0e5eMnmIM20oZlix8ZVty8SllcNt/UYtX5eTVnckb50AAyMx5fAHUDa3q9IkD05Ijg
         bnYSvknj6pVueD3S2ApeoXOcncpdS75V2jYpnf9lrUnutBqbYBnD76D5b8ZtcajHVu6q
         wzIw==
X-Gm-Message-State: AOAM530rK5if/UwTpbYJ2RCyd3ncxa8MhZEEXpT8g9SGLHit8fQvJFKL
        w7Ns5PsOd57vbp/4+QwCo/Q=
X-Google-Smtp-Source: ABdhPJyMN2RyklzbTiIOup1YSIezfIPUIpHJptCVfA2aeCLv42/D38XvdmUyWzmZoMhH4em0DDLr0g==
X-Received: by 2002:aa7:9a4c:: with SMTP id x12mr6280147pfj.307.1596682372051;
        Wed, 05 Aug 2020 19:52:52 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t17sm4998669pgu.30.2020.08.05.19.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 19:52:51 -0700 (PDT)
Date:   Thu, 6 Aug 2020 10:52:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     gnault@redhat.com, netdev@vger.kernel.org, pmachata@gmail.com,
        roopa@cumulusnetworks.com, dsahern@kernel.org, akaris@redhat.com
Subject: Re: [PATCH net] Revert "vxlan: fix tos value before xmit"
Message-ID: <20200806025241.GO2531@dhcp-12-153.nay.redhat.com>
References: <20200805024131.2091206-1-liuhangbin@gmail.com>
 <20200805084427.GC11547@pc-2.home>
 <20200805101807.GN2531@dhcp-12-153.nay.redhat.com>
 <20200805.121110.1918790855908756881.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805.121110.1918790855908756881.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 12:11:10PM -0700, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Wed, 5 Aug 2020 18:18:07 +0800
> 
> > Should I re-post the patch with Fixes flag?
> 
> No, I took care the Fixes tag and queued this up for -stable.

Thanks

> 
> But you do need to explain what kind of testing you even did on this
> change we are reverting.  Did you make this change purely on
> theoretical grounds and a code audit?
> 
> Because it is clear now that this commit broke things and did not fix
> anything at all.
> 
> Please explain.

Yes, I do have a bug report about this and did testing before post the patch.
But the test script is long and the reason for the issue is very clear(3 bits
of DSCP are omitted). So I only explained the theory in the commit message.

The rough steps are setting vxlan tunnel on OVS. set inner packet tos to
1011 1010 (0xba) and outer vxlan to 1111 1100(0xfc). The outer packet's tos
should be 0xfe at latest as it inherit the inner ECN bit. But with RT_TOS(tos)
We actually got tos 0x1e as the first 3 bits are omitted.

Now here is detailed testing steps:

1. On Host A (which has commit 71130f29979c "vxlan: fix tos value before
xmit"):

# cat ovs.sh
#!/bin/bash
remoteip=192.168.1.207
ip link set eth1 up
ip addr add 192.168.1.156/24 dev eth1

systemctl restart openvswitch
ovs-vsctl --may-exist add-br br-int -- set Bridge br-int datapath_type=system -- br-set-external-id br-int bridge-id br-int
ovs-vsctl add-port br-int vxlan0 -- set interface vxlan0 type=vxlan options:remote_ip=$remoteip
ip netns add private
ip link add name veth-host type veth peer name veth-guest
ovs-vsctl add-port br-int veth-host
ip link set dev veth-guest netns private
ip link set dev veth-host up
ip -n private link set dev veth-guest up
ip -n private link set dev lo up
ip -n private a a dev veth-guest 192.168.123.1/24
ovs-vsctl set interface vxlan0 options:tos=0xfc

2. On Host B (which has reverted commit 71130f29979c)

# cat ovs.sh
#!/bin/bash
remoteip=192.168.1.156

ip link set eth1 up
ip addr add 192.168.1.207/24 dev eth1

systemctl restart openvswitch
ovs-vsctl --may-exist add-br br-int -- set Bridge br-int datapath_type=system -- br-set-external-id br-int bridge-id br-int
ovs-vsctl add-port br-int vxlan0 -- set interface vxlan0 type=vxlan options:remote_ip=$remoteip
ip netns add private
ip link add name veth-host type veth peer name veth-guest
ovs-vsctl add-port br-int veth-host
ip link set dev veth-guest netns private
ip link set dev veth-host up
ip -n private link set dev veth-guest up
ip -n private link set dev lo up
ip -n private a a dev veth-guest 192.168.123.2/24
ovs-vsctl set interface vxlan0 options:tos=0xfc


3. On Host A, ping host B
# ip netns exec private ping 192.168.123.2 -c1 -W1 -Q 0xba

4. Capture the packets from Host B
# tcpdump -i eth1 -nn -l -vvv
22:34:37.663803 IP (tos 0x1e,ECT(0), ttl 64, id 63743, offset 0, flags [DF], proto UDP (17), length 134)
    192.168.1.156.55502 > 192.168.1.207.4789: [no cksum] VXLAN, flags [I] (0x08), vni 0

	^^ you can see the tos value is 0x1e from Host A
IP (tos 0xba,ECT(0), ttl 64, id 37413, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.123.1 > 192.168.123.2: ICMP echo request, id 22930, seq 1, length 64

22:34:37.664624 IP (tos 0xfe,ECT(0), ttl 64, id 8233, offset 0, flags [DF], proto UDP (17), length 134)
    192.168.1.207.47657 > 192.168.1.156.4789: [no cksum] VXLAN, flags [I] (0x08), vni 0

        ^^ From Host B it's 0xfe
IP (tos 0xba,ECT(0), ttl 64, id 42030, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.123.2 > 192.168.123.1: ICMP echo reply, id 22930, seq 1, length 64
^C

Thanks
Hangbin
