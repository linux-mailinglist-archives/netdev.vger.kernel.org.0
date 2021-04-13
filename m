Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F2D35E704
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345006AbhDMTZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344831AbhDMTZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 15:25:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ED4C061574;
        Tue, 13 Apr 2021 12:25:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s15so20731322edd.4;
        Tue, 13 Apr 2021 12:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MCOU/nejpwv7NDugm0TZ1/T9s9gQ2ZIv4K11HpLSrPA=;
        b=JEyOEXxPtkTZ1o8WSc+hVafkw92M+ZXhItshX+Mr+6bfDmh0RIDUx7G7/M+e/IMS9o
         XhGTmiW4EYsKLjN2rnfXVE6Z/S/XyVhNlZnzi/vK0yKYLzqOOiBPKn1dSddU/gFzRP06
         yGRIg4vB0QIX7QT+nQpou4caHRwUooKLG0t3g7hhvKQGp8WX9V6sLNVTTIddAEFGTeYi
         UNe+NpyUIGk4cjJyAKG83YJBxsPQ8yLPPgSjpn2u5zpwY9I0dxPTDTTUAdwSNM2y+Kl/
         AlXfz4tHNmZyW9Ob8InFYwPJnzWlQh/09YaH/lmsJwzD9RwF/+pf/J5vw815eaj71I95
         pqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MCOU/nejpwv7NDugm0TZ1/T9s9gQ2ZIv4K11HpLSrPA=;
        b=EZIH+ZsFVY+TSzOEBScaPhxQaCwQ8Le6I7vISJgJjThVcCr7+fkcUHyXODH6+h/5VG
         UdIjUTCqDGglNy7hrwhj8y2iWIhzzI+ndJ2aOAtmPZWgUBvw1m0MsuUgz3A5HERV/AGs
         ClfrDp8b+P6bTRyLblfV0RPkJ+shosfc9J9O1NBis0VyNyFAsTbhwuO7oaqCSlSN+gum
         z7/m+si00ia91ocojTz5N5qDkvmn3ZJopteZI0JyINxElga30+t6US65iI/5JJx5VMM2
         afntqi4ZUv8KuaqIzMa5p/kFBGuOzkHFS8PrnwDAYFkzvynSu2EqBfxADMilx8N7MbkY
         a4ew==
X-Gm-Message-State: AOAM531mjuuQkjQmy1f1YIryg3VT7bpnvF0IY1TH0dgkyTebAwnqaEqP
        ALSiB/qGprfta8tXrWPHKhtB9lzqbc6IQok+J5k=
X-Google-Smtp-Source: ABdhPJwe6chIr78Ru8fjzwPsIXJ0W5CCMZtZhid5Tdj1QhJQUPgMS4zk+5Snli2NF+67hCv59XKZBS6pHnVY85smjzY=
X-Received: by 2002:aa7:d843:: with SMTP id f3mr30941494eds.52.1618341918127;
 Tue, 13 Apr 2021 12:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
 <YHODYWgHQOuwoTf4@lunn.ch> <CAFBinCD9TV3F_AEMwH8WvqH=g2vw+1YAwGBr4M9_mnNwVuhwBw@mail.gmail.com>
 <YHTbk3g2rM8zZZ5h@lunn.ch>
In-Reply-To: <YHTbk3g2rM8zZZ5h@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 13 Apr 2021 21:25:07 +0200
Message-ID: <CAFBinCDvQNhyxdPo4=q7b5E6oe3_wVGG0g-QFvNRz2BQ41S-Lg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping
 the registers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 1:45 AM Andrew Lunn <andrew@lunn.ch> wrote:
[...]
> > > and a few people have forked it and modified it for other DSA
> > > switches. At some point we might want to try to merge the forks back
> > > together so we have one tool to dump any switch.
> > actually I was wondering if there is some way to make the registers
> > "easier to read" in userspace.
>
> You can add decoding to ethtool. The marvell chips have this, to some
> extent. But the ethtool API is limited to just port registers, and
> there can be a lot more registers which are not associated to a
> port. devlink gives you access to these additional registers.
oh, then that's actually also a problem with my patch:
the .get_regs implementation currently also uses five registers which
are not related to the specific port.
noted in case I re-send this as .get_regs patch instead of moving over
to devlink.

Thanks for the hints as always!


Martin
