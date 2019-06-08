Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8AA5399EA
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbfFHAWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 20:22:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40823 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729685AbfFHAWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 20:22:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so2041446pfn.7
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 17:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=br9M6QvPePgtTcctWqxdQBAgmimA8ZKxzPwoWPCd1Kw=;
        b=rqq2nCnyVIhBh9oCQ8av/i/TNamjlpwDpW6qfdf2OYnRfqW2/MuDxnOWh3+SJ/eV5S
         1Io04sZZkrhxU5HnJLpXm2IEZnaApqEUbg7CuXx3bP7XasIbb/1HJ6yjaJTaAyF168QT
         5vWoSdvtJQDNAJ4ON9Z4hBdnN/7pwwuhQxBFoifVjnmV0vXo+MySPgjVvgzT/In7aB/P
         vVO0kq7RE4/5p8231ZT7O1JtTPYo34IchDU6ylmYox9JqABKddR3tii7cSUKkscEsEZH
         3Nhq6Eup6BBSf6xyh6YyzUPiiOVXBK+65x76v2/SbrOSMIkq8TAOLNLSvy2zAIY/Am5b
         /gDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=br9M6QvPePgtTcctWqxdQBAgmimA8ZKxzPwoWPCd1Kw=;
        b=lHONQ4vKwMBU4lB9qGyGUIedbPG5ysT56y1syW/IECmwRhlM9jSyW2Dl2KLmRvJefy
         kwiPonbZYP6WAjjRIse2lYL//+ckRCV81yxF/4EEuRZbqiMVcm2a/MFCQ1CDPF+gFoLv
         FU0lTRvVcfFStkecJ+eTcD+O68RFuWFXk4hPZxeyWZ3Gw/Jr4qG0QbF6ymC3p0ZDMW77
         6WDSw/Oa0K1njsBz7CPh9t81Ha7RvZd0H5Ln/M8XI5u4BoIDA/GuFAKJZehnF2L6OqCe
         N/G8oUmRs8zJwVZKXPzv7msM3FiZ0J5kwX6SXD0ktAwOmpStpkRs6wxS7Doqxamq1Y50
         lhuA==
X-Gm-Message-State: APjAAAX6UoOFf2bH0UJW6gaHUhCoKb43jMlGLdlUG9dWu9MSaZmI3wSN
        sbFwJQXMV3PrT/ZK1GeIiaO+og==
X-Google-Smtp-Source: APXvYqxr9f3adY3IKijCKF5LiGwg2lGjz4k/1+hPhgKrcLglDFMGRBDT8LudxRiK1ECXuzLpV7Q16Q==
X-Received: by 2002:a63:4c0f:: with SMTP id z15mr5265717pga.245.1559953364259;
        Fri, 07 Jun 2019 17:22:44 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g8sm3328122pjp.17.2019.06.07.17.22.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 17:22:44 -0700 (PDT)
Date:   Fri, 7 Jun 2019 17:22:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 203847] New: VMware e1000 adapter doesn't get an IP
 address assigned. Manually assigning one does not solve the issue
Message-ID: <20190607172242.6b6836b1@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 07 Jun 2019 23:53:00 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 203847] New: VMware e1000 adapter doesn't get an IP address assigned. Manually assigning one does not solve the issue


https://bugzilla.kernel.org/show_bug.cgi?id=203847

            Bug ID: 203847
           Summary: VMware e1000 adapter doesn't get an IP address
                    assigned. Manually assigning one does not solve the
                    issue
           Product: Networking
           Version: 2.5
    Kernel Version: 5.2-rc3
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: www.anuprita804@gmail.com
        Regression: No

Created attachment 283149
  --> https://bugzilla.kernel.org/attachment.cgi?id=283149&action=edit  
Dmesg for 5.2-rc3

When booting 5.2-rc3 on an arubacloud VPS (running VMware and using the e1000
driver for internet access) no IP address is assigned to eth0 

The last working kernel was 5.2-rc2
Systemd-networkd is being used for network setup. Tried networkmanager too.
With systemd-networkd no IP address is assigned to eth0. Networkmanager does
assign an address to eth0 but there is no internet access

Booting 5.2-rc2 or 5.1.7 works with both systemd-networkd and networkmanager
without any issues

The dmesg for 5.2-rc3 has been attached
The kernel configuration can be found here
https://emptyclouds.net/anupri/dot.config

This is an output of ip addr on 5.2-rc3

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group
default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default
qlen 1000
    link/ether 00:50:56:9f:92:d8 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default
qlen 1000
    link/ether 00:50:56:9f:e4:53 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default
qlen 1000
    link/ether 00:50:56:9f:31:a5 brd ff:ff:ff:ff:ff:ff

Same thing but with 5.2-rc2 (or 5.1.7 as the output is the same for both)
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group
default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc cake state UP group
default qlen 1000
    link/ether 00:50:56:9f:92:d8 brd ff:ff:ff:ff:ff:ff
    inet 217.61.104.90/24 brd 217.61.104.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 2a03:a140:10:2c5a::1/64 scope global
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:fe9f:92d8/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default
qlen 1000
    link/ether 00:50:56:9f:e4:53 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default
qlen 1000
    link/ether 00:50:56:9f:31:a5 brd ff:ff:ff:ff:ff:ff

ip link on 5.2-rc3
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode
DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ether 00:50:56:9f:92:d8 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ether 00:50:56:9f:e4:53 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ether 00:50:56:9f:31:a5 brd ff:ff:ff:ff:ff:ff
[root@archlinux ~]# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode
DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc cake state UP mode
DEFAULT group default qlen 1000
    link/ether 00:50:56:9f:92:d8 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ether 00:50:56:9f:e4:53 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000

ip link on 5.2-rc2
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode
DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc cake state UP mode
DEFAULT group default qlen 1000
    link/ether 00:50:56:9f:92:d8 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ether 00:50:56:9f:e4:53 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT
group default qlen 1000
    link/ether 00:50:56:9f:31:a5 brd ff:ff:ff:ff:ff:ff

-- 
You are receiving this mail because:
You are the assignee for the bug.
