Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527DA31D12
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 15:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfFAN0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 09:26:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37809 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729805AbfFAN0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 09:26:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id a23so7918707pff.4
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 06:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pwvnYnBqLw7TKDTfHUAStl91ZXmaSNmLLfk1dZ/hOA8=;
        b=iKFhXP10jsmQAyGbE9Z0+RUUrs0d6RCY5FVGGr6UxHAcJhl3kHEIWNwGSiJ/PWYuy8
         /kt8BQnKPa6/aq1On1lWb6ndY8o2CPMl96GpeQZwtyZW1h8HiwbpdoGwDreVo4Ln2mi8
         sKvZXeJk19d/OHCcyuvYnBiOzNjTJKvMLa90Uvae2ywnGlkWqQ9aES0D8NeOWFHfCjQc
         9/yc1ThG4VJWhpp8QmMNA7Qnkkzk5aMfv4O2EX22mZuEihBFtqr+DY4ltvYyj6aSi+I6
         Dk7H+OyzIIxcicysVWRaOltRHxwIPZ96PrDAsVxnOfKSrSrOA0UrzyQefo/a9weA6G7n
         bopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=pwvnYnBqLw7TKDTfHUAStl91ZXmaSNmLLfk1dZ/hOA8=;
        b=O6jwYOfouI3VWUejWUIKpxfun6ZQHtYE/JjF1O/nxFbWHmQj3lgRuKAvVmwD9y0eLY
         TPiLlrYaUKTjWri6DsdLexQ1S+SDjke41fwdIWG1Ba7B9C29FTo/o/7MBD5n6zW4WiVX
         iiAUqtl4pb8jFn9vAAkY9+GlPKDVUJRnSLWvRt/3/rdOVomH4eyZUW5sdcNfOFoU7Fxv
         Dxp0a+5u969yfC13dcBqqsvq/2gaMBLHAKzXuM3jYGfr4X/RhPJVqP1robJVuAheoFEo
         mtYq6D8luo8hTG/kIP6RNaEmXcM461cHrGZKnSJz5bRx0SpwAHg6xXkA+SHe4NFo5+7r
         FPLA==
X-Gm-Message-State: APjAAAXmcoJpldyVtaRvXXYlHFDGNQzTYfEEl7SDJmD4KJZY02ruXqgC
        So/s6/NQSvFlr45pEPnpwmY1mybV6XgxaQ==
X-Google-Smtp-Source: APXvYqxXLKMeoLKPbDQIbvyJ2JVdTcMjSEVuZ09wje8NwWgfMVCOxl33oowTbxAkgmipG8IFXUkbng==
X-Received: by 2002:a17:90a:ca14:: with SMTP id x20mr14983138pjt.98.1559395613381;
        Sat, 01 Jun 2019 06:26:53 -0700 (PDT)
Received: from xps13 (S01065039555c1e92.gv.shawcable.net. [24.69.138.89])
        by smtp.gmail.com with ESMTPSA id n13sm7612913pff.59.2019.06.01.06.26.52
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 01 Jun 2019 06:26:53 -0700 (PDT)
Date:   Sat, 1 Jun 2019 06:26:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 203769] New: Regression: Valid network link no longer
 detected
Message-ID: <20190601062651.2d82b819@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Details are a bit scarce. 

The referenced commit is.

commit 7dc2bccab0ee37ac28096b8fcdc390a679a15841
Author: Maxim Mikityanskiy <maximmi@mellanox.com>
Date:   Tue May 21 06:40:04 2019 +0000

    Validate required parameters in inet6_validate_link_af

Begin forwarded message:

Date: Sat, 01 Jun 2019 09:53:51 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 203769] New: Regression: Valid network link no longer detected


https://bugzilla.kernel.org/show_bug.cgi?id=203769

            Bug ID: 203769
           Summary: Regression: Valid network link no longer detected
           Product: Networking
           Version: 2.5
    Kernel Version: 5.2.0-rc2
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: gwhite@kupulau.com
        Regression: No

Commit 7dc2bccab0ee37ac28096b8fcdc390a679a15841 has broken wired networking on
two of my machines.  Drivers e1000e, igb and r8169 all fail to detect link with
this commit applied.  The drivers load and appear to initialize correctly, but
no link is ever detected.

With this commit reverted, they work perfectly.

This is on a fully updated Arch.  Happy to provide any other information that
is of use.

-- 
You are receiving this mail because:
You are the assignee for the bug.
