Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3248E507F79
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 05:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347101AbiDTDOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 23:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiDTDOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 23:14:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD79512AE8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 20:11:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id a15so656870pfv.11
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 20:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Mydw971D/sZS+4Yis0DSYjscuNVU8Du2iucpJIzUbA=;
        b=fU+GbbvI5fCa368dd7O+P7GhEBBtkZSC9EYD47px51Ya7T7c1WOge0zyIAwBlyR97z
         YK12XxztlGVxtD34wUxz81eHKGH+YEpVxwtMbUukBnEU6vMo29hOck7gw1K1FxvyDzsw
         LYqzMWifIESEgX4lm6+VxqSmA78y/3K75WNpyZv4pswGn2K6893gDLxd21UiLHRx4/CU
         Y9cIq9QZM1GWPvtFO8GdN6X4Cf++7qFj1kwMaIRtGWkGVi2lc5MWZ46A9xfJ8PIyXIWy
         OBNY65BSJ0qgMoRE9ltTZIuheK3uCy/08ict/VMwsZKIoMDxtX8BQLULQ1hpwl/34u1f
         kxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Mydw971D/sZS+4Yis0DSYjscuNVU8Du2iucpJIzUbA=;
        b=eH2dRFJqpd1mzheIL2BAPrvZSv/XhUpzPCiYSLjI89087ZduGyU+zAw1TBymNiAIVo
         k8VMbnulgxnoJjZPL2/TmzjEjhISnQcnlejoIBnEA1deiJLnnOBFn3jt+TxTgwNvxVYQ
         wbU4Ia2SLPmEvwtZIsrRla+MtCv1ecV8YO9E0+6wf2FLTSy1SLVSfRM1SttOQd5VLrKF
         S/voam1Nz0NRguZ5EeJiRPMzUg4xXtqvJD7hPxCKaDb/EwJf8vEWy4w/U42hW+zUV52/
         r/qBPS1Ee2paTT0AOUtfPtT6QQTE7n0xBMCEX5qKFXzPmPeMv4hu50rzeWGT7SizVjFs
         fG1w==
X-Gm-Message-State: AOAM5301oe0ssB0AYwfEvF/UrKwLfThDf7+YvupT0J3CFry48Bdxz0jx
        RdDYV8aG2YIKar1E8DL8MrniH+TJwc+Qzw==
X-Google-Smtp-Source: ABdhPJzvpKSJmwK9GU13PC2gJXIzt5fnIIefi0MKuwkNq0jVvaPwkviVul7QyBtHff031H3nr1nWOg==
X-Received: by 2002:a63:4004:0:b0:39d:8634:fff2 with SMTP id n4-20020a634004000000b0039d8634fff2mr16953391pga.28.1650424277925;
        Tue, 19 Apr 2022 20:11:17 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id x39-20020a056a0018a700b004fa7e6ceafesm19015641pfh.169.2022.04.19.20.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 20:11:17 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next v2] ip-link: put types on man page in alphabetic order
Date:   Tue, 19 Apr 2022 20:11:15 -0700
Message-Id: <20220420031115.26270-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lets try and keep man pages using alpha order, it looks like
it started that way then drifted.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/ip-link.8.in | 175 +++++++++++++++++++++---------------------
 1 file changed, 89 insertions(+), 86 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index ec3cc4297da5..fc214a10c4e7 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -209,43 +209,43 @@ ip-link \- network device configuration
 .ti -8
 .IR TYPE " := [ "
 .BR amt " | "
-.BR bridge " | "
+.BR bareudp " |"
 .BR bond " | "
+.BR bridge " | "
 .BR can " | "
 .BR dummy " | "
-.BR hsr " | "
-.BR ifb " | "
-.BR ipoib " |"
-.BR macvlan  " | "
-.BR macvtap  " | "
-.BR vcan " | "
-.BR vxcan " | "
-.BR veth " | "
-.BR vlan " | "
-.BR vxlan " |"
-.BR ip6tnl " |"
-.BR ipip " |"
-.BR sit " |"
+.BR erspan " |"
+.BR geneve " |"
 .BR gre " |"
 .BR gretap " |"
-.BR erspan " |"
+.BR gtp " |"
+.BR hsr " | "
+.BR ifb " | "
+.BR ip6erspan " |"
 .BR ip6gre " |"
 .BR ip6gretap " |"
-.BR ip6erspan " |"
-.BR vti " |"
-.BR nlmon " |"
+.BR ip6tnl " |"
+.BR ipip " |"
+.BR ipoib " |"
 .BR ipvlan " |"
 .BR ipvtap " |"
 .BR lowpan " |"
-.BR geneve " |"
-.BR bareudp " |"
-.BR vrf " |"
 .BR macsec " |"
+.BR macvlan  " | "
+.BR macvtap  " | "
 .BR netdevsim " |"
+.BR nlmon " |"
 .BR rmnet " |"
-.BR xfrm " |"
-.BR gtp " |"
-.BR virt_wifi " ]"
+.BR sit " |"
+.BR vcan " | "
+.BR veth " | "
+.BR virt_wifi " |"
+.BR vlan " | "
+.BR vrf " |"
+.BR vti " |"
+.BR vxcan " | "
+.BR vxlan " |"
+.BR xfrm " ]"
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
@@ -290,44 +290,52 @@ specifies the type of the new device.
 Link types:
 
 .in +8
-.B bridge
-- Ethernet Bridge device
+.BR amt
+- Automatic Multicast Tunneling (AMT)
+.sp
+.BR bareudp
+- Bare UDP L3 encapsulation support
 .sp
 .B bond
 - Bonding device
+.B bridge
+- Ethernet Bridge device
+.sp
+.B can
+- Controller Area Network
 .sp
 .B dummy
 - Dummy network interface
 .sp
-.B hsr
-- High-availability Seamless Redundancy device
+.BR erspan
+- Encapsulated Remote SPAN over GRE and IPv4
 .sp
-.B ifb
-- Intermediate Functional Block device
+.B geneve
+- GEneric NEtwork Virtualization Encapsulation
 .sp
-.B ipoib
-- IP over Infiniband device
+.B gre
+- Virtual tunnel interface GRE over IPv4
 .sp
-.B macvlan
-- Virtual interface base on link layer address (MAC)
+.BR gretap
+- Virtual L2 tunnel interface GRE over IPv4
 .sp
-.B macvtap
-- Virtual interface based on link layer address (MAC) and TAP.
+.BR gtp
+- GPRS Tunneling Protocol
 .sp
-.B vcan
-- Virtual Controller Area Network interface
+.B hsr
+- High-availability Seamless Redundancy device
 .sp
-.B vxcan
-- Virtual Controller Area Network tunnel interface
+.B ifb
+- Intermediate Functional Block device
 .sp
-.B veth
-- Virtual ethernet interface
+.BR ip6erspan
+- Encapsulated Remote SPAN over GRE and IPv6
 .sp
-.BR vlan
-- 802.1q tagged virtual LAN interface
+.BR ip6gre
+- Virtual tunnel interface GRE over IPv6
 .sp
-.BR vxlan
-- Virtual eXtended LAN
+.BR ip6gretap
+- Virtual L2 tunnel interface GRE over IPv6
 .sp
 .BR ip6tnl
 - Virtual tunnel interface IPv4|IPv6 over IPv6
@@ -335,71 +343,66 @@ Link types:
 .BR ipip
 - Virtual tunnel interface IPv4 over IPv4
 .sp
-.BR sit
-- Virtual tunnel interface IPv6 over IPv4
+.B ipoib
+- IP over Infiniband device
 .sp
-.BR gre
-- Virtual tunnel interface GRE over IPv4
+.BR ipvlan
+- Interface for L3 (IPv6/IPv4) based VLANs
 .sp
-.BR gretap
-- Virtual L2 tunnel interface GRE over IPv4
+.BR ipvtap
+- Interface for L3 (IPv6/IPv4) based VLANs and TAP
 .sp
-.BR erspan
-- Encapsulated Remote SPAN over GRE and IPv4
+.BR lowpan
+- Interface for 6LoWPAN (IPv6) over IEEE 802.15.4 / Bluetooth
 .sp
-.BR ip6gre
-- Virtual tunnel interface GRE over IPv6
+.BR macsec
+- Interface for IEEE 802.1AE MAC Security (MACsec)
 .sp
-.BR ip6gretap
-- Virtual L2 tunnel interface GRE over IPv6
+.B macvlan
+- Virtual interface base on link layer address (MAC)
 .sp
-.BR ip6erspan
-- Encapsulated Remote SPAN over GRE and IPv6
+.B macvtap
+- Virtual interface based on link layer address (MAC) and TAP.
 .sp
-.BR vti
-- Virtual tunnel interface
+.BR netdevsim
+- Interface for netdev API tests
 .sp
 .BR nlmon
 - Netlink monitoring device
 .sp
-.BR ipvlan
-- Interface for L3 (IPv6/IPv4) based VLANs
-.sp
-.BR ipvtap
-- Interface for L3 (IPv6/IPv4) based VLANs and TAP
+.BR rmnet
+- Qualcomm rmnet device
 .sp
-.BR lowpan
-- Interface for 6LoWPAN (IPv6) over IEEE 802.15.4 / Bluetooth
+.BR sit
+- Virtual tunnel interface IPv6 over IPv4
 .sp
-.BR geneve
-- GEneric NEtwork Virtualization Encapsulation
+.B vcan
+- Virtual Controller Area Network interface
 .sp
-.BR bareudp
-- Bare UDP L3 encapsulation support
+.B veth
+- Virtual ethernet interface
 .sp
-.BR amt
-- Automatic Multicast Tunneling (AMT)
+.BR virt_wifi
+- rtnetlink wifi simulation device
 .sp
-.BR macsec
-- Interface for IEEE 802.1AE MAC Security (MACsec)
+.BR vlan
+- 802.1q tagged virtual LAN interface
 .sp
 .BR vrf
 - Interface for L3 VRF domains
 .sp
-.BR netdevsim
-- Interface for netdev API tests
+.BR vti
+- Virtual tunnel interface
 .sp
-.BR rmnet
-- Qualcomm rmnet device
+.B vxcan
+- Virtual Controller Area Network tunnel interface
+.sp
+.BR vxlan
+- Virtual eXtended LAN
 .sp
 .BR xfrm
 - Virtual xfrm interface
 .sp
-.BR gtp
-- GPRS Tunneling Protocol
-.sp
-.BR virt_wifi
-- rtnetlink wifi simulation device
 .in -8
 
 .TP
-- 
2.35.1

