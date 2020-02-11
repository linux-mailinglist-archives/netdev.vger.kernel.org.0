Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1404B1593FC
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgBKPyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:54:53 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:45637 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbgBKPyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:54:53 -0500
Received: by mail-pg1-f179.google.com with SMTP id b9so5913099pgk.12
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 07:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YX2oJMlvutNZVS/q7UJNyF07p5YmCbx+KfvY7dLQhbs=;
        b=dQhkAtL9Sx2LNrj+q9w6vBS5kqcwV/pAk8yc9xFoOc/nnsxefTXmN6lwrMdEM/rjLQ
         sBOXALTme6HZ7tRCU27/ciRiTO3zkODAfeSbHh0e3JC36zKJe1UlIxishLQGsz8pKv/5
         pDCOrZahDAZJ/u69kAP3mVWx+cllUXh5xB+fGGMvkhdWzoksHKUe0ykVOj9FRkiDJW1X
         4UC8HnQdjAXEA8lXNEKAphgs10Zv5d2EwqhN2yhCNmxlW1yt1EIOMgH33zilFVlAjM4N
         9NT0EIg3Emexd2bNaQXwUSn7sYB8nMLfR+lt6RN/Wl6+FjcTWTVRb24HquV88im4qynW
         ywdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=YX2oJMlvutNZVS/q7UJNyF07p5YmCbx+KfvY7dLQhbs=;
        b=tmNJQubDmWdpBij2RFXk3OnxoEeQ8jMR8NrRW3qiqSeM6E+LU54Ezscf+hZSmXGdbl
         os+/HgnrP5TI2DK2iyAFa+caSI2GJNrZQRkA+mRg8diH2hanLYm6kcrzRBmRzP/5nIGf
         Jh9e9EIxrG/guF5LzjdmTvCtaRIZHVimRK4ufwH0S67NB3mnINPfb8YxkSdL+k9fG6Vi
         StT3ov8B/TgfBatKBFiygGTrSC5h9IxJOwpYiGUD4D7rkZAiIiETWEkrwVLT7WD9mk0T
         y22sJznxs6uakLz/yhIoGVr53fUNFamzEXj/HryAjSya1aNvNoQcM+NBZL8ejZn8CfIC
         G7Ow==
X-Gm-Message-State: APjAAAVtNXFYefdbc18+x0Qv3bP3OPMUrTvJBRHbgY+JcCYVQtF/7UNO
        IlOAU5OlVdCeiMmqstNlwc/1EqINCao=
X-Google-Smtp-Source: APXvYqyKj/nDQF2Gm9mxFwO19dvki5jUEsDQH9k8SK7HEWGpzLhAj94or1VwXO5XPyCbSxTQPS00ZA==
X-Received: by 2002:a65:621a:: with SMTP id d26mr7314435pgv.151.1581436490665;
        Tue, 11 Feb 2020 07:54:50 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y127sm4944866pfg.22.2020.02.11.07.54.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 07:54:50 -0800 (PST)
Date:   Tue, 11 Feb 2020 07:54:42 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206497] New: pfifo_fast: netdev xmit sends frames OOO to
 devices
Message-ID: <20200211075442.0de80458@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



This seems to be a duplicate of recent bug on qdisc ordering.
But forwarded it so that netdev can see it as well.

Begin forwarded message:

Date: Tue, 11 Feb 2020 13:08:19 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206497] New: pfifo_fast: netdev xmit sends frames OOO to devices


https://bugzilla.kernel.org/show_bug.cgi?id=206497

            Bug ID: 206497
           Summary: pfifo_fast: netdev xmit sends frames OOO to devices
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.18
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: chaitanya.mgit@gmail.com
        Regression: No

When running iperf3 on a Single Q device (WLAN device), iperf3 reports OOO (out
of order frames) after investigating it was found the ndo_xmit() itself is
sending the frames OOO. (only a few per stream)

$ sudo tc -s qdisc show dev wlp4s0f0
qdisc pfifo_fast 0: root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1
1 1
 Sent 792082458 bytes 523933 pkt (dropped 0, overlimits 0 requeues 0) 
 backlog 0b 0p requeues 0 


4 iperf3 sessions are run on different ports and below rules to prioritize
them:

iptables -A OUTPUT -o lo -t mangle -d localhost -p udp --dport 5201 -j DSCP
--set-dscp-class cs1
iptables -A OUTPUT -o lo -t mangle -d localhost -p udp --dport 5202 -j DSCP
--set-dscp-class cs0
iptables -A OUTPUT -o lo -t mangle -d localhost -p udp --dport 5203 -j DSCP
--set-dscp-class cs4
iptables -A OUTPUT -o lo -t mangle -d localhost -p udp --dport 5204 -j DSCP
--set-dscp-class cs6

FYI, my problem seems to quite similar to the one
https://www.spinics.net/lists/netdev/msg490934.html but the fix is already part
of 5.4.18

2 workarounds found
 - booting with `nosmp` (similar to commenting TCQ_F_NOLOCK but haven't tried)
 - And, switching to fq_codel solves the problem. (Forgot the exact params for
the tc fq_codel)

-- 
You are receiving this mail because:
You are the assignee for the bug.
