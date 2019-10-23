Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195E7E205C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407158AbfJWQQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:16:50 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:39762 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407150AbfJWQQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:16:49 -0400
Received: by mail-pf1-f182.google.com with SMTP id v4so13238612pff.6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bGcHzW7/Fn3xzYgIzS/OcGYLksnONnpd/6hgnh8jG2Y=;
        b=O0RANRbgavmtTFG3n79PXVoeLUotdDjGHn0dvQ8f9u387Ika0jGo953LiD3RbdedEG
         RGaGUQ77y5i/mAytP/N5bwVC6r1VXN8/0r6o1Q6lYilbwQgVAjd5xUoog/ukyMS4zA1U
         PtAcV0N7dHazWXzPACk461gwMGRosAIH2GfhunQyOm+QIaoQWlfWfCLsvrdsu89stF6j
         DpJWVbRG7smiIM2Hsxp0O2oR1PpXX1qyQ3p6DjvinCNka5QTwrvnZtPAhANh7fcWva0+
         4fdAkBV366F+UzpJ8qT8ih+pFhw+stiYTT7etmZLp6DryJNtYvJKs60fnbmiENmHg7tW
         H3QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bGcHzW7/Fn3xzYgIzS/OcGYLksnONnpd/6hgnh8jG2Y=;
        b=DXp5VL0XlzJp7AmaxtByZ6hM1yP/rvSVG8i4tsZ4grP0fnMl/8fDAyaw3D3TNgUR3y
         oBaMu7cvVzhjJo/Ou434kTrPueubtSM53fYjLrJtiW2SgRjb9NYxVwOgEJMndhqkJPUs
         1/WUWFObaS37I5+wzTKWMcX0A8vvE5CJxOxhqVaCl+OnSkwCkXM4HUTvHflEXsMYaN9A
         82Gj8bIacNL8aN4eFoS4vXrenCy25uH4cYvMRfNrSgh4HCGFDpkxmYmRI/F7z3pbS1jA
         FSQoMQpjwR1tL35TVqwP57TUvGjNfVLeGcb507Rc1o7OVhu28Il926y4jzxA9EGSkQIH
         0YVQ==
X-Gm-Message-State: APjAAAW5P80cBX5HRtWZov3o58mnHbkU3cqXGXOBihnHE9Wx41JswDtx
        g5Je4BfFDPbk93R9216+KAuAXF9oA8yQFA==
X-Google-Smtp-Source: APXvYqyXK1dF37I0FqX9BapUmwtNTwL6LIbejPTabxs7f2vyrZYLj7bu61eMZlCxihPBjb/S4UDSMQ==
X-Received: by 2002:a63:6b49:: with SMTP id g70mr10876134pgc.357.1571847405400;
        Wed, 23 Oct 2019 09:16:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m12sm12012724pjk.13.2019.10.23.09.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 09:16:44 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 3/3] examples: remove diffserv
Date:   Wed, 23 Oct 2019 09:16:32 -0700
Message-Id: <20191023161632.541-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191023161632.541-1-stephen@networkplumber.org>
References: <20191023161632.541-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The diffserv examples here are out of date and incomplete.
Remove them rather than try and fix them.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 examples/diffserv/Edge1              |  68 ---------
 examples/diffserv/Edge2              |  87 ------------
 examples/diffserv/Edge31-ca-u32      | 170 -----------------------
 examples/diffserv/Edge31-cb-chains   | 132 ------------------
 examples/diffserv/Edge32-ca-u32      | 198 ---------------------------
 examples/diffserv/Edge32-cb-chains   | 144 -------------------
 examples/diffserv/Edge32-cb-u32      | 145 --------------------
 examples/diffserv/README             |  98 -------------
 examples/diffserv/afcbq              | 105 --------------
 examples/diffserv/ef-prio            |  25 ----
 examples/diffserv/efcbq              |  31 -----
 examples/diffserv/regression-testing | 125 -----------------
 12 files changed, 1328 deletions(-)
 delete mode 100644 examples/diffserv/Edge1
 delete mode 100644 examples/diffserv/Edge2
 delete mode 100644 examples/diffserv/Edge31-ca-u32
 delete mode 100644 examples/diffserv/Edge31-cb-chains
 delete mode 100644 examples/diffserv/Edge32-ca-u32
 delete mode 100644 examples/diffserv/Edge32-cb-chains
 delete mode 100644 examples/diffserv/Edge32-cb-u32
 delete mode 100644 examples/diffserv/README
 delete mode 100644 examples/diffserv/afcbq
 delete mode 100644 examples/diffserv/ef-prio
 delete mode 100644 examples/diffserv/efcbq
 delete mode 100644 examples/diffserv/regression-testing

diff --git a/examples/diffserv/Edge1 b/examples/diffserv/Edge1
deleted file mode 100644
index 4ddffdd195f1..000000000000
--- a/examples/diffserv/Edge1
+++ /dev/null
@@ -1,68 +0,0 @@
-#! /bin/sh -x
-#
-# sample script on using the ingress capabilities
-# This script just tags on the ingress interfac using Ipchains
-# the result is used for fast classification and re-marking
-# on the egress interface
-#
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/root/DS-6-beta/iproute2-990530-dsing
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-IPCHAINS=/root/DS-6-beta/ipchains-1.3.9/ipchains
-INDEV=eth2
-EGDEV="dev eth1"
-#
-# tag all incoming packets from host 10.2.0.24 to value 1
-# tag all incoming packets from host 10.2.0.3 to value 2
-# tag the rest of incoming packets from subnet 10.2.0.0/24 to value 3
-#These values are used in the egress
-#
-############################################################ 
-$IPCHAINS -A input -s 10.2.0.4/24 -m 3
-$IPCHAINS -A input -i $INDEV -s 10.2.0.24 -m 1
-$IPCHAINS -A input -i $INDEV -s 10.2.0.3 -m 2
-
-######################## Egress side ########################
-
-
-# attach a dsmarker
-#
-$TC qdisc add $EGDEV handle 1:0 root dsmark indices 64 set_tc_index
-#
-# values of the DSCP to change depending on the class
-#
-#becomes EF
-$TC class change $EGDEV classid 1:1 dsmark mask 0x3 \
-       value 0xb8
-#becomes AF11
-$TC class change $EGDEV classid 1:2 dsmark mask 0x3 \
-       value 0x28
-#becomes AF21
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x48
-#
-#
-# The class mapping
-#
-$TC filter add $EGDEV parent 1:0 protocol ip prio 4 handle 1 fw classid 1:1
-$TC filter add $EGDEV parent 1:0 protocol ip prio 4 handle 2 fw classid 1:2
-$TC filter add $EGDEV parent 1:0 protocol ip prio 4 handle 3 fw classid 1:3
-#
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent 1:0
-
-echo "---- qdisc parameters Egress  ----------"
-$TC qdisc ls $EGDEV
-echo "---- Class parameters Egress  ----------"
-$TC class ls $EGDEV
-echo "---- filter parameters Egress ----------"
-$TC filter ls $EGDEV parent 1:0
diff --git a/examples/diffserv/Edge2 b/examples/diffserv/Edge2
deleted file mode 100644
index f81f510fc06f..000000000000
--- a/examples/diffserv/Edge2
+++ /dev/null
@@ -1,87 +0,0 @@
-#! /bin/sh -x
-#
-# sample script on using the ingress capabilities
-# This script tags the fwmark on the ingress interface using IPchains
-# the result is used first for policing on the Ingress interface then
-# for fast classification and re-marking
-# on the egress interface
-#
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/root/DS-6-beta/iproute2-990530-dsing
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-IPCHAINS=/root/DS-6-beta/ipchains-1.3.9/ipchains
-INDEV=eth2
-EGDEV="dev eth1"
-#
-# tag all incoming packets from host 10.2.0.24 to value 1
-# tag all incoming packets from host 10.2.0.3 to value 2
-# tag the rest of incoming packets from subnet 10.2.0.0/24 to value 3
-#These values are used in the egress
-############################################################ 
-$IPCHAINS -A input -s 10.2.0.0/24 -m 3
-$IPCHAINS -A input -i $INDEV -s 10.2.0.24 -m 1
-$IPCHAINS -A input -i $INDEV -s 10.2.0.3 -m 2
-############################################################ 
-#
-# install the ingress qdisc on the ingress interface
-############################################################ 
-$TC qdisc add dev $INDEV handle ffff: ingress
-############################################################ 
-
-#
-# attach a fw classifier to the ingress which polices anything marked
-# by ipchains to tag value 3 (The rest of the subnet packets -- not
-# tag 1 or 2) to not go beyond 1.5Mbps
-# Allow up to at least 60 packets to burst (assuming maximum packet 
-# size of # 1.5 KB) in the long run and up to about 6 packets in the
-# shot run
-
-############################################################ 
-$TC filter add dev $INDEV parent ffff: protocol ip prio 50 handle 3 fw \
-police rate 1500kbit burst 90k mtu 9k drop flowid :1
-############################################################ 
-
-######################## Egress side ########################
-
-
-# attach a dsmarker
-#
-$TC qdisc add $EGDEV handle 1:0 root dsmark indices 64
-#
-# values of the DSCP to change depending on the class
-#
-$TC class change $EGDEV classid 1:1 dsmark mask 0x3 \
-       value 0xb8
-$TC class change $EGDEV classid 1:2 dsmark mask 0x3 \
-       value 0x28
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x48
-#
-#
-# The class mapping
-#
-$TC filter add $EGDEV parent 1:0 protocol ip prio 4 handle 1 fw classid 1:1
-$TC filter add $EGDEV parent 1:0 protocol ip prio 4 handle 2 fw classid 1:2
-$TC filter add $EGDEV parent 1:0 protocol ip prio 4 handle 3 fw classid 1:3
-#
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent ffff:
-
-echo "---- qdisc parameters Egress  ----------"
-$TC qdisc ls $EGDEV
-echo "---- Class parameters Egress  ----------"
-$TC class ls $EGDEV
-echo "---- filter parameters Egress ----------"
-$TC filter ls $EGDEV parent 1:0
-#
-#deleting the ingress qdisc
-#$TC qdisc del $DEV ingress
diff --git a/examples/diffserv/Edge31-ca-u32 b/examples/diffserv/Edge31-ca-u32
deleted file mode 100644
index 7344851aec32..000000000000
--- a/examples/diffserv/Edge31-ca-u32
+++ /dev/null
@@ -1,170 +0,0 @@
-#! /bin/sh -x
-#
-# sample script on using the ingress capabilities using u32 classifier
-# This script tags tcindex based on metering on the ingress 
-# interface the result is used for fast classification and re-marking
-# on the egress interface
-# This is an example of a color aware mode marker with PIR configured
-# based on draft-wahjak-mcm-00.txt (section 3.1)
-#
-# The colors are defined using the Diffserv Fields
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/usr/src/iproute2-current
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-INDEV=eth0
-EGDEV="dev eth1"
-CIR1=1500kbit
-CIR2=1000kbit
-
-#The CBS is about 60 MTU sized packets
-CBS1=90k
-CBS2=90k
-
-############################################################ 
-#
-# install the ingress qdisc on the ingress interface
-$TC qdisc add dev $INDEV handle ffff: ingress
-############################################################ 
-#
-# Create u32 filters 
-$TC filter add dev $INDEV parent ffff: protocol ip prio 4 handle 1: u32 \
-divisor 1
-############################################################ 
-
-# The meters: Note that we have shared meters in this case as identified
-# by the index parameter
-meter1=" police index 1 rate $CIR1 burst $CBS1 "
-meter2=" police index 2 rate $CIR2 burst $CBS1 "
-meter3=" police index 3 rate $CIR2 burst $CBS2 "
-meter4=" police index 4 rate $CIR1 burst $CBS2 "
-meter5=" police index 5 rate $CIR1 burst $CBS2 "
-
-# All packets are marked with a tcindex value which is used on the egress
-# tcindex 1 maps to AF41, 2->AF42, 3->AF43, 4->BE
-
-# *********************** AF41 *************************** 
-#AF41 (DSCP 0x22) is passed on with a tcindex value 1
-#if it doesn't exceed its CIR/CBS 
-#policer 1  is used.
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 4 u32 \
-match ip tos 0x88 0xfc \
-$meter1 \
-continue flowid :1
-#
-# if it exceeds the above but not the extra rate/burst below, it gets a 
-# tcindex value  of 2
-# policer 2 is used
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 5 u32 \
-match ip tos 0x88 0xfc \
-$meter2 \
-continue flowid :2
-#
-# if it exceeds the above but not the rule below, it gets a tcindex value
-# of 3 (policer 3)
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 u32 \
-match ip tos 0x88 0xfc \
-$meter3 \
-drop flowid :3
-#
-
-# *********************** AF42 *************************** 
-#AF42 (DSCP 0x24) from is passed on with a tcindex value 2
-#if it doesn't exceed its CIR/CBS 
-#policer 2 is used. Note that this is shared with the AF41
-#
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 5 u32 \
-match ip tos 0x90 0xfc \
-$meter2 \
-continue flowid :2
-#
-# if it exceeds the above but not the rule below, it gets a tcindex value
-# of 3 (policer 3)
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 u32 \
-match ip tos 0x90 0xfc \
-$meter3 \
-drop flowid :3
-#
-# *********************** AF43 *************************** 
-#
-#AF43 (DSCP 0x26) from is passed on with a tcindex value 3
-#if it doesn't exceed its CIR/CBS
-#policer 3 is used. Note that this is shared with the AF41 and AF42
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 u32 \
-match ip tos 0x98 0xfc \
-$meter3 \
-drop flowid :3
-#
-# *********************** BE *************************** 
-#
-# Anything else (not from the AF4*) gets discarded if it 
-# exceeds 1Mbps and by default goes to BE if it doesn't
-# Note that the BE class is also used by the AF4* in the worst
-# case
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 7 u32 \
-match ip src 0/0\
-$meter4 \
-drop flowid :4
-
-######################## Egress side ########################
-
-# attach a dsmarker
-#
-$TC qdisc add $EGDEV handle 1:0 root dsmark indices 64
-#
-# values of the DSCP to change depending on the class
-#note that the ECN bits are masked out
-#
-#AF41 (0x88 is 0x22 shifted to the right by two bits)
-#
-$TC class change $EGDEV classid 1:1 dsmark mask 0x3 \
-       value 0x88
-#AF42
-$TC class change $EGDEV classid 1:2 dsmark mask 0x3 \
-       value 0x90
-#AF43
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x98
-#BE
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x0
-#
-#
-# The class mapping
-#
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 1 tcindex classid 1:1
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 2 tcindex  classid 1:2
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 3 tcindex  classid 1:3
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 4 tcindex  classid 1:4
-#
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent ffff:
-
-echo "---- qdisc parameters Egress  ----------"
-$TC qdisc ls $EGDEV
-echo "---- Class parameters Egress  ----------"
-$TC class ls $EGDEV
-echo "---- filter parameters Egress ----------"
-$TC filter ls $EGDEV parent 1:0
-#
-#deleting the ingress qdisc
-#$TC qdisc del $INDEV ingress
diff --git a/examples/diffserv/Edge31-cb-chains b/examples/diffserv/Edge31-cb-chains
deleted file mode 100644
index 49c396bc9af7..000000000000
--- a/examples/diffserv/Edge31-cb-chains
+++ /dev/null
@@ -1,132 +0,0 @@
-#! /bin/sh -x
-#
-# sample script on using the ingress capabilities
-# This script fwmark tags(IPchains) based on metering on the ingress 
-# interface the result is used for fast classification and re-marking
-# on the egress interface
-# This is an example of a color blind mode marker with no PIR configured
-# based on draft-wahjak-mcm-00.txt (section 3.1)
-#
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/root/DS-6-beta/iproute2-990530-dsing
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-IPCHAINS=/root/DS-6-beta/ipchains-1.3.9/ipchains
-INDEV=eth2
-EGDEV="dev eth1"
-CIR1=1500kbit
-CIR2=1000kbit
-
-#The CBS is about 60 MTU sized packets
-CBS1=90k
-CBS2=90k
-
-meter1="police rate $CIR1 burst $CBS1 "
-meter2="police rate $CIR1 burst $CBS2 "
-meter3="police rate $CIR2 burst $CBS1 "
-meter4="police rate $CIR2 burst $CBS2 "
-meter5="police rate $CIR2 burst $CBS2 "
-#
-# tag the rest of incoming packets from subnet 10.2.0.0/24 to fw value 1
-# tag all incoming packets from any other subnet to fw tag 2
-############################################################ 
-$IPCHAINS -A input -i $INDEV -s 0/0 -m 2
-$IPCHAINS -A input -i $INDEV -s 10.2.0.0/24 -m 1
-#
-############################################################ 
-# install the ingress qdisc on the ingress interface
-$TC qdisc add dev $INDEV handle ffff: ingress
-#
-############################################################ 
-
-# All packets are marked with a tcindex value which is used on the egress
-# tcindex 1 maps to AF41, 2->AF42, 3->AF43, 4->BE
-#
-############################################################ 
-# 
-# anything with fw tag of 1 is passed on with a tcindex value 1
-#if it doesn't exceed its allocated rate (CIR/CBS)
-# 
-$TC filter add dev $INDEV parent ffff: protocol ip prio 4 handle 1 fw \
-$meter1 \
-continue flowid 4:1
-#
-# if it exceeds the above but not the extra rate/burst below, it gets a 
-#tcindex value  of 2
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 5 handle 1 fw \
-$meter2 \
-continue flowid 4:2
-#
-# if it exceeds the above but not the rule below, it gets a tcindex value
-# of 3
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 handle 1 fw \
-$meter3 \
-drop flowid 4:3
-#
-# Anything else (not from the subnet 10.2.0.24/24) gets discarded if it 
-# exceeds 1Mbps and by default goes to BE if it doesn't
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 handle 2 fw \
-$meter5 \
-drop flowid 4:4
-
-
-######################## Egress side ########################
-
-
-# attach a dsmarker
-#
-$TC qdisc add $EGDEV handle 1:0 root dsmark indices 64
-#
-# values of the DSCP to change depending on the class
-#note that the ECN bits are masked out
-#
-#AF41 (0x88 is 0x22 shifted to the right by two bits)
-#
-$TC class change $EGDEV classid 1:1 dsmark mask 0x3 \
-       value 0x88
-#AF42
-$TC class change $EGDEV classid 1:2 dsmark mask 0x3 \
-       value 0x90
-#AF43
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x98
-#BE
-$TC class change $EGDEV classid 1:4 dsmark mask 0x3 \
-       value 0x0
-#
-#
-# The class mapping (using tcindex; could easily have
-# replaced it with the fw classifier instead)
-#
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 1 tcindex classid 1:1
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 2 tcindex  classid 1:2
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 3 tcindex  classid 1:3
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 4 tcindex  classid 1:4
-#
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent ffff:
-
-echo "---- qdisc parameters Egress  ----------"
-$TC qdisc ls $EGDEV
-echo "---- Class parameters Egress  ----------"
-$TC class ls $EGDEV
-echo "---- filter parameters Egress ----------"
-$TC filter ls $EGDEV parent 1:0
-#
-#deleting the ingress qdisc
-#$TC qdisc del $INDEV ingress
diff --git a/examples/diffserv/Edge32-ca-u32 b/examples/diffserv/Edge32-ca-u32
deleted file mode 100644
index 9d3ccd07796c..000000000000
--- a/examples/diffserv/Edge32-ca-u32
+++ /dev/null
@@ -1,198 +0,0 @@
-#! /bin/sh -x
-#
-# sample script on using the ingress capabilities using u32 classifier
-# This script tags tcindex based on metering on the ingress 
-# interface the result is used for fast classification and re-marking
-# on the egress interface
-# This is an example of a color aware mode marker with PIR configured
-# based on draft-wahjak-mcm-00.txt (section 3.2)
-#
-# The colors are defined using the Diffserv Fields
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/root/DS-6-beta/iproute2-990530-dsing
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-IPCHAINS=/root/DS-6-beta/ipchains-1.3.9/ipchains
-INDEV=eth2
-EGDEV="dev eth1"
-CIR1=1000kbit
-CIR2=500kbit
-# the PIR is what is in excess of the CIR
-PIR1=1000kbit
-PIR2=500kbit
-
-#The CBS is about 60 MTU sized packets
-CBS1=90k
-CBS2=90k
-#the EBS is about 20 max sized packets
-EBS1=30k
-EBS2=30k
-
-# The meters: Note that we have shared meters in this case as identified
-# by the index parameter
-meter1=" police index 1 rate $CIR1 burst $CBS1 "
-meter1a=" police index 2 rate $PIR1 burst $EBS1 "
-meter2=" police index 3 rate $CIR2 burst $CBS1 "
-meter2a=" police index 4 rate $PIR2 burst $EBS1 "
-meter3=" police index 5 rate $CIR2 burst $CBS2 "
-meter3a=" police index 6 rate $PIR2 burst $EBS2 "
-meter4=" police index 7 rate $CIR1 burst $CBS2 "
-
-############################################################ 
-#
-# install the ingress qdisc on the ingress interface
-$TC qdisc add dev $INDEV handle ffff: ingress
-############################################################ 
-#
-# All packets are marked with a tcindex value which is used on the egress
-# tcindex 1 maps to AF41, 2->AF42, 3->AF43, 4->BE
-#
-# *********************** AF41 *************************** 
-#AF41 (DSCP 0x22) from is passed on with a tcindex value 1
-#if it doesn't exceed its CIR/CBS + PIR/EBS
-#policer 1  is used.
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 1 u32 \
-match ip tos 0x88 0xfc \
-$meter1 \
-continue flowid :1
-$TC filter add dev $INDEV parent ffff: protocol ip prio 2 u32 \
-match ip tos 0x88 0xfc \
-$meter1a \
-continue flowid :1
-#
-# if it exceeds the above but not the extra rate/burst below, it gets a 
-# tcindex value  of 2
-# policer 2 is used
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 3 u32 \
-match ip tos 0x88 0xfc \
-$meter2 \
-continue flowid :2
-$TC filter add dev $INDEV parent ffff: protocol ip prio 4 u32 \
-match ip tos 0x88 0xfc \
-$meter2a \
-continue flowid :2
-#
-# if it exceeds the above but not the rule below, it gets a tcindex value
-# of 3 (policer 3)
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 5 u32 \
-match ip tos 0x88 0xfc \
-$meter3 \
-continue flowid :3
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 u32 \
-match ip tos 0x88 0xfc \
-$meter3a \
-drop flowid :3
-#
-# *********************** AF42 *************************** 
-#AF42 (DSCP 0x24) from is passed on with a tcindex value 2
-#if it doesn't exceed its CIR/CBS + PIR/EBS
-#policer 2 is used. Note that this is shared with the AF41
-#
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 8 u32 \
-match ip tos 0x90 0xfc \
-$meter2 \
-continue flowid :2
-$TC filter add dev $INDEV parent ffff: protocol ip prio 9 u32 \
-match ip tos 0x90 0xfc \
-$meter2a \
-continue flowid :2
-#
-# if it exceeds the above but not the rule below, it gets a tcindex value
-# of 3 (policer 3)
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 10 u32 \
-match ip tos 0x90 0xfc \
-$meter3 \
-continue flowid :3
-$TC filter add dev $INDEV parent ffff: protocol ip prio 11 u32 \
-match ip tos 0x90 0xfc \
-$meter3a \
-drop flowid :3
-
-#
-# *********************** AF43 *************************** 
-#
-#AF43 (DSCP 0x26) from is passed on with a tcindex value 3
-#if it doesn't exceed its CIR/CBS + PIR/EBS
-#policer 3 is used. Note that this is shared with the AF41 and AF42
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 13 u32 \
-match ip tos 0x98 0xfc \
-$meter3 \
-continue flowid :3
-$TC filter add dev $INDEV parent ffff: protocol ip prio 14 u32 \
-match ip tos 0x98 0xfc \
-$meter3a \
-drop flowid :3
-#
-## *********************** BE *************************** 
-##
-## Anything else (not from the AF4*) gets discarded if it 
-## exceeds 1Mbps and by default goes to BE if it doesn't
-## Note that the BE class is also used by the AF4* in the worst
-## case
-##
-$TC filter add dev $INDEV parent ffff: protocol ip prio 16 u32 \
-match ip src 0/0\
-$meter4 \
-drop flowid :4
-
-######################## Egress side ########################
-
-# attach a dsmarker
-#
-$TC qdisc add $EGDEV handle 1:0 root dsmark indices 64
-#
-# values of the DSCP to change depending on the class
-#note that the ECN bits are masked out
-#
-#AF41 (0x88 is 0x22 shifted to the right by two bits)
-#
-$TC class change $EGDEV classid 1:1 dsmark mask 0x3 \
-       value 0x88
-#AF42
-$TC class change $EGDEV classid 1:2 dsmark mask 0x3 \
-       value 0x90
-#AF43
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x98
-#BE
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x0
-#
-#
-# The class mapping
-#
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 1 tcindex classid 1:1
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 2 tcindex  classid 1:2
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 3 tcindex  classid 1:3
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 4 tcindex  classid 1:4
-#
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent ffff:
-
-echo "---- qdisc parameters Egress  ----------"
-$TC qdisc ls $EGDEV
-echo "---- Class parameters Egress  ----------"
-$TC class ls $EGDEV
-echo "---- filter parameters Egress ----------"
-$TC filter ls $EGDEV parent 1:0
-#
-#deleting the ingress qdisc
-#$TC qdisc del $INDEV ingress
diff --git a/examples/diffserv/Edge32-cb-chains b/examples/diffserv/Edge32-cb-chains
deleted file mode 100644
index 88ee2ceaf57e..000000000000
--- a/examples/diffserv/Edge32-cb-chains
+++ /dev/null
@@ -1,144 +0,0 @@
-#! /bin/sh -x
-#
-# sample script on using the ingress capabilities
-# This script fwmark tags(IPchains) based on metering on the ingress 
-# interface the result is used for fast classification and re-marking
-# on the egress interface
-# This is an example of a color blind mode marker with no PIR configured
-# based on draft-wahjak-mcm-00.txt (section 3.1)
-#
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/root/DS-6-beta/iproute2-990530-dsing
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-IPCHAINS=/root/DS-6-beta/ipchains-1.3.9/ipchains
-INDEV=eth2
-EGDEV="dev eth1"
-CIR1=1500kbit
-CIR2=500kbit
-
-#The CBS is about 60 MTU sized packets
-CBS1=90k
-CBS2=90k
-
-meter1="police rate $CIR1 burst $CBS1 "
-meter1a="police rate $CIR2 burst $CBS1 "
-meter2="police rate $CIR1 burst $CBS2 "
-meter2a="police rate $CIR2 burst $CBS2 "
-meter3="police rate $CIR2 burst $CBS1 "
-meter3a="police rate $CIR2 burst $CBS1 "
-meter4="police rate $CIR2 burst $CBS2 "
-meter5="police rate $CIR1 burst $CBS2 "
-#
-# tag the rest of incoming packets from subnet 10.2.0.0/24 to fw value 1
-# tag all incoming packets from any other subnet to fw tag 2
-############################################################ 
-$IPCHAINS -A input -i $INDEV -s 0/0 -m 2
-$IPCHAINS -A input -i $INDEV -s 10.2.0.0/24 -m 1
-#
-############################################################ 
-# install the ingress qdisc on the ingress interface
-$TC qdisc add dev $INDEV handle ffff: ingress
-#
-############################################################ 
-
-# All packets are marked with a tcindex value which is used on the egress
-# tcindex 1 maps to AF41, 2->AF42, 3->AF43, 4->BE
-#
-############################################################ 
-# 
-# anything with fw tag of 1 is passed on with a tcindex value 1
-#if it doesn't exceed its allocated rate (CIR/CBS)
-# 
-$TC filter add dev $INDEV parent ffff: protocol ip prio 1 handle 1 fw \
-$meter1 \
-continue flowid 4:1
-$TC filter add dev $INDEV parent ffff: protocol ip prio 2 handle 1 fw \
-$meter1a \
-continue flowid 4:1
-#
-# if it exceeds the above but not the extra rate/burst below, it gets a 
-#tcindex value  of 2
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 3 handle 1 fw \
-$meter2 \
-continue flowid 4:2
-$TC filter add dev $INDEV parent ffff: protocol ip prio 4 handle 1 fw \
-$meter2a \
-continue flowid 4:2
-#
-# if it exceeds the above but not the rule below, it gets a tcindex value
-# of 3
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 5 handle 1 fw \
-$meter3 \
-continue flowid 4:3
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 handle 1 fw \
-$meter3a \
-drop flowid 4:3
-#
-# Anything else (not from the subnet 10.2.0.24/24) gets discarded if it 
-# exceeds 1Mbps and by default goes to BE if it doesn't
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 7 handle 2 fw \
-$meter5 \
-drop flowid 4:4
-
-
-######################## Egress side ########################
-
-
-# attach a dsmarker
-#
-$TC qdisc add $EGDEV handle 1:0 root dsmark indices 64
-#
-# values of the DSCP to change depending on the class
-#note that the ECN bits are masked out
-#
-#AF41 (0x88 is 0x22 shifted to the right by two bits)
-#
-$TC class change $EGDEV classid 1:1 dsmark mask 0x3 \
-       value 0x88
-#AF42
-$TC class change $EGDEV classid 1:2 dsmark mask 0x3 \
-       value 0x90
-#AF43
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x98
-#BE
-$TC class change $EGDEV classid 1:4 dsmark mask 0x3 \
-       value 0x0
-#
-#
-# The class mapping (using tcindex; could easily have
-# replaced it with the fw classifier instead)
-#
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 1 tcindex classid 1:1
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 2 tcindex  classid 1:2
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 3 tcindex  classid 1:3
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 4 tcindex  classid 1:4
-#
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent ffff:
-
-echo "---- qdisc parameters Egress  ----------"
-$TC qdisc ls $EGDEV
-echo "---- Class parameters Egress  ----------"
-$TC class ls $EGDEV
-echo "---- filter parameters Egress ----------"
-$TC filter ls $EGDEV parent 1:0
-#
-#deleting the ingress qdisc
-#$TC qdisc del $INDEV ingress
diff --git a/examples/diffserv/Edge32-cb-u32 b/examples/diffserv/Edge32-cb-u32
deleted file mode 100644
index 544941376f92..000000000000
--- a/examples/diffserv/Edge32-cb-u32
+++ /dev/null
@@ -1,145 +0,0 @@
-#! /bin/sh 
-#
-# sample script on using the ingress capabilities using u32 classifier
-# This script tags tcindex based on metering on the ingress 
-# interface the result is used for fast classification and re-marking
-# on the egress interface
-# This is an example of a color blind mode marker with PIR configured
-# based on draft-wahjak-mcm-00.txt (section 3.2)
-#
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/root/DS-6-beta/iproute2-990530-dsing
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-INDEV=eth2
-EGDEV="dev eth1"
-CIR1=1000kbit
-CIR2=1000kbit
-# The PIR is the excess (in addition to the CIR i.e if always
-# going to the PIR --> average rate is CIR+PIR)
-PIR1=1000kbit
-PIR2=500kbit
-
-#The CBS is about 60 MTU sized packets
-CBS1=90k
-CBS2=90k
-#the EBS is about 10 max sized packets
-EBS1=15k
-EBS2=15k
-# The meters
-meter1=" police rate $CIR1 burst $CBS1 "
-meter1a=" police rate $PIR1 burst $EBS1 "
-meter2=" police rate $CIR2 burst $CBS1 "
-meter2a="police rate $PIR2 burst $CBS1 "
-meter3=" police rate $CIR2 burst $CBS2 "
-meter3a=" police rate $PIR2 burst $EBS2 "
-meter4=" police rate $CIR1 burst $CBS2 "
-meter5=" police rate $CIR1 burst $CBS2 "
-
-
-# install the ingress qdisc on the ingress interface
-############################################################ 
-$TC qdisc add dev $INDEV handle ffff: ingress
-############################################################ 
-#
-############################################################ 
-
-# All packets are marked with a tcindex value which is used on the egress
-# NOTE: tcindex 1 maps to AF41, 2->AF42, 3->AF43, 4->BE
-# 
-#anything from subnet 10.2.0.2/24 is passed on with a tcindex value 1
-#if it doesn't exceed its CIR/CBS + PIR/EBS
-# 
-$TC filter add dev $INDEV parent ffff: protocol ip prio 1 u32 \
-match ip src 10.2.0.0/24 $meter1 \
-continue flowid :1
-$TC filter add dev $INDEV parent ffff: protocol ip prio 2 u32 \
-match ip src 10.2.0.0/24 $meter1a \
-continue flowid :1
-
-#
-# if it exceeds the above but not the extra rate/burst below, it gets a 
-#tcindex value  of 2
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 3 u32 \
-match ip src 10.2.0.0/24 $meter2 \
-continue flowid :2
-$TC filter add dev $INDEV parent ffff: protocol ip prio 4 u32 \
-match ip src 10.2.0.0/24 $meter2a \
-continue flowid :2
-#
-# if it exceeds the above but not the rule below, it gets a tcindex value
-# of 3
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 5 u32 \
-match ip src 10.2.0.0/24 $meter3 \
-continue flowid :3
-$TC filter add dev $INDEV parent ffff: protocol ip prio 6 u32 \
-match ip src 10.2.0.0/24 $meter3a \
-drop flowid :3
-#
-#
-# Anything else (not from the subnet 10.2.0.24/24) gets discarded if it 
-# exceeds 1Mbps and by default goes to BE if it doesn't
-#
-$TC filter add dev $INDEV parent ffff: protocol ip prio 7 u32 \
-match ip src 0/0 $meter5 \
-drop flowid :4
-
-
-######################## Egress side ########################
-
-
-# attach a dsmarker
-#
-$TC qdisc add $EGDEV handle 1:0 root dsmark indices 64
-#
-# values of the DSCP to change depending on the class
-#note that the ECN bits are masked out
-#
-#AF41 (0x88 is 0x22 shifted to the right by two bits)
-#
-$TC class change $EGDEV classid 1:1 dsmark mask 0x3 \
-       value 0x88
-#AF42
-$TC class change $EGDEV classid 1:2 dsmark mask 0x3 \
-       value 0x90
-#AF43
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x98
-#BE
-$TC class change $EGDEV classid 1:3 dsmark mask 0x3 \
-       value 0x0
-#
-#
-# The class mapping
-#
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 1 tcindex classid 1:1
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 2 tcindex  classid 1:2
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 3 tcindex  classid 1:3
-$TC filter add $EGDEV parent 1:0 protocol ip prio 1 \
-          handle 4 tcindex  classid 1:4
-#
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent ffff:
-
-echo "---- qdisc parameters Egress  ----------"
-$TC qdisc ls $EGDEV
-echo "---- Class parameters Egress  ----------"
-$TC class ls $EGDEV
-echo "---- filter parameters Egress ----------"
-$TC filter ls $EGDEV parent 1:0
-#
-#deleting the ingress qdisc
-#$TC qdisc del $INDEV ingress
diff --git a/examples/diffserv/README b/examples/diffserv/README
deleted file mode 100644
index ec91d632e0c9..000000000000
--- a/examples/diffserv/README
+++ /dev/null
@@ -1,98 +0,0 @@
-
-Note all these are mere examples which can be customized to your needs
-
-AFCBQ
------
-AF PHB built using CBQ, DSMARK,GRED (default in GRIO mode) ,RED for BE 
-and the tcindex classifier with some algorithmic mapping
-
-EFCBQ
------
-EF PHB built using CBQ (for rate control and prioritization), 
-DSMARK( to remark DSCPs), tcindex  classifier and  RED for the BE
-traffic.
-
-EFPRIO
-------
-EF PHB using the PRIO scheduler, Token Bucket to rate control EF,
-tcindex classifier, DSMARK to remark, and RED for the BE traffic
-
-EDGE scripts
-==============
-
-CB-3(1|2)-(u32/chains)
-======================
-
-
-The major differences are that the classifier is u32 on -u32 extension
-and IPchains on the chains extension. CB stands for color Blind
-and 31 is for the mode where only a CIR and CBS are defined whereas
-32 stands for a mode where a CIR/CBS + PIR/EBS are defined.
-
-Color Blind (CB)
-==========-----=
-We look at one special subnet that we are interested in for simplicty
-reasons to demonstrate the capability. We send the packets from that
-subnet to AF4*, BE or end up dropping depending on the metering results. 
-
-
-The algorithm overview is as follows:
-
-*classify:
-
-**case: subnet X
-----------------
-  if !exceed meter1 tag as AF41
-	else
-	    if !exceed meter2  tag as AF42
-	        else
-		  if !exceed meter 3 tag as AF43
-		      else 
-			 drop 
-
-default case: Any other subnet
--------------------------------
-  if !exceed meter 5 tag as AF43
-      else
-	 drop 
-
-
-One Egress side change the DSCPs of the packets to reflect AF4* and BE
-based on the tags from the ingress.
-
--------------------------------------------------------------
-
-Color Aware
-===========
-
-Define some meters with + policing and give them IDs eg
-
-meter1=police index 1 rate $CIR1 burst $CBS1  
-meter2=police index 2 rate $CIR2 burst $CBS2   etc 
-
-General overview:
-classify based on the DSCPs and use the policer ids to decide tagging
-
-
-*classify on ingress:
-
-switch (dscp) {
-    case AF41: /* tos&0xfc == 0x88 */
-	if (!exceed meter1) break;
-    case AF42: /* tos&0xfc == 0x90 */
-	if (!exceed meter2) {
-	    tag as AF42;
-	    break;
-	}
-    case AF43: /* tos&0xfc == 0x98 */
-	if (!exceed meter3) {
-	    tag as AF43;
-	    break;
-	} else
-	  drop;
-    default:
-	if (!exceed meter4) tag as BE;
-	else drop;
-}
-
-On the Egress side mark the proper AF tags
diff --git a/examples/diffserv/afcbq b/examples/diffserv/afcbq
deleted file mode 100644
index 10d6d934486f..000000000000
--- a/examples/diffserv/afcbq
+++ /dev/null
@@ -1,105 +0,0 @@
-#!/usr/bin/perl
-#
-#
-# AF using CBQ for a single interface eth0 
-# 4 AF classes using GRED and one BE using RED
-# Things you might want to change:
-#	- the device bandwidth (set at 10Mbits)
-#	- the bandwidth allocated for each AF class and the BE class	
-#	- the drop probability associated with each AF virtual queue
-#
-# AF DSCP values used (based on AF draft 04)
-# -----------------------------------------
-# AF DSCP values
-# AF1 1. 0x0a 2. 0x0c 3. 0x0e
-# AF2 1. 0x12 2. 0x14 3. 0x16
-# AF3 1. 0x1a 2. 0x1c 3. 0x1e
-# AF4 1. 0x22 2. 0x24 3. 0x26
-
-#
-# 
-# A simple DSCP-class relationship formula used to generate
-# values in the for loop of this script; $drop stands for the
-# DP
-#	$dscp = ($class*8+$drop*2)
-#
-#  if you use GRIO buffer sharing, then GRED priority is set as follows:
-#  $gprio=$drop+1; 
-#
-
-$TC = "/usr/src/iproute2-current/tc/tc";
-$DEV = "dev lo";
-$DEV = "dev eth1";
-$DEV = "dev eth0";
-# the BE-class number
-$beclass = "5";  
-
-#GRIO buffer sharing on or off?
-$GRIO = "";
-$GRIO = "grio";
-# The bandwidth of your device
-$linerate="10Mbit";
-# The BE and AF rates
-%rate_table=();
-$berate="1500Kbit";
-$rate_table{"AF1rate"}="1500Kbit";
-$rate_table{"AF2rate"}="1500Kbit";
-$rate_table{"AF3rate"}="1500Kbit";
-$rate_table{"AF4rate"}="1500Kbit";
-#
-#
-#
-print "\n# --- General setup  ---\n";
-print "$TC qdisc add $DEV handle 1:0 root dsmark indices 64 set_tc_index\n";
-print "$TC filter add $DEV parent 1:0 protocol ip prio 1 tcindex mask 0xfc " .
-   "shift 2 pass_on\n";
-   #"shift 2\n";
-print "$TC qdisc add $DEV parent 1:0 handle 2:0 cbq bandwidth $linerate ".
-  "cell 8 avpkt 1000 mpu 64\n";
-print "$TC filter add $DEV parent 2:0 protocol ip prio 1 tcindex ".
-  "mask 0xf0 shift 4 pass_on\n";
-for $class (1..4) {
-    print "\n# --- AF Class $class specific setup---\n";
-    $AFrate=sprintf("AF%drate",$class);
-    print "$TC class add $DEV parent 2:0 classid 2:$class cbq ".
-      "bandwidth $linerate rate $rate_table{$AFrate} avpkt 1000 prio ".
-      (6-$class)." bounded allot 1514 weight 1 maxburst 21\n";
-    print "$TC filter add $DEV parent 2:0 protocol ip prio 1 handle $class ".
-      "tcindex classid 2:$class\n";
-    print "$TC qdisc add $DEV parent 2:$class gred setup DPs 3 default 2 ".
-      "$GRIO\n";
-# 
-# per DP setup
-#
-    for $drop (1..3) {
-    print "\n# --- AF Class $class DP $drop---\n";
-	$dscp = $class*8+$drop*2;
-	$tcindex = sprintf("1%x%x",$class,$drop);
-	print "$TC filter add $DEV parent 1:0 protocol ip prio 1 ".
-	  "handle $dscp tcindex classid 1:$tcindex\n";
-	$prob = $drop*0.02;
-        if ($GRIO) {
-	$gprio = $drop+1;
-	print "$TC qdisc change $DEV parent 2:$class gred limit 60KB min 15KB ".
-	  "max 45KB burst 20 avpkt 1000 bandwidth $linerate DP $drop ".
-	  "probability $prob ".
-          "prio $gprio\n";
-        } else {
-	print "$TC qdisc change $DEV parent 2:$class gred limit 60KB min 15KB ".
-	  "max 45KB burst 20 avpkt 1000 bandwidth $linerate DP $drop ".
-	  "probability $prob \n";
-	}
-    }
-}
-#
-#
-print "\n#------BE Queue setup------\n";
-print "$TC filter add $DEV parent 1:0 protocol ip prio 2 ".
-          "handle 0 tcindex mask 0 classid 1:1\n";
-print "$TC class add $DEV parent 2:0 classid 2:$beclass cbq ".
-      "bandwidth $linerate rate $berate avpkt 1000 prio 6 " .
-      "bounded allot 1514 weight 1 maxburst 21 \n";
-print "$TC filter add $DEV parent 2:0 protocol ip prio 1 handle 0 tcindex ".
-  "classid 2:5\n";
-print "$TC qdisc add $DEV parent 2:5 red limit 60KB min 15KB max 45KB ".
-  "burst 20 avpkt 1000 bandwidth $linerate probability 0.4\n";
diff --git a/examples/diffserv/ef-prio b/examples/diffserv/ef-prio
deleted file mode 100644
index 48611bdd65e8..000000000000
--- a/examples/diffserv/ef-prio
+++ /dev/null
@@ -1,25 +0,0 @@
-#!/usr/bin/perl
-$TC = "/root/DS-6-beta/iproute2-990530-dsing/tc/tc";
-$DEV = "dev eth1";
-$efrate="1.5Mbit";
-$MTU="1.5kB";
-print "$TC qdisc add $DEV handle 1:0 root dsmark indices 64 set_tc_index\n";
-print "$TC filter add $DEV parent 1:0 protocol ip prio 1 tcindex ".
-  "mask 0xfc shift 2\n";
-print "$TC qdisc add $DEV parent 1:0 handle 2:0 prio\n";
-#
-# EF class: Maximum about one MTU sized packet allowed on the queue
-#
-print "$TC qdisc add $DEV parent 2:1 tbf rate $efrate burst $MTU limit 1.6kB\n";
-print "$TC filter add $DEV parent 2:0 protocol ip prio 1 ".
-	  "handle 0x2e tcindex classid 2:1 pass_on\n";
-#
-# BE class
-#
-print "#BE class(2:2) \n";
-print "$TC qdisc add $DEV parent 2:2 red limit 60KB ".
-	  "min 15KB max 45KB burst 20 avpkt 1000 bandwidth 10Mbit ".
-	  "probability 0.4\n";
-#
-print "$TC filter add $DEV parent 2:0 protocol ip prio 2 ".
-	  "handle 0 tcindex mask 0 classid 2:2 pass_on\n";
diff --git a/examples/diffserv/efcbq b/examples/diffserv/efcbq
deleted file mode 100644
index bcc437b3d229..000000000000
--- a/examples/diffserv/efcbq
+++ /dev/null
@@ -1,31 +0,0 @@
-#!/usr/bin/perl
-#
-$TC = "/root/DS-6-beta/iproute2-990530-dsing/tc/tc";
-$DEV = "dev eth1";
-print "$TC qdisc add $DEV handle 1:0 root dsmark indices 64 set_tc_index\n";
-print "$TC filter add $DEV parent 1:0 protocol ip prio 1 tcindex ".
-  "mask 0xfc shift 2\n";
-print "$TC qdisc add $DEV parent 1:0 handle 2:0 cbq bandwidth ".
-	"10Mbit cell 8 avpkt 1000 mpu 64\n";
-#
-# EF class
-#
-print "$TC class add $DEV parent 2:0 classid 2:1 cbq bandwidth ". 
-	"10Mbit rate 1500Kbit avpkt 1000 prio 1 bounded isolated ".
-	"allot 1514 weight 1 maxburst 10 \n";
-# packet fifo for EF?
-print "$TC qdisc add $DEV parent 2:1 pfifo limit 5\n";
-print "$TC filter add $DEV parent 2:0 protocol ip prio 1 ".
-	  "handle 0x2e tcindex classid 2:1 pass_on\n";
-#
-# BE class
-#
-print "#BE class(2:2) \n";
-print "$TC class add $DEV parent 2:0 classid 2:2 cbq bandwidth ". 
-	"10Mbit rate 5Mbit avpkt 1000 prio 7 allot 1514 weight 1 ".
-	"maxburst 21 borrow split 2:0 defmap 0xffff \n";
-print "$TC qdisc add $DEV parent 2:2 red limit 60KB ".
-	  "min 15KB max 45KB burst 20 avpkt 1000 bandwidth 10Mbit ".
-	  "probability 0.4\n";
-print "$TC filter add $DEV parent 2:0 protocol ip prio 2 ".
-	  "handle 0 tcindex mask 0 classid 2:2 pass_on\n";
diff --git a/examples/diffserv/regression-testing b/examples/diffserv/regression-testing
deleted file mode 100644
index d50f4c8a3b5a..000000000000
--- a/examples/diffserv/regression-testing
+++ /dev/null
@@ -1,125 +0,0 @@
-
-These were the tests done to validate the Diffserv scripts.
-This document will be updated continuously. If you do more
-thorough validation testing please post the details to the
-diffserv mailing list. 
-Nevertheless, these tests should serve for basic validation.
-
-AFCBQ, EFCBQ, EFPRIO
-----------------------
-
-generate all possible DSCPs and observe that they 
-get sent to the proper classes. In the case of AF also
-to the correct Virtual Queues.
-
-Edge1
------
-generate TOS values 0x0,0x10,0xbb each with IP addresses
-10.2.0.24 (mark 1), 10.2.0.3 (mark2) and 10.2.0.30 (mark 3)
-and observe that they get marked as expected.
-
-Edge2
------
-
--Repeat the tests in Edge1
--ftp with data direction from 10.2.0.2
-	*observe that the metering/policing works correctly (and the marking
-	as well). In this case the mark used will be 3
-
-Edge31-cb-chains
-----------------
-
--ftp with data direction from 10.2.0.2
-
-	*observe that the metering/policing works correctly (and the marking
-	as well). In this case the mark used will be 1. 
-
-	Metering: The data throughput should not exceed 2*CIR1 + 2*CIR2
-	which is roughly: 5mbps
-
-	Marking: the should be a variation of marked packets:
-	AF41(TOS=0x88) AF42(0x90) AF43(0x98) and BE (0x0)
-
-More tests required to see the interaction of several sources (other
-than subnet 10.2.0.0/24).
-
-Edge31-ca-u32
---------------
-
-Generate data using modified tcpblast from 10.2.0.2 (behind eth2) to the 
-discard port of 10.1.0.2 (behind eth1)
-
-1) generate with src tos = 0x88
-	Metering: Allocated throughput should not exceed 2*CIR1 + 2*CIR2
-	approximately 5mbps
-	Marking: Should vary between 0x88,0x90,0x98 and 0x0
-
-2) generate with src tos = 0x90
-	Metering: Allocated throughput should not exceed CIR1 + 2*CIR2
-	approximately 3.5mbps
-	Marking: Should vary between 0x90,0x98 and 0x0
-
-3) generate with src tos = 0x98
-	Metering: Allocated throughput should not exceed CIR1 + CIR2
-	approximately 2.5mbps
-	Marking: Should vary between 0x98 and 0x0
-
-4) generate with src tos any other than the above
-	Metering: Allocated throughput should not exceed CIR1 
-	approximately 1.5mbps
-	Marking: Should be consistent at 0x0
-
-TODO: Testing on how each color shares when all 4 types of packets
-are going through the edge device
-
-Edge32-cb-u32, Edge32-cb-chains
--------------------------------
-
--ftp with data direction from 10.2.0.2
-
-	*observe that the metering/policing works correctly (and the marking
-	as well). 
-
-	Metering: 
-        The data throughput should not exceed 2*CIR1 + 2*CIR2
-	+ 2*PIR2 + PIR1 for u32 which is roughly: 6mbps
-        The data throughput should not exceed 2*CIR1 + 5*CIR2
-	for chains which is roughly: 6mbps
-
-	Marking: the should be a variation of marked packets:
-	AF41(TOS=0x88) AF42(0x90) AF43(0x98) and BE (0x0)
-
-TODO:
--More tests required to see the interaction of several sources (other
-than subnet 10.2.0.0/24).
--More tests needed to capture stats on how many times the CIR was exceeded
-but the data was not remarked etc.
-
-Edge32-ca-u32
---------------
-
-Generate data using modified tcpblast from 10.2.0.2 (behind eth2) to the 
-discard port of 10.1.0.2 (behind eth1)
-
-1) generate with src tos = 0x88
-	Metering: Allocated throughput should not exceed 2*CIR1 + 2*CIR2
-	+PIR1 -- approximately 4mbps
-	Marking: Should vary between 0x88,0x90,0x98 and 0x0
-
-2) generate with src tos = 0x90
-	Metering: Allocated throughput should not exceed CIR1 + 2*CIR2
-	+ 2* PIR2 approximately 3mbps
-	Marking: Should vary between 0x90,0x98 and 0x0
-
-3) generate with src tos = 0x98
-	Metering: Allocated throughput should not exceed PIR1+ CIR1 + CIR2
-	approximately 2.5mbps
-	Marking: Should vary between 0x98 and 0x0
-
-4) generate with src tos any other than the above
-	Metering: Allocated throughput should not exceed CIR1 
-	approximately 1mbps
-	Marking: Should be consistent at 0x0
-
-TODO: Testing on how each color shares when all 4 types of packets
-are going through the edge device
-- 
2.20.1

