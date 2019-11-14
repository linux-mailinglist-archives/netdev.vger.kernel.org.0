Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3996FC1D0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 09:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfKNIrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 03:47:49 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46384 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfKNIrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 03:47:49 -0500
Received: by mail-lf1-f68.google.com with SMTP id o65so4328152lff.13
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 00:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Fm4cgskO7xAtTVrqH1BFUqnNfZpTIAGunhMGmIZW7/s=;
        b=TN39mF4nR35JtFm0whkw7+oks46zhE32UjqNJZVgFIfm2CioG3rpFIY6VVS/OR4ZPe
         Bh/gA9bYQuszxouKL+WS8I4ThJTK2QKxocEeH4fwYO3Qhp/0aihBhaQRLmM7Cmpm5jj+
         ycXaxAwhmwhRPETdzSW66meln/xbxNddYo7M2Y+q1SbUagFN9GbY76bcd/tmPRuv84rs
         EC/zZ9Xkhk5+tS1W5zlCCoj2NLl7wM8M8TAlf71m9yvxKZTPTnJZ4ayHj53QHfKkg2VP
         BRlWbD2KlObIijeowoQArlnnZwSujiBfP/o0/VnhnLfeSmaJTf3oAid6uy6lsCfeIu7y
         eCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Fm4cgskO7xAtTVrqH1BFUqnNfZpTIAGunhMGmIZW7/s=;
        b=W/uK1IwkoDN8Sd+VIoWV8NslCyalZ3BWoceTUYU7+tN10LljIv4we5B5mcGpL+E0fg
         6QQADR0iymv8ICmBqw24gCCK/Js4c//LNuMYiocwkGZsQGX37suMkSiXiBP4s7ImcHTn
         45r630dJogmV+7mSqdgDaXwFZXzH45RBWZkyzlbmTXkPW4TA9FnWjYKRhjhnOt+B3Jbg
         hIMMDhvFeWcQQaMAWOSZ5AwyOlOqjf5aOmtI6L0AJf2t5YqSSPm0LKGFFSoYUpn75Xs/
         LTx4PoCCOR2g3HkvfgSTdhSdLUgkQ0bwF0khF4tCzXCn+392zyEuJp1V4/1kn+Ku1hA3
         lgHw==
X-Gm-Message-State: APjAAAXJbL5U3BqGWmlo4OT29+TbkC2EXf/dIJs0UwBYCRDRWKTRZO85
        GOYxU94VTJWRS7ZtnBs+O8Abad0eECxvVfIEKobZKw==
X-Google-Smtp-Source: APXvYqys1Y1h3MHYkjo5uaPKewSsiFyuAjEYY3aphEjNA66bzAHnvvFundH0r15k5BA4/6LwCmcvfSjRt9YoOaPqnhQ=
X-Received: by 2002:a19:e018:: with SMTP id x24mr5785690lfg.191.1573721266204;
 Thu, 14 Nov 2019 00:47:46 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 14 Nov 2019 14:17:34 +0530
Message-ID: <CA+G9fYsmZOf9zgo5dy2_HfPPK-0tBYfCXpZy2DneFOeiJfN=_g@mail.gmail.com>
Subject: selftest/net: so_txtime.sh fails intermittently - read Resource
 temporarily unavailable
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        lkft-triage@lists.linaro.org,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

selftests net so_txtime.sh fails intermittently on multiple boards and
linux next and mainline.


# selftests net so_txtime.sh
net: so_txtime.sh_ #
#
: _ #
# SO_TXTIME ipv6 clock monotonic
ipv6: clock_monotonic #
# payloada delay452 expected0 (us)
delay452: expected0_(us) #
#
: _ #
# SO_TXTIME ipv4 clock monotonic
ipv4: clock_monotonic #
# payloada delay97 expected0 (us)
delay97: expected0_(us) #
#
: _ #
# SO_TXTIME ipv6 clock monotonic
ipv6: clock_monotonic #
# payloada delay168 expected0 (us)
delay168: expected0_(us) #
#
: _ #
# SO_TXTIME ipv4 clock monotonic
ipv4: clock_monotonic #
# payloada delay90 expected0 (us)
delay90: expected0_(us) #
#
: _ #
# SO_TXTIME ipv6 clock monotonic
ipv6: clock_monotonic #
# payloada delay10146 expected10000 (us)
delay10146: expected10000_(us) #
#
: _ #
# SO_TXTIME ipv4 clock monotonic
ipv4: clock_monotonic #
# payloada delay10146 expected10000 (us)
delay10146: expected10000_(us) #
#
: _ #
# SO_TXTIME ipv6 clock monotonic
ipv6: clock_monotonic #
# payloada delay10261 expected10000 (us)
delay10261: expected10000_(us) #
# payloadb delay20211 expected20000 (us)
delay20211: expected20000_(us) #
#
: _ #
# SO_TXTIME ipv4 clock monotonic
ipv4: clock_monotonic #
# payloada delay10186 expected10000 (us)
delay10186: expected10000_(us) #
# payloadb delay20387 expected20000 (us)
delay20387: expected20000_(us) #
#
: _ #
# SO_TXTIME ipv6 clock monotonic
ipv6: clock_monotonic #
# payloadb delay20238 expected20000 (us)
delay20238: expected20000_(us) #
# payloada delay20294 expected20000 (us)
delay20294: expected20000_(us) #
#
: _ #
# SO_TXTIME ipv4 clock monotonic
ipv4: clock_monotonic #
# payloadb delay20258 expected20000 (us)
delay20258: expected20000_(us) #
# payloada delay20313 expected20000 (us)
delay20313: expected20000_(us) #
#
: _ #
# SO_TXTIME ipv6 clock tai
ipv6: clock_tai #
# ./so_txtime read Resource temporarily unavailable
read: Resource_temporarily #
#
: _ #
# SO_TXTIME ipv6 clock tai
ipv6: clock_tai #
# ./so_txtime read Resource temporarily unavailable
read: Resource_temporarily #
#
: _ #
# SO_TXTIME ipv6 clock tai
ipv6: clock_tai #
# payloada delay10097 expected10000 (us)
delay10097: expected10000_(us) #
#
: _ #
# SO_TXTIME ipv4 clock tai
ipv4: clock_tai #
# payloada delay9957 expected10000 (us)
delay9957: expected10000_(us) #
#
: _ #
# SO_TXTIME ipv6 clock tai
ipv6: clock_tai #
# payloada delay10382 expected10000 (us)
delay10382: expected10000_(us) #
# ./so_txtime read Resource temporarily unavailable
read: Resource_temporarily #
[FAIL] 24 selftests net so_txtime.sh # exit=1
selftests: net_so_txtime.sh [FAIL]

Test run full log,
https://lkft.validation.linaro.org/scheduler/job/1010545#L1234

Test results comparison link,
https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/net_so_txtime.sh
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/net_so_txtime.sh

Best regards
Naresh Kamboju
