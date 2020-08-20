Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E703D24C3D6
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHTQ5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbgHTQ5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:57:20 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2132FC061386
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:57:20 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id g11so780644ual.2
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 09:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=QYuR2e8AkRz6vIxG3CqwQqEQ7G/qCpkD6SKe9AUP/Rg=;
        b=E0rxJ6YBO2Ep5q2WB3Hki5mUK6bXNhjLmh23hVYGsYhh2eh8h0SeCbLhpeSf5x0RHY
         wIuMss2ECTZkkbiNAz0YjV+gjbISwMjfFGqj2EHARF0FfujtYjWBmE/0QkNzEPRHzQdx
         poND40MbXd8K2NAHuAG2L6zhdOlsg5EHSXots=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=QYuR2e8AkRz6vIxG3CqwQqEQ7G/qCpkD6SKe9AUP/Rg=;
        b=eSutHk7WPAIO+7aIF+Lee/NTIw04+0laEeZf2uYHwC1QPFT8wGrKMx5237y5NVrwB9
         fOIEdRTk80SE8VeyuEcYIQTlUvM6lS/AIiBZJtI1JiCy/o1HktYl8iNgbNdcN9lHCRmU
         7EvQjonQwep6kDW7UL4BPNHawRbNy3Xk28YpFJDBaYFcgOLr5l9GN50ePMsslA75XnuS
         Qe+kEQ06P01NbHWZAl9EU7TqjlByMyBQfblrrjRolkvxxEK4/VNbY+PKVYXectzajo63
         HQ+rpICS9C8jonp3BxcT06vjaezsU/rn6kpv5lrUfgoZBfl++cI5CgxxM2ZDx7G1HDVx
         Q0mA==
X-Gm-Message-State: AOAM533vN8dNkl2899PFSY8oOsVqov6lwhYmQ5ps24WK4XvST7gA7eYX
        tn5gugYK8hxK97P1SU2Lre83m4q6bOk5YcBK8YuDu2FDMV5FFQ==
X-Google-Smtp-Source: ABdhPJxuiPNsNRab4REiueDhEETHzegNMG3ZBMS8VZdE2G7/syTOMsdkXHxsD8c9BBsm0AK9nSGmqyLkyVnC3fw0VU8=
X-Received: by 2002:ab0:624d:: with SMTP id p13mr2316482uao.136.1597942636770;
 Thu, 20 Aug 2020 09:57:16 -0700 (PDT)
MIME-Version: 1.0
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Thu, 20 Aug 2020 09:57:06 -0700
Message-ID: <CANFp7mV=Uf37Hk0RgNY3dUpr46DZOSTtKzcp7ptWF8YCKEzuCQ@mail.gmail.com>
Subject: Request to queue patch for 5.7 and 5.8 stable
To:     netdev <netdev@vger.kernel.org>
Cc:     aros@gmx.com, Manish Mandlik <mmandlik@google.com>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev@,

Please include upstream commit
6fb00d4e94bc28c39fa077b03e6531956de87802 for release to stable
branches 5.7 and 5.8.

This fixes a suspend/resume issue on Bluetooth controllers and has
been extensively tested on Chromebooks. It's also needed to fix the
bug reported at https://bugzilla.kernel.org/show_bug.cgi?id=207629

I assume this is the right way to request a stable patch following the
faq at https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt.
If this is incorrect, please let me know the correct procedure. I
think this patch was missed in normal stable backporting because it is
missing a Fixes: tag. We will be more vigilant about the inclusion of
this tag during code review going forward.

Thanks
Abhishek
