Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB309126F24
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfLSUu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:50:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39264 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfLSUu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:50:26 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so3954072pfs.6;
        Thu, 19 Dec 2019 12:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5hHtLxBl/f/KnEapSkPu95KSvj6JTeXO1zosJzNLAX4=;
        b=BGg9GWWFEXfp+7yFaa1ERgtN83b1thcWilPQs4ysQl0wuEEtolZ3kx+a1bO2BXB13f
         92IVsJKDKKL1FZKQ9s6i3+aRM2tc+mX2DGX4bwwmfMLzfIXch3nIoHTOXy9iIV1pkJuo
         estjdOXP0/3myvkLrNXZ6arc+e9T/7nY9TjDku0M1SuXA/rl5jBhgvzDxJOdq6tr1JUb
         JNIvS8UmjHITtk3tItNmh/jjErBJiTRSKJBmygeC2hjBL/aedSQSX1uxb2LgCCYkgcg5
         TmkuoMqZX6RaSKXZlZJSoOPLZGGQho9/gazWoSq5wUxsPtJpmOpTSG7XX/4FYyBAW2zZ
         KL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5hHtLxBl/f/KnEapSkPu95KSvj6JTeXO1zosJzNLAX4=;
        b=FI0en9QCzWFuy+PJWA5/ywpS2GeA4++DNjcXteQBTZsWqoYWQ9DjwPUwNhzFBQG75L
         C4K5Dt86DjZJiaenQEJqKkWUBAGrW5IRrGIdF0O+Xdp7nI5ilN2r5eRRyo00uf3g1pf2
         qcjgv1UTWpEvO0MEpdeF3HAWoiPGV0ekY4T9XStYM+zafdmdg075Fw6fIRaVoYC3U+EM
         p4O2HnvZX31UxKtB7aKfh447gsZLw4qllnAYjttLylH5c4F/cM9ts2dB1tbykGXFgIOp
         cuq4gQBj9VnNIC1kdJMhxoj2aL9ADsaH4Q49V7vYur6QOCjMPGOEm6IQy1DHgu1L3tYd
         txGw==
X-Gm-Message-State: APjAAAVIbERfXWNsmwtg/Aj2VUiNp1cd90C6XJKxcAKDa+TTBZLkMRKv
        QRrCtKvJ0IHs9susU2om3ZcXYSlBX13MJ0tpEC8=
X-Google-Smtp-Source: APXvYqxVE7snj7/boXLc4VKXjR5n9umgqtVwrRs4lwMNg2JFniIYd6iyLQPDp9obQymytdQQzu5rTOj9caDZhbR9hKM=
X-Received: by 2002:a63:4e0e:: with SMTP id c14mr10940202pgb.237.1576788625590;
 Thu, 19 Dec 2019 12:50:25 -0800 (PST)
MIME-Version: 1.0
References: <git-mailbomb-linux-master-8ffb055beae58574d3e77b4bf9d4d15eace1ca27@kernel.org>
 <CAMuHMdVgF0PVmqXbaWqkrcML0O-hhWB3akj8UAn8Q_hN2evm+A@mail.gmail.com>
In-Reply-To: <CAMuHMdVgF0PVmqXbaWqkrcML0O-hhWB3akj8UAn8Q_hN2evm+A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 19 Dec 2019 12:50:14 -0800
Message-ID: <CAM_iQpWOhXR=x10i0S88qXTfG2nv9EypONTp6_vpBzs=iOySRQ@mail.gmail.com>
Subject: Re: refcount_warn_saturate WARNING (was: Re: cls_flower: Fix the
 behavior using port ranges with hw-offload)
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 2:12 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> I still see the below warning on m68k/ARAnyM during boot with v5.5-rc2
> and next-20191219.
> Reverting commit 8ffb055beae58574 ("cls_flower: Fix the behavior using
> port ranges with hw-offload") fixes that.
>
> As this is networking, perhaps this is seen on big-endian only?
> Or !CONFIG_SMP?
>
> Do you have a clue?
> I'm especially worried as this commit is already being backported to stable.
> Thanks!

I did a quick look at the offending commit, I can't even connect it to
any dst refcnt.

Do you have any more information? Like what happened before the
warning? Does your system use cls_flower filters at all? If so, please
share your tc configurations.

Thanks.
