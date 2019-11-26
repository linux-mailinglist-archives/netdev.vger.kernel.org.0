Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9410982A
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 04:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKZDzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 22:55:15 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36303 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbfKZDzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 22:55:15 -0500
Received: by mail-lj1-f194.google.com with SMTP id k15so18469865lja.3
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 19:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jpmKSRiJVeUJXgN2GyGxen55p/yccWN0FKHO19CAFVE=;
        b=JwQ9vdguWg5+4q7zWM3b3iwlCGcQyETozpN0qTWBy1n+SIvu6IuTh4PzsmCTjlJ+0/
         vgvWl87TrHHTQa6vC8mNoRlpPChfMs+6p22CdKCnzJhz7OXNvyk06CUt+sgaa5wmwDN/
         HZAeuxcl4TDfonIGK2AbNGOcy8LhR7W+rHHO+yejgVi4Ae9TREnR4RefDWdX5+Fit38e
         7pd1Ncqyf7+PeHOCsNufeDQ97KClKn7IbYIhGAEPmf044FcyAPBHip0l7jo3ntZYbHFg
         QEq+JvMRubVcAPsrcd/C18LevU4Vc/HV5jciRxtzQLleSIWwM2cxRR4PnkIt6z7YJQiG
         dHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jpmKSRiJVeUJXgN2GyGxen55p/yccWN0FKHO19CAFVE=;
        b=fwK1iDBpV6Lxk11XL/KB8od3EQEAgbtTV8y/YD1eYtG2VGG/eHQHpTtPI9rY/Lv+tE
         gELiS9NXZyPGM1BiZ7m/FOEQYQm67UoYbSWpMHordKScKWsOaklTpSm8hqgauvF32+Ab
         f43jSIWA9kCcWeF84f0J45MMZsUawpKkyC9NHronkJvs0O3me7JaCr5aM5gBzZTg7P2j
         ogl0JykJWWTjk/yX6cdE/lZOZq0zCHSD9G+uZyraOIKnoRkyUJGBgm7I/czPQ+XPh76j
         EvJWFFKjSJXmFwoxwIMcBM2SpyzzKS0wx5dI7xx2UPZb5ty+OS7Uad4VNlh4rRxcLsk6
         NefA==
X-Gm-Message-State: APjAAAU3FD3odAZI2f8eOQSJtHqjYEScJ03z+q6AzZj7c+/au4jMCGZk
        e4U+5gQOINwmf8qPwcmC5namHB3zaXF28UE63ViRgMgp0d4=
X-Google-Smtp-Source: APXvYqwih9V2svwM3xs4eurIBFbf6d9bvsSgmgrySI1N9FoXlgeJnNmdzyuRtdiRGPGmNmD52iZje5jLyLG8MxDGmO8=
X-Received: by 2002:a2e:a410:: with SMTP id p16mr24801147ljn.46.1574740511113;
 Mon, 25 Nov 2019 19:55:11 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 26 Nov 2019 09:25:00 +0530
Message-ID: <CA+G9fYtgEfa=bq5C8yZeF6P563Gw3Fbs+-h_oy1e4G_1G0jrgw@mail.gmail.com>
Subject: selftests:netfilter: nft_nat.sh: internal00-0 Error Could not open
 file \"-\" No such file or directory
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, pablo@netfilter.org, fw@strlen.de,
        jeffrin@rajagiritech.edu.in, horms@verge.net.au,
        yanhaishuang@cmss.chinamobile.com, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do you see the following error while running selftests netfilter
nft_nat.sh test ?
Are we missing any kernel config fragments ? We are merging configs
from the directory.

# selftests netfilter nft_nat.sh
netfilter: nft_nat.sh_ #
# Cannot create namespace file \"/var/run/netns/ns1\" File exists
create: namespace_file #
# internal00-0 Error Could not open file \"-\" No such file or directory
Error: Could_not #
#
: _ #
#
: _ #
# internal00-0 Error Could not open file \"-\" No such file or directory
Error: Could_not #
#
: _ #
#
: _ #
# internal00-0 Error Could not open file \"-\" No such file or directory
Error: Could_not #
#
: _ #
#
: _ #
# <cmdline>16-12 Error syntax error, unexpected counter
Error: syntax_error, #
# list counter inet filter ns0in
counter: inet_filter #
#      ^^^^^^^
: _ #
# ERROR ns0in counter in ns1 has unexpected value (expected packets 1 bytes 84)
ns0in: counter_in #
# <cmdline>16-12 Error syntax error, unexpected counter
Error: syntax_error, #
# list counter inet filter ns0in
counter: inet_filter #
#      ^^^^^^^
: _ #
# <cmdline>16-12 Error syntax error, unexpected counter


Full test log:
https://lkft.validation.linaro.org/scheduler/job/1021542#L14602
https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20191125/testrun/1021542/log

Dashboard link,
https://qa-reports.linaro.org/lkft/linux-mainline-oe/tests/kselftest/netfilter_nft_nat.sh
https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/netfilter_nft_nat.sh

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: c165016bac2719e05794c216f9b6da730d68d1e3
  git describe: next-20191125
  make_kernelversion: 5.4.0-rc8
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-next/653/config
  build-location:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/hikey/lkft/linux-next/653

Best regards
Naresh Kamboju
