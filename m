Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28F42D4C20
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 21:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387729AbgLIUnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 15:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgLIUnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 15:43:13 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98127C0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 12:42:33 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id p4so1884991pfg.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 12:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=hq4Pf3LlOZU16NK1/OH7MUMpzig08/p4poxwoVH6YWU=;
        b=s8CSsjyYzTFBgLy0UULYrobsW+Aox/amoIPHwd86zpLI0f3VptTwixs/sRJSL/+HXH
         C1Hi6yl9da7rSirYkbOo3zDo4k8OXfSjguW1Bxt10ySG5YGqHIpWvYLDp2YDQ+myqoHL
         he20vpDY7unG9GauAR828SL4DnZQGlQTkEPxBZveq/cvH7MM2LTYyZ7uDTwnXMzFHpfH
         VYcihCLD5png+Rs4tYLKlMebfJcaLYiHmxpAhTtQp6b5DGb/VZVNC0REsN42fSTZxZIa
         6kh+rCllFxEkuwWpWJmimEJeaai6HUTzE2u+lccp5Vu3DIr2Usv83b64u90cfviz29gQ
         cDDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=hq4Pf3LlOZU16NK1/OH7MUMpzig08/p4poxwoVH6YWU=;
        b=ENvWhPDRDFmX94br+IotewTzndfl0w0rllFyv1uKAUE1iEJ+cY1/GkFQ3JKSbpmFgJ
         LdqdF3ae3nGwj8xGjRW/c83VLkWTYUyl42a+GrMjFKPmK8uNULv8S9Wl/K5dgN/Hy6N7
         le3bxQx2+0+VaWS21gfIGTmEeFtgRaZdy93VqxBYx69KvAJccD58hVoIz0btq+i5lkeU
         +7uKQmbpgbqrunN0oaJ+DRjUKsvY3vJxB3jXS9AXk/Pp6xoOLQYF+jhyLjfnkDx9NRFw
         M/EMNUXStJsFbCfSdzVoMfzwlhHQmGX8HPTSGsrZ/9a+lmOW3qENOiTeU84VAw3MJekg
         L8jQ==
X-Gm-Message-State: AOAM531PwCvpEVDWh78k84TXo7Xhe2wVLQwyitwt8Bn6dH77OPGrlZFE
        HpSLCXSrGYLvft+gCSesEB/82JnXFqY7e8gf
X-Google-Smtp-Source: ABdhPJzLGzieNsHBqm/1Yj3hYZHXarCk06Np3wbpjzBFVuRSQUfsi0kmS8sfAsMq+gklkTNaFpfrFQ==
X-Received: by 2002:a17:90b:46ca:: with SMTP id jx10mr3838665pjb.208.1607546552547;
        Wed, 09 Dec 2020 12:42:32 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y14sm3684096pfo.142.2020.12.09.12.42.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 12:42:32 -0800 (PST)
Date:   Wed, 9 Dec 2020 12:42:28 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 210569] New: ping over geneve would fail
Message-ID: <20201209124228.79075241@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 09 Dec 2020 02:04:16 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 210569] New: ping over geneve would fail


https://bugzilla.kernel.org/show_bug.cgi?id=210569

            Bug ID: 210569
           Summary: ping over geneve would fail
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10.0-rc6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: jishi@redhat.com
        Regression: No

ping over geneve would fail on 5.10.0-rc6 after commit 
Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
Commit: 55fd59b003f6 - Merge
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

reproducer:

ip netns add client                                                             
ip netns add server                                                             
ip link add veth0_c type veth peer name veth0_s                                 
ip link set veth0_c netns client                                                
ip link set veth0_s netns server                                                
ip netns exec client ip link set lo up                                          
ip netns exec client ip link set veth0_c up                                     
ip netns exec server ip link set lo up                                          
ip netns exec server ip link set veth0_s up                                     
ip netns exec client ip addr add 2000::1/64 dev veth0_c                         
ip netns exec client ip addr add 10.10.0.1/24 dev veth0_c                       
ip netns exec server ip addr add 2000::2/64 dev veth0_s                         
ip netns exec server ip addr add 10.10.0.2/24 dev veth0_s                       
ip netns exec client ping 10.10.0.2 -c 2                                        
ip netns exec client ping6 2000::2 -c 2                                         
ip netns exec client ip link add geneve1 type geneve vni 1234 remote 10.10.0.2
ttl 64                 
ip netns exec server ip link add geneve1 type geneve vni 1234 remote 10.10.0.1
ttl 64                 
ip netns exec client ip link set geneve1 up                                     
ip netns exec client ip addr add 1.1.1.1/24 dev geneve1                         
ip netns exec server ip link set geneve1 up                                     
ip netns exec server ip addr add 1.1.1.2/24 dev geneve1
ip netns exec client ping 1.1.1.2 -c 3

-- 
You are receiving this mail because:
You are the assignee for the bug.
