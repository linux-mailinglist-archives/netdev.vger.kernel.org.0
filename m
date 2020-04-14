Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC351A7890
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 12:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438451AbgDNKff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 06:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438421AbgDNKep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 06:34:45 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7BEC061A0C;
        Tue, 14 Apr 2020 03:23:11 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id h205so6905214ybg.6;
        Tue, 14 Apr 2020 03:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MudcixcZUb+kvMHsLn0fRVwWPgbJXDIShuvyjdGupTk=;
        b=oaRLPeOHAo/HoLVEzWijMXsjYYLQBHAtU0chOQc1J59DyHE9H5Ff/Jxf40AgI38ZW+
         3a2fFpM/pYDfkigqeD/CHsnJ0P975v+jq0Q3wb6XiReCmTRlK6OjK+IQLfh9ucOVf+jL
         fNXRwG5egeKE/yGjZJRfmKvk021MdMh5gZXs8gwC8G+pLoSMSlTKRKjLFBcZks6taIva
         aXhyCxBytfzbMtNiqT3fD91DkiQMiH64vv05bpHN+v5+jtvo+Xh3R/Byho08dfnFrK7/
         m9azQcHGIjzjDqnU/FOJt2QcoMNfzSDbzYCxrgQOhEZnukrvrZjTrECer+QCfJir+tRZ
         gwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MudcixcZUb+kvMHsLn0fRVwWPgbJXDIShuvyjdGupTk=;
        b=Ov7AxwnHzDZLuOCwSS4PRpui7b6YKtWYzXZBr/QhoxbAM5cQfadBi9m9HokcrDyt3q
         IbfAlG42E/Sv1EVSYtPlBQ1znXKk982MoFZW9grcWQ+VoF0QSOD2qBrKFnv2Fm4ATS+1
         oVCgclwQAlyn9jXQ2Ba52dZz/lREWnKCwSgIsH0g7MdodtoZZs3JOQjGS2OqXjKnh9AL
         zGkyu51hhsG2pUjn9idzcEnqsvOAUWNTGABqMKyya8EgJdmTos+qH8hS5p1jKixUb5Qb
         iVJYg0Cy5HDE3VqjwA8o3xP7gqYqO7LGscPNCnfWG2ins4A7Vrmb/BtWJ9xRZ94J9kv/
         jieg==
X-Gm-Message-State: AGi0PuYafoYqqe8T13R447j13Z05YUkDIv7jPUWqsBIIj1ZYNPHvy9ji
        eeHowO3ypHPuyqaSL+3RTyCn6IHYtwcw8HZs4Ko=
X-Google-Smtp-Source: APiQypK7qfTjVZoBt9pehm8VzrsuAr1n+VJ2HhNmFMNxRIgLQCvz7qRKZ5Mr2RGWNVJeR/ewcivcmSv0FJ8U8RjYLSA=
X-Received: by 2002:a5b:5cf:: with SMTP id w15mr31976689ybp.215.1586859790739;
 Tue, 14 Apr 2020 03:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200411231413.26911-1-sashal@kernel.org> <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20200414015627.GA1068@sasha-vm>
In-Reply-To: <20200414015627.GA1068@sasha-vm>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 14 Apr 2020 13:22:59 +0300
Message-ID: <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for representors
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 4:56 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Sun, Apr 12, 2020 at 10:59:35AM -0700, Jakub Kicinski wrote:
> >On Sun, 12 Apr 2020 10:10:22 +0300 Or Gerlitz wrote:
> >> On Sun, Apr 12, 2020 at 2:16 AM Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> > [ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]
> >>
> >> Sasha,
> >>
> >> This was pushed to net-next without a fixes tag, and there're probably
> >> reasons for that.
> >> As you can see the possible null deref is not even reproducible without another
> >> patch which for itself was also net-next and not net one.
> >>
> >> If a team is not pushing patch to net nor putting a fixes that, I
> >> don't think it's correct
>
> While it's great that you're putting the effort into adding a fixes tag
> to your commits, I'm not sure what a fixes tag has to do with inclusion
> in a stable tree.
>
> It's a great help when we look into queueing something up, but on it's
> own it doesn't imply anything.
>
> >> to go and pick that into stable and from there to customer production kernels.
>
> This mail is your two week warning that this patch might get queued to
> stable, nothing was actually queued just yet.
>
> >> Alsom, I am not sure what's the idea behind the auto-selection concept, e.g for
> >> mlx5 the maintainer is specifically pointing which patches should go
> >> to stable and
>
> I'm curious, how does this process work? Is it on a mailing list
> somewhere?
>
> >> to what releases there and this is done with care and thinking ahead, why do we
> >> want to add on that? and why this can be something which is just
> >> automatic selection?
> >>
> >> We have customers running production system with LTS 4.4.x and 4.9.y (along with
> >> 4.14.z and 4.19.w) kernels, we put lots of care thinking if/what
> >> should go there, I don't
> >> see a benefit from adding auto-selection, the converse.
> >
> >FWIW I had the same thoughts about the nfp driver, and I indicated to
> >Sasha to skip it in the auto selection, which AFAICT worked nicely.
> >
> >Maybe we should communicate more clearly that maintainers who carefully
> >select patches for stable should opt out of auto-selection?
>
> I've added drivers/net/ethernet/mellanox/ to my blacklist for auto
> selection. It's very easy to opt out, just ask... I've never argued with
> anyone around this - the maintainers of any given subsystem know about
> it way better than me.

Just to make sure, does this excluding of mlx5 happens immediately, that is,
applies also to all non committed patches that you already posted?

IMHO - I think it should be the other way around, you should get approval
from sub-system maintainers to put their code in charge into auto-selection,
unless there's kernel summit decision that says otherwise, is this documented
anywhere?
