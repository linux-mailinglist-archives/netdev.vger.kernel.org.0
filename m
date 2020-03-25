Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC278192C52
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgCYP0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:26:24 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:44300 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbgCYP0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:26:23 -0400
Received: by mail-pg1-f177.google.com with SMTP id 142so1278749pgf.11
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=rR/adMTP0klm0aKLJ4Jitqp8PklTDeB3TjccNpzVOcA=;
        b=J96/lLdWuTVY7WpLI6W/J4lqVJ6XxTF/nWn9cdmqSEUwdYkXpoeuJKaZ9xC7wua/Zq
         FCv+fCpuBxB+XirMZrtGRaVHS2YcMe5jNkx/HZHYq+yjiWjh0BBsea5yNPjWJ6g76tP0
         BYl0ZzGbdFRfDjmHmfVbC+xbe8gVP7P5wqpOLc+mQdwxPxUCtHk07DPH1SN9uRLfzlaH
         HnIyTyGj0R3KL8IWKWQBJhj5m3C/HGXtZjvW/FMWR5XWBdYZz80mErlupF//z86u3zxG
         K1rv8LQg4RvrNPSyCBJ66bVYvQV13JTB3D4al62YECl2z3Wzan2R/qtTrpOm5ebBu45U
         Bz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=rR/adMTP0klm0aKLJ4Jitqp8PklTDeB3TjccNpzVOcA=;
        b=P/gUxEQNNev6iNKAZAoFticTCeMcLFqjWA0y6B6caxb36dM15hQj00B4t+t8ITPs+F
         Te6xlWl648cJuBvsk525yXF1tk1Bezfbp/mdd1okdsnEOMp8555km87hrINr0fWdeWcN
         bTR5GNXD/M4sqORFGF6mNoMTV4TfZyBlIV5dSPSPTxF0uQTS2bTXvRr9J/rdcrD0VCTG
         WQrWgj3A2BkAHihH4Vh7swwcrmPwhT4kqeO82mqZp/aTcjImVi0a57zACjeEv6KFS1Md
         2K6qxvOrzZ5HkmXr6dECmMFaS8pPEhj63bhHJAXZPXUsYuJBuOZS3GHn1C2Dhv5r9KPL
         ZWlw==
X-Gm-Message-State: ANhLgQ1K0Q6eKUgZMibXHZoO8pz6ihCm3Fudr9bOZe11MhazhIRNrQvG
        M1YWTuvQJ+6sIYQsi3eDISGu0w5wnDrErg==
X-Google-Smtp-Source: ADFU+vvBzVgfGqoqxwR5HddHWG1ykM4Yw0Eh8kSOEwhfq5Rui7YJj9e4GCLDW8CkhQLTtx+veyxiEQ==
X-Received: by 2002:a63:717:: with SMTP id 23mr3753027pgh.61.1585149980832;
        Wed, 25 Mar 2020 08:26:20 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x188sm19119957pfx.198.2020.03.25.08.26.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:26:20 -0700 (PDT)
Date:   Wed, 25 Mar 2020 08:26:11 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206945] New: downgrading IPID assignment for TCP datagrams
Message-ID: <20200325082611.1cb94f97@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 25 Mar 2020 08:49:38 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206945] New: downgrading IPID assignment for TCP datagrams


https://bugzilla.kernel.org/show_bug.cgi?id=206945

            Bug ID: 206945
           Summary: downgrading IPID assignment for TCP datagrams
           Product: Networking
           Version: 2.5
    Kernel Version: since kernel 3.9
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: fengxw18@mails.tsinghua.edu.cn
        Regression: No

Through sending a forged ICMP "Fragmentation Needed" message to the Linux host,
an off-path attacker can clear the DF (Don't Fragment) flag in IP header, thus
downgrading the IPID assignment for TCP datagrams from the more secure
per-socket
based counter to hash based counter (since kernel version 3.9). Then the
attacker
can detect a shared IPID counter via hash collisions, which forms a
side-channel.
By observing the side channel, the attacker can hijack TCP connections on
the vulnerable Linux host completely off-path.

-- 
You are receiving this mail because:
You are the assignee for the bug.
