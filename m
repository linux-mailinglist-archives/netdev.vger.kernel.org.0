Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4F6449F4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfFMRxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:53:17 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:34543 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfFMRxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:53:16 -0400
Received: by mail-qt1-f174.google.com with SMTP id m29so23592765qtu.1
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Uy066ZV7bgAktFEXl4WYIMVfekGzUJn9sDijeqz/6js=;
        b=ppvRcj2fAvxAjLvxfx37Nx8VsHo8Zn84KOQIFwh3nkP68zAI/pJDwz6o+YNhmCDWpC
         laWqQisfVdfx2bN6+IhaVNLtv8THGpCBPvW+VImBxk0zY+NeB+TlvnaXYp6DhIpFoBPN
         IkFrKZ80Tns1S8o/GZbrf65MFIq96UYTVnMUn1FaaHizgbOVBQaQZye0boOknbXmnV6M
         rKvLk9s4eqUb3iVqdbNIwm66vxO1yDPZEdoq2VbCNlg+HlmFXN944pX1IJGXvEC7qY4L
         wqI+ptqVTFF3HIUDO/xsLq1v8WBE/f7srOOfnwPoachOPpzn2nYvPkLJZWggfYaa9qoD
         uayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Uy066ZV7bgAktFEXl4WYIMVfekGzUJn9sDijeqz/6js=;
        b=mhOydPEg2Mz3OmKNrLtxNcZk97gmG4NPPAFjjrte2TlWea0rOyDbzyNQwDo6lCWaPp
         9Soo4YBwWicSWrM07idbcIoydKnJ1GHq90+3Zfsh8r//CGLCFKkupsZtFBAks0AR8TtO
         tg1Ds1A8T6t4Ue7sMLVOb+nXsp6CUAEy0Ph9MPKn2VFR1jHUhwozlOpgyC3cbeX+8AcN
         MgxB5q1ZK78wWAUeyYJr/LBSMQJaufVWBsxjeu1wOa2VN9+4wUmVAb/c7CsdbmhSnfq8
         XlQV8MGanaThu8ox2LztBpnybHRSoh+Sz0Jn1HH73XDZP2XpS1o/Z1BNtSc9qOzF9bwB
         ygOQ==
X-Gm-Message-State: APjAAAX4X2tWUDutMzion7aSqWxvqpHlkbdhaJe9eWoPSCtoJ6uh0YrD
        97GB3S2U7jpoK2sNnjyHOaCahx/389nMlzIToQLJRG7i1T7Y3w==
X-Google-Smtp-Source: APXvYqzkT447i3R9IhbIClKX63YPdh9gzEn8y6slBvWgGiQka3EvlzqGEoCmY/PUe8lHb4NKJjMoQgPBaSXMEsnpq/w=
X-Received: by 2002:a0c:8a23:: with SMTP id 32mr4732749qvt.231.1560448395630;
 Thu, 13 Jun 2019 10:53:15 -0700 (PDT)
MIME-Version: 1.0
From:   Nathan Huckleberry <nhuck@google.com>
Date:   Thu, 13 Jun 2019 10:53:05 -0700
Message-ID: <CAJkfWY5ZuDsmV6u1p=DPZF84ijYS3Mu2NeySGgfCXgLGnruu_A@mail.gmail.com>
Subject: Cleanup of -Wunused-const-variable in drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
To:     maxime.chevallier@bootlin.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,

I'm looking into cleaning up ignored warnings in the kernel so we can
remove compiler flags to ignore warnings.

There's an unused variable 'mvpp2_dbgfs_prs_pmap_fops' in
mvpp2_debugfs.c. It looks like this code is for dumping useful
information into userspace. I'd like to either remove the variable or
dump it to userspace in the same way the other variables are.

Wanted to reach out for opinions on the best course of action before
submitting a patch.

https://github.com/ClangBuiltLinux/linux/issues/529

Thanks,
Nathan Huckleberry
