Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5258834BA6
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfFDPJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:09:23 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43577 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbfFDPJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:09:22 -0400
Received: by mail-lf1-f68.google.com with SMTP id j29so2817323lfk.10
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 08:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHkkdbLqPEB+oq5ZYlYQ04v+bg1uDHjFgi25HXnSqzQ=;
        b=CEqHdLS26UGSQKNYFlyxBcKhAeB9PdJ6h1OXuqGUvs5txEgQ4m9t9wVTBarsfwxzve
         rMNFvPEDMCCKVZBh7pMUFljHqOKhVHBkoOyiXDSUMsHBEZHqIJa9n3opSJLmSzdkupDg
         FbT8Q+DopzJvexeHBo32CwdZHEctGANO+ozjYwOfsr40JrVaR0GJ6yF7jH3CIvvzgrM/
         5N/rgmUcSUCmtykOuh/QGYngnLaCa5DYpVGkM1SfnnOU8LfIBix/UjUipv2WLKK7bfsG
         9ZKBEiJDykHFH4vl/Gk23o37f1tgACWHk/+EGrpEKxckUsS5WZB2QBMRN6Fyr3FE/b0H
         sCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qHkkdbLqPEB+oq5ZYlYQ04v+bg1uDHjFgi25HXnSqzQ=;
        b=qJs5kY2XFpGpXJcEo2ZkmSumZUiuWx4fNDNsmeCCB4+S6ekH/Iq15TtJPbsSJ9WWl6
         SF24KlqkcLYvaMX9VMDt/vSGQVNx3FXnw6Pn29Wyqg6ldpag/kYaG91vCfkIOa/l+mUi
         OIxvoAYPdHX8yPHi6MZyInQaYAD48cOYRPW8YQlTSPMs5Jz/nvugp40+/HmaECDcBXIt
         bXFRBZCEW7ging6qDNA1qej58V7cu31HUuX8P9iDX6M8kOcsVzvu4Wy2zT1rYmv+PO8H
         4+bLGqxT9iPz4Q9/rlqt4QBPno6Z2mlM9sAKGgAnpm5qNJ3WJS5OhTiO5k73G5BFrS5L
         pAtQ==
X-Gm-Message-State: APjAAAVdWgFUmCeWQSdpKw/9YeSUBHc2s5VN19v89vVwUpqGDb2g9Eq2
        NxyizhDV4AxPPRN2b7+QI1eFMfFMYYFEpKtu0HM=
X-Google-Smtp-Source: APXvYqwR/RQZd/GajyeZyFGFhGsHFy1bz1BhCToka86vWK1SvJAb78QeC4t/W6Ac9j5VLOXbq2M1DSLv7S/NI0GpbtQ=
X-Received: by 2002:a19:e05c:: with SMTP id g28mr2392969lfj.167.1559660960803;
 Tue, 04 Jun 2019 08:09:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190604134044.2613-1-jiri@resnulli.us>
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Jun 2019 08:09:09 -0700
Message-ID: <CAADnVQJXj=tDnJ4FMQPrc_NxkXoJ_s_wVD+3fOmdk-WV5VXBew@mail.gmail.com>
Subject: Re: [patch net-next v3 0/8] expose flash update status to user
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, mlxsw@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 6:41 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> From: Jiri Pirko <jiri@mellanox.com>
>
> When user is flashing device using devlink, he currenly does not see any
> information about what is going on, percentages, etc.
> Drivers, for example mlxsw and mlx5, have notion about the progress
> and what is happening. This patchset exposes this progress
> information to userspace.
>
> Example output for existing flash command:
> $ devlink dev flash pci/0000:01:00.0 file firmware.bin
> Preparing to flash
> Flashing 100%
> Flashing done
>
> See this console recording which shows flashing FW on a Mellanox
> Spectrum device:
> https://asciinema.org/a/247926

from api perspective it looks good to me.
Thanks!
Acked-by: Alexei Starovoitov <ast@kernel.org>
