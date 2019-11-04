Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8799CEE091
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 14:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfKDNE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 08:04:27 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39770 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbfKDNE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 08:04:27 -0500
Received: by mail-lj1-f195.google.com with SMTP id y3so17513786ljj.6
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 05:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JhQ7HFlU2UjuPowmnwPGHmD+EdJPReNvJPv4o/73DLw=;
        b=B5FY1/XbL+HcLM8uSIu6+xWTIFQMhgGR0ZPc+1TqFaYNb1YQ36cPU6LCYvBlUYusqP
         avFe3K1dEA5OAwuz0iPyfvQUmKLIDhsKl0k4ZLnULf/uordbSoPvhYCHckvMW/hTlUSS
         yZI/RBp4yvR1rCdMD7t5ddJBuTgMn8WFIijWmaY8qSTlDu2WR+Sd8gkxHDkISxD5UEhj
         QJl9FclTkuIOpCIAag+MkYWG97kQcyZiHNoweOVHDhYSTSf7PnynXwYEDbUTTXGLXiGN
         qtP4vYFmNw0OHaTrGlgmMTjFc5DC8u70AsjW1rVABrOR9EUNFL8XRPd7z1Ch00QT6eo9
         EAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JhQ7HFlU2UjuPowmnwPGHmD+EdJPReNvJPv4o/73DLw=;
        b=iU3gUlCUUIB0MuAMiSv4wZvHm/oZCzZxyEiiZSC8cZaPZkkfPc3rUWXwAyTvbWBxQz
         WDVDsBwI/GNbwnwbECbjCHbiFBdwdd8aVoFylZxxiuvVNw1KfmVXPgrZIXOVoi0k/edL
         uf4M+bilxVxw8z6Id1aDQns+v5NCDI0uhe+TBCe9mV/B7aKmHUajirvI8iWkqZ3XrU0n
         APDdFYUGkwDCC3oncME5VDzS5PfnIEopwac8NJfYr6f5Gcn79dHEMp5xXgjcsDbhrC6Z
         GWJUsIPXtjrspeDrZDe2SKqqKSrgGNbAJL+6SBIQ7+MNu0+3hHWh/hMYJwBQAEf/7f15
         XUdg==
X-Gm-Message-State: APjAAAUkDBT+4bH1rLMh+i3LJT8YeZCJ9KUyWMzncAfyk+FaMXGasqu+
        Ysd/2IJuLjjGKU0M2+5+GJ7IscdwNcWY5gYUOoyEFg==
X-Google-Smtp-Source: APXvYqz5yHtYXhLt1jqsbom3DmiNCD/Pl9JJmdKaVL59tf08VLPMTBtZfDVWp2YoogUmAUPkOXxwQTAYiXXb4t82d+U=
X-Received: by 2002:a2e:9a5a:: with SMTP id k26mr8959112ljj.46.1572872665261;
 Mon, 04 Nov 2019 05:04:25 -0800 (PST)
MIME-Version: 1.0
References: <0100016e3654527a-82a12a13-1ed1-448a-8c6d-58f7e85bc85c-000000@email.amazonses.com>
 <20191104122138.GA2127297@kroah.com>
In-Reply-To: <20191104122138.GA2127297@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Nov 2019 18:34:14 +0530
Message-ID: <CA+G9fYshX87tu3FWjVH3-hga4SdwbwcXeBFTgmBbH_6tHDdpXQ@mail.gmail.com>
Subject: stable-rc 4.19: net/ipv6/addrconf.c:6747:22: error:
 'blackhole_netdev' undeclared
To:     Greg KH <gregkh@linuxfoundation.org>,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        "Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two reasons for build failure on arm64, arm, x86_64 and i386.

For arm64 we have identified missing patch,
Patch "efd00c7 arm64: Add MIDR encoding for HiSilicon Taishan CPUs" needs to
be bacported as well,

for arm, x86_64 and i386 build error log,
------------------------------------

net/ipv6/addrconf.c: In function 'addrconf_init':
net/ipv6/addrconf.c:6747:22: error: 'blackhole_netdev' undeclared
(first use in this function); did you mean 'alloc_netdev'?
  bdev = ipv6_add_dev(blackhole_netdev);
                      ^~~~~~~~~~~~~~~~
                      alloc_netdev
net/ipv6/addrconf.c:6747:22: note: each undeclared identifier is
reported only once for each function it appears in
net/ipv6/addrconf.c: In function 'addrconf_cleanup':
net/ipv6/addrconf.c:6839:18: error: 'blackhole_netdev' undeclared
(first use in this function); did you mean 'alloc_netdev'?
  addrconf_ifdown(blackhole_netdev, 2);
                  ^~~~~~~~~~~~~~~~
                  alloc_netdev


For arm64 build error log,
---------------------------------------
arch/arm64/kernel/cpufeature.c: In function 'unmap_kernel_at_el0':
arch/arm64/kernel/cpufeature.c:909:21: error: 'MIDR_HISI_TSV110'
undeclared (first use in this function); did you mean
'GICR_ISACTIVER0'?
   MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
                     ^
arch/arm64/include/asm/cputype.h:141:12: note: in definition of macro
'MIDR_RANGE'
   .model = m,     \
            ^


Meta data:
------------------------------------------------------------------------
kernel: 4.19.82-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-4.19.y
git commit: 7d816e1d91b01911392b7f8f93a4a153b9af60d3
git describe: v4.19.81-145-g7d816e1d91b0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe-sanity/build/v4.19.81-145-g7d816e1d91b0


- Naresh
