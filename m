Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0E513C28
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 23:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfEDU5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 16:57:14 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35282 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfEDU5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 16:57:14 -0400
Received: by mail-qt1-f194.google.com with SMTP id d20so616924qto.2
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=dvIGM8sFsFSAvumIFyOSybZZvkNsP4Ek6Q7/egKEP0A=;
        b=KNHtAQUCmjrfNS3YeXXwMBr3xaxWNoo4VBfP03bj10nfuu7hCzmdM/R7nOElTe/aoz
         UEyrsyulwL8YUqQARmB462lD6uT1g+r6XzzeUThlTndrQk+2D5H2xqRkl7PimuLrYUCA
         ubZgCSnhoPhPsduyqLLer6Va+ciI+do02Mlndret8gXnz9flb/HHa1hfNOQFrmN/yxBW
         /QLA2WHQpZz9AYrcmXpphzQcmORdJdXF6f9FDzj4hQRpOoaLFlA5u6acszbtSRDr1xXw
         baHJnR3/gUi2PPf46KK0JdWIHiezrF3ZmY4W00TMGj6IrH2g3plbWBDG2yWfEEsd3Ggk
         zR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=dvIGM8sFsFSAvumIFyOSybZZvkNsP4Ek6Q7/egKEP0A=;
        b=hKnHxIWl516seGVtukpLcAX2sAgyN4uplOO/iZaY0X+CloJ/B2ANnW1d/NhOWXz4Yl
         k1qNhnHE2u3blZgKYnUfA3GWWQFSYEL+0YaC/aa5t+Da4E+Po67B49dl0PJtaQHd3G+h
         DsOHCi/CyfFGScseU6st7TvlMcnkZvfAeeZ9kU5et2CTQltbib9w3JQSHRY1Sc/8Z1Au
         ZoIAlj6M0XRxmW0pfMcJ0NDld24H1VrAjkzA+7ZHxi6Oshbc7XWnNUxQOHBRN5dwagLC
         rWCtLjESOyqO1KAu4mnIzLvFuEgXwGcZeiNRvpS3DYpuJ4Avelet0yf7N+dpNDnd9UIq
         PXZw==
X-Gm-Message-State: APjAAAVh7L0rV27/FlYSAMRiz1nmLg6l8hhBrTVQPtAx/ideAZz+ffWB
        u73TIXQwVYe21CxPRpABGLc=
X-Google-Smtp-Source: APXvYqwYp8LahvLJh0iphx8E2JJvUWzopkiOhQF1MiwFtunhjukpGZ90aWTzIFIylKW6Ab4LFzcDbg==
X-Received: by 2002:aed:3108:: with SMTP id 8mr14542910qtg.314.1557003433077;
        Sat, 04 May 2019 13:57:13 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n62sm3192167qkd.76.2019.05.04.13.57.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 13:57:12 -0700 (PDT)
Date:   Sat, 4 May 2019 16:57:11 -0400
Message-ID: <20190504165711.GD21656@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v2 2/9] net: dsa: Optional VLAN-based port
 separation for switches without tagging
In-Reply-To: <20190504135919.23185-3-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
 <20190504135919.23185-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat,  4 May 2019 16:59:12 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> This patch provides generic DSA code for using VLAN (802.1Q) tags for
> the same purpose as a dedicated switch tag for injection/extraction.
> It is based on the discussions and interest that has been so far
> expressed in https://www.spinics.net/lists/netdev/msg556125.html.
> 
> Unlike all other DSA-supported tagging protocols, CONFIG_NET_DSA_TAG_8021Q
> does not offer a complete solution for drivers (nor can it). Instead, it
> provides generic code that driver can opt into calling:
> - dsa_8021q_xmit: Inserts a VLAN header with the specified contents.
>   Can be called from another tagging protocol's xmit function.
>   Currently the LAN9303 driver is inserting headers that are simply
>   802.1Q with custom fields, so this is an opportunity for code reuse.
> - dsa_8021q_rcv: Retrieves the TPID and TCI from a VLAN-tagged skb.
>   Removing the VLAN header is left as a decision for the caller to make.
> - dsa_port_setup_8021q_tagging: For each user port, installs an Rx VID
>   and a Tx VID, for proper untagged traffic identification on ingress
>   and steering on egress. Also sets up the VLAN trunk on the upstream
>   (CPU or DSA) port. Drivers are intentionally left to call this
>   function explicitly, depending on the context and hardware support.
>   The expected switch behavior and VLAN semantics should not be violated
>   under any conditions. That is, after calling
>   dsa_port_setup_8021q_tagging, the hardware should still pass all
>   ingress traffic, be it tagged or untagged.
> 
> For uniformity with the other tagging protocols, a module for the
> dsa_8021q_netdev_ops structure is registered, but the typical usage is
> to set up another tagging protocol which selects CONFIG_NET_DSA_TAG_8021Q,
> and calls the API from tag_8021q.h. Null function definitions are also
> provided so that a "depends on" is not forced in the Kconfig.
> 
> This tagging protocol only works when switch ports are standalone, or
> when they are added to a VLAN-unaware bridge. It will probably remain
> this way for the reasons below.
> 
> When added to a bridge that has vlan_filtering 1, the bridge core will
> install its own VLANs and reset the pvids through switchdev. For the
> bridge core, switchdev is a write-only pipe. All VLAN-related state is
> kept in the bridge core and nothing is read from DSA/switchdev or from
> the driver. So the bridge core will break this port separation because
> it will install the vlan_default_pvid into all switchdev ports.
> 
> Even if we could teach the bridge driver about switchdev preference of a
> certain vlan_default_pvid (task difficult in itself since the current
> setting is per-bridge but we would need it per-port), there would still
> exist many other challenges.
> 
> Firstly, in the DSA rcv callback, a driver would have to perform an
> iterative reverse lookup to find the correct switch port. That is
> because the port is a bridge slave, so its Rx VID (port PVID) is subject
> to user configuration. How would we ensure that the user doesn't reset
> the pvid to a different value (which would make an O(1) translation
> impossible), or to a non-unique value within this DSA switch tree (which
> would make any translation impossible)?
> 
> Finally, not all switch ports are equal in DSA, and that makes it
> difficult for the bridge to be completely aware of this anyway.
> The CPU port needs to transmit tagged packets (VLAN trunk) in order for
> the DSA rcv code to be able to decode source information.
> But the bridge code has absolutely no idea which switch port is the CPU
> port, if nothing else then just because there is no netdevice registered
> by DSA for the CPU port.
> Also DSA does not currently allow the user to specify that they want the
> CPU port to do VLAN trunking anyway. VLANs are added to the CPU port
> using the same flags as they were added on the user port.
> 
> So the VLANs installed by dsa_port_setup_8021q_tagging per driver
> request should remain private from the bridge's and user's perspective,
> and should not alter the VLAN semantics observed by the user.
> 
> In the current implementation a VLAN range ending at 4095 (VLAN_N_VID)
> is reserved for this purpose. Each port receives a unique Rx VLAN and a
> unique Tx VLAN. Separate VLANs are needed for Rx and Tx because they
> serve different purposes: on Rx the switch must process traffic as
> untagged and process it with a port-based VLAN, but with care not to
> hinder bridging. On the other hand, the Tx VLAN is where the
> reachability restrictions are imposed, since by tagging frames in the
> xmit callback we are telling the switch onto which port to steer the
> frame.
> 
> Some general guidance on how this support might be employed for
> real-life hardware (some comments made by Florian Fainelli):
> 
> - If the hardware supports VLAN tag stacking, it should somehow back
>   up its private VLAN settings when the bridge tries to override them.
>   Then the driver could re-apply them as outer tags. Dedicating an outer
>   tag per bridge device would allow identical inner tag VID numbers to
>   co-exist, yet preserve broadcast domain isolation.
> 
> - If the switch cannot handle VLAN tag stacking, it should disable this
>   port separation when added as slave to a vlan_filtering bridge, in
>   that case having reduced functionality.
> 
> - Drivers for old switches that don't support the entire VLAN_N_VID
>   range will need to rework the current range selection mechanism.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

Thank you,
Vivien
