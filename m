Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F26B7569
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387874AbfISIqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:46:35 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:40815 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfISIqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:46:35 -0400
Received: by mail-wr1-f42.google.com with SMTP id l3so2151538wru.7
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 01:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=f7sTbfuoLEs8rck0B3+KipVug0psOXx8ujb0gz0bo8E=;
        b=JDLCD2x/BH/xU2U7FljVfq3ON4EF6uO3JJuPVPR3XpfZ+W77UR+VKyRyfzcGkCYybx
         EVnSDZQ+oHQI/A7OxXiJN0zMY5eZeKaNFb+q984WyjbeB/NRZPgSa8aVogZksJ80v4oX
         4ebRAgdA1cJMYJpZkie0snm3YF0HKSLH0uteSAmzjyWcvpVA3yqYa3ijk060gVB3l/Mo
         821JEMLag46pCeq8/4ffqoMe8GceyLWyRTZzP4crOeYN5eCKFH7N2fxYPGHt7dhYP3Xz
         c2m58Gost51fCTCJE015+gKCy9tUy62RAmRJ4oVT/mtYRaPp1uZovQoGQFRT51+S2Cln
         bqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=f7sTbfuoLEs8rck0B3+KipVug0psOXx8ujb0gz0bo8E=;
        b=V2r54UoZLC2/h47Ymx731fyevirotyNHQsAZMp8gMf5mevHSTP7ucy1xkYkcaiyxMB
         fjmdl8+kqCINBMcWokT1uGIAEHLqIkJeRFwld1XSNE9SRWBGOWK1PSIXC+R/wFIXgqUQ
         GrH2PKNX8Q0obDfTLODJc1FurACtPUfSkhdgMgDQ4Tb4w5Wdbdrzusfd+p6qyspYIJ17
         ITMFFq/712kY4SrrhB9xHEUkQTJiMHq+4iZcQqsc2ogNBSin//22GG6bxs8ufaMT/jwW
         KRqXEwl88b9nW1YRDzdfPKHw9cNHnDHRMh15Fh7LUzN7MiKXqENcplIfrI/7Q7QGSTZv
         kVfA==
X-Gm-Message-State: APjAAAU+HquV9n4yu0nBvZse/UiMeNhpSI6gaPk+hkv4H4bF/St8wiv5
        JKCkc2xiPIz2Cb4aJUxvkonF4Q==
X-Google-Smtp-Source: APXvYqzI0GJjDr6aMYiUaJ7y0UHLJ5uLY64OhPft3ukJEpK5VhQgRHes8KtlrhXC81vRvrlXdg+1Wg==
X-Received: by 2002:adf:e48a:: with SMTP id i10mr6122807wrm.311.1568882793142;
        Thu, 19 Sep 2019 01:46:33 -0700 (PDT)
Received: from xps13 (lmontsouris-657-1-167-187.w82-127.abo.wanadoo.fr. [82.127.205.187])
        by smtp.gmail.com with ESMTPSA id x16sm7393120wrl.32.2019.09.19.01.46.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Sep 2019 01:46:32 -0700 (PDT)
Date:   Thu, 19 Sep 2019 10:46:28 +0200
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Fw: [Bug 204903] New: unable to create vrf interface when
 ipv6.disable=1
Message-ID: <20190919104628.05d9f5ff@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 18 Sep 2019 15:15:42 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 204903] New: unable to create vrf interface when ipv6.disable=1


https://bugzilla.kernel.org/show_bug.cgi?id=204903

            Bug ID: 204903
           Summary: unable to create vrf interface when ipv6.disable=1
           Product: Networking
           Version: 2.5
    Kernel Version: 5.2.14
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: zhangyoufu@gmail.com
        Regression: No

`ip link add vrf0 type vrf table 100` fails with EAFNOSUPPORT when boot with
`ipv6.disable=1`. There must be somewhere inside `vrf_newlink` trying to use
IPv6 without checking availablity. Maybe `vrf_add_fib_rules` I guess.

-- 
You are receiving this mail because:
You are the assignee for the bug.
