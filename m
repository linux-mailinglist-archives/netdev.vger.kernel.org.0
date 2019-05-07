Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7229E1663D
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 17:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfEGPI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 11:08:29 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:35653 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGPI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 11:08:29 -0400
Received: by mail-pg1-f174.google.com with SMTP id h1so8468916pgs.2
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 08:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=IHA9ZBXJCbNAwkZVEIzcqIGduoSMqiI5f2ptgSEvG3U=;
        b=jsY3qTOk4eLUIwl0HDHvEpVgjcYTvAm+SZvDOL831uk8Eui6Ns5MFMia86yzjwDckG
         F4qFUkEzwJvttISMkQuw5DWlVglQKefs3b/Kj2PtMsEQJs/jFoPxfoqMWh72K9POnRHG
         bbYE0vhp+ECliHJRESmGciQJ70yz74KLYXl0vnv2OzOvPL631dskhhtj5aZhRS1dwx6X
         IOMaw4ia15q8hh3t2wODUMOEbUVuyRz4tsSMEP1Okn2YViDZhQJlqYwSL0zXVXS1zGQ4
         yunfHzXpS/RkdmAup9Pq4Wpcx+yI59UN/vHkMKd6jNF8UhhKH+MTkuktezXRE6q5gM08
         Z5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=IHA9ZBXJCbNAwkZVEIzcqIGduoSMqiI5f2ptgSEvG3U=;
        b=mazGpwCLrd1i/A7AzL5fdj5QwYo7SpgMg5MN38k1nj8hVYZmsOWm/oyzGbtWn+f7SI
         CrrU9PvyJBv6iMjEaKCIPK6Eoo39jEHhrUFCwm0oseYsLaKFb8FRp/lHlskceg0tKRau
         nKisspJKn9fiuutQwgflVx4R2j4bA7iQAWrZUHBCjPC2fbJtyr+E2jtrRZrd5ZgE/bAj
         SHR+AvkfpYrnzI7Eoxg3fEaOzD0x94+CyGPrHY/eZwahwtixBBKnzu4y1LedGbC7L0i3
         NnqjzLtgBa7j/yHoNpkiML9Z2Zy9N7XUSwK/69jNJwtRoOm7Nj0xdDdbLnudPWSdlyIr
         8h8g==
X-Gm-Message-State: APjAAAVDCNbbObsQ2Q+yM0n3pPLTx4y3shGUyyJ8ClNER0n59hqcevxJ
        ysmr28kSBDFprW8BjJfPV+QIMzOB0sY=
X-Google-Smtp-Source: APXvYqyDQt/B2yo72E9+/WHriOYTAR8ZCGb06pl26+dXzJu/yer4bmtEdgna38rpJgGT3Ks4wF6Ilw==
X-Received: by 2002:a63:309:: with SMTP id 9mr18960246pgd.49.1557241707963;
        Tue, 07 May 2019 08:08:27 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t65sm29893875pfa.175.2019.05.07.08.08.27
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 08:08:27 -0700 (PDT)
Date:   Tue, 7 May 2019 08:08:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 203533] New: VxLAN: Cannot create multiple vxlan devices
 for a given VNI and different source addresses.
Message-ID: <20190507080821.3496b560@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a valid request, not sure if just changing the check is enough
because it also matters where packets match endpoints.


Begin forwarded message:

Date: Mon, 06 May 2019 21:18:30 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 203533] New: VxLAN: Cannot create multiple vxlan devices for a given VNI and different source addresses.


https://bugzilla.kernel.org/show_bug.cgi?id=203533

            Bug ID: 203533
           Summary: VxLAN: Cannot create multiple vxlan devices for a
                    given VNI and different source addresses.
           Product: Networking
           Version: 2.5
    Kernel Version: 4.9.110
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: hasanrazaonline@gmail.com
        Regression: No

When trying to create two vxlan terminations with different source VTEPs, only
one termination is allowed and second netdevice creation fails with EEXIST
error.

root@:~# ip link add vxlan-10 type vxlan id 10 local 10.1.1.1 dstport 4789
root@:~# ip link add vxlan2-10 type vxlan id 10 local 20.1.1.1 dstport 4789
RTNETLINK answers: File exists
root@:~#

It is a valid use-case scenario where a router is terminating multiple VxLAN
endpoints. But this doesn't seem to be allowed in the kernel.

The EEXIST error is coming from here:
vxlan_dev_configure():
...
    list_for_each_entry(tmp, &vn->vxlan_list, next) {
        if (tmp->cfg.vni == conf->vni &&
          | (tmp->default_dst.remote_ip.sa.sa_family == AF_INET6 ||
          |  tmp->cfg.saddr.sa.sa_family == AF_INET6) == use_ipv6 &&
          | tmp->cfg.dst_port == vxlan->cfg.dst_port &&
          | (tmp->flags & VXLAN_F_RCV_FLAGS) ==
          | (vxlan->flags & VXLAN_F_RCV_FLAGS)) {
            pr_info("duplicate VNI %u\n", be32_to_cpu(conf->vni));
            return -EEXIST;
        }
    }

The uniqueness of vxlan device should be checked with <local-endpoint, vni,
dstport> instead of just <vni, dstport>. Similarly, vxlan_vs_find_vni() should  
lookup vxlan device using <src-addr, vni> instead of just <vni>:
static struct vxlan_dev *vxlan_vs_find_vni(struct vxlan_sock *vs, __be32 vni)

As per the code, I can see this issue exists in v5.1 as well.

-- 
You are receiving this mail because:
You are the assignee for the bug.
