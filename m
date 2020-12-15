Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE52DAD34
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 13:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgLOM2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 07:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729500AbgLOM2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 07:28:20 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF43C06179C;
        Tue, 15 Dec 2020 04:27:40 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id w18so6412195iot.0;
        Tue, 15 Dec 2020 04:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bgzicqHGurBoYsOg6Ds+t2DBVqpKT7glXw7tbw5LPNI=;
        b=lnWZIpSBb4qC9GXdfGstcGgcx7Kgu6yKphmlx+1QASnzSdYQ9yxaLe7sM/5M9CoUUx
         kZx3oeQJ5ldF8hPHJzjH0zpHyIipRSMMttrZaO9ppxkDOb8SEhrkwMCqXl6QEMeE9cNG
         r+lA40IVspcDfyKsRpjVU8NEHHLiDDn4UJuYhptsJQPQPP1xGVwb/7JlAdiEFcbtv/qs
         mJJsoRCp9lXsZLaeKzHqGXYfk4KD/+iBhi8UkTjmd5Y59SN9tElAbTLl0qeOM1dIyxIQ
         Cjlk89JdfYQFecPraY1AUE5lrcLvdZjJfllVKF8YMCOT+QrM/JezGLG5JFGqGHNPGRLR
         FcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bgzicqHGurBoYsOg6Ds+t2DBVqpKT7glXw7tbw5LPNI=;
        b=U5dRyEWTyoOKONtQhO+JeqhAZ4pCrMkEpffnn4Jes375cw2R6ob9xKH5JumG1hG3Gw
         NdxW5zI8wZY9WKQpIMLU3Gf8VOgzWWqdGFF965xMLqRwXIcrbI2NT2CzkmKU8GCodQq6
         msMbjOC4fLSipqIZIyFJLzYbPCU+OzV2VAunvQJr2K2NB8eybkqsx7pGJnk8IEORB7Zz
         9f4n5WAE9OFpiTfL4bpJjvbybvR4tHHsaNyqA23tLxBVR3IMKtmyvyFixMVpHe/vuZPj
         dJZpE2vN5RVkO4sd0gSqkuZ3WHtQu0AXD+Qbq8acfGOkIsXXauSy7lXT3LlaNniYNQer
         PDyA==
X-Gm-Message-State: AOAM5304uU9WxzRHXC4IIerdtnee+Chxdk6OpODWs/lsGicOJK9YCHTm
        V+6CcQEHByl79Q+0Fch6FpcywTV+QT1fyB5fFDY=
X-Google-Smtp-Source: ABdhPJxSz/+zoLLj7JVt9L136lIOdTmaPso2a5vLMkNJtcMA7k63WEeQlv+9ImJs5IFW2UgjTbT3okSQ7+l4behmusY=
X-Received: by 2002:a5e:9512:: with SMTP id r18mr38525653ioj.86.1608035259607;
 Tue, 15 Dec 2020 04:27:39 -0800 (PST)
MIME-Version: 1.0
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201214103008.14783-1-gomonovych@gmail.com> <20201214111608.GE5005@unreal>
 <20201214110351.29ae7abb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1113d2d634d46adb9384e09c3f70cb8376a815c4.camel@perches.com>
 <20201215051838.GH5005@unreal> <19198242da4d01804dc20cb41e870b05041bede2.camel@perches.com>
 <20201215061847.GL5005@unreal>
In-Reply-To: <20201215061847.GL5005@unreal>
From:   Vasyl <gomonovych@gmail.com>
Date:   Tue, 15 Dec 2020 13:27:28 +0100
Message-ID: <CAHYXAnJZrxOPTttd4Z1v4f1ixwarxsJpz8YYZNDL_5r4_SkyeQ@mail.gmail.com>
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Joe Perches <joe@perches.com>, Jakub Kicinski <kuba@kernel.org>,
        tariqt@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Ouuu it was fixed recently in net-next.
Sorry, I missed that.
Thanks for submitting policy clarification I am going to adapt to it.

Thanks

On Tue, Dec 15, 2020 at 7:18 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Dec 14, 2020 at 09:37:34PM -0800, Joe Perches wrote:
> > On Tue, 2020-12-15 at 07:18 +0200, Leon Romanovsky wrote:
> > > On Mon, Dec 14, 2020 at 11:15:01AM -0800, Joe Perches wrote:
> > > > I prefer revisions to single patches (as opposed to large patch ser=
ies)
> > > > in the same thread.
> > >
> > > It depends which side you are in that game. From the reviewer point o=
f
> > > view, such submission breaks flow very badly. It unfolds the already
> > > reviewed thread, messes with the order and many more little annoying
> > > things.
> >
> > This is where I disagree with you.  I am a reviewer here.
>
> It is ok, different people have different views.
>
> >
> > Not having context to be able to inspect vN -> vN+1 is made
> > more difficult not having the original patch available and
> > having to search history for it.
>
> I'm following after specific subsystems and see all patches there,
> so for me and Jakub context already exists.
>
> Bottom line, it depends on the workflow.
>
> >
> > Almost no one adds URL links to older submissions below the ---.
>
> Too bad, maybe it is time to enforce it.
>
> >
> > Were that a standard mechanism below the --- line, then it would
> > be OK.
>
> So let's me summarize, we (RDMA and netdev subsystems) would like to ask
> do not submit new patch revisions as reply-to.
>
> Thanks



--=20
=D0=94=D0=BE=D0=B1=D1=80=D0=BE=D1=97 =D0=B2=D0=B0=D0=BC =D0=BF=D0=BE=D1=80=
=D0=B8 =D0=B4=D0=BD=D1=8F.
