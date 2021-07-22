Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011923D25EE
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhGVN7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbhGVN7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:59:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53484C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:39:49 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x16so4667550plg.3
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 07:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4O4ZT1NALkc2zE1gBG4BZfP7VuUf7AOSjs/+xceZfEY=;
        b=Cfs2EN6evelRvQo4AYcf8YqckHamKqih0mFUuVnx6VwvuMxPj67E1BoMm4raYMK0+l
         ZJgD4juT3PTGfUlTSQZTDDUFLVx3oh6eUvAYDD7ZO2Qyrg1z1SVCpx03JJIpNik2Lppc
         Bf34sjTCDChx/lKQ0kY7GZwZB7eQkG6JRUJWCxSQq867AjfmCsjgn527B/mL2g9rRWXS
         DU+hmSjoFksNfvBlaH7NrrmYnIe9As0TXcsJKj0PV3EflJsfuiopEbxf/5EN9NRJp9Pl
         bTvHF9Jbh79ap+B/iA5XqKbnq4ucFDSXO+RkfVBtRXObZZd8nwVExbmmnGE2PJjnXe/c
         j0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=4O4ZT1NALkc2zE1gBG4BZfP7VuUf7AOSjs/+xceZfEY=;
        b=ITNuC3g2LY3KhB7ySyQd5AKcx8/CC2ZPYPwzVdAL39h3Lzcj184QHCnne8ABKUxHS5
         kUanjqjTAf4RLgqT0zoIzTKUhIi1qZ5cNJiTMhEHhTak+V3rSXd+5v+gCcCAZ1ybwoZs
         n7IkUefLaI/4HRAvA3oOR9/mdYffbsa/Z3cN6yM77D0UHoDahY+307htsn+teDd4ea5m
         wLYpm/KvXF39hZHwHECrD5ldtUHg6O9sKK4jIRmZJxRI5hlpKc3t06LVHPk38+yY9eX/
         MN9SdmU1d0eziDhWZaNTxMFZD3fNAWEbjhxTyB2++C2zbmHMVV37nAM6qfzjCAXC4cYv
         dSXA==
X-Gm-Message-State: AOAM533q7sdkDJKZ2cdG4dKUn5hwJJ9oT3mLFqZqLnhfdflhDEr1vYZI
        yUrSK6lUqVafASM9YLI3jUj/iE+hUJiYBg==
X-Google-Smtp-Source: ABdhPJwxMAkkD5Zfxg+iFNVdAsCahIxosf0qpdxr+XEiCjgSxcvGTl4KizjDpfkTGb/5UAxWNp0ksw==
X-Received: by 2002:a17:902:c64b:b029:12b:25f7:9b17 with SMTP id s11-20020a170902c64bb029012b25f79b17mr61153pls.24.1626964788332;
        Thu, 22 Jul 2021 07:39:48 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d31sm13799209pgd.33.2021.07.22.07.39.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 07:39:48 -0700 (PDT)
Date:   Thu, 22 Jul 2021 07:39:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 213821] New: Cannot create LACP bond over virtual network
 interfaces
Message-ID: <20210722073944.32321f61@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 22 Jul 2021 14:04:56 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 213821] New: Cannot create LACP bond over virtual network interfaces


https://bugzilla.kernel.org/show_bug.cgi?id=213821

            Bug ID: 213821
           Summary: Cannot create LACP bond over virtual network
                    interfaces
           Product: Networking
           Version: 2.5
    Kernel Version: 3.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: darren.reed@softelsystems.com.au
        Regression: No

Typically an LACP bond is formed over a pair of physical network interfaces to
another piece of hardware. This is the bread and butter of many systems
engineers.

But what about virtual network interfaces, such as tunnels?

Except in 1 case, it does not work. Why?

None of the virtual network interfaces (geneve, vxlan, ipip, gre) advertise
either the network interface speed or the duplex of the connection. Check your
output from "ethtool" to confirm. This prevents the 802.3ad driver from ever
using the virtual network interface. That's the bug.

There is of course some merit behind that because as virtual network interfaces
they have no inherent speed. But then there's the tun driver.

The tun driver advertises 10Mb/s and full duplex but it is the slowest of all
the family of virtual network interfaces and thus the least desirable. It's not
clear why someone chose 10Mb/s but it has its place.

Why would I like to create a LACP bond over a pair of virtual interfaces?
Because that's the easiest way to know if the other end is "dead". For example,
if I create a L2TP tunnel between two systems and run an 802.3ad bond over each
interface on the two systems then the LACP heartbeat becomes a defacto method
of informing me about the status of the other system.

In short, using an 802.3ad bond over a tunnel allows the bond network
connection to become a virtual wire between the two systems. When the bond goes
down, it as if the network cable has been unplugged.

After all that, what would I like to see fixed? Where a virtual network device
(such as geneve) is associated with a physical device (such as eno1) that it
inherits the physical properties of speed and duplex of the physical device.
This may also be applied to other virtual network devices that have a physical
device associated with them upon creation.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
