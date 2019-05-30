Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66C752FC6F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 15:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfE3Nfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 09:35:51 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40812 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfE3Nfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 09:35:51 -0400
Received: by mail-lj1-f196.google.com with SMTP id q62so6073987ljq.7
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 06:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/U1f8Fc02eyDkuGsWIDz5srojNJJU/zoTrLNm2qEEYE=;
        b=PcjCE05Vr6571Z0FZcLJcqv+cvaAJeL7YpbARuQ2LSZIHBxhkDAdsF9jD7NhDOKngU
         6X1SX5q77QkN9n3E19d4YHs9c0CtfyLSRuUuSdOXluMQYnqok+2LuhQnfV6Yvt5gokXc
         rv1Y97UwU29b5+KdfE/UeKLzGLNovyUXymuMuyGyAd1g6N0pG2/4sWOP2UBIUSzYLfHX
         V1r+bdOV/ByhYIvgWgk1An0M77FfT6aJutWDNqmHH2KjEzC70mCUzzpod9jb6FNa/AtR
         MEO9qpdFx+xNcpWYtV4mCZ49HXeovOfghdnPjt29AHlHiv/t+7uoYA1WS7kIwbDGPK1R
         tWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/U1f8Fc02eyDkuGsWIDz5srojNJJU/zoTrLNm2qEEYE=;
        b=HrYAhcqXycAEn6ZcTsz7dhl3UYC7CdxAD66wz63xttps6RbckHWQdpnFJ+A5CSi8W3
         QriJL0b77Vdheo2h3T8+xrpZDNy4tjWaxr56GG7fx1qE6CiZwyEsLYCJfSd+8nYvfG6e
         rWmmYSq/Qrzm89BL+El09TGErl4t+9BwJu/OxYZo9jtFziXltCi6gfjfeoyZG7dBvOMe
         m+55N4+yflsOxj0z2DXYNhisO/Ge8oXNmZ6IKGxnlCQF0x6hcrpkBySs7BYwhnuZkk/Q
         GtDwQL2pXp4tm16E3pWohmPvw6zH8VjNcmvSm/OcP9vDH33o+eeqYl6E7byvEvjRu70Z
         Y5Rg==
X-Gm-Message-State: APjAAAUnfCebhcPX6+4jq8ybA1hpRMH8y/s1R646PMHzP6D27oOyefkT
        hpkKVfiu4nSz49mPWMfCbFRprpiqqf1jG7aN5EFG
X-Google-Smtp-Source: APXvYqxLKiEME9EKDe015SLMtCLzjMQupiY0eTQcPEupXRnKhW/v5gEX9weuoubW+5N0jXscBR8tMiamdrFu8nfWc0w=
X-Received: by 2002:a2e:3e14:: with SMTP id l20mr2252084lja.40.1559223348494;
 Thu, 30 May 2019 06:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com>
 <CAHC9VhTQ0gDZoWUh1QB4b7h3AgbpkhS40jrPVpCfJb11GT_FzQ@mail.gmail.com> <1674888.6UpDe63hFX@x2>
In-Reply-To: <1674888.6UpDe63hFX@x2>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 May 2019 09:35:36 -0400
Message-ID: <CAHC9VhQqiaHRxZkOZO2c5UzMOQ_NNu1pEsc4fQDX=Hj-HnGUoQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 9:08 AM Steve Grubb <sgrubb@redhat.com> wrote:
> On Wednesday, May 29, 2019 6:26:12 PM EDT Paul Moore wrote:
> > On Mon, Apr 22, 2019 at 9:49 AM Paul Moore <paul@paul-moore.com> wrote:
> > > On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com>
> wrote:
> > > > On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> > > > > Implement kernel audit container identifier.
> > > >
> > > > I'm sorry, I've lost track of this, where have we landed on it? Are we
> > > > good for inclusion?
> > >
> > > I haven't finished going through this latest revision, but unless
> > > Richard made any significant changes outside of the feedback from the
> > > v5 patchset I'm guessing we are "close".
> > >
> > > Based on discussions Richard and I had some time ago, I have always
> > > envisioned the plan as being get the kernel patchset, tests, docs
> > > ready (which Richard has been doing) and then run the actual
> > > implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> > > to make sure the actual implementation is sane from their perspective.
> > > They've already seen the design, so I'm not expecting any real
> > > surprises here, but sometimes opinions change when they have actual
> > > code in front of them to play with and review.
> > >
> > > Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> > > whatever additional testing we can do would be a big win.  I'm
> > > thinking I'll pull it into a separate branch in the audit tree
> > > (audit/working-container ?) and include that in my secnext kernels
> > > that I build/test on a regular basis; this is also a handy way to keep
> > > it based against the current audit/next branch.  If any changes are
> > > needed Richard can either chose to base those changes on audit/next or
> > > the separate audit container ID branch; that's up to him.  I've done
> > > this with other big changes in other trees, e.g. SELinux, and it has
> > > worked well to get some extra testing in and keep the patchset "merge
> > > ready" while others outside the subsystem look things over.
> >
> > I just sent my feedback on the v6 patchset, and it's small: basically
> > three patches with "one-liner" changes needed.
> >
> > Richard, it's your call on how you want to proceed from here.  You can
> > post a v7 incorporating the feedback, or since the tweaks are so
> > minor, you can post fixup patches; the former being more
> > comprehensive, the later being quicker to review and digest.
> > Regardless of that, while we are waiting on a prototype from the
> > container folks, I think it would be good to pull this into a working
> > branch in the audit repo (as mentioned above), unless you would prefer
> > to keep it as a patchset on the mailing list?
>
> Personally, I'd like to see this on a branch so that it's easier to build a
> kernel locally for testing.

FWIW, if Richard does prefer for me to pull it into a working branch I
plan to include it in my secnext builds both to make it easier to test
regularly and to make the changes available to people who don't want
to build their own kernel.

* http://www.paul-moore.com/blog/d/2019/04/kernel_secnext_repo.html

-- 
paul moore
www.paul-moore.com
