Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E862822178D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 00:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgGOWLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 18:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgGOWLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 18:11:32 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD8AC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 15:11:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc9so3793006pjb.2
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 15:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=MYog57HUvGR/K7i5W6g9JP1gfU+JhxzEMIkfXRw6RBU=;
        b=pT5kw7K9TgDNrDKGXfLndth+MNP5c5Pod+kvq57ALWm5k8yrbLpjTYEP3u2vMWUdBw
         Sdu4bIMPGHOlrMcPA7c+dlwXb7OiLXmwW62Did7I8yo4GpanYsForV2NeJiFDKX+C0sK
         +cDJzKi4AP2HubFHAyOMs3S0H7NHubPHCeUv3gr8ZDsrc4urvzWbklPlNaUucZeLAOn0
         WpaW2LrkOe55dZvLQMOiXruR4Et8bgtfqKefvkIZn1HOnhsti23NzSB3SHStM+hxkGWp
         PPj6UiceQo+8lFJC/VdLvxws+rOtW7xxVDwpG1Fw9AaPSnexT2OxoZf5evygv9GLcCTL
         PoXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=MYog57HUvGR/K7i5W6g9JP1gfU+JhxzEMIkfXRw6RBU=;
        b=Bjdrv17A7jJlghV9RCOVVrLW625l/M0zptLY1sn/SN4lFJoBYhrY8Btg2Mwk2we7Sk
         aOllARlL7TQ04FvymHhg4Xc8qO5aKS8dzH2txqHW1Op2TUXKd/3+mimGBWiUy98DHMRG
         ofv7jIdao2MsGuWgzy59VuVpai8mg7YEWkxt7bMTnPOo9Y/cFIBYPz4VLpq0lj/+A+RN
         s7O7GdkeGUJgfDONZu3nvzBRj+Ls3lCsJZvC64shBgkvUK0fibPWilBPWRwfDfV7Z4dx
         fXA0IMGMJgLd/lIK8pP1m4rwtPsMUeNoq9/uAAiA5t35l0jS948Mt6SirrooB3cq7mPr
         M59Q==
X-Gm-Message-State: AOAM532z6Ttv9aUQ+9skk2hBqrTL6RXbsplHoFwHhekR5LIEfQ8YGjfL
        /0IQ79vD9j/ARLv4toyX/NllSYqXbiLLjw==
X-Google-Smtp-Source: ABdhPJzXek7f+UYQCx2Y4774WrqKt3gaNnL9/48wjEJdUUdQycLjLUrT2OkxySw/pNu2uzxd/8zKcA==
X-Received: by 2002:a17:902:7612:: with SMTP id k18mr1148380pll.187.1594851091374;
        Wed, 15 Jul 2020 15:11:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n15sm3110162pgs.25.2020.07.15.15.11.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 15:11:31 -0700 (PDT)
Date:   Wed, 15 Jul 2020 15:11:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 208563] New: After detaching the HDD from the machine,
 DHCP starts requesting every possible address available.
Message-ID: <20200715151123.5225ed3e@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Concerning but does not look like a kernel bug.

Begin forwarded message:

Date: Wed, 15 Jul 2020 10:24:34 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 208563] New: After detaching the HDD from the machine, DHCP starts requesting every possible address available.


https://bugzilla.kernel.org/show_bug.cgi?id=208563

            Bug ID: 208563
           Summary: After detaching the HDD from the machine, DHCP starts
                    requesting every possible address available.
           Product: Networking
           Version: 2.5
    Kernel Version: 4.19.0-9-amd64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: vcc.nicolas@gmail.com
        Regression: No

Created attachment 290289
  --> https://bugzilla.kernel.org/attachment.cgi?id=290289&action=edit  
Router DHCP Page

Hello everyone.

Yesterday i shutdown my NAS which hosts the VMS HDD, without shutting the VMS
down (forgot).
Today, i woke up with my wifi unable to give my phone a ip on the network.
Same happened for my computer, and all the other devices which had to connect.

After logging in to my router, i discovered that the 3 VMS (Debian 10.4),
requested all the available ip address through their DHCP client.

All 3 VMS did exactly the same, probably when the DHCP offer ended, and it was
time to renew it.

This completely crashed the network, making unavailable to everyone
Fortunately, my DHCP range is only half of the network, so i was able to
recover it by using a static ip on my linux machine.

If in a bigger network, or company-network, this could have caused immense
damage.

Notes:
- The 3 VMS are hosted on VMWARE ESXI 7.0, with k3s installed on each of them.
- Both ESXI and command-line "shutdown" were not able to shutdown the VMS.
- The NAS was holding their disks through iSCSI. 
- The NAS was shutdown around 3PM of yesterday.
- Network started malfunctioning around 2AM of today.
- The Network CIDR is 192.168.1.0/24, and the DHCP range is
192.168.1.2-192.168.1.99.
- The VMS names are: K3S-Master, K3S-Node1, K3S-Node2

The attachments show the IPs requested by the VMS, their console, and the
router DHCP page.
Here is the imgur album with all the screenshots of the case:
https://imgur.com/a/XThsBdz

I dont know to which field this is related, as i am not a Kernel expert.

Thanks in advance to everyone looking in to this.

-- 
You are receiving this mail because:
You are the assignee for the bug.
