Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F005DFE1
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfGCIeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:34:00 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42202 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfGCId7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 04:33:59 -0400
Received: by mail-io1-f67.google.com with SMTP id u19so2779383ior.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 01:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZml3Gj+soXAdQY213m+oydrpiUdH8ZgVL3elKHiNEo=;
        b=PEym0mh15w9ffN3L7a8lmnIoabVod90J3NLWYKSZtaov1xe7Il4IfRgFrh1LISr2vT
         Ou2xqcXJV8jSzmPAgg61qnAPqH/QGLeSwPXdYnG7z8OJ6x2ucNOq9TfgXe3sdEUM9nyQ
         xIfkBfMbKhhAtwk6EYBuSMKnp6u0rQQEXxTgEIbnkRNM5KpBB5nNvJWtryWkYqJ4ofjo
         HwwtHf14rEYkgAzPVS4myktYFTBSjGX6eJ8eRZvSwC5CACmsuVxBW3ZngVcVgAJbP7Cq
         +VWrSw/Fp2zzZEvVTpA7LmIEdxOvYHm84bZPSj7Z34/Cn3mzm7FPUKi5d7KtnGUisQJe
         yZfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZml3Gj+soXAdQY213m+oydrpiUdH8ZgVL3elKHiNEo=;
        b=uFvjwiBD2E6Bigfw4TaUvMCzyN8YY6OFBo24aMg9g3EypUyQQHI0co0xZdy77z7ZQw
         7R5nTpob/6+qLi2vdrOrDPD12XTqIsJmqJro+6IrSR7xV6iS/pB15OWZ66F6JcsSwP3w
         ZvtvHHdCempMGSqH/vN7HqXAN2x3yShoHc/Fd/x/RPwm3wDOMTZS3hkagWF+tssQmbvg
         51ZfNOCCq6Qg9+Jy4MIF7rOkxJkw/lJ5cYO2+czxzfSZOkBKEqlhHQz7FZ6L85cFvBB1
         CrICD7/w5Inw9PKZe6MCM8QlVkkb+wctyVs7vHFIHrm4l+j1aOuscydoXMs9bh9Jvknw
         7Onw==
X-Gm-Message-State: APjAAAV0Zk9UmgKxE2RYVwfZ21Q+lS0nkHYkjsoi/fiY3cKR36/+XFky
        faM2XxXJQa+woWmERnEjmBopDg97IqBAW58TTtxzWg==
X-Google-Smtp-Source: APXvYqzdUABY9gUTu+f90Dto8T7fyg5uOUs11JH+Dew2RR9Bhx8KAAWYcsgYU7y/9cphD9y8DZ9qj3n1LSSdtReWJvo=
X-Received: by 2002:a5d:9dc7:: with SMTP id 7mr38407952ioo.237.1562142838041;
 Wed, 03 Jul 2019 01:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com> <CA+FuTSd3DaYsY1o_GFp-X=uRkfb6i0PUPbUsUagERmAZS+Hd7Q@mail.gmail.com>
In-Reply-To: <CA+FuTSd3DaYsY1o_GFp-X=uRkfb6i0PUPbUsUagERmAZS+Hd7Q@mail.gmail.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Wed, 3 Jul 2019 09:33:47 +0100
Message-ID: <CAK+XE==_AahZczgb4hU9auoj8=Kcx66JEdK3ZQ3TYpQuxdT05A@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/5] Add MPLS actions to TC
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 3:19 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Jul 2, 2019 at 8:32 PM John Hurley <john.hurley@netronome.com> wrote:
> >
> > This patchset introduces a new TC action module that allows the
> > manipulation of the MPLS headers of packets. The code impliments
> > functionality including push, pop, and modify.
> >
> > Also included are tests for the new funtionality. Note that these will
> > require iproute2 changes to be submitted soon.
> >
> > NOTE: these patches are applied to net-next along with the patch:
> > [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
> > This patch has been accepted into net but, at time of posting, is not yet
> > in net-next.
> >
> > v4-v5:
> > - move mpls_hdr() call to after skb_ensure_writable - patch 3
> >   (Willem de Bruijn)
> > - move mpls_dec_ttl to helper - patch 4 (Willem de Bruijn)
> > - add iproute2 usage example to commit msg - patch 4 (David Ahern)
> > - align label validation with mpls core code - patch 4 (David Ahern)
> > - improve extack message for no proto in mpls pop - patch 4 (David Ahern)
> > v3-v4:
> > - refactor and reuse OvS code (Cong Wang)
> > - use csum API rather than skb_post*rscum to update skb->csum (Cong Wang)
> > - remove unnecessary warning (Cong Wang)
> > - add comments to uapi attributes (David Ahern)
> > - set strict type policy check for TCA_MPLS_UNSPEC (David Ahern)
> > - expand/improve extack messages (David Ahern)
> > - add option to manually set BOS
> > v2-v3:
> > - remove a few unnecessary line breaks (Jiri Pirko)
> > - retract hw offload patch from set (resubmit with driver changes) (Jiri)
> > v1->v2:
> > - ensure TCA_ID_MPLS does not conflict with TCA_ID_CTINFO (Davide Caratti)
> >
> > John Hurley (5):
> >   net: core: move push MPLS functionality from OvS to core helper
> >   net: core: move pop MPLS functionality from OvS to core helper
> >   net: core: add MPLS update core helper and use in OvS
> >   net: sched: add mpls manipulation actions to TC
> >   selftests: tc-tests: actions: add MPLS tests
>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
>
> I did have some conflicts applying the patches from patchwork (to diff
> v4 vs v5). Might be my process. This is clean against net-next, right?

Hi Willem, thanks for review.
See the note in the cover letter....
We had a patch accepted into net earlier in the week, these patches
are applied to net-next + that patch.
Unfortunately when we applied the patches direct to net-next and tried
to merge in net then we got merge conflicts that needed manually
fixed.
Basically, the above patches should apply cleanly to net-next once net
has been merged in.
