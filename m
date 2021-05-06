Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672A43755F9
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 16:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbhEFOzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 10:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbhEFOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 10:55:04 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062A6C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:54:05 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id v13so4977344ilj.8
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 07:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=huUXHgZjNKj4ozdUIZOT3gjlkDIS/nxHdiapttMvJR0=;
        b=TRnZOpMxzdOGLu0C2rWhGuX6oAe6r6sH9zZytMv7jQGjrSQDQAJ4GVYp1RPHXqnTFO
         e+Eok8y1qFdtf9w3AM+VrLSeSi5t52qUyKYlXeP6bsc+z8PrKN7lFAELJ0TaC1fnE4c+
         s3e7+Lk2neu5hLy50ZhAxabvTTpoEZmnOqYnPApe8X2KiCLU5vYo8jtP4rwZQSkfTjJ1
         EOKeK/0elhhhLdvy1Syt1mfCWz8LYX0n80AWUlYUl5llvBSEoKS34E8GbqE8M7UVvAe+
         ASQ9ji0Y0JQlP+ZlmIlJlbOk9gLoXoTZ3Qk3PGzJX8t7m7pn8s0TVZvorqFouu5D8I7b
         soXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=huUXHgZjNKj4ozdUIZOT3gjlkDIS/nxHdiapttMvJR0=;
        b=ZpNSpT6k67618Mn5DnHcrgrUOgNYbCKBdjrR4ukPs6OpBV4g8v+3F2own7VKJIcbJV
         JAz8TQaslhxY6ASTv8B6gpYYYFLKVFGzTHMEmVkEr7OmS1pHf+3UVomPEoH7P0QKr7B7
         eaMY6jHQTNgjLu+i5d6eDJmZz/2WqOli9u8acichiPcWsVLvFEJZSBsNfmsQ1D50yeOA
         ecdFPpoP0mDKM498IkiTnc7LYrERZ7Q5GyJtvla0S8sDnGIrVf1GzLDdQ9qNTqVQ/+Jw
         c+G37v6qQZXANg4USVMqYhHS/kctbnmriYFwpuDJD/M1HDLKZAx4YT6ZUkRLDUQ6Z38m
         eBog==
X-Gm-Message-State: AOAM530aLfiAit/NY9Q/XLThYUEiYBE5Za4TuEonwJ2Ub85O6ktmXcZY
        IDLErCSdYuTiC6F9cCqvLgy1NFgFTjkuyKhWGCMWR+dXe/k=
X-Google-Smtp-Source: ABdhPJy7mZA5zjdjgw2xdwF76Aa/SliHmaRnrlROZreO0xphMT5bnzv8WTdXsFEQ7GhtEfLmVr2TxTHZMPXyL9TXecQ=
X-Received: by 2002:a92:c78b:: with SMTP id c11mr4657617ilk.249.1620312844498;
 Thu, 06 May 2021 07:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
In-Reply-To: <421cc86c-b66f-b372-32f7-21e59f9a98bc@kontron.de>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 6 May 2021 07:53:51 -0700
Message-ID: <CAA93jw6bWOU3wX5tubkTzOFxDMWXdgmBqnGPAnzZKVVFQTEUDQ@mail.gmail.com>
Subject: Re: i.MX8MM Ethernet TX Bandwidth Fluctuations
To:     Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am a big fan of bql - is that implemented on this driver?

cd /sys/class/net/your_device_name/queues/tx-0/byte_queue_limits/
cat limit

see also bqlmon from github

is fq_codel running on the ethernet interface? the iperf bidir test
does much better with that in place rather than a fifo. tc -s qdisc
show dev your_device

Also I tend to run tests using the flent tool, which will yield more
data. Install netperf and irtt on the target, flent, netperf, irtt on
the test driver box...

flent -H the-target-ip -x --socket-stats -t whateveryouaretesting rrul
# the meanest bidir test there

flent-gui *.gz

On Thu, May 6, 2021 at 7:47 AM Frieder Schrempf
<frieder.schrempf@kontron.de> wrote:
>
> Hi,
>
> we observed some weird phenomenon with the Ethernet on our i.MX8M-Mini bo=
ards. It happens quite often that the measured bandwidth in TX direction dr=
ops from its expected/nominal value to something like 50% (for 100M) or ~67=
% (for 1G) connections.
>
> So far we reproduced this with two different hardware designs using two d=
ifferent PHYs (RGMII VSC8531 and RMII KSZ8081), two different kernel versio=
ns (v5.4 and v5.10) and link speeds of 100M and 1G.
>
> To measure the throughput we simply run iperf3 on the target (with a shor=
t p2p connection to the host PC) like this:
>
>         iperf3 -c 192.168.1.10 --bidir
>
> But even something more simple like this can be used to get the info (wit=
h 'nc -l -p 1122 > /dev/null' running on the host):
>
>         dd if=3D/dev/zero bs=3D10M count=3D1 | nc 192.168.1.10 1122
>
> The results fluctuate between each test run and are sometimes 'good' (e.g=
. ~90 MBit/s for 100M link) and sometimes 'bad' (e.g. ~45 MBit/s for 100M l=
ink).
> There is nothing else running on the system in parallel. Some more info i=
s also available in this post: [1].
>
> If there's anyone around who has an idea on what might be the reason for =
this, please let me know!
> Or maybe someone would be willing to do a quick test on his own hardware.=
 That would also be highly appreciated!
>
> Thanks and best regards
> Frieder
>
> [1]: https://community.nxp.com/t5/i-MX-Processors/i-MX8MM-Ethernet-TX-Ban=
dwidth-Fluctuations/m-p/1242467#M170563



--=20
Latest Podcast:
https://www.linkedin.com/feed/update/urn:li:activity:6791014284936785920/

Dave T=C3=A4ht CTO, TekLibre, LLC
