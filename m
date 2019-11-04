Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A25EE0D0
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 14:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfKDNOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 08:14:55 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:44064 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbfKDNOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 08:14:54 -0500
Received: by mail-lf1-f50.google.com with SMTP id v4so12203605lfd.11
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 05:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WMEf75w9oTagZRQTZzN7l66ng3i5+ieYjRbW8mGQvLE=;
        b=lagxcqO9BFG+5tBBWGjO/MIu8tH/fFE9Gxtrjq2WCr7OSpNkq9wThHjLZtIaP/Z3/d
         llCbpUKdJhZWEogUhme8/naioG5rI2AAMpsqphTfKmtvPvLF71r5wTq53R8Jm6SJagjn
         ZV3+KfhiQOeWSz5zXnjT1qzsUg8Y+bcyc6BiMXJrdaa+i0Ws2VtGKLUu3u4y9Ldgf4mR
         rPgBcWVJ2SszHsiFx26VFlwiecPFrb8b5yn3G8FPMl+PMrgHu2WIL9slyliZGjMnxeSX
         TRGmRmfPZTIvNLyLOIb0N/2PIZLCBYpo2WHhrXi3hqrwBXKYvspCj/n0pKn844SCh3Be
         NBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WMEf75w9oTagZRQTZzN7l66ng3i5+ieYjRbW8mGQvLE=;
        b=kB7w2hjlK9J3ldPy7bDSFsLQslUiKLgTZaFKsV5ypCTTou/CxqnTFqwHKXckRCZTea
         ic6gfrAWHik1Gk84+G0SbsSMxo2wsueiwn5v1/FjxawDYs9eynBBk8o5BeXpBIIw+CXl
         ZSDPnmhHcJtAX68uyZDHDc/wKHcawzgmv8gUjdUOS6UjksRWwe47KBSfixNyATzGysLn
         DNXCH5pg8uwny6vR3iaSbP4HRe12AFltOi0qdZZP3pwyvouzMPtjZyPcPgnqGjgYMBJ4
         0SipqtAExcd5TtHxtrQwe5PidF7D+Q+q6To7XLTe0JuGsIhja3MCDo7+qj2Ey9jMaZsI
         zr0A==
X-Gm-Message-State: APjAAAXHVUFAX5Ep7ffZU8zTPF0jjekHufIhhkuEhilcg7CMkdbwc+D/
        Re8spwmL00wffWImykr1KI37NcMRSh375ZGE/nrk3Q==
X-Google-Smtp-Source: APXvYqyXlHJrIntltQv8i8RV7fF+BbSZCuGIhS2LO0/Un8NILT1G3+ClWfvxx+fQbF2wluVplwQyGzi4uJCkpuEw9Jw=
X-Received: by 2002:a19:f811:: with SMTP id a17mr16390181lff.132.1572873290596;
 Mon, 04 Nov 2019 05:14:50 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 4 Nov 2019 18:44:39 +0530
Message-ID: <CA+G9fYsnRVisD=ZvuoM2FViRkXDcm_n0hZ1cceUSM=XtqJRHgQ@mail.gmail.com>
Subject: stable-rc 4.14 : net/ipv6/addrconf.c:6593:22: error:
 'blackhole_netdev' undeclared
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stable-rc 4.14 for architectures arm64, arm, x86_64 and i386 builds
failed due to below error,

net/ipv6/addrconf.c: In function 'addrconf_init':
net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared
(first use in this function); did you mean 'alloc_netdev'?
  bdev = ipv6_add_dev(blackhole_netdev);
                      ^~~~~~~~~~~~~~~~
                      alloc_netdev
net/ipv6/addrconf.c:6593:22: note: each undeclared identifier is
reported only once for each function it appears in
net/ipv6/addrconf.c: In function 'addrconf_cleanup':
net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared
(first use in this function); did you mean 'alloc_netdev'?
  addrconf_ifdown(blackhole_netdev, 2);
                  ^~~~~~~~~~~~~~~~
                  alloc_netdev

Build link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.14/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/632/consoleText

- Naresh
