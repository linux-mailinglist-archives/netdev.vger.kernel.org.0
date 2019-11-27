Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0549310B69A
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfK0TUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:20:07 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34018 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfK0TUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:20:07 -0500
Received: by mail-lj1-f193.google.com with SMTP id m6so18342202ljc.1
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 11:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SwGlaflyfMYsLmwlIQulRra4gO7xoKJhMixLlAT06bw=;
        b=AZAWZiB8dXMRGg0cFsUASjG5lSbsTKtRIdf/0fMgaVbiCSwgi01PBTF5/E61UOaLVr
         p4rG8lUfsLFtLOHVYLySO8tmt+ljDl0Rg6m+k0YSUtpKAnaJv9/UU/poQEYTM4xYlo1s
         8L2bRuJqICdzJ2QiLVm4ZyQSWhuLkEzvkQdYLfbi1nWh5sCjZxdENgNj1PTwkNFlvopE
         yuBead4CYQ/dvIPXTEQEMP0scdIu76FpDTSIiWkMMKv2tse3pQU5ISoPbM59pOr86BV2
         sJg7OM9Honvjigua3I9HfxAgUsfez4l/z4PNexypZactOD/lZQUfQQZNVgh82yJbtx77
         Gosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SwGlaflyfMYsLmwlIQulRra4gO7xoKJhMixLlAT06bw=;
        b=L+l4IsRkIW6pObA8c5UyA+bnJyG1KiEwQcaevhuKKG3KtFe57D9+69xRXs4wWBBBkl
         7NnXYtG/3ghQ2q+iHnDv+WOA60nvX0yVpx3OIc0pL/G9+RPJlBusa4Iqnr2tfxipcogj
         IiU87VqQB19z76oqWEpuWio/tOarBJWjfyNTXeIJuduGxAB2UE/Q4TW0SHVgz4W3E1wy
         gF2JB+YeujsNtUO1Yd3dgUMtswGYBUwi2qPYL+ncHjdDXzblTFBxdwTLsn8xowZ8HBsi
         D4/1jdr38tN+KvYxRFOMSA5EqsfrDiyCSv9Eg7MWamCMVHoNHxfuyKo7yW3oshcFgR9u
         N5vg==
X-Gm-Message-State: APjAAAVMj0uXUcVpjhk3gPjDO7AKpXDwbkt/m3F7MdIR8b5JHcEJVYd8
        PlWxJ4gEr5q+hjzkCHvRjdwa13DK6tw5Tbyv1QN7VQ==
X-Google-Smtp-Source: APXvYqzUn71qSDD4hCx3MNN0CeiY/vj0Ix0Iqx1K5PoXiCjYfgoV9VPAcd8hv7FDKyXseTPrU25vj01s2BdnCORJQYI=
X-Received: by 2002:a05:651c:299:: with SMTP id b25mr32191751ljo.195.1574882405011;
 Wed, 27 Nov 2019 11:20:05 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYtgEfa=bq5C8yZeF6P563Gw3Fbs+-h_oy1e4G_1G0jrgw@mail.gmail.com>
 <20191126155632.GF795@breakpoint.cc>
In-Reply-To: <20191126155632.GF795@breakpoint.cc>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 28 Nov 2019 00:49:54 +0530
Message-ID: <CA+G9fYur6RHnz2nzy9RwZ64yUDv0bRs4eP9odLud0mDP9SAA-w@mail.gmail.com>
Subject: Re: selftests:netfilter: nft_nat.sh: internal00-0 Error Could not
 open file \"-\" No such file or directory
To:     Florian Westphal <fw@strlen.de>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        pablo@netfilter.org, jeffrin@rajagiritech.edu.in,
        horms@verge.net.au, yanhaishuang@cmss.chinamobile.com,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 at 21:26, Florian Westphal <fw@strlen.de> wrote:
>
> Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > Do you see the following error while running selftests netfilter
> > nft_nat.sh test ?
> > Are we missing any kernel config fragments ? We are merging configs
> > from the directory.
> >
> > # selftests netfilter nft_nat.sh
> > netfilter: nft_nat.sh_ #
> > # Cannot create namespace file \"/var/run/netns/ns1\" File exists
>
> 'ns1' is not a good name.
> What is the output of nft --version?

nftables v0.7 (Scrooge McDuck)

>
> Does this patch help?  Even if it doesn't, its probably a good idea
> to add it.

I tested on arm64 Hikey and did not help.
However, I will validate on x86_64 and other devices and let you know.

>
> Subject: [PATCH] selftests: netfilter: use randomized netns names
>
> Using ns0, ns1, etc. isn't a good idea, they might already exist.
> Add a random suffix to avoid interering with other, unrelated net namespaces.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tools/testing/selftests/netfilter/nft_nat.sh | 332 ++++++++++---------
>  1 file changed, 176 insertions(+), 156 deletions(-)

+ ./nft_nat.sh
[   29.100929] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[   29.191505] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
internal:0:0-0: Error: Could not open file \"-\": No such file or directory
internal:0:0-0: Error: Could not open file \"-\": No such file or directory
internal:0:0-0: Error: Could not open file \"-\": No such file or directory
[   29.985551] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
<cmdline>:1:6-12: Error: syntax error, unexpected counter
list counter inet filter ns0in
     ^^^^^^^
ERROR: ns0in counter in ns1-Tj5FGVgK has unexpected value (expected
packets 1 bytes 84) at check_counters 1
<cmdline>:1:6-12: Error: syntax error, unexpected counter
list counter inet filter ns0in
     ^^^^^^^
<cmdline>:1:6-12: Error: syntax error, unexpected counter
list counter inet filter ns0out
     ^^^^^^^

ref:
https://lkft.validation.linaro.org/scheduler/job/1025331#L1508
