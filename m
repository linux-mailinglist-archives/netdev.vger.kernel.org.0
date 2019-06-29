Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86CA5AD8E
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 00:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbfF2WBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 18:01:43 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:39344 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfF2WBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 18:01:43 -0400
Received: by mail-wr1-f44.google.com with SMTP id x4so9795869wrt.6
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 15:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:reply-to:to:openpgp:autocrypt:subject:message-id:date
         :user-agent:mime-version:content-transfer-encoding:content-language;
        bh=gH/zpXXnnJrY0svJ9zk4kynkhlN/4zsRHgI/PdXXh+E=;
        b=i/aykYdQm4DgbzgaG4LpmY/IfhlqgDtpycbyJrNjluCGIaTo/1e5DsxrqXHdKMKMpk
         rCoLx7SBjro8qylYwPdCU0dfxC9TEkn+8fnWKa9sRbALAFapng2NHKd6LQQzQ2OvT7vd
         ksS8oAb+iHIOg+9jkMzH//BjLsx4OM549wtGxppNB7AJN6tMICQN49NxMLOlfn2rMR6j
         /Lb12ejxlZbPNG6KQUpjJvj5bQ2yeAktW+wmZ9t3DeVsgs/49aIEar/RXC1h3cwJm5B0
         X/1JHKaX977CeVY09e5zf5rMegaY5Ql5vBvJ+Ue1lG5nxuXFaLAyunv2MAC2kNlKlIoP
         VuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:reply-to:to:openpgp:autocrypt:subject
         :message-id:date:user-agent:mime-version:content-transfer-encoding
         :content-language;
        bh=gH/zpXXnnJrY0svJ9zk4kynkhlN/4zsRHgI/PdXXh+E=;
        b=rFc0JFAD7h0p+19+0GClekrYf+HMy3Jm7OlnCF46a/7C3XN3ba2v32oNFyMPSeoBPr
         gxKwrCssPedSEZSAjNrbM759UMjMgu/XmayNKWAI08+Xe41vDAOwGBnQTHZ25QJgFszl
         TsFY+qBI5YsMRwEhtMLlgPNzkP4qKEPgP8z6zqrtbWjulOEC98KK0EXxY30i4YSJHUNM
         T5xdAWkFcZzpQvHVZoX/7v1vfdiOSvrPAFGFjzPkZKwtIMDMBhFg8SAbNwf/cnfAK2UW
         //pxzuIcsEZMelrCUkHQ3WeJPqcCiL8GOO/+6ai8IvlgOhkwsA/4jrhTHSh805EeR5fk
         OfpQ==
X-Gm-Message-State: APjAAAXTCLyAoGVrqbDApiSh2FG5Ld/xy1zVWkiOeV2krF+um6sXu8IA
        e4UizfY+B9bVPdJ/ss5p3Cxu/6V0
X-Google-Smtp-Source: APXvYqxJSU8qNKUdNHLrVTHgs3gtWdy0pbztywS+2aA2UrF1tCObpOYkYppZtctufEuLCcRqr2au5A==
X-Received: by 2002:adf:e2cb:: with SMTP id d11mr13061742wrj.66.1561845699588;
        Sat, 29 Jun 2019 15:01:39 -0700 (PDT)
Received: from [192.168.84.205] ([134.101.180.17])
        by smtp.gmail.com with ESMTPSA id x16sm6018645wmj.4.2019.06.29.15.01.38
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 29 Jun 2019 15:01:39 -0700 (PDT)
From:   vtolkm@googlemail.com
X-Google-Original-From: vtolkm@gmail.com
Reply-To: vtolkm@gmail.com
To:     netdev@vger.kernel.org
Openpgp: id=640E6954D6F535488EDDC809729CFF47A416598B
Autocrypt: addr=vtolkm@gmail.com; prefer-encrypt=mutual; keydata=
 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
Subject: loss of connectivity after enabling vlan_filtering
Message-ID: <e5252bf0-f9c1-3e40-aebd-8c091dbb3e64@gmail.com>
Date:   Sun, 30 Jun 2019 00:01:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* DSA MV88E6060
* iproute2 v.5.0.0-2.0
* OpenWRT 19.07 with kernel 4.14.131 armv7l
_______

after

# bridge v a dev {bridge} self vid {n} untagged pvid

or with the device enslaved in the br

# bridge v a dev {device} vid {n} untagged pvid

I am hitting a roadblock when executing

# sysctl -w /sys/class/net/{bridge}/bridge/vlan_filtering=3D1

there is immediate loss of connectivity with the node until

# sysctl -w /sys/class/net/{bridge}/bridge/vlan_filtering=3D0

Since writing here I apparently trust that above is unexpected and I
cannot figure out what is (going) wrong.

Tried some variation (enabling VID on the client when appropriate) but
having met the same outcome.

# bridge v a dev {bridge} self vid {n} untagged
# bridge v a dev {bridge} self vid {n} pvid
# bridge v a dev {bridge} self vid {n}

# bridge v s

reflects any such change.

# ip -d l sh type bridge

br-mgt: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state
UP mode DEFAULT group default qlen 1000
=C2=A0=C2=A0=C2=A0 link/ether 1e:8e:c2:3c:b8:35 brd ff:ff:ff:ff:ff:ff pro=
miscuity 0
=C2=A0=C2=A0=C2=A0 bridge forward_delay 200 hello_time 200 max_age 2000 a=
geing_time
30000 stp_state 0 priority 32767 vlan_filtering 0 vlan_protocol 802.1Q
bridge_id 7fff.1E:8E:C2:3C:B8:35 designated_root 7fff.1E:8E:C2:3C:B8:35
root_port 0 root_path_cost 0 topology_change 0 topology_change_detected
0 hello_timer=C2=A0=C2=A0=C2=A0 0.00 tcn_timer=C2=A0=C2=A0=C2=A0 0.00 top=
ology_change_timer=C2=A0=C2=A0=C2=A0 0.00
gc_timer=C2=A0 168.58 vlan_default_pvid 1 vlan_stats_enabled 0 group_fwd_=
mask
0 group_address 01:80:c2:00:00:00 mcast_snooping 0 mcast_router 1
mcast_query_use_ifaddr 0 mcast_querier 0 mcast_hash_elasticity 4
mcast_hash_max 512 mcast_last_member_count 2 mcast_startup_query_count 2
mcast_last_member_interval 100 mcast_membership_interval 26000
mcast_querier_interval 25500 mcast_query_interval 12500
mcast_query_response_interval 1000 mcast_startup_query_interval 3125
mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_version 1
nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode
stable_secret numtxqueues 1 numrxqueues 1 gso_max_size 65536
gso_max_segs 65535

______________________

* kernel conf
---
CONFIG_NETFILTER=3Dy
CONFIG_NETFILTER_ADVANCED=3Dy
CONFIG_BRIDGE_NETFILTER=3Dm
CONFIG_NETFILTER_INGRESS=3Dy
CONFIG_NETFILTER_NETLINK=3Dm
CONFIG_NETFILTER_FAMILY_BRIDGE=3Dy
CONFIG_NETFILTER_FAMILY_ARP=3Dy
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=3Dm
CONFIG_NETFILTER_NETLINK_LOG=3Dm
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_IP_NF_MATCH_RPFILTER=3Dm
CONFIG_IP_NF_FILTER=3Dm
CONFIG_IP_NF_ARPFILTER=3Dm
CONFIG_IP6_NF_MATCH_RPFILTER=3Dm
CONFIG_IP6_NF_FILTER=3Dm
CONFIG_BRIDGE_EBT_T_FILTER=3Dm
CONFIG_ATM_BR2684_IPFILTER=3Dy
CONFIG_BRIDGE_VLAN_FILTERING=3Dy
CONFIG_HAVE_NET_DSA=3Dy
CONFIG_NET_DSA=3Dy
CONFIG_NET_DSA_TAG_DSA=3Dy
CONFIG_NET_DSA_TAG_EDSA=3Dy
CONFIG_NET_DSA_TAG_TRAILER=3Dy
CONFIG_BT_BNEP_MC_FILTER=3Dy
CONFIG_BT_BNEP_PROTO_FILTER=3Dy
# CONFIG_NET_DSA_BCM_SF2 is not set
# CONFIG_NET_DSA_LOOP is not set
# CONFIG_NET_DSA_MT7530 is not set
CONFIG_NET_DSA_MV88E6060=3Dy
CONFIG_NET_DSA_MV88E6XXX=3Dy
CONFIG_NET_DSA_MV88E6XXX_GLOBAL2=3Dy
# CONFIG_NET_DSA_QCA8K is not set
# CONFIG_NET_DSA_SMSC_LAN9303_I2C is not set
# CONFIG_NET_DSA_SMSC_LAN9303_MDIO is not set
# CONFIG_HNS_DSAF is not set
CONFIG_PPP_FILTER=3Dy
CONFIG_IPPP_FILTER=3Dy




