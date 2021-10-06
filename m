Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E28424128
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239124AbhJFPVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbhJFPVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 11:21:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E763C061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 08:19:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ls18so2457279pjb.3
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 08:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=k6dXWdkzytTPMVlamgW3MJfN3gop+oiZYHi4A1Y/EYc=;
        b=25JxC0jb/VULGO0T4EnOPCHKbVTjB6XHzl/g3QK3sbJH/nquZAlvZuMXBVQvn3i9Sv
         t7QZAZFEJBRXkqsanw1Jt+ePAx8ml7Y1by3SiFIb4OA7m2VtiqVrSOjEQh9fAt5Y7U80
         2r0YEHbfGrW8wdPqEVZKakd48KiAfBEdjGqMZ48FrayYG8mpS3D288wxX5i7/t6vcCgY
         uuLkGSVM+HA0qwtV1GPRA7KgtcBcJB5mqnlQzpjqqftmsaOMOOWsaKz0PjE92fhI0BUh
         +0LKu1HfwifO6zE86hN+SnWVAKwyrPdgriGh9H8toKDPsq26R5rflBKbgiRL74yzF3Vx
         t6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=k6dXWdkzytTPMVlamgW3MJfN3gop+oiZYHi4A1Y/EYc=;
        b=eFHR3PL96lNHnm+KqDd2AZzhn+RPy2+F3XJ2Bhz9OUIWhJYRCq7yTyCZb8O5WMhs9w
         VIqa3J4CTgUUswziF7mo/XMccwJmoIBmv0j8UZ4UGZDh8QpjzXf8wjrnPQ7iIUO4A+V3
         jZ91QYdvqDxFvWRzjVdVgILYSPr/Igtsk7uLZn62Wx1uD34yP4hPgipWhzDoL5bkVldp
         KQnzzHC58jihIai6iq8Ib+AGkL2UcZKdoTtFkA4Tkxv+P+DjODSQRAHPMYwQPI6w59So
         ebWdAu4pGZQ9GpMTnOFS/7Qw09KE6abNjJrKQcwRlj0awTg8Cfk/eYMmX2F1Pe12czj2
         M69A==
X-Gm-Message-State: AOAM533iIITykVlD/lw9JgbMpn2sej6oN2OnIpS/3ykoKcal4i1ZnK+U
        jwppfH9Q0u8rTcDDGYJ/sR/AcYcVNzR4/A==
X-Google-Smtp-Source: ABdhPJyRIuGDzeNSjX6MGLyxl1eZelUItdBteLxUx0FHKFdbd/BwxYHgVKXKtbhW8b44QWVBZ4kyqA==
X-Received: by 2002:a17:902:e544:b0:13e:e863:6cd2 with SMTP id n4-20020a170902e54400b0013ee8636cd2mr8435132plf.41.1633533596368;
        Wed, 06 Oct 2021 08:19:56 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id r23sm5520064pjo.3.2021.10.06.08.19.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:19:56 -0700 (PDT)
Date:   Wed, 6 Oct 2021 08:19:53 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 214631] New: Creating a macvlan with as bridge as parent
 -> NO-CARRIER on both
Message-ID: <20211006081953.539005df@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 06 Oct 2021 15:09:30 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 214631] New: Creating a macvlan with as bridge as parent -> NO-CARRIER on both


https://bugzilla.kernel.org/show_bug.cgi?id=214631

            Bug ID: 214631
           Summary: Creating a macvlan with as bridge as parent ->
                    NO-CARRIER on both
           Product: Networking
           Version: 2.5
    Kernel Version: 5.7+
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: jan@delandtsheer.eu
        Regression: No

When creating a macvlan with a bridge as parent, interfaces brought up, have
NO-CARRIER.
Only when connecting another type of interface to the bridge (like a dummy) and
bring it up, the bridge and macvlan start forwarding


ip netns add tns
ip link add tbr type bridge
ip link add tmv link tbr type macvlan mode bridge
ip link set tmv netns tns
ip link set tbr up
ip -n tns link set lo up
ip -n tns link set tmv up


behaviour :
  kernel 5.4 -> that always works
  kernel 5.10 -> mostly works, __sometimes__ not
  kernel 5.14 -> never works

verifyable with `ip link show dev tbr` having NO-CARRIER

When it doesn't work:
ip link add tdum type dummy
ip link set tdum master tbr
ip link set tdum up

and then the bridge and macvlans start forwarding

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
