Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BBA33F7BD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhCQSBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhCQSBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 14:01:33 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB82EC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 11:01:33 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id p21so54021pgl.12
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 11:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9eqiSdHy5NbSMi9ZAr+T/GiF1bv5P0EkOixzvdcsTGg=;
        b=GIC/TJSVZSeAgec4D/58uqw78AYhtRQ5a6yPlg8r5PP5JkryqOr6S0TbrSJjX5yQkt
         BRUdETs0GTDOwdHoA+ZqVB20LADBfJ476gyYylHdzuUSXL3cbnt/n2j2nJY17nW5rNGp
         dpQ+e1HPg7Y2cfKDAG6DNfwgHaygmC1ZZZsx0QpBRBImZQ5FWfzNRK7TaXkBzWPF9ZxX
         Te/BYCKK29Dy6oxTmBRnKN6C0/MKZ7q4BFh1nNvyqCRxbyCuM3KQXxb3ROdrzMT/1ufS
         nEtkcUXaQZ9SgBHFBf82c1ucmplHfv1OU2XOPkfGKaEqZpdj0rNE78DIKaNwrPuBkHtv
         eRRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9eqiSdHy5NbSMi9ZAr+T/GiF1bv5P0EkOixzvdcsTGg=;
        b=NnnJ3705DDsOG4gbMUZC6j61SV1W3mz8JvD7bPnbTGI6gAcerqXTovw8ZrIQqM5g7N
         J00Fao9SNhXvthzC4hjDFDT7i5c0jlyPhzoJrtapx77ae/qodCijOQYZR10OUO4NSedb
         izUIo20LAOhg+X6HEU78qr0CiuCIrZ7f9c6RKB5eYdcsAALpMsvIepeMNwocowmZ6NKu
         7x6ILGoML+EWCcf59S58OZvfE4JezXTFIa7jk064T7nSDXwzQWRRxA9IMLmQ6i7Y09+O
         xxhHNSWE9JxjxYH+WBSU0mESKvSWip4ce7yOvMXcbhhsxZtalefKI89yNJREvYAnDl5s
         012A==
X-Gm-Message-State: AOAM532kvuJnb3gXUxsue7LZFXo9EjpA+TbxlWjXgezxlZFDLf1xXUcd
        xY/plIbnEp9j0NIjTTPGxEuBn9ltQG7D/w==
X-Google-Smtp-Source: ABdhPJzHx5DOQZV765gmEenx6y3Hv2eoe4LIKA8YDw/L6GcH03zfHRcVIluHPMe6lZKXRBZQM+6JAA==
X-Received: by 2002:aa7:8d05:0:b029:1ec:b460:f21d with SMTP id j5-20020aa78d050000b02901ecb460f21dmr300877pfe.29.1616004092766;
        Wed, 17 Mar 2021 11:01:32 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id e1sm3578823pjt.10.2021.03.17.11.01.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 11:01:32 -0700 (PDT)
Date:   Wed, 17 Mar 2021 11:01:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212317] New: /proc/net/dev: reversed counter for network
 namespaces?
Message-ID: <20210317110124.71b7240b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 17 Mar 2021 14:14:36 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212317] New: /proc/net/dev: reversed counter for network namespaces?


https://bugzilla.kernel.org/show_bug.cgi?id=212317

            Bug ID: 212317
           Summary: /proc/net/dev: reversed counter for network
                    namespaces?
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10.23
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: steffen@sdaoden.eu
        Regression: No

Hello.
Yesterday i extended my tmux status line to include all "network devices", and
now i am looking at a line

  RF:W~B~ wlp1s0~158/16 wg0~6/2 browse~8/124

which are /proc/net/dev devices (less in-namespace stuff) with non-0 byte
counts.
wlp1s0 is the sole connection to the internet, and browse is a network
namespace that boxes graphical browser usage, and can only access the internet,
no local services (but DNS).

As you can see it states it has send 124 MiB and receives 8 MiB, which i deem
wrong, especially since the entire up/downstream bytes of wlp1s0 state
something different.  Could it be the counts are reversed?

Thank you!!

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
