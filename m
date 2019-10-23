Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D41E205A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407148AbfJWQQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:16:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35535 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404332AbfJWQQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:16:45 -0400
Received: by mail-pl1-f196.google.com with SMTP id c3so10327063plo.2
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LzLtUJVGAqj+nB5fMVDF0Gu1nCreHcHqhcsYVBPsSvE=;
        b=g4DwjqJ2D110171xmgOEYDIqdF6mZa7ey71mDycdN3pARiKCDPcproJHNZUX8ZKXdQ
         KmBNnNLPbfAjSEU018vYBzth1K/oGAJPGXDpZzLA2c+6MQk9JvLMtwsnuYtLdwJH2aaE
         B6wTiREOvcnWKp4xOFL5a6dZqMgh2yEcUWM7QpA9ce0qldKLwyvQgXE6uaWoXVREQS6C
         xZLtzjFqNX1rerCODgDs1cX2jTJlc1xhtQxP1ZZuRMEn32D4ClZT2m9aejNyg2b8BRXX
         gtvfcklKYMPcaRKqpuIfM6CxT1F+YC7qyLeYlLZ8cvdaPTOf2zLWDgFlP1GrXB69kW/f
         DQtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LzLtUJVGAqj+nB5fMVDF0Gu1nCreHcHqhcsYVBPsSvE=;
        b=FXx0o7i/QC4rfeII6llRAwFhlWor88iWDgB7MlX2IBn8Fz9eq8lng8xXzFoYnYJ/Aq
         2Bkalfyi2UO0DgDj2WqKnPRLhomS/nBHEEewR5enqvkjRG45unAEvhRQ9WixIW1r+FB0
         +abv98/ctYP9i33BaFC1R9er5VRBW1Ay/5YqYKhvus8C72V3HKmvMKHqY32XX8HWWj7a
         bbmkDxnxyJXS/S4YjfCGoBZkvyIr6iWlwLbS4J6eiKek49ac1P7tq1LXUmBUzF6FpORM
         hfBBc4v7srcGG+pXS8JC/ywB+ffMgL1O+5Dwf5nvcMLy5StZV9WJX3zA+xh5ndfjRcA/
         lk0g==
X-Gm-Message-State: APjAAAVN58IjOxXi6Kk87zgJJtAg7oS/aBfJ9RELTERh9Y2+Zuo+fLpz
        8nr24FYuXeASHsUX/XnL9hhLf42MMS0eAA==
X-Google-Smtp-Source: APXvYqwJetc3hTe1vqWpT6iucA4FeVvxHC/AQoqlT1DtaX0psxnC8+u2LAlh3SiA9jaSiJbEG8G0rg==
X-Received: by 2002:a17:902:b70f:: with SMTP id d15mr6840767pls.210.1571847402295;
        Wed, 23 Oct 2019 09:16:42 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m12sm12012724pjk.13.2019.10.23.09.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 09:16:41 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/3] examples: remove out of date cbq stuff
Date:   Wed, 23 Oct 2019 09:16:30 -0700
Message-Id: <20191023161632.541-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191023161632.541-1-stephen@networkplumber.org>
References: <20191023161632.541-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The examples around cbq are out of date and never updated.
There are better ways to achieve same kind of thing with more
modern qdisc.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 examples/README.cbq         | 122 ------------------------------------
 examples/SYN-DoS.rate.limit |  49 ---------------
 examples/cbqinit.eth1       |  76 ----------------------
 3 files changed, 247 deletions(-)
 delete mode 100644 examples/README.cbq
 delete mode 100644 examples/SYN-DoS.rate.limit
 delete mode 100644 examples/cbqinit.eth1

diff --git a/examples/README.cbq b/examples/README.cbq
deleted file mode 100644
index 38c1089d1d1e..000000000000
--- a/examples/README.cbq
+++ /dev/null
@@ -1,122 +0,0 @@
-# CHANGES
-# -------
-# v0.3a2- fixed bug in "if" operator. Thanks kad@dgtu.donetsk.ua.
-# v0.3a-  added TIME parameter. Example:
-#         TIME=00:00-19:00;64Kbit/6Kbit
-#         So, between 00:00 and 19:00 RATE will be 64Kbit.
-#         Just start "cbq.init timecheck" periodically from cron (every 10
-#         minutes for example).
-#         !!! Anyway you MUST start "cbq.init start" for CBQ initialize.
-# v0.2 -  Some cosmetique changes. Now it more compatible with
-#         old bash version. Thanks to Stanislav V. Voronyi
-#         <stas@cnti.uanet.kharkov.ua>.
-# v0.1 -  First public release
-# 
-# README
-# ------
-# 
-# First of all - this is just a SIMPLE EXAMPLE of CBQ power.
-# Don't ask me "why" and "how" :)
-# 
-# This is an example of using CBQ (Class Based Queueing) and policy-based
-# filter for building smart ethernet shapers. All CBQ parameters are
-# correct only for ETHERNET (eth0,1,2..) linux interfaces. It works for
-# ARCNET too (just set bandwidth parameter to 2Mbit). It was tested
-# on 2.1.125-2.1.129 linux kernels (KSI linux, Nostromo version) and 
-# ip-route utility by A.Kuznetsov (iproute2-ss981101 version). 
-# You can download ip-route from ftp://ftp.inr.ac.ru/ip-routing or
-# get iproute2*.rpm (compiled with glibc) from ftp.ksi-linux.com.
-# 
-# 
-# HOW IT WORKS
-# 
-# Each shaper must be described by config file in $CBQ_PATH
-# (/etc/sysconfig/cbq/) directory - one config file for each CBQ shaper.
-# 
-# Some words about config file name:
-# Each shaper has its personal ID - two byte HEX number. Really ID is 
-# CBQ class.
-# So, filename looks like:
-# 
-# cbq-1280.My_first_shaper
-# ^^^ ^^^  ^^^^^^^^^^^^^
-#  |  |            |______ Shaper name - any word
-#  |  |___________________ ID (0000-FFFF), let ID looks like shaper's rate
-#  |______________________ Filename must begin from "cbq-" 
-# 
-# 
-# Config file describes shaper parameters and source[destination] 
-# address[port].
-# For example let's prepare /etc/sysconfig/cbq/cbq-1280.My_first_shaper:
-# 
-# ----------8<---------------------
-# DEVICE=eth0,10Mbit,1Mbit
-# RATE=128Kbit
-# WEIGHT=10Kbit
-# PRIO=5
-# RULE=192.168.1.0/24
-# ----------8<---------------------
-# 
-# This is minimal configuration, where:
-# DEVICE:  eth0   - device where we do control our traffic
-#          10Mbit - REAL ethernet card bandwidth
-#          1Mbit  - "weight" of :1 class (parent for all shapers for eth0),
-#                   as a rule of thumb weight=batdwidth/10.
-#          100Mbit adapter's example: DEVICE=eth0,100Mbit,10Mbit
-#          *** If you want to build more than one shaper per device it's
-#              enough to describe bandwidth and weight once  - cbq.init
-#              is smart :) You can put only 'DEVICE=eth0' into cbq-* 
-#              config file for eth0.
-# 
-# RATE:    Shaper's speed - Kbit,Mbit or bps (bytes per second)
-# 
-# WEIGHT:  "weight" of shaper (CBQ class). Like for DEVICE - approx. RATE/10
-# 
-# PRIO:    shaper's priority from 1 to 8 where 1 is the highest one.
-#          I do always use "5" for all my shapers.
-# 
-# RULE:    [source addr][:source port],[dest addr][:dest port]
-#          Some examples:
-# RULE=10.1.1.0/24:80         - all traffic for network 10.1.1.0 to port 80
-#                               will be shaped.
-# RULE=10.2.2.5               - shaper works only for IP address 10.2.2.5   
-# RULE=:25,10.2.2.128/25:5000 - all traffic from any address and port 25 to
-#                               address 10.2.2.128 - 10.2.2.255 and port 5000
-#                               will be shaped.
-# RULE=10.5.5.5:80,           - shaper active only for traffic from port 80 of
-#                               address 10.5.5.5
-# Multiple RULE fields per one config file are allowed. For example:
-# RULE=10.1.1.2:80
-# RULE=10.1.1.2:25
-# RULE=10.1.1.2:110
-# 
-# *** ATTENTION!!!
-# All shapers do work only for outgoing traffic!
-# So, if you want to build bidirectional shaper you must set it up for
-# both ethernet card. For example let's build shaper for our linux box like:
-# 
-#                     ---------             192.168.1.1
-# BACKBONE -----eth0-|  linux  |-eth1------*[our client]
-#                     ---------
-# 
-# Let all traffic from backbone to client will be shaped at 28Kbit and
-# traffic from client to backbone - at 128Kbit. We need two config files:
-# 
-# ---8<-----/etc/sysconfig/cbq/cbq-28.client-out----
-# DEVICE=eth1,10Mbit,1Mbit
-# RATE=28Kbit
-# WEIGHT=2Kbit
-# PRIO=5
-# RULE=192.168.1.1
-# ---8<---------------------------------------------
-# 
-# ---8<-----/etc/sysconfig/cbq/cbq-128.client-in----
-# DEVICE=eth0,10Mbit,1Mbit
-# RATE=128Kbit
-# WEIGHT=10Kbit
-# PRIO=5
-# RULE=192.168.1.1,
-# ---8<---------------------------------------------
-#                 ^pay attention to "," - this is source address!
-# 
-# Enjoy.
diff --git a/examples/SYN-DoS.rate.limit b/examples/SYN-DoS.rate.limit
deleted file mode 100644
index 8766b679ce36..000000000000
--- a/examples/SYN-DoS.rate.limit
+++ /dev/null
@@ -1,49 +0,0 @@
-#! /bin/sh -x
-#
-# sample script on using the ingress capabilities
-# this script shows how one can rate limit incoming SYNs
-# Useful for TCP-SYN attack protection. You can use
-# IPchains to have more powerful additions to the SYN (eg 
-# in addition the subnet)
-#
-#path to various utilities;
-#change to reflect yours.
-#
-IPROUTE=/root/DS-6-beta/iproute2-990530-dsing
-TC=$IPROUTE/tc/tc
-IP=$IPROUTE/ip/ip
-IPCHAINS=/root/DS-6-beta/ipchains-1.3.9/ipchains
-INDEV=eth2
-#
-# tag all incoming SYN packets through $INDEV as mark value 1
-############################################################ 
-$IPCHAINS -A input -i $INDEV -y -m 1
-############################################################ 
-#
-# install the ingress qdisc on the ingress interface
-############################################################ 
-$TC qdisc add dev $INDEV handle ffff: ingress
-############################################################ 
-
-#
-# 
-# SYN packets are 40 bytes (320 bits) so three SYNs equals
-# 960 bits (approximately 1kbit); so we rate limit below
-# the incoming SYNs to 3/sec (not very sueful really; but
-#serves to show the point - JHS
-############################################################ 
-$TC filter add dev $INDEV parent ffff: protocol ip prio 50 handle 1 fw \
-police rate 1kbit burst 40 mtu 9k drop flowid :1
-############################################################ 
-
-
-#
-echo "---- qdisc parameters Ingress  ----------"
-$TC qdisc ls dev $INDEV
-echo "---- Class parameters Ingress  ----------"
-$TC class ls dev $INDEV
-echo "---- filter parameters Ingress ----------"
-$TC filter ls dev $INDEV parent ffff:
-
-#deleting the ingress qdisc
-#$TC qdisc del $INDEV ingress
diff --git a/examples/cbqinit.eth1 b/examples/cbqinit.eth1
deleted file mode 100644
index 226ec1c54072..000000000000
--- a/examples/cbqinit.eth1
+++ /dev/null
@@ -1,76 +0,0 @@
-#! /bin/sh
-
-TC=/home/root/tc
-IP=/home/root/ip
-DEVICE=eth1
-BANDWIDTH="bandwidth 10Mbit"
-
-# Attach CBQ on $DEVICE. It will have handle 1:.
-#   $BANDWIDTH is real $DEVICE bandwidth (10Mbit).
-#   avpkt is average packet size.
-#   mpu is minimal packet size.
-
-$TC qdisc add dev $DEVICE  root  handle 1:  cbq \
-$BANDWIDTH avpkt 1000 mpu 64
-
-# Create root class with classid 1:1. This step is not necessary.
-#   bandwidth is the same as on CBQ itself.
-#   rate == all the bandwidth
-#   allot is MTU + MAC header
-#   maxburst measure allowed class burstiness (please,read S.Floyd and VJ papers)
-#   est 1sec 8sec means, that kernel will evaluate average rate
-#                 on this class with period 1sec and time constant 8sec.
-#                 This rate is viewed with "tc -s class ls dev $DEVICE"
-
-$TC class add dev $DEVICE parent 1:0 classid :1 est 1sec 8sec cbq \
-$BANDWIDTH rate 10Mbit allot 1514 maxburst 50 avpkt 1000
-
-# Bulk.
-#    New parameters are: 
-#    weight, which is set to be proportional to
-#            "rate". It is not necessary, weight=1 will work as well.
-#    defmap and split say that best effort ttraffic, not classfied
-#            by another means will fall to this class.
-
-$TC class add dev $DEVICE parent 1:1 classid :2 est 1sec 8sec cbq \
-$BANDWIDTH rate 4Mbit allot 1514 weight 500Kbit \
-prio 6 maxburst 50 avpkt 1000 split 1:0 defmap ff3d
-
-# OPTIONAL.
-# Attach "sfq" qdisc to this class, quantum is MTU, perturb
-# gives period of hash function perturbation in seconds.
-#
-$TC qdisc add dev $DEVICE parent 1:2 sfq quantum 1514b perturb 15
-
-# Interactive-burst class
-
-$TC class add dev $DEVICE parent 1:1 classid :3 est 2sec 16sec cbq \
-$BANDWIDTH rate 1Mbit allot 1514 weight 100Kbit \
-prio 2 maxburst 100 avpkt 1000 split 1:0 defmap c0
-
-$TC qdisc add dev $DEVICE parent 1:3 sfq quantum 1514b perturb 15
-
-# Background.
-
-$TC class add dev $DEVICE parent 1:1 classid :4 est 1sec 8sec cbq \
-  $BANDWIDTH rate 100Kbit allot 1514 weight 10Mbit \
-  prio 7 maxburst 10 avpkt 1000 split 1:0 defmap 2
-
-$TC qdisc add dev $DEVICE parent 1:4 sfq quantum 1514b perturb 15
-
-# Realtime class for RSVP
-
-$TC class add dev $DEVICE parent 1:1 classid 1:7FFE cbq \
-rate 5Mbit $BANDWIDTH allot 1514b avpkt 1000 \
-maxburst 20
-
-# Reclassified realtime traffic
-#
-# New element: split is not 1:0, but 1:7FFE. It means,
-#     that only real-time packets, which violated policing filters
-#     or exceeded reshaping buffers will fall to it.
-
-$TC class add dev $DEVICE parent 1:7FFE classid 1:7FFF  est 4sec 32sec cbq \
-rate 1Mbit $BANDWIDTH allot 1514b avpkt 1000 weight 10Kbit \
-prio 6 maxburst 10 split 1:7FFE defmap ffff
-
-- 
2.20.1

