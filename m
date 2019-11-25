Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1E7410919B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 17:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfKYQIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 11:08:51 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46825 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbfKYQIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 11:08:51 -0500
Received: by mail-pl1-f196.google.com with SMTP id k20so2229468pll.13
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 08:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=39muSJ0ZXwmJvHVglSEJfZegp9zCh6oKS32rpX3uVf8=;
        b=MdHLOUiEqdQS+9nqPP1JRvhdWNimMhQJKXFFYrcAzPo1NJp+1h0f9cScuw1F++qubo
         URloUZtRApUFoW5jt/fywJdvBeUFemow1wPYrQr/LBU7KE4kYtFc2O9zBEG1kvRkl2Qs
         NTiuwTTXqch8QgustFSKRfYmtGru3oO6gljm4RWUQnVV6tGjJtNZylpNYbz3eXzSUUm6
         9iTIY7EoN+zRpBwzOQbY5MticmgXr+sUJ9D8DVMVi4Qx+t/CebZen/8uH4IM+47/tBI3
         GfYouDvKIWDCZ7C+rDyw8ll+1uHp3dui4JmAFHILdk2HMaiBLWV9R+0CQkTNHw0+w5ez
         23nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=39muSJ0ZXwmJvHVglSEJfZegp9zCh6oKS32rpX3uVf8=;
        b=Js6crcM/sqPQql6DEfzF5Y4CrO6tyg69NZXRW/7XtZLqgcTSG7+oPDISvJOrbmOjVh
         GZmGAnw7t+g8Rh93G5XD/LNvy1ZTEFLn5dYWqOxkoHzjhcbrAEuGaUf18HiLvbEol3YS
         ryuV3Ab5vP7nJ1mumOLheRhMebbSx4KoROHuwHJios1eLwcM8CW5k9Qf+Bpa4PsmDNxu
         zoNF0VC1gVoYdCDWTTL76qk+xbku+PotxEr9kkTnKRKoMbJsll2A+z44qLBPblU+9Bjb
         tmC/CUfwU4IQdG+23SHSsEfQ4fb1kZgy9KJHxsqt+DtMcs5KO1JuMfmMMdq0ink6Uloj
         soqg==
X-Gm-Message-State: APjAAAW6W//AAzadgNIfdoSFyyXhbRI8ed7+OlcC4ND7IfCegoZ7+5l3
        6vTEfHSoCiJwBez5kcPCIwvwMcGA0rcj7g==
X-Google-Smtp-Source: APXvYqzzh88Ey0NkefO86HM/rYFH20/uR37+LF/iNyRf1poKHfsXmr8VNV1DWldENg/5jZUzywRI9A==
X-Received: by 2002:a17:902:6903:: with SMTP id j3mr27629523plk.231.1574698128055;
        Mon, 25 Nov 2019 08:08:48 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x7sm9035410pfa.107.2019.11.25.08.08.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 08:08:47 -0800 (PST)
Date:   Mon, 25 Nov 2019 08:08:39 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 205647] New: Wi-Fi cannot connect to network (regression,
 bisected)
Message-ID: <20191125080839.7cb386d9@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 25 Nov 2019 07:23:24 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205647] New: Wi-Fi cannot connect to network (regression, bisected)


https://bugzilla.kernel.org/show_bug.cgi?id=205647

            Bug ID: 205647
           Summary: Wi-Fi cannot connect to network (regression, bisected)
           Product: Networking
           Version: 2.5
    Kernel Version: next-20191122
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: nicholas.johnson-opensource@outlook.com.au
        Regression: No

Created attachment 286039
  --> https://bugzilla.kernel.org/attachment.cgi?id=286039&action=edit  
dmesg, sudo lspci -xxxx, .config, result of bisect

Marking as high severity as it directly impacts the user - the user will be
wondering why they cannot connect to a wireless network.

Using Arch Linux
Using Linux next-20191122
Using Dell XPS 9370 (i7-8650U, Intel Wireless 8265 [8086:24fd])

Will attach in a zip file: dmesg, sudo lspci -xxxx, .config, result of bisect

At the end of the dmesg, you can see repeated failed attempts to connect - I
could not get a single successful connection. On another kernel version (or
same kernel version with the culprit patch reversed), on the same computer, the
wireless comes straight up without any user intervention.

I have done a bisect. The result was:
"
6570bc79c0dfff0f228b7afd2de720fb4e84d61d is the first bad commit
commit 6570bc79c0dfff0f228b7afd2de720fb4e84d61d
Author: Alexander Lobakin <alobakin@dlink.ru>
Date:   Mon Oct 14 11:00:33 2019 +0300

    net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()

....

:040000 040000 56eacee948f7d3f2e04b09d6af502116c2cdd492
96653f8053eb477d1c37afa3ffdea678ee2fa7bd M      net
"

I reverse applied the diff of this patch to a clean Linux next-20191122 and the
regression disappeared.

I use Intel Wireless 8265 [8086:24fd] (iwlwifi.ko), but there were other
network driver modules which were re-generated upon reversing the patch, also.

Can somebody else please reproduce / confirm this regression? I will notify the
relevant people by replying to [0] in the mean time, but they probably should
not revert it on the basis of testimony by a single person.

[0]
https://lore.kernel.org/lkml/7e68da00d7c129a8ce290229743beb3d@dlink.ru/

-- 
You are receiving this mail because:
You are the assignee for the bug.
