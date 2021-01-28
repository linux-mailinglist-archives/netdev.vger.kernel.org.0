Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA734307A4F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhA1QIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhA1QIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:08:45 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A60C061574;
        Thu, 28 Jan 2021 08:08:04 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 11so4279511pfu.4;
        Thu, 28 Jan 2021 08:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mmsAaGz0qy+EULWgb8BRy1dw0rnx2dvW966eExwXI1o=;
        b=DCAER6gJjO9gqAdc8WzCm6L4EPQVEBWxMx0IBDeA5D75EELcCujiiXnpRZ2+Ug+e7y
         71Qx4zU5kXM9iu30oYodtmFpt2Zvlb+0AoDNGh64hXZqeQD2b2Nmex4DKtywFSQL7W0G
         8zZr8SkA/P/Qc9Dz1+r/ScGTRJOqq/JAuDfqXnvwWIVh4M7WmOnAgl2WrUteIGuihRwh
         B62Lq5B7ge6OPDFLf0NjC0hg23MdglrbwoNpmNpIbogg8bJYHzPfPGhSJ7I03MPKDxo8
         zUoun/+xt3KMx6LzSJbKcpdQeAV8VYucA0hWL1iQ1TE1zZeb6aB8DN3tFcxmPspBKo4k
         JecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mmsAaGz0qy+EULWgb8BRy1dw0rnx2dvW966eExwXI1o=;
        b=NNDbn85gZfrX+t+QTdS3d1+FeFPT8XHHu/1uSf/ic0GlGsqjp1K908qYMhri2ZY3C6
         lxMrpPGWi6Xh0MrxNzZs13u3AwgksOSkX0xsqyUQr244fhpjctgoNNH8v/dIxfDuilzL
         Dic6rB3cclCIRt7pYbyqjoqCw8LnJqqBZtlmAEDNd9Y+EMarfyAKtGZmhDELVjVBENX7
         21U97paAEB52UhofiUa6FShWrEDDD+s/NKSelCq1MNiB/qdOgr26UGwjqne4KkC1Lz8t
         Pbrl/BoZ8FCThf+htKdil28X7wTlriDPZQSwAX8Blet0/hjnHPN8VBdmyotUR1stZiEh
         4hBw==
X-Gm-Message-State: AOAM531gzjDj3RaK07L8Iq/TE6t2JknTx/7PWGaogS2SI/I/P4BM67Eq
        NzarnUucYA6UM+iHNQbHsWN1mjqbdmn2s2FoKcE=
X-Google-Smtp-Source: ABdhPJzRg/hDOPh3YsW4O5+7SS6TK5brH1QhTYjZQs++Hl2tqKUFekfTNAdnj0oLtJtrnH7lJLdd/q23ajkmuJgfqUY=
X-Received: by 2002:a63:e50:: with SMTP id 16mr285707pgo.74.1611850084193;
 Thu, 28 Jan 2021 08:08:04 -0800 (PST)
MIME-Version: 1.0
References: <20210125045631.2345-1-lorenzo.carletti98@gmail.com> <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
In-Reply-To: <20210125045631.2345-2-lorenzo.carletti98@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 28 Jan 2021 18:07:47 +0200
Message-ID: <CAHp75VeyKpeDa7XSjQ7zAEQ0BnseZCAJhh+nakNYN2nP+6PJAQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: dsa: rtl8366rb: standardize init jam tables
To:     Lorenzo Carletti <lorenzo.carletti98@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 7:00 AM Lorenzo Carletti
<lorenzo.carletti98@gmail.com> wrote:
>
> In the rtl8366rb driver there are some jam tables which contain
> undocumented values.
> While trying to understand what these tables actually do,
> I noticed a discrepancy in how one of those was treated.
> Most of them were plain u16 arrays, while the ethernet one was
> an u16 matrix.
> By looking at the vendor's droplets of source code these tables came from,
> I found out that they were all originally u16 matrixes.
>
> This commit standardizes the jam tables, turning them all into
> u16 matrixes.
> This change makes it easier to understand how the jam tables are used
> and also makes it possible for a single function to handle all of them,
> removing some duplicated code.

...

Since further replies removed code, I reply here for everybody with an
example of my thoughts against this cryptic data.

If you look into the below, for example, you may notice a few things.
 - it pokes different address regions (sounds like data section, text
section, etc.)
 - it has different meaning for some addresses (0xBE prefix)

+static const u16 rtl8366rb_init_jam_f5d8235[][2] = {
+       {0x0242, 0x02BF}, {0x0245, 0x02BF}, {0x0248, 0x02BF}, {0x024B, 0x02BF},
+       {0x024E, 0x02BF}, {0x0251, 0x02BF}, {0x0254, 0x0A3F}, {0x0256, 0x0A3F},
+       {0x0258, 0x0A3F}, {0x025A, 0x0A3F}, {0x025C, 0x0A3F}, {0x025E, 0x0A3F},

Sounds like we program some buffer lengths / limits (0x2c0, 0xa40 if
it rings any bell to anybody).

+       {0x0263, 0x007C}, {0x0100, 0x0004}, {0xBE5B, 0x3500}, {0x800E, 0x200F},

BE5B seems like "execute the routine at 0x3500 address".
Thus I think shuffling those pairs before 0xbe shouldn't give any
difference (but I have no hw to try).

+       {0xBE1D, 0x0F00}, {0x8001, 0x5011}, {0x800A, 0xA2F4}, {0x800B, 0x17A3},
+       {0xBE4B, 0x17A3}, {0xBE41, 0x5011}, {0xBE17, 0x2100}, {0x8000, 0x8304},
+       {0xBE40, 0x8304}, {0xBE4A, 0xA2F4}, {0x800C, 0xA8D5}, {0x8014, 0x5500},
+       {0x8015, 0x0004}, {0xBE4C, 0xA8D5}, {0xBE59, 0x0008}, {0xBE09, 0x0E00},
+       {0xBE36, 0x1036}, {0xBE37, 0x1036}, {0x800D, 0x00FF}, {0xBE4D, 0x00FF},

0x80 addresses are some kind of magic, like interrupt vector returns
or so. You may notice some 0xBE commands against the addresses that
are put into the 0x8000 address region.

 };

Overall it seems you have to discover a full firmware image to make
any assumptions about CPU ISA used there and address mapping.

-- 
With Best Regards,
Andy Shevchenko
