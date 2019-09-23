Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06447BACF3
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 05:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406371AbfIWD4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 23:56:25 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:40985 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404038AbfIWD4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 23:56:24 -0400
Received: by mail-ot1-f50.google.com with SMTP id g13so10881421otp.8
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 20:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=iqaADYeITMA2UiqpA3+GaEcUYDaEfLYZRgRE5A4vCaM=;
        b=gzAcfPWIEHjrFHzWy99DLl/OZ99KpYAePmEig/7i7+e1KD+w1pSXh1gYJukRFaVF/7
         owoNCCF+cvyxgyRSlU/bQDvkws9lat9xr6j1E3Md8BsJFKD9TU0jmmrss6AgGCsEa6+x
         J7aug33CGP+T9MWMuTvIC5unrWC1mAPdDvdM306sSjiiFOT+Ch/uwoNxyUb1o6XPlR2g
         0LxAodlHCcxMwk0cpIPpidGWBMfaJk682wmt2Hgh/DWZ2KEUAvoBp+ECDf9n3pldK5Pq
         HOvBOJzAD7sPf7yJt17kNIk5dvyK7gYkUexyLw9Ot3rGEtbHIXfPhpTJe3LXqDpOEA5k
         hIKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=iqaADYeITMA2UiqpA3+GaEcUYDaEfLYZRgRE5A4vCaM=;
        b=nfwtur1vZZnMKCve/3oVtCUTbLv7p4qxhPZlqGsJof0wm0O+xv7gEevPVJXIcJPZ4w
         uBgcYbwpt/+sjJDi3AMJKD0GOaXvYv4foyvUy+dkQg40tZ6GqKTZBWGvazQzhVQO42bu
         nEbqro4xl6TqY716C0Hiq/Eb2HLzQYWFP6YODl/ywBYXbi6o8BQvi2LKZv15Xrm1m1dG
         GV+vfsX0iCmJ0Y2hM4tqnnu6+fVFoVHL1dst/hJM3Kth15hPBNUFkQOD8RZhS9ZT6Vmp
         vlUi26jEmxcMmkJ67l/83i7YcNA6KSDbR72B7iNU9NlGOm0R76T+87bCAnpEBj1cqY8/
         pwjQ==
X-Gm-Message-State: APjAAAVSxUaK/uJYijV4q0iiX8yT0MrP2G6XN4pSem+6L1mSlA33STs7
        mw/yjqYHUjsX6q3MWKVoPlhV8xTOwQ8aMm5PVbVHoWgwmUc=
X-Google-Smtp-Source: APXvYqz4QVfwSXYpT5ArXEo8F+ED3kDtGGiUx6qdA2RG3pSYx+hH3bN4+k3PAbRQVQhwMCLvE+V/TeY+AdWJIVvaCdA=
X-Received: by 2002:a9d:200c:: with SMTP id n12mr21173489ota.334.1569210983955;
 Sun, 22 Sep 2019 20:56:23 -0700 (PDT)
MIME-Version: 1.0
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 23 Sep 2019 11:55:48 +0800
Message-ID: <CAMDZJNWSBGzwR8-xuUy5B8g0uHXi6gpZP6gn6bkTLDpzcsutrw@mail.gmail.com>
Subject: one question about openvswitch flow_hash
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs-discuss@openvswitch.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin
one question about openvswitch, why we add BUILD_BUG_ON in flow_hash?
It is never be true, right ?

flow_hash
...

        /* Make sure number of hash bytes are multiple of u32. */
        BUILD_BUG_ON(sizeof(long) % sizeof(u32));

 ...
