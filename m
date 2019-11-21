Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7C8105725
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKUQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:36:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38337 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUQgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 11:36:19 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so1962669pfp.5
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 08:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=KAJW0s0QdbX7OOUDsXuAKaGlGhF39TgqfVvzDVSdOg4=;
        b=SVCUGeieLI+P7FI3q6KZppUnhzVI7RUUssrPgs1LDEWA7AdiAapKwqIuZ/eDUDX27Q
         dPNxnCaYL20AkERz+EkNfe4X577+fVokTorYlwqOrq+Gn1QOVPsZwrXNZMWU+C4qs+hV
         jwqxe10FGgTH8GgvJC5uVwEKUxNXLE5U5pGR6ilihsJesnJgKcY2DawWhVMWD0WrbwQP
         0PJTlFKaifkYAGVOEYnlRAZNSIGHCf4wiXyh9lNuPdT3zgOc6PTqwB9fUPbV0h2h8jPG
         jrCh7dpYFsu1ON16UUkzKe3zKqjmxewQ1Jzg/eRf6UVGGiHpvoRTV+kg7G1vIkhzrCRj
         FoxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=KAJW0s0QdbX7OOUDsXuAKaGlGhF39TgqfVvzDVSdOg4=;
        b=lCDUcc6bctiqMNAfJEXwCHZZBbGgTVNlPRJYGTrqwt4FYWSMCwPkuJMjt1E571rp+5
         vjmlIEkORlHJQanfwIeApRLi7t419BjX58ZPpVlEGDrCfyojQyefxdtKMQvCVwu+RzFI
         o9CgoLsPGZ0gdAVCXCx8GitMvLz38WQ+C4kk4L24wR9eTtMoJMk+BiOZ8SidXjIHG6uo
         kNUskljuFVQQeC1EXe2mpoYoBQfc/B/3JOHhQ5ZlEHg5xf5gzvaSXJcZX7VutCd6EkUy
         r+G7QsoSGs3o+wTRIEjBkSLCzxj+QcstKfw5ndb4xsqdBchWR/XDHFM0F9bqZN8tEZrK
         Zfkg==
X-Gm-Message-State: APjAAAWQbh4N1uQr+IrukD2/dOZKN1Y9r4eZLpvPRyi50MxjCq+TAMY3
        eMHkigX10SSKnjwhGL1fI9xz+z5PgqFXnA==
X-Google-Smtp-Source: APXvYqxYJ35f3o5VGyrMxLuPcMKnIlcYmVpgiSPtvU75la/WQFoz2xjtyyWtHn4TadpuRhtQq21mmw==
X-Received: by 2002:a62:384f:: with SMTP id f76mr11886541pfa.155.1574354176461;
        Thu, 21 Nov 2019 08:36:16 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w62sm4315041pfb.15.2019.11.21.08.36.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 08:36:15 -0800 (PST)
Date:   Thu, 21 Nov 2019 08:36:07 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 205621] New: Linux next-20191121 NULL dereference on
 start-up, leading to unusable system
Message-ID: <20191121083607.09dafe7d@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 21 Nov 2019 14:48:31 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205621] New: Linux next-20191121 NULL dereference on start-up, leading to unusable system


https://bugzilla.kernel.org/show_bug.cgi?id=205621

            Bug ID: 205621
           Summary: Linux next-20191121 NULL dereference on start-up,
                    leading to unusable system
           Product: Networking
           Version: 2.5
    Kernel Version: next-20191121
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: nicholas.johnson-opensource@outlook.com.au
        Regression: No

Created attachment 286005
  --> https://bugzilla.kernel.org/attachment.cgi?id=286005&action=edit  
The .config

Linux next-20191121 - .config file attached.

NULL dereference on start-up, leading to unusable system.

Used "git clone --depth=1 --single-branch --branch next-20191115
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"

Where I am, I cannot use serial console to save the stack trace.

I will attach a photo of the screen.

The top few functions are:

kernfs_find_and_get_ns
sysfs_remove_group
netdev_queue_update_kobjects
netdev_unregister_kobject

This leads me to believe that it is part of networking.

I will do a bisect if I have to, but given how time consuming they are on a
quad-core machine, I hope somebody else with a 32-core Threadripper can step up
to the task.

-- 
You are receiving this mail because:
You are the assignee for the bug.
