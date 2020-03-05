Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53EE517B161
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 23:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgCEWZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 17:25:02 -0500
Received: from hs2.cadns.ca ([149.56.24.197]:59801 "EHLO hs2.cadns.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgCEWZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 17:25:02 -0500
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        by hs2.cadns.ca (Postfix) with ESMTPSA id 96F801D7A86
        for <netdev@vger.kernel.org>; Thu,  5 Mar 2020 17:24:59 -0500 (EST)
Authentication-Results: hs2.cadns.ca;
        spf=pass (sender IP is 209.85.222.181) smtp.mailfrom=sriram.chadalavada@mindleap.ca smtp.helo=mail-qk1-f181.google.com
Received-SPF: pass (hs2.cadns.ca: connection is authenticated)
Received: by mail-qk1-f181.google.com with SMTP id q18so447631qki.10
 for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 14:24:59 -0800 (PST)
X-Gm-Message-State: ANhLgQ3P9A7xKqeb/VB0vE0p+MEgiArImoGN7fBjpvPjDFZV3zRzMbec
 6a4RtmpHgXT1A3MaDgGTGElhQqVVt39k7gqZipw=
X-Google-Smtp-Source: ADFU+vt3m8nW8O/K/qOnYllLesRVrhhd4LBliElNmr+q36nI8wE7Ibxv2D38APl9YOJOoIlTHXQXArIkgHnjdSOHCQg=
X-Received: by 2002:a37:5044:: with SMTP id e65mr239044qkb.294.1583447099160;
 Thu, 05 Mar 2020 14:24:59 -0800 (PST)
MIME-Version: 1.0
From:   Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Date:   Thu, 5 Mar 2020 17:24:47 -0500
X-Gmail-Original-Message-ID: <CAOK2joFxzSETFgHX7dRuhWPVSSEYswJ+-xfSxbPr5n3LcsMHzw@mail.gmail.com>
Message-ID: <CAOK2joFxzSETFgHX7dRuhWPVSSEYswJ+-xfSxbPr5n3LcsMHzw@mail.gmail.com>
Subject: Information on DSA driver initialization
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-PPP-Message-ID: <20200305222500.1878.73859@hs2.cadns.ca>
X-PPP-Vhost: mindleap.ca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Is there information in kernel documentation or elsewhere about DSA
initialization process starting from the device tree parse to the
Marvell switch being detected?

The specific problem I'm facing is that while I see this:
root@SDhub:/# dmesg | grep igb
[ 1.314324] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4.0-k
[ 1.314332] igb: Copyright (c) 2007-2014 Intel Corporation.
[ 1.314679] igb 0000:03:00.0: enabling device (0140 -> 0142)
[ 1.343926] igb 0000:03:00.0: added PHC on eth0
[ 1.343938] igb 0000:03:00.0: Intel(R) Gigabit Ethernet Network Connection
[ 1.343949] igb 0000:03:00.0: eth0: (PCIe:2.5Gb/s:Width x1) c4:48:38:00:63:eb
[ 1.344019] igb 0000:03:00.0: eth0: PBA No: 000300-000
[ 1.344030] igb 0000:03:00.0: Using MSI-X interrupts. 4 rx queue(s), 4
tx queue(s)
[ 1.344464] libphy: igb_enet_mii_bus: probed

I do NOT see this in the log:
[ 1.505474] libphy: mdiobus_find: mii bus [igb_enet_mii_bus] found
[ 1.645075] igb 0000:03:00.0 eth0: [0]: detected a Marvell 88E6176 switch
[ 24.341748] igb 0000:03:00.0 eth0: igb_enet_mii_probe starts
[ 24.344928] igb 0000:03:00.0 eth0: igb: eth0 NIC Link is Up 1000 Mbps
Full Duplex, Flow Control: RX/TX

Any suggestions/speculations what may be going on here?
