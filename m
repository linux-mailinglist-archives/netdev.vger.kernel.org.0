Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842623D2FA4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhGVVfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbhGVVfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:35:36 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3652C061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:16:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so1312909pjd.0
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=qlDIb/U95h4PDjbbvFS2gpU1qWZdbi8kSumvPaXhfP8=;
        b=KpMuHkN7WicFKlh7lbq4Jg1Hw2wpPSoSJ/RzWiU6AGrBiKV8gp/k05DTbJCJ0lGi7A
         OV+28rCQsNVoKwJV70lAvz8aK7UJP2HViHfVwh8qjWchahfQ9yfyAklhE5B+9fY1kytE
         LkjddP+MY8Jr4sYPt6whSYyN8qDMhe1AEZOZRt8nJE9ph9JnG5lN+Rdqz/cGUYYcmaj9
         MsDO4SXBIsPp/Mknj5ssSlTwTb8o/FSzarVaL9Zg7IwRkarcJuk5v/mEMyPxs9ZGu+2f
         8NI/UQ7/VAsszylyZS0TnOYtWwmq65T/PbJFqOnO5NTqMxXNT64VcYa1gzvq0mMMo28x
         6mLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=qlDIb/U95h4PDjbbvFS2gpU1qWZdbi8kSumvPaXhfP8=;
        b=t0lBk/3lgcewK54CYotaQKrUdrRxlU0DwA6hHRfVJaUM4vChigPYqAnTC3m4rU6g4m
         hcr+B7G+5AbPxum8yw1d+DSVP2DDbUO7xQZTk911D9pSlamIS3F08Ufsv77pgYPkVZP5
         0FDNHOiWd2yJZBebz/Fn+QocnyQiaKft7lWd1cTLnJAApGFU0x4p+ALqjoJtMiE+N1AT
         +PtHy45INIW+BatGRrboOppRjZTXlosDUi3TfoZvzUITtku1rHwwcMDneXgWWccb4j3z
         hvUr2K0COHObmPXdw2gS+OFaYFKJZplQ58O3eiSq1wi15262btbkmRBz9pqcQnkAlYl7
         JHNA==
X-Gm-Message-State: AOAM531GapgBlDodvsfKPgucaZDtlRkRjACPUHcqQRtUR0NtMvrmc8E/
        VU5DKUr0HHYnTBO5S9Nn6p3iWGWswKyviQ==
X-Google-Smtp-Source: ABdhPJwz0ajWehklmRYEyOIWRpJBMFwP7dJork31RpZVjjpNhLYL5EI8c9jXTOMlGWcVlpQrcW9VQA==
X-Received: by 2002:a05:6a00:a8a:b029:356:be61:7f18 with SMTP id b10-20020a056a000a8ab0290356be617f18mr1778052pfl.29.1626992169892;
        Thu, 22 Jul 2021 15:16:09 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id j21sm26306711pjz.26.2021.07.22.15.16.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:16:09 -0700 (PDT)
Date:   Thu, 22 Jul 2021 15:16:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 213827] New: Stall In TCP/IP
Message-ID: <20210722151606.4dd189da@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 22 Jul 2021 22:03:50 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 213827] New: Stall In TCP/IP


https://bugzilla.kernel.org/show_bug.cgi?id=213827

            Bug ID: 213827
           Summary: Stall In TCP/IP
           Product: Networking
           Version: 2.5
    Kernel Version: Observed 5.9.2. Confirmed on 5.12 and 5.13
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: martenst@crankuptheamps.com
        Regression: No

Created attachment 298007
  --> https://bugzilla.kernel.org/attachment.cgi?id=298007&action=edit  
A basic repro of the observed issue.

We see an unexpected pause of 3-60 seconds where the test no longer receives
data, recv() is blocking, netstat shows data is sitting in the 7777 server's
send queue and 0 bytes are in the test's receive queue.

Setting net.core.rmem_max seems to be a key factor. For our testing we used
net.core.rmem_max=16777216

See attached README and repro.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
