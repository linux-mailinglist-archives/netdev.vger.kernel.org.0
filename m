Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5DE74C8FF
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 10:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfFTIIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 04:08:06 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:36628 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfFTIIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 04:08:05 -0400
Received: by mail-lf1-f48.google.com with SMTP id q26so1748741lfc.3
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 01:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5nLDF4KvNjOO0UGhzTbw+kgDFdu3GO4N4s2vFIPF9iU=;
        b=OmXGcAXDCg5tpnkC3zM065z42PKi+z/FVjoDHqkRFwQQ351XflSo05WQbSV3o17OA1
         ZCsdnjvvy8dS/tX2Yrk0+vtSVbKzdotrcrp1d3vJpozy0Jdb5LybpVHsiW48i/dDVI4m
         ck78rIIOF3bMUbZaiZAMkWKmJcJn6Z/ZVjyWEsqoSws8e7XxsYNIIMXEHmshvOdBKAcx
         J/hpS3vishBxStBuT5Vd6dFmaBnP06wN4IJ6LTtHWz3vxRs0dzNXAKspTbq1O91EelUW
         7USUCZOQGv2Sw7kPzWpfZs5oEBsiyWFpcnyvM6d2Eb0IbXkpG8FtvbT1xWFcC5FeFvd/
         egbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5nLDF4KvNjOO0UGhzTbw+kgDFdu3GO4N4s2vFIPF9iU=;
        b=ptvURURvVF0PYduJFoc/jaLaPwnArYnbpt/kvwU90VwGBaqoxqZf8aYuxui+DCy6F7
         ivuxw4LiaL8VNb6AXDn5cs2a4RmdCrkNwHNev6Oi3AmbyStIKBz+WBqHgyHsff2PF78e
         Fi7seFP5kdhL19q9P1DVOUAG/Pg0fwtWGEaAn3X+9FAIo08XOuPEQSlPaTMZPXyUONyC
         nxum6YN47yOlYYAKHL/Eg8zm2ytOHwUSruazZgZOT1cZ2jHs0Hu3UY5lxX2tC/waRLdg
         fHYVzeECsbARsEkAnqivw4Q+ZwPuWQ0gfb+tKzudfqXb74hDep0qlJlfIIy9O4B3lDKV
         q3ww==
X-Gm-Message-State: APjAAAV63sWVJm5R7i420dAAvzb7F5zjpJjNYo3ZXeIECQHZ/57U47rX
        qPPjxrKQXdvfgNu8ntkEylvZmGMFKQXKeRUFC3q+OA==
X-Google-Smtp-Source: APXvYqyU7SYZ3r1zFZE21AN1DFeMgGQwh6SguX3BRtEUzUX/aM0TrfFkxtA08Wzok29Qq+v25QAmavsjX/AI8Qz4iuA=
X-Received: by 2002:a19:671c:: with SMTP id b28mr12475324lfc.164.1561018083426;
 Thu, 20 Jun 2019 01:08:03 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Jun 2019 13:37:52 +0530
Message-ID: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
Subject: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, kafai@fb.com,
        Yonghong Song <yhs@fb.com>, john.fastabend@gmail.com,
        hawk@kernel.org, jakub.kicinski@netronome.com,
        Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

selftests: bpf test_libbpf.sh failed running Linux -next kernel
20190618 and 20190619.

Here is the log from x86_64,
# selftests bpf test_libbpf.sh
bpf: test_libbpf.sh_ #
# [0] libbpf BTF is required, but is missing or corrupted.
libbpf: BTF_is #
# test_libbpf failed at file test_l4lb.o
failed: at_file #
# selftests test_libbpf [FAILED]
test_libbpf: [FAILED]_ #
[FAIL] 29 selftests bpf test_libbpf.sh
selftests: bpf_test_libbpf.sh [FAIL]

Full test log,
https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190619/testrun/781777/log

Test results comparison,
https://qa-reports.linaro.org/lkft/linux-next-oe/tests/kselftest/bpf_test_libbpf.sh

Good linux -next tag: next-20190617
Bad linux -next tag: next-20190618
git branch     master
git commit    1c6b40509daf5190b1fd2c758649f7df1da4827b
git repo
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Best regards
Naresh Kamboju
