Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3065873B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0Qia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:38:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35570 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfF0Qia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:38:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so6342275wml.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 09:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BiIK19rWec7lYBKFGQeinVagjx2qM3OHhwACQ52D01M=;
        b=SY6tvvy/3/KVMphOJSG1HwkA/RC28GUefbKAVul/U5FOCwcHKG2kHzqLg2/BxHE4oT
         KfNBabz9otJOvIb6BSiUbdoiguOt5cv1+pzVgSfBOaHyCugodFfSnqSCHjcdY5tNvKny
         pIeJuyYXBDhndabwgCe8bE/bmj8LjsqS+khGNDvo5cd2J4JqTQvN/GNHd+Gdw5216NYm
         QwdlSheHrK3aeoV6ap8u5VO1/g3jOn2OBkFaqd5OfJCzSYizn69iGufvRFE6KPpwXzfV
         vKyg1XGz1e6UX+ZGk/qte9fETZ5r3l4pu2wKgABCV7Nfi3+jMei5r40P4yxnmlLUwCri
         BGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BiIK19rWec7lYBKFGQeinVagjx2qM3OHhwACQ52D01M=;
        b=c+K/tcti7+juhTNQew1LqqXq+RY665YI0lGKnuZ1riDin7TFqA2fFFhLDNsiyIaeSu
         bmNK0//kk9hszmergfqlxmrX+jC3HQ1u8RuwQPnPhfhZ9j07EJH53UrL6HR5C7MBquWk
         GeUiw9ud08aJlizGT1OdEeItUbx0mV3HpYvLEZqo+OUnpkSvJs2wzpyRSPv2kKQ/Ybc4
         ayN1sXiIaGVVkpAMdUqVqpAVhqsVvHVDBuO5M++4jfq4XHGOArTuBgCCR4IzvbWV0xUz
         Vk5BDZgSDDJdozx+YuN+BM6uMG22Ryu3ArLybyfNFpd4oFtQ1Q//hGIVP0xSvnbmf5tW
         cK9A==
X-Gm-Message-State: APjAAAX2Wr9IgdpqSPOCG7SqdswftTgdKWBP2daxB01xgl581Lhe4bxJ
        M0LawTgt17Df9GBwGZarz64+G7gm
X-Google-Smtp-Source: APXvYqwoNFes9ZDVf6p1jLEFG45GNB8xxrseDdihZXmZO08LZPJsl4mtf8Ki53nZDlwFMgb7mhKkig==
X-Received: by 2002:a1c:dc07:: with SMTP id t7mr4058792wmg.164.1561653506282;
        Thu, 27 Jun 2019 09:38:26 -0700 (PDT)
Received: from [10.67.50.91] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u2sm6415336wmc.3.2019.06.27.09.38.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 09:38:25 -0700 (PDT)
Subject: Re: [RFC PATCH 1/1] Documentation: net: dsa: b53: Describe b53
 configuration
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
 <20190627101506.19727-1-b.spranger@linutronix.de>
 <20190627101506.19727-2-b.spranger@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <5fe6c1b8-6273-be3d-cf75-6efdd7f9b27d@gmail.com>
Date:   Thu, 27 Jun 2019 09:38:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190627101506.19727-2-b.spranger@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/19 3:15 AM, Benedikt Spranger wrote:
> Document the different needs of documentation for the b53 driver.
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> ---
>  Documentation/networking/dsa/b53.rst | 300 +++++++++++++++++++++++++++
>  1 file changed, 300 insertions(+)
>  create mode 100644 Documentation/networking/dsa/b53.rst
> 
> diff --git a/Documentation/networking/dsa/b53.rst b/Documentation/networking/dsa/b53.rst
> new file mode 100644
> index 000000000000..5838cf6230da
> --- /dev/null
> +++ b/Documentation/networking/dsa/b53.rst
> @@ -0,0 +1,300 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==========================================
> +Broadcom RoboSwitch Ethernet switch driver
> +==========================================
> +
> +The Broadcom RoboSwitch Ethernet switch family is used in quite a range of
> +xDSL router, cable modems and other multimedia devices.
> +
> +The actual implementation supports the devices BCM5325E, BCM5365, BCM539x,
> +BCM53115 and BCM53125 as well as BCM63XX.
> +
> +Implementation details
> +======================
> +
> +The driver is located in ``drivers/net/dsa/bcm_sf2.c`` and is implemented as a
> +DSA driver; see ``Documentation/networking/dsa/dsa.rst`` for details on the
> +subsystemand what it provides.

The driver is under drivers/net/dsa/b53/

s/ethernet/Ethernet/ for your global submission.

What you are describing is not entirely specific to the B53 driver
(maybe with the exception of having a VLAN tag on the DSA master network
device, since B53 puts the CPU port tagged in all VLANs by default), and
therefore the entire document should be written with the general DSA
devices in mind, and eventually pointing out where B53 differs in a
separate document.

There are largely two kinds of behavior:

- switches that are configured with DSA_TAG_PROTO_NONE, which behave in
a certain way and require a bridge with VLAN filtering even when ports
are intended to be used as standalone devices.

- switches that are configured with a tagging protocol other than
DSA_TAG_PROTO_NONE, which behave more like traditional network devices
people are used to use.

> +
> +The switch is, if possible, configured to enable a Broadcom specific 4-bytes
> +switch tag which gets inserted by the switch for every packet forwarded to the
> +CPU interface, conversely, the CPU network interface should insert a similar
> +tag for packets entering the CPU port. The tag format is described in
> +``net/dsa/tag_brcm.c``.
> +
> +The configuration of the device depends on whether or not tagging is
> +supported.
> +
> +Configuration with tagging support
> +----------------------------------
> +
> +The tagging based configuration is desired.
> +
> +To use the b53 DSA driver some configuration need to be performed. As
> +example configuration the following scenarios are used:
> +
> +*single port*
> +  Every switch port acts as a different configurable ethernet port
> +
> +*bridge*
> +  Every switch port is part of one configurable ethernet bridge
> +
> +*gateway*
> +  Every switch port except one upstream port is part of a configurable
> +  ethernet bridge.
> +  The upstream port acts as different configurable ethernet port.
> +
> +All configurations are performed with tools from iproute2, wich is available at
> +https://www.kernel.org/pub/linux/utils/net/iproute2/
> +
> +In this documentation the following ethernet ports are used:
> +
> +*eth0*
> +  CPU port
> +
> +*LAN1*
> +  a switch port
> +
> +*LAN2*
> +  another switch port
> +
> +*WAN*
> +  A switch port dedicated as upstream port
> +
> +Further ethernet ports can be configured similar.
> +The configured IPs and networks are:
> +
> +*single port*
> +  *  wan: 192.0.2.1/30 (192.0.2.0 - 192.0.2.3)
> +  * lan1: 192.0.2.5/30 (192.0.2.4 - 192.0.2.7)
> +  * lan2: 192.0.2.9/30 (192.0.2.8 - 192.0.2.11)
> +
> +*bridge*
> +  * br0: 192.0.2.129/25 (192.0.2.128 - 192.0.2.255)
> +
> +*gateway*
> +  * br0: 192.0.2.129/25 (192.0.2.128 - 192.0.2.255)
> +  * wan: 192.0.2.1/30 (192.0.2.0 - 192.0.2.3)
> +
> +single port
> +~~~~~~~~~~~
> +
> +.. code-block:: sh
> +
> +  # configure each interface
> +  ip addr add 192.0.2.1/30 dev wan
> +  ip addr add 192.0.2.5/30 dev lan1
> +  ip addr add 192.0.2.9/30 dev lan2
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up
> +
> +bridge
> +~~~~~~

I would add something like:

All ports being part of a single bridge/broadcast domain or something
along those lines. Seeing the "wan" interface being added to a bridge is
a bit confusing.

> +
> +.. code-block:: sh
> +
> +  # create bridge
> +  ip link add name br0 type bridge
> +
> +  # add ports to bridge
> +  ip link set dev wan master br0
> +  ip link set dev lan1 master br0
> +  ip link set dev lan2 master br0
> +
> +  # configure the bridge
> +  ip addr add 192.0.2.129/25 dev br0
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up
> +
> +  # bring up the bridge
> +  ip link set dev br0 up
> +
> +gateway
> +~~~~~~~
> +
> +.. code-block:: sh
> +
> +  # create bridge
> +  ip link add name br0 type bridge
> +
> +  # add ports to bridge
> +  ip link set dev lan1 master br0
> +  ip link set dev lan2 master br0
> +
> +  # configure the bridge
> +  ip addr add 192.0.2.129/25 dev br0
> +
> +  # configure the upstream port
> +  ip addr add 192.0.2.1/30 dev wan
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up
> +
> +  # bring up the bridge
> +  ip link set dev br0 up
> +
> +Configuration without tagging support
> +-------------------------------------
> +
> +Older models (5325, 5365) support a different tag format that is not supported
> +yet. 539x and 531x5 require managed mode and some special handling, which is
> +also not yet supported. The tagging support is disabled in these cases and the
> +switch need a different configuration.

On that topic, did the patch I sent you ended up working the way you
wanted it with ifupdown-scripts or are you still chasing some other
issues with it?

> +
> +single port
> +~~~~~~~~~~~
> +The configuration can only be set up via VLAN tagging and bridge setup.
> +By default packages are tagged with vid 1:
> +
> +.. code-block:: sh
> +
> +  # tag traffic on CPU port
> +  ip link add link eth0 name eth0.1 type vlan id 1
> +  ip link add link eth0 name eth0.2 type vlan id 2
> +  ip link add link eth0 name eth0.3 type vlan id 3

That part is indeed a B53 implementation specific detail because B53
tags the CPU port in all VLANs, since otherwise any PVID untagged VLAN
programming would basically change the CPU port's default PVID and make
it untagged, undesirable.

> +
> +  # create bridges
> +  ip link add name br0 type bridge
> +  ip link add name br1 type bridge
> +  ip link add name br2 type bridge
> +
> +  # activate VLAN filtering
> +  ip link set dev br0 type bridge vlan_filtering 1
> +  ip link set dev br1 type bridge vlan_filtering 1
> +  ip link set dev br2 type bridge vlan_filtering 1
> +
> +  # add ports to bridges
> +  ip link set dev wan master br0
> +  ip link set eth0.1 master br0
> +  ip link set dev lan1 master br1
> +  ip link set eth0.2 master br1
> +  ip link set dev lan2 master br2
> +  ip link set eth0.3 master br2

I don't think you need one bridge for each port you want to isolate with
DSA_PROTO_TAG_NONE, you can just have a single bridge and assign the
ports a different VLAN with the commands below:

> +
> +  # tag traffic on ports
> +  bridge vlan add dev lan1 vid 2 pvid untagged
> +  bridge vlan del dev lan1 vid 1
> +  bridge vlan add dev lan2 vid 3 pvid untagged
> +  bridge vlan del dev lan2 vid 1

And also permit the different VLANs that you created on the bridge
master device itself:

bridge vlan add vid 2 dev br0 self
bridve vlan add vid 3 dev br0 self

Maybe that last part above ^^ was missing and that's why people tend to
create multiple bridge devices?

> +
> +  # configure the bridges
> +  ip addr add 192.0.2.1/30 dev br0
> +  ip addr add 192.0.2.5/30 dev br1
> +  ip addr add 192.0.2.9/30 dev br2
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +  ip link set eth0.1 up
> +  ip link set eth0.2 up
> +  ip link set eth0.3 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up
> +
> +  # bring up the bridge devices
> +  ip link set br0 up
> +  ip link set br1 up
> +  ip link set br2 up
> +
> +bridge
> +~~~~~~
> +
> +.. code-block:: sh
> +
> +  # tag traffic on CPU port
> +  ip link add link eth0 name eth0.1 type vlan id 1
> +
> +  # create bridge
> +  ip link add name br0 type bridge
> +
> +  # activate VLAN filtering
> +  ip link set dev br0 type bridge vlan_filtering 1
> +
> +  # add ports to bridge
> +  ip link set dev wan master br0
> +  ip link set dev lan1 master br0
> +  ip link set dev lan2 master br0
> +  ip link set eth0.1 master br0
> +
> +  # configure the bridge
> +  ip addr add 192.0.2.129/25 dev br0
> +
> +  # The master interface needs to be brought up before the slave ports.
> +  ip link set eth0 up
> +  ip link set eth0.1 up
> +
> +  # bring up the slave interfaces
> +  ip link set wan up
> +  ip link set lan1 up
> +  ip link set lan2 up
> +
> +  # bring up the bridge
> +  ip link set dev br0 up
> +
> +gateway
> +~~~~~~~
> +
> +.. code-block:: sh
> +
> +  # tag traffic on CPU port
> +  ip link add link eth0 name eth0.1 type vlan id 1
> +  ip link add link eth0 name eth0.2 type vlan id 2
> +
> +  # create bridges
> +  ip link add name br0 type bridge
> +  ip link add name br1 type bridge

Likewise, I have seen claims of people telling me they used two bridge
devices, but AFAICT this is only because the bridge master did not have
VID 2 programmed to it, so if you did the following:

bridge vlan add vid 2 dev br0 self

you should be able to get away with a single bridge master device, can
you try that?

Overall this is fills a lot of gaps and questions that were being asked
on the lamobo R1 threads on various forums, thanks a lot for doing that!
-- 
Florian
