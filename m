Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4DA9BD67
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 13:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfHXL5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 07:57:37 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:38522 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbfHXL5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 07:57:36 -0400
Received: by mail-io1-f50.google.com with SMTP id p12so26398223iog.5
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 04:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=zmWNoIbOMBqHFx2cdKk99NrwhcGTgDxRP+5Vlodw/6w=;
        b=P2YoJmzQNQHsy3VdQtT3x2o4PRotkDTwXA2hormWI8RNP8KRqHpvW4h0e9KX2rEzTp
         tOMfNwMGSNysg1t29+et+thwFxnyTiNokUbpDXsG9pkU8u3dIcnkvKL0BSF/KmEhCN18
         ShWzd5/irqry0aIVc/WdpkfZxC0cWV6wnvNpS5n55qYb5S+4fIs8w99GwEpA9SUKD9CJ
         WwlkUjsNatiiUZrWC9FzW5aGWfMQQ09JmGOdlW6qP7cV7AMSBSTkylD0Re6m7paLMcmM
         hYwHooJ2l3JTVdMtAM5EqJA7mDbXvZBFQbpNwn6CxBSJ6pzPFb51Rs+4KbSF+hAbFoow
         UEuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=zmWNoIbOMBqHFx2cdKk99NrwhcGTgDxRP+5Vlodw/6w=;
        b=YBrsbEep7ClFmZEgPy3DUiCxSCpDt2BM5FBAsJRgMEQwS6O7bNArdLMosRly76DFrd
         qveV2NrZfhGrD4nAS2b2UF1S+1dMa9NWPVc78yzVQ3rWN1ytkqxghVqnEJ7i7MlZ7XLN
         YaSAJM+A9ZG4Qd/jbzAXr3KfX8heYzGbRvTX9hZaYDvTIDtUhUltH3jaz0Ch77zAPTdp
         fZXRERhnYfSprqhnJ2O8KbLU+mEDveNtFOHFJ9ZJPDGWBTABZGiIGW6cP+Ts1UGy/7qQ
         51Vyx1gY+/hekfaG4x+VwcXb6gPfmADdtq17wafmL2+CRGgZ2zBHFF02Y/c8d7n4/ZKt
         PGHw==
X-Gm-Message-State: APjAAAX0snG2IombNv2nXiJu/+NhwAhwKL8sOmJ2+8/K5c5wLNoJxY0m
        ci7I+Q5kyXxgJTC+4W32q5Z/DUjfLO8=
X-Google-Smtp-Source: APXvYqzqet3feoKF6sZVdh+p6JTKtboCZNcdksgQPh8l7UT6tzWtAI6Uvyoum1lzT4oXv5DB6KE1Mg==
X-Received: by 2002:a5d:8cd2:: with SMTP id k18mr656215iot.242.1566647855291;
        Sat, 24 Aug 2019 04:57:35 -0700 (PDT)
Received: from xps13.local.tld (cpe-67-255-90-149.maine.res.rr.com. [67.255.90.149])
        by smtp.gmail.com with ESMTPSA id k9sm4974938ioa.10.2019.08.24.04.57.34
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 24 Aug 2019 04:57:34 -0700 (PDT)
Date:   Sat, 24 Aug 2019 07:57:26 -0400
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 204681] New: Kernel BUG/Oops:  tc qdisc delete with tc
 filter action xt -j CONNMARK
Message-ID: <20190824075726.398cc8a3@xps13.local.tld>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 23 Aug 2019 23:44:26 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 204681] New: Kernel BUG/Oops:  tc qdisc delete with tc filter action xt -j CONNMARK


https://bugzilla.kernel.org/show_bug.cgi?id=204681

            Bug ID: 204681
           Summary: Kernel BUG/Oops:  tc qdisc delete with tc filter
                    action xt -j CONNMARK
           Product: Networking
           Version: 2.5
    Kernel Version: 5.2.6 (x86_64) / 4.19.62 (mips32)/ 4.14.133 (arm7l)
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: itugrok@yahoo.com
        Regression: No

Created attachment 284581
  --> https://bugzilla.kernel.org/attachment.cgi?id=284581&action=edit  
BUG/Oops: kernel 5.2.6/x86_64

Overview:
=========

Several uses of "tc filter .. action xt" work as expected and also allow final
qdisc/filter deletion: e.g. xt_DSCP and xt_CLASSIFY.

However, trying to delete a qdisc/filter using xt_CONNMARK results in a kernel
oops or hang/crash on all platforms and kernel versions tested.


Steps to Reproduce:
===================

# tc qdisc add dev lo clsact
# tc filter add dev lo egress protocol ip matchall action xt -j CONNMARK
--save-mark
# tc qdisc del dev lo clsact
<Kernel Oops>


Systems Tested:
===============

Ubuntu 18.04 LTS (mainline kernel 5.2.6/x86_64, iptables 1.6.1, iproute2 4.15)
(Kernel build: https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2.6/)

Ubuntu 18.04 LTS (distro kernel 4.15/x86_64, iptables 1.6.1, iproute2 4.15)

OpenWrt master, r10666-fc5d46dc62 (kernel 4.19.62, mips32_be, iptables 1.8.3,
iproute2 5.0.0)

OpenWrt 19.07, r10324-8bf8de95a2 (kernel 4.14.133, armv7l, iptables 1.8.3,
iproute2 5.0.0)


Kernel Logs:
============

The clearest call traces are from the Ubuntu systems, and are attached.

-- 
You are receiving this mail because:
You are the assignee for the bug.
