Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B403EA882
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhHLQZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhHLQZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 12:25:42 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B33C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 09:25:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j1so10516380pjv.3
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 09:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=0DW/8Jvb6Vm7xQoGvfgr8pZ4+8BmmfDZIqJ9Qdm8fqI=;
        b=R76iMLNlT06VrHzF6r4/Z+AkzWjJAcOplDT8hRDqTe0KNGCZm7EDaYLtPkWImLsXrJ
         OSPUJD7MARw4+V/GEFRFSUVKY07kj5Kih9fKY8VbFeIJ0sZHpSr5DOF9RuDen0IJAwbr
         EyGvGR7c2Pc52pOl6VM/o8cRezIj56OYMQUVP1S0EseRGn/JIsmPCADQ6e0neMZzzmWQ
         R4ukmETPN68kCjdtJdoixtw6w6Xa8J0YnTc9rbSCsErC+Q2EU/VrNKTVT5EE74D/15/X
         WnBHvkGZhwsI3Gx05m3TMXNfRsY6xMKoGnUAjoKYg3nDOEk3eqLWD7EHIjeg618nZOgp
         pflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=0DW/8Jvb6Vm7xQoGvfgr8pZ4+8BmmfDZIqJ9Qdm8fqI=;
        b=CCy33lpmQ3kRFPdvzdNPjPjxBphWcky22+zGczh3TGY5uUm5eRQw1raE+qEcJLfIMU
         tc/Jd2+8oT3ZsFL2N9XsQeiRDXMwOaxVGT3SAfxJi2NXdD+Qd6vBkFwI34m2TwSPsuXX
         U+VzwCtQeTDGe652auGidEdJyz7fOFKR+m0hHWgxyMb8Q5Sgc0bQZ/gOS2WyXGzgL3i9
         eK1x9V/vLbkUYxy8+sZrtpLG6n5sO02+S79QpcvLBStm3ctl5vH8iNHTqMRkq/PxG9cN
         KSkqbZ0uKkLGkjQQ3GJ8O1wCoRDJn+eIDwH/+3HrpMSjM8u9/tMcUi4QHvFL67p5nZ8V
         HTNg==
X-Gm-Message-State: AOAM530MgwdxxUUuCdRzs8SxEteA4KqqJb2TuFLudDoxgufBRKaxiWso
        rZTOr3E/ChsF8nQDZK1o3DuYqXuCsu/yFA==
X-Google-Smtp-Source: ABdhPJypKed7v7BmmBSvTsciDerG4y5m9WagmMNCIo399q10LNgmHNOccJLMShB4LXduEw35moeH4w==
X-Received: by 2002:a17:90a:eb08:: with SMTP id j8mr12763406pjz.94.1628785516320;
        Thu, 12 Aug 2021 09:25:16 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id q18sm4061759pfj.178.2021.08.12.09.25.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 09:25:16 -0700 (PDT)
Date:   Thu, 12 Aug 2021 09:25:13 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 213943] New: Poor network speed with 10G NIC with kernel
 5.13 (Intel X710-T2L)
Message-ID: <20210812092513.3e5ed199@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 02 Aug 2021 14:05:30 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 213943] New: Poor network speed with 10G NIC with kernel 5.13 (Intel X710-T2L)


https://bugzilla.kernel.org/show_bug.cgi?id=213943

            Bug ID: 213943
           Summary: Poor network speed with 10G NIC with kernel 5.13
                    (Intel X710-T2L)
           Product: Networking
           Version: 2.5
    Kernel Version: 5.13.x
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: ealrann@gmail.com
        Regression: No

Hello,

On a server, I use to receive files (parallel cp with NFS4) with a 10g NIC
(Intel X710-T2L). I can usually achieve a total speed close to 1 GB/s
(generally 4 cp at the same time, targeted to 4 different HDD).

Switching to kernel 5.13 (Archlinux) with the exact same configuration, my
speed is now limited at 250MB/s. Rolling back to a previous kernel fix the
speed. 

The problem is maybe in the last Intel driver i40e, but I don't really know how
to investigate more.


The problem still appear in 5.13.7 (last one at the moment).

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
