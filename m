Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B452418FAA6
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgCWQ71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:59:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44580 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbgCWQ70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 12:59:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id b72so7758881pfb.11
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 09:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=0Yz3aCtfs/NmJpk29XMbsItf5utDQd9JiRR8EbPIQxE=;
        b=wPwACC9/U3hgmHfDEX/maP0v/3kGU5BlP4UJu+jRZqzcMPJ5AcHAsbNRRBeCu4AEnS
         mWqrxTdvHjhCg2JtZvvv+GFR4wxnmrnHdTNUYDcywVsOkYUMonVDNJlWNO2gFBhDQnFR
         5NUos6C9yEvhCTO6tu00VxEip5/IctaGTam9655bLoe+PJHcR436cmiamXaLEzCuJtpU
         1K6d0BYPRAG6ttOyVYck6guZJ6/yAw+DEbQf58Hk7V7WgLdd19sd2ZiTfCC+BDgZ1x7m
         nfBlz5vTH/j0rJi6itHIs+e28Vipc30/4bX02+KV4Y1Dcmq8qjdJZXJjcirRt8pkisNW
         rPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=0Yz3aCtfs/NmJpk29XMbsItf5utDQd9JiRR8EbPIQxE=;
        b=WIo/0fYahXkOtp1zzSBS5Qi07P3KDl9dtflWvn2RXybWxTTYaf9kvuDzx0ml8SaCeN
         FPfftdhlnRdU8ndUL/DilPHFH87zE6dMZ/GvOdsMHjGT+5SAtooPuvsFSHtuYPhxcAwm
         d3IL8YL7TPc04FVoHmTRzRu7lN++WsOFHDzkhepEM0ssCQv5AfO28HZ0YtBV5b7O/HO4
         NlQdWZC6ZQ3ObLgPB+qYfo3IOKl96sglComW6tDbXno852iVdruuwSS1Q9V6q2vTCK71
         0S++7DslvAydyXFV+znBeEu1L4YpvCjA2jTbUjEaRk2KKGDMtqMBRTnia+iYqhR8nxJ1
         GbJQ==
X-Gm-Message-State: ANhLgQ342e6E3XIXzRMay6a4XPglL/ogXt4yGq8t+JjwsN/FXwGb8fnj
        AWfTruJrtXQBuQb+j6DpnxKBuFclf0Y=
X-Google-Smtp-Source: ADFU+vtXeKcQWLY+dA2JLgzKrkbYlsnbb6px0eh+Tw2qRtCcEt0hfKTwy0N7ahGHcBPaoBsP8MNyUg==
X-Received: by 2002:a63:1003:: with SMTP id f3mr23221873pgl.450.1584982763979;
        Mon, 23 Mar 2020 09:59:23 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q13sm12570922pgh.30.2020.03.23.09.59.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 09:59:23 -0700 (PDT)
Date:   Mon, 23 Mar 2020 09:59:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 206919] New: Very bad performance of sendto function
Message-ID: <20200323095918.1f6d6400@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There maybe something here but probably not.

Begin forwarded message:

Date: Sun, 22 Mar 2020 11:22:46 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 206919] New: Very bad performance of sendto function


https://bugzilla.kernel.org/show_bug.cgi?id=206919

            Bug ID: 206919
           Summary: Very bad performance of sendto function
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.13
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: bernat.arlandis@gmail.com
        Regression: No

Created attachment 288007
  --> https://bugzilla.kernel.org/attachment.cgi?id=288007&action=edit  
Sysprof capture file

Hi,

I have a case where the sendto function is slowing down the software I'm trying
to use. Sysprof capture file attached.

It's probably being called at a high frequency and the __netlink_dump_start
function spends a lot of time in the mutex lock, then also in the netlink_dump
call.

This is causing the threads calling the function to stall. At least this is my
interpretation of the profiling session.

I don't have any knowledge about the way networking code works. I'd like to
know if the flaw is in the user-space software or in the kernel. Can I provide
any more info or do some test to help determine what's happening? I'd like to
help fix it.

My NIC: Intel Corporation I211 Gigabit Network Connection (rev 03)

My system: Debian 10 with kernel 5.4.13.

Thanks.

-- 
You are receiving this mail because:
You are the assignee for the bug.
