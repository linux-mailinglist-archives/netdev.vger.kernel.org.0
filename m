Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBB910C0E9
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 01:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfK1ABA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 19:01:00 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:35184 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727300AbfK1ABA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 19:01:00 -0500
Received: by mail-pj1-f45.google.com with SMTP id s8so10935011pji.2
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 16:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=adQ+wUnZ3IALa2nL7g/CgLDZiAftusTPTXQegxAJmkE=;
        b=T0mPqJKqDopNzwD6OuyaRcbQ8Bur82NFaSHZxXNaxfpFHTU7ltxW2/Hsd//FpsVsEw
         fTpMXLmGjfQftPEGnjgZR5nPv+JIiW+AYoruvg19BRnSbe15+EnDlTHVPyqZjALAhaF1
         KVijjt606b8N2VmILANSmu8Kohap2Vtjjuy750PqSFXTCIu8QT/6rr1wz8wo5CyuPS43
         jiC7j3iO0lMLbxXJeHX5D1U2pfPK0EaAHsr2GlKEkNMS7Aji5xuxzgzEf8VFOZh5mGpM
         V9OFR3l58ha6tz1LcgskO/HmY2gT5lbE6hFbVhtPePIJF4ZZ8IfciHaDU3pHnE3PldD/
         jalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=adQ+wUnZ3IALa2nL7g/CgLDZiAftusTPTXQegxAJmkE=;
        b=Qgg6wZuFJukpQW0RH4KUJR7+JZLJaLN71bQdOVlPnKHN/wRyGnR2D5NAaYEHGW6D3s
         1739ijgXbS2QXWzTViFH2yQQfKzE1dFke7Rr+a4pe0IpguiuveRpKTKvXpXmMUsdhpiS
         LLopIb0bQnnKOvkq+T2ehOIvU2ggGQkduL8o/a+nZt503Vlwo71gkhFKAH7FbKYVhQZ1
         kVDT1R396H2JAlq/xcaz4jqfJLkyqV4U16qc9tekydAS7jC7G6koIntJsU/TQB6JzlB3
         k7F42FBHazRqwPJua5231TQRT8kzzDslSicwNlW2hGEsz62NLPfyzl0kpKRRXAetGuHP
         FHYw==
X-Gm-Message-State: APjAAAXU9LQGHHjK0otNokUpYElbUxkn479nVzhkwylg2r61qdS3/utn
        PcdGZMCVv8IMSU5cBwuJQ2+6l7ycbda80A==
X-Google-Smtp-Source: APXvYqzaEp+YIs2p7RuYt6zi8yUJXt20GP68PAExBo8dctTdreXaSZV2UZ7xMghXaoBbFerW1J9aMQ==
X-Received: by 2002:a17:902:7b95:: with SMTP id w21mr6415433pll.298.1574899257854;
        Wed, 27 Nov 2019 16:00:57 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d139sm19445358pfd.162.2019.11.27.16.00.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 16:00:57 -0800 (PST)
Date:   Wed, 27 Nov 2019 16:00:49 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 205687] New: VXLAN from ipv6 is not sending ipv6
 fragmetation pachets
Message-ID: <20191127160049.79e74101@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like a UDP PMTU related issue?

Begin forwarded message:

Date: Wed, 27 Nov 2019 23:46:00 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205687] New: VXLAN from ipv6 is not sending ipv6 fragmetation pachets


https://bugzilla.kernel.org/show_bug.cgi?id=205687

            Bug ID: 205687
           Summary: VXLAN from ipv6 is not sending ipv6 fragmetation
                    pachets
           Product: Networking
           Version: 2.5
    Kernel Version: 5.3.13-arch1-1
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

ens3 mtu is 9000 bytes. Internal and guest network mtu 65535 bytes.

Sending packet to guest network:

#> ip netns exec test ping -s 8700 fd00::6  
PING fd00::6(fd00::6) 8700 data bytes
8708 bytes from fd00::6: icmp_seq=1 ttl=64 time=0.674 ms
8708 bytes from fd00::6: icmp_seq=2 ttl=64 time=0.648 ms
^C
--- fd00::6 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1008ms
rtt min/avg/max/mdev = 0.648/0.661/0.674/0.013 ms
[root@arch user (0)]
#> ip netns exec test ping -s 32768 fd00::6  
PING fd00::6(fd00::6) 32768 data bytes
^C
--- fd00::6 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1022ms

[root@arch user (1)]
#>   


Send big backet from ipb6 is failure from vxlan.

-- 
You are receiving this mail because:
You are the assignee for the bug.
