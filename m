Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A08B2880C2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731515AbgJIDjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731508AbgJIDjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:39:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45E2C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 20:39:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h6so6078703pgk.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 20:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=TX8wCShQRLkXz08OZnEDhplGz4+cyNbOMhOoRUEqC5g=;
        b=HkbXn875SXmuw2dqNuX1RoTHs1uJE9Tp8sT+gNsw09N8bKKVunqk6SytBx0PHh9Ybm
         4EqGW9/9VP1rxGpj4eSyxQDiXI1jJixf9RO8zrBHYhq3PZg0zpRcqKCcXjlvcurmZ/6+
         +DRyIXrd6NSyG8dYQAyWH2TAbHSkoRufW+bk+Z9udHyIcjwBa/7kc57WAFKWnjDgyA1z
         3XT9vf6CoPuowOfDkXptzLEQFOTLgrGWQalYmjthvDY42XObJQleF1yFP1Jy+0jR/8fn
         8gC4Q2pgQb/UqYdMr887D4XSjqXHVioF9eEJT3fDAUhc9IuUoRAh++mI8BgJbnUL77F4
         2FUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=TX8wCShQRLkXz08OZnEDhplGz4+cyNbOMhOoRUEqC5g=;
        b=HC4E8Xiemmeg5V34WKXdgJqDZqnt61zaoQdwemVbBM2YK0JWTUjUFeg4WINHSZ5wKK
         vERmwXOfJ5MKrkzG5VN5vpKC867n8jz4Jl6zwvDhIiGvoHNaM8CbtH67/nmylFWdz6a6
         RX74C54ySDQpp278JPEAkUr2o7a8UBsnwYKlOGEpdDJXrD275D1yZe5fYYlaDLizvyi4
         Cc76D6rMulEsDPg05fB5lwufr2SSsX64VNf4kqvpKIwP49A+ckSRkTCkdl5+PEqt62e7
         H8g2PT4n2m2hvBj/2EieTmbq36AxLTll1R8T8pF9RZ1YLJQW69VOJ8sXnVAmBS/aIlwe
         zHFg==
X-Gm-Message-State: AOAM533KGr89WuULfrvQeUZB6jzPqVM/0yguMq07l7XOSBoGzWk3CDO8
        JtjD+FWw55nSq2sQvttw5i3J1shj5jFyWg==
X-Google-Smtp-Source: ABdhPJzyVBQIdYgYNN4wV0c9cQxPptErTJr8/u6XiNFaUX73MS312FeArMhYEGrB1zEo38D3vqPAgw==
X-Received: by 2002:aa7:9501:0:b029:155:3b11:d5c4 with SMTP id b1-20020aa795010000b02901553b11d5c4mr6980382pfp.76.1602214774297;
        Thu, 08 Oct 2020 20:39:34 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id bf12sm8701186pjb.17.2020.10.08.20.39.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 20:39:33 -0700 (PDT)
Date:   Thu, 8 Oct 2020 20:39:25 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 209579] New: MPLS not forwarding packet, if packet type is
 not ipv4, ipv6
Message-ID: <20201008203925.69e58959@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 08 Oct 2020 07:33:23 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 209579] New: MPLS not forwarding packet, if packet type is not ipv4, ipv6


https://bugzilla.kernel.org/show_bug.cgi?id=209579

            Bug ID: 209579
           Summary: MPLS not forwarding packet, if packet type is not
                    ipv4, ipv6
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.24-rt15-2-rt
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: ne-vlezay80@yandex.ru
        Regression: No

The mpls packet is with label 100 not forwarding to gt0 interface.

Earlier soch the packet is normal forwarding.

```
#> tc filter show dev ns-test.0 parent ffff:  
filter protocol ipv6 pref 10 flower chain 0 
filter protocol ipv6 pref 10 flower chain 0 handle 0x1 
  dst_mac 33:33:ff:ff:ff:ff/33:33:00:00:00:00
  eth_type ipv6
  not_in_hw
        action order 1:  pedit action pipe keys 2
         index 1 ref 1 bind 1
         key #0  at eth+0: val 22222222 mask 00000000
         key #1  at eth+4: val 22220000 mask 0000ffff

        action order 2: mpls  push protocol mpls_uc label 100 ttl 255 pipe
         index 1 ref 1 bind 1

        action order 3: mirred (Egress Mirror to device lo) pipe
        index 1 ref 1 bind 1

filter protocol arp pref 49152 matchall chain 0 
filter protocol arp pref 49152 matchall chain 0 handle 0x1 
  not_in_hw
        action order 1:  pedit action pipe keys 2
         index 2 ref 1 bind 1
         key #0  at eth+0: val 22222222 mask 00000000
         key #1  at eth+4: val 22220000 mask 0000ffff

        action order 2: mpls  push protocol mpls_uc label 100 ttl 255 pipe
         index 3 ref 1 bind 1

[root@arch user (0)]
#> ip -M r  
100 as to 101 via inet 169.254.1.2 dev gt0 
105 dev ns-test.0 
[root@arch user (0)]
```

-- 
You are receiving this mail because:
You are the assignee for the bug.
