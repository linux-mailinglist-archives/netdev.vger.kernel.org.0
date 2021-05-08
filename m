Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D337747A
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhEHW74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHW7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:59:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6CFC061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 15:58:53 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s20so7344301plr.13
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 15:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=xcSh1Bh5wcshExSdwvX2bSL99h32EBN7GiX+GGJgewQ=;
        b=DvrqPF7lGjK1V2AFj0NT11uyu8ok9RQcIE455Qs8REZW6KcqgfTda7MxHm/3Thvnsj
         9wY+vADLRKa9aBqvDaB8aRbh3IQirUi6RjdPBhJXfcVeMM2z9DOdN8DIuURg4OPSii68
         glFpHMECIKG2k68hZ37mDanIZih1nMF2iQ4Uu4FPgvrH3vNw4brCVUI2G2Fq8AY4Ch15
         awDepvEGxMkEzkUfMd7eNBNF8w9MfdKlxw5XAlFOqGCzTlV/LyMEmoA4XdaZFwGFiuyb
         XlegzwsLyfPklJc82OxomWEbTWgDuzk8tiz/1MqUHqtRlLjNpwA1zEUIULHde3Uq+QAZ
         FW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=xcSh1Bh5wcshExSdwvX2bSL99h32EBN7GiX+GGJgewQ=;
        b=iPUH1hy+8akVQKzjaPc7WwTFmKUXh9W1G3/8CQg398/RHsCRg4aCESW7Xc1zA3GbHz
         4Mq2uE+prCz7c5B7VUmWSbGe6bmO1lbIOmn3TFxOTz3XFxi9fmH36hYE9iH8owBLsHD9
         76q1NzFIiqzjVhO3MCO0BM33fAaCc71NZulULvY5MtR1TXJMpgZfyMpnVtFjEmxZ7Yzy
         swxlbS1nMi/t8kwyKn28ktk4q81H3BJyLVVtRJuTTY4lHcNUj/G0d4y/wSmHOe04K+Iv
         JrSOPWZAyJV31DfBZYR8MB+SdndvZTWtZTUrwv0DxkjU8LDzeqLKW1fRbHA0/43saiuW
         4NiA==
X-Gm-Message-State: AOAM533dCqdXrTNf9sQrPJNqT8nhVD5KTjEL5MlA++xaOx3c83Vb+O5i
        hGczDt6xwQ6DJYVZoPEUNeLtWKKUfaYcMA==
X-Google-Smtp-Source: ABdhPJyGftpXSucxCLIAwzzqfX/kaKBvLPSaNW7SF0Ypho/fzYTk5eHlVtmVrpL1le47AfyTMRS3uA==
X-Received: by 2002:a17:90a:488a:: with SMTP id b10mr18467831pjh.2.1620514732760;
        Sat, 08 May 2021 15:58:52 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id k8sm8362569pfp.99.2021.05.08.15.58.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:58:52 -0700 (PDT)
Date:   Sat, 8 May 2021 15:58:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 212997] New: /proc/net/dev: netns default route via
 wireguard no longer counted
Message-ID: <20210508155849.0527ba64@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Sat, 08 May 2021 16:23:48 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 212997] New: /proc/net/dev: netns default route via wireguard no longer counted


https://bugzilla.kernel.org/show_bug.cgi?id=212997

            Bug ID: 212997
           Summary: /proc/net/dev: netns default route via wireguard no
                    longer counted
           Product: Networking
           Version: 2.5
    Kernel Version: 5.10.33
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

Despite 212317 i am "now" seeing another problem which i am pretty sure was not
there "a few weeks ago".  In a box started via

  ip netns exec secweb /usr/bin/env -i TERM=screen-256color /usr/bin/unshare
--ipc --uts --pid --fork --mount --mount-proc --kill-child
--root=/tmp/ports-2BiE7A/root /init

where secweb is a namespaced with routes

  default dev wgsewe scope link
  10.4.0.8/30 dev secweb_peer proto kernel scope link src 10.4.0.10
  10.4.0.9 dev secweb_peer scope link
  10.5.4.0/22 dev wgsewe proto kernel scope link src 10.5.4.2

(where 10.4.0.9 is veth to main namespace, and a local dnsmasq cache is
listening to provide DNS, nothing else is possible) aka

11: secweb_peer@if12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
state UP group default qlen 1000
    link/ether 2e:5d:78:06:bf:94 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.4.0.10/30 brd 10.4.0.11 scope global secweb_peer
       valid_lft forever preferred_lft forever
    inet6 fe80::2c5d:78ff:fe06:bf94/64 scope link
       valid_lft forever preferred_lft forever
13: wgsewe: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state
UNKNOWN group default qlen 1000
    link/none
    inet 10.5.4.2/22 scope global wgsewe
       valid_lft forever preferred_lft forever

the /proc/net/dev counters of secweb no longer count any traffic routed via
wgsewe, only the DNS traffic via 10.4.0.9:

secweb:   29157     382    0    0    0     0          0         0    42301    
308    0    0    0     0       0          0

whereas we see
=== WG wgsewe@secweb ===
interface: wgsewe
...
  allowed ips: 0.0.0.0/0
  latest handshake: 7 seconds ago
  transfer: 218.64 MiB received, 7.50 MiB sent

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
