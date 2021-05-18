Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4FD387F17
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344188AbhERR66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240327AbhERR66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 13:58:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C977C061573
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 10:57:39 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so2000424pjb.2
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 10:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=oxaauVHhw5lY1FoxZJi1j49Hg+WpaUu0CMw+4TZkq0Y=;
        b=YxbZwuoVQ2BxxrK0fv3JUeQvK2mMnQFXSDOVmGs36pD794tgbdLr0w+XpkbjKs/pLj
         E1cMAahDY2IZS2nUMnubrUrTEnGc6u+yrtSpZGLAzXUx7sdaTdXR1R9I8iHqkwp0Uc6P
         B8C/3c3yctP8qkKWpAa1vnMrV1F3+jJNrv7piPbkJD46W3hRKA6DUBSf2ea3Hw3Ofs+g
         6x0NO5qtbYCAmu8tz56ENxM2+IiWwe8tG0Hb/Rp4fX27zNJ7CXXQWoCRM0+vOGWjDWq1
         QEWxpKHlecbr3zw2rGdOea+Lz8WUhX82Yl0WC4sG5eqRKOGpRr3SzGzdazerAcz4/x9d
         dXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=oxaauVHhw5lY1FoxZJi1j49Hg+WpaUu0CMw+4TZkq0Y=;
        b=A4G3ll9AFLUTMlQeY94P2Q06P2buSwN5CaUkWb0dSYESr/QqPyvXXNRJr0NVTOQV25
         AAllxe3ZS35FwPDE2TGJ0lbPmZuCoWG5afN1XcrSbBG6nYrWfHKsuX39zn3RIPWqUczx
         YlJee7cC20Au49uUzX6Dn2is1jY4AuMui3oL2Qsra985wMg27Bw3MngKvTkutIgGBYxo
         sGyMzvy2KBPkeluwfIbrFCv8Jc0ycGNRmNw0KIL4fsQ3iiVgg5cxIV19shek1x6T6Vfq
         vqHsCGomYAmG4Sk8rBpJJ38mz7EMPhW5Zf7RfZi3zi40nkFByQZu0SGnsvPjpSkKLb54
         WA3Q==
X-Gm-Message-State: AOAM532Yv6iqQq35lsFCq7spl0/E3+7Ve/CNsclGwfYoITStIZm0HBZN
        oElZolDxNI9cWOVKyRaca3JJvmx41XGj3w==
X-Google-Smtp-Source: ABdhPJy+GuF1H579pSKix9Iz5A9ZDpo1JI/7Qo582RKSWY/5NINyAV2Uh1qRJfi1vmwZZBkSTMUEsg==
X-Received: by 2002:a17:90a:dac1:: with SMTP id g1mr6292025pjx.199.1621360658969;
        Tue, 18 May 2021 10:57:38 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id d13sm12215710pfn.136.2021.05.18.10.57.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:57:38 -0700 (PDT)
Date:   Tue, 18 May 2021 10:57:35 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 213123] New: The performance deteriorates because the
 ip_victor function is deleted.
Message-ID: <20210518105735.4f4f7eeb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 18 May 2021 07:31:29 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 213123] New: The performance deteriorates because the ip_victor function is deleted.


https://bugzilla.kernel.org/show_bug.cgi?id=213123

            Bug ID: 213123
           Summary: The performance deteriorates because the ip_victor
                    function is deleted.
           Product: Networking
           Version: 2.5
    Kernel Version: 4.19.90
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: kircherlike@outlook.com
        Regression: No

In the 4.19 kernel, we see that there is this commit

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net/ipv4/ip_fragment.c?id=86e93e470cadedda9181a2bd9aee1d9d2e5e9c0f 

Before the integration, the ip_victor function is used to release the old
fragmented data when the fragmented IP data occupies the fragmented buffer.

However, in the same scenario, the kernel of 4.19 discards all subsequent data
until the 30-second buffer wait time set by ipfrag_time expires.
After this, subsequent fragmented data is received.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
