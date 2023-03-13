Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989366B7933
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 14:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCMNlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 09:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjCMNlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 09:41:11 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D212E62B74
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:41:08 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5418d54d77bso70765137b3.12
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 06:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678714868;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hh5Gq5jvSdqyypbXy3QpzhbIlDjwPC5f0GUbw4Q2RfM=;
        b=X9a1W9MrC8fDjGhbphRa0SUWLiAolOM1k8sZDwL/H1ioq/F4N3vXUH8gjll9uEDO7p
         MIv6Hg4qt2j/b4jz3q4D9yD4hgiQY5J+hVufZuZPxjk4RICsoQ0c6iq5BWHwOahlfUwR
         UzjVFxJhn3VYi+CDla44A6CJzNLUU6fYlBqzFTWGDGWv9GJAyhmAtRZyce5dWpgAIeb+
         H7wFSY4rkaTruzcXpWUVTXx7qWqXAJSnqT4whRlj9ugGl/2sIR13TRQlizyDH55sd6K6
         /nMzERMDkIjwvp2Un6U7RsHTkqcXnKmkXzWPZNWPVpVeoptSoDgNea2WYILLItSz2ofB
         VZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678714868;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hh5Gq5jvSdqyypbXy3QpzhbIlDjwPC5f0GUbw4Q2RfM=;
        b=Bjsc60krqH4M3OkGJIkqNhyJkNqPEpfhazABXAHYiBRNLnpgHsveDp7UvTxrtD8G8j
         Si14Vv7DKBskNqVmm+OAEJZWnrtdjRfxdK9zdPy6OXzJusscc7gJ4FMXW9jjhL7kLDIL
         csgz2uFOOfCurdAGVghcvuQZUiKGgTNCuvFwnvza0lTfZf8QZz4ADWCuPQ2SFFkFr5m4
         bDiooo2v/WTjCTA2sbtkmNi0hEJHeBA2F3IOkKw4/VMn2U8cN5VODfHlSjGltBHxlpGx
         44ibz/Q/HL6kbkALaWp0YJTsfv8Mpfm5e+wi1lukaYC9RcaH5efnkagIa2WdoUZApkJf
         SBTg==
X-Gm-Message-State: AO0yUKXPWBsDBw559ZGDgUIv4aNTgjwsd8dv0OFMTphL6cV8RKxEcXbv
        I4/VQj9/d7d3KUnQwwX7cnqAaTgXZzn9z2Y0exT3jcDuhAc=
X-Google-Smtp-Source: AK7set/lbHvE0HsiZhDrVY9dy552AZn4XUzxRwafWzsA5QfujsdmtvYGmfI2Snm8uocQBtrCm9G5rr8KF0yxipZqbDE=
X-Received: by 2002:a81:a906:0:b0:52e:d2a7:1ba1 with SMTP id
 g6-20020a81a906000000b0052ed2a71ba1mr22456938ywh.1.1678714867688; Mon, 13 Mar
 2023 06:41:07 -0700 (PDT)
MIME-Version: 1.0
From:   Turritopsis Dohrnii Teo En Ming <tdtemccnp@gmail.com>
Date:   Mon, 13 Mar 2023 21:40:57 +0800
Message-ID: <CAD3upLsLPF3nYdD1HHhqiweXt8zzOLKWpdPwuUKrccc1x33XBQ@mail.gmail.com>
Subject: Fortigate Firewall Setup SOP Draft 13 Mar 2023
To:     netdev@vger.kernel.org
Cc:     ceo@teo-en-ming-corp.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.8 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: Fortigate Firewall Setup SOP Draft 13 Mar 2023

Collated by: Mr. Turritopsis Dohrnii Teo En Ming
Country: Singapore
Date: 13 Mar 2023 Monday
Time: 9:21 PM GMT+8 Singapore

01. Register the brand new Fortigate firewall at https://support.fortinet.com

02. Key in the Contract Registration Code. This is very important.

03. Upgrade firewall firmware to the latest version.

04. Set hostname.
XXX-FWXX

05. Set regional date/time. Time zone is important.

06. Enable admin disclaimer page.
config system global
set pre-login-banner enable

07. Create firewall super-admin accounts.
a. admin
b. xx-admin
c. si-company
d. abctech

08. Configure WAN1 interface.
Most business broadband plans are using DHCP.

09. Enable FTM / SNMP / SSH / HTTPS for WAN1 interface.

10. Configure default static route.

11. Configure LAN interface.
Optional: DHCP Server

12. Set DHCP lease time to 14400.

13. Configure HTTPS port for firewall web admin to 64444.

14. Configure SSL port for VPN to 443.

15. Configure LDAP Server.

16. Create Address Objects.

17. Create Address Groups.

18. Configure firewall policies for LAN to WAN (outgoing internet access).

19. Configure and apply security profiles to above firewall policies.

20. Create Virtual IPs.

21. Create custom services.

22. Create service groups.

23. Create firewall policies for port forwarding (WAN to LAN).

24. Configure other firewall policies.

25. Disable FortiCloud auto-join.
config system fortiguard
set auto-join-forticloud disable
end

26. Configure FTM Push.
config system ftm-push
set server-port 4433
set server x.x.x.x (WAN1 public address)
set status enable

27. Remove existing firewall/router and connect brand new Fortigate
firewall to the internet.

28. Configure FortiGuard DDNS.
xxx-fw.fortiddns.com

29. Configure DNS.

30. Activate FortiToken.

31. Create SSL VPN Group.

32. Create SSL VPN Users (local or LDAP).

33. Configure 2FA for SSL VPN Users.

34. Create SSL-VPN Portals.

35. Configure SSL VPN Settings (split or full tunneling).

36. Configure firewall policies for SSL VPN to LAN.
Optionally configure firewall policies for SSL VPN to WAN (if full tunneling).

37. Configure C-NetMOS Network Monitoring Service.
configure log syslogd setting
set status enable
set server "a.b.c.d"
set mode legacy-reliable
set port 601
set facility auth
end

38. Apply hardening steps (Systems Integrator's Internal Document).

39. Convert SOHO wireless router to access point mode.

40. Configure and apply security profiles (REMINDER).

Testing
=======

1. Internet access for all users.

2. VPN connection using FortiToken.

Documentation
==============

Firewall documentation for administrator (settings / policies / VPN).

User Training
==============

A. For Administrator
====================

1. How to access Fortigate firewall URL.

2. How to add/remove/reassign FortiToken.

3. How to add/remove VPN users.

4. How to generate usage report for Government PSG Grant.

B. For End User
================

1. How to connect to VPN.

2. How to use FortiToken.

3. How to connect company laptop to VPN.

===EOF===




REFERENCES
===========

[1] https://pastebin.com/raw/yg0QUcv6
[2] https://controlc.com/85e667fb
