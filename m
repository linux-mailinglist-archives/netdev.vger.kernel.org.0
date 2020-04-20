Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9EB1AFF1C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 02:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDTAMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 20:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbgDTAMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 20:12:31 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ABEC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:12:31 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b62so8881086qkf.6
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nl4MyICdsucZjE6+CYv2FKrZxRZiX6lloSfFYM6/Y6o=;
        b=boeMkjj9qy9nyt6SV1ZSWYNJ1lEN1GssxKAL00Bv2v2mT2CSxmQSNuSWYeR5aJlY6T
         qXWIfb5SBsP0C8X3/ArsOrXSd2F2Tjaa94YTcryfSaItCtYOjpBP8T4nQ3VtkQz+nhPC
         Ibw/7kNiSYxSc8XCm81Oi8q8R6qEPSD+ufqSQ+VOSOX+4P9A3us5lyc+SA8bUu5A0vug
         SGPl/am0hQoXmWTErQHuXeG4QN0ORh6/C6n7ahC2HyAQo3sNvae236HLzOyQVDYV3Lgi
         vxPbPNTSuiELOemMdCnEbRevkWesKHxTmqO+3y1xB3IoiUfWNhdUh04k1qWuKNpQoq0P
         Lgfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nl4MyICdsucZjE6+CYv2FKrZxRZiX6lloSfFYM6/Y6o=;
        b=MkzJ2Ptu59c4SGo2z1wcATQFnll6CvtfXY78Y0rrCWL4QhmYoDI2nLFaota6CCkiAY
         1g5tim3GNPHWFUZclcYMs+mPSyA7QWRtZj/RvJ5cVXI87JjUsJrWSQ1pz0XzVwMp6Wxh
         5e0LqoOKnv5zS4QXXR5afHL6NLXw658V0tqZWgPgZSVx2oClVtFCOprbArnCP/AmR2DP
         m/kflXHMzLf2HAose+4Y1fsmbVMHpHt7REtyYvu4yf05GigaQZvhN/k28aJ/fuOwGXEK
         mcjmL6lH2eQFelAWyWWAo1IqF0cdwtSJqd1wpZTZHFRLgvHYbR3ifRBS5+z+pUSVMsBF
         ST8A==
X-Gm-Message-State: AGi0PuZPboGzK4i+MYBIai4s5MsBK/d46VcqIuj8XKD2D+kV0RWEogAe
        KqyG6yZUoOoyZgWMlD2Ty+YZ/XgohMvicyhAHZA=
X-Google-Smtp-Source: APiQypKBs5DxOsNTsm/qMCOAQzAbTDACMrirStxGDA5kDZfPwoRWUPIW/KtvB8tpWrE+HCjJ6bBbdLU9waBZxJUhTbI=
X-Received: by 2002:a05:620a:1647:: with SMTP id c7mr13874978qko.473.1587341550248;
 Sun, 19 Apr 2020 17:12:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDZJNWm5Vu-G4_het+CyxdbZYPJuidihUPK0ZhPC1HfKXsM2A@mail.gmail.com>
 <5e5bc4248759f4a1bfc449fa2b8854dd56c0e281.camel@mellanox.com>
In-Reply-To: <5e5bc4248759f4a1bfc449fa2b8854dd56c0e281.camel@mellanox.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 20 Apr 2020 08:11:54 +0800
Message-ID: <CAMDZJNU_3G83tHs+khV9wwpXdoFrOngDTq6kS0TMWXdj9hRkeA@mail.gmail.com>
Subject: Re: discussion mlx5e vlan forwarding
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 6:48 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Fri, 2020-04-17 at 18:57 +0800, Tonghao Zhang wrote:
> > Hi Saeed and maintainers
> >
> > In one case, I want to push vlan and forward the packets to one VF.
> > Tc
> > command shown as below
> > $ tc filter add dev $PF0_REP0 parent ffff: protocol ip prio 1 chain 0
> > \
> >     flower src_mac 0a:47:da:d6:40:04 dst_mac 00:11:22:33:44:66 \
> >     action vlan push id 200 pipe action mirred egress redirect dev
> > $PF_REP1
> >
> > dmesg:
> > mlx5_core 0000:82:00.0: mlx5_cmd_check:756:(pid 10735):
> > SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad
> > parameter(0x3), syndrome (0xa9c090)
> >
> > So do we support that forwarding ?
> >
>
> Hi Tonghao,
>
> CC'ing more experts, Or and Roi, they might have more useful info for
> you.
>
> but as far as i recall, this can only work on uplink port and not a VF.
Do we have plan to support that function? I guess that this feature is
important for us.
Because I use vlan id as metadata, and that will be matched in future.
> > kernel version: 5.6.0-rc7+ [OFED 5.0 has that issue too]
> > firmware-version: 16.27.1016
> > NIC: Mellanox Technologies MT27800 Family [ConnectX-5]



-- 
Best regards, Tonghao
