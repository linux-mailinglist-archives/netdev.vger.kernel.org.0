Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D850063817
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 16:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfGIOnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 10:43:47 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:37396 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfGIOnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 10:43:47 -0400
Received: by mail-pf1-f174.google.com with SMTP id 19so9411666pfa.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 07:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=6TuVq4DbQT2toSxqpSohEPMm5bRH5GH0PJgkYD+wkdA=;
        b=kh6krsEeWhpU2rzjGEcoabvk/cr7e2TDhOCbQtuAem6uS0OIlfQYQj54gkWnix62y/
         U4CnFwlCNrLynZ5Y8zxDZ89rFmETCVTkzTZ55tWiu9BHMmEupHK8uUA8gGRPC/IRMJ63
         3BbDaQkPCnVy1YFESpQ5kjV9TuHmatQ2bch4EHkLxczwIfHDS9tc3TXVz22i7NMKQXwg
         7VCfZqsDqybbR+hdzSdvUe2xZ9dSG4KEmVTpjmVklV755flpZOezUyHFzPskSO5r1lDH
         ZY5ZDfBEON0jpA02Qbnn6JGf7GNZxnNlUEdDwwMcQnUGrlZudzi4Lp/AEHkTmWz+I4Y8
         as9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=6TuVq4DbQT2toSxqpSohEPMm5bRH5GH0PJgkYD+wkdA=;
        b=nwDsCZjguKSwJxO+N+qG+uoZK22Zo78s1+M41XWfo89de5cW0DMhMtQNFHg01s4eqr
         9C6IQgUYBKs9QfVMoZj0+QVH9Xf1zgJeTWqjavLBNIguPQxqGqfRV+sVMAMiAf7eqgsh
         ipvigfKTCDyNhjGDfU6fO8s5TcaqmX9VRoRiq63UhGu+ZTkzwgNf8dJwEjVME3TR1ZcB
         OdalPu7AT88LZArghkPMBqsCO5UXdFIxPFI6KOmudIVCJ/3REUm5iMv/XeQPEO8TBTgh
         jhX8oVd8Nco4RHBXVGmliSb8c5FAFTObrSJAo3x7OjLMxgWkAhRo7qU5KsTJcr2CFBcd
         BBQA==
X-Gm-Message-State: APjAAAVntSTAUSQtOkSBN36BokpIB61+2zfyhJcaYqikpP7jSc0spmV8
        u8MTOfNz3lzGUcLAFdL33c1rCmU/NCk=
X-Google-Smtp-Source: APXvYqynxR/WyMFFcKF6FIQIQGtmw4NcsM1AQqLHTLdSz5sz06MVBGUBzjBvz3CM7EG5Z7UyPCHt4Q==
X-Received: by 2002:a65:454c:: with SMTP id x12mr31035716pgr.354.1562683426171;
        Tue, 09 Jul 2019 07:43:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p2sm27826534pfb.118.2019.07.09.07.43.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 07:43:46 -0700 (PDT)
Date:   Tue, 9 Jul 2019 07:43:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 204099] New: systemd-networkd fails on 5.2 - same version
 works on 5.1.16
Message-ID: <20190709074344.76049d02@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like the stricter netlink validation broke userspace.
This is bad.

Begin forwarded message:

Date: Tue, 09 Jul 2019 00:44:01 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 204099] New: systemd-networkd fails on 5.2 - same version works on 5.1.16


https://bugzilla.kernel.org/show_bug.cgi?id=204099

            Bug ID: 204099
           Summary: systemd-networkd fails on 5.2 - same version works on
                    5.1.16
           Product: Networking
           Version: 2.5
    Kernel Version: 5.2
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: Ian.kumlien@gmail.com
        Regression: No

This is more FYI, I haven't had time to properly debug it.

Booting 5.2 causes systemd-networkd to fail to bring any interface up, it will
fail with: "Could not bring up interface: Invalid argument"

However, booting 5.1.16 with the same software works just fine.

Sounds like something was changed in, what I assume is, the netlink API

-- 
You are receiving this mail because:
You are the assignee for the bug.
