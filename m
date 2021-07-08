Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2736A3BF484
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhGHEVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:21:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56174 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhGHEVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 00:21:22 -0400
Received: from mail-pj1-f70.google.com ([209.85.216.70])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1m1LUm-0004aW-2Y
        for netdev@vger.kernel.org; Thu, 08 Jul 2021 04:18:40 +0000
Received: by mail-pj1-f70.google.com with SMTP id v4-20020a17090a4ec4b02901731757d1a2so2788572pjl.4
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 21:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4G9i8vQWT5nXUI2uXZLc2Au8KV/9r+vg878BWJ9X0yw=;
        b=f3lTyhw73EMwM9x0vxmmpzSsMoLw1ZIyd9zqSYuVLaF78jSM91Vj8cUM6ZEi8qHN5+
         J9XhWM6fCpH2Lsre53QZKpKNRh3VtvLoyTV5G+ZAPG5OAqUKvXslfGdF2TP+yQUIG8lq
         5fWMTnICvpf8AreksJ2qPpug0zc/1x2KGE8/nyTEVcSYQu3xdIhALDEij58+JwmY5Yfa
         qRAzSvMB0vUrFpjiWk1YpbDGNMDX/ms28mY28HDEi0p7kHQN9AodkcEBB/Rbfykc51r5
         gBaRLq0zi3WIBO7tDu9wnbCu3AJAo4DxqmwHAW/op/CsQu9bFbKYyqVFs/zLa2RgxVwl
         Rlgw==
X-Gm-Message-State: AOAM533d7rkP/D2orLYTQp8e5FpJc2lWJVdjDUkim20VNH8Aznwew6Fp
        5JrJzD0Breaq4VvOOCkgW/h7d/LtBKXTEa270d/lZG86Z+DbxtchNyGuJO2A2LMLFvbaKwSx7PA
        qh0nb1mtsYXrFKa6NNeNZb95P+bLqzxYs/N70Y8kizD+uyml+
X-Received: by 2002:a65:6659:: with SMTP id z25mr29667112pgv.291.1625717918562;
        Wed, 07 Jul 2021 21:18:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy73Par1gV7DO9u9OB55lNW9eOWHyS+LnBRXdrclf95y+wZHPdXg7cl+6HhiGgE6qOgbxg95hFBfk9zlpCAcZY=
X-Received: by 2002:a65:6659:: with SMTP id z25mr29667086pgv.291.1625717918266;
 Wed, 07 Jul 2021 21:18:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210525113316.25416-1-po-hsu.lin@canonical.com> <87y2c1swnz.fsf@nvidia.com>
In-Reply-To: <87y2c1swnz.fsf@nvidia.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Thu, 8 Jul 2021 12:18:26 +0800
Message-ID: <CAMy_GT_4dqEuSfUGND9GTBxGORcwf480-a46Z=J736YHo2RkDA@mail.gmail.com>
Subject: Re: [PATCHv2] selftests: Use kselftest skip code for skipped tests
To:     linux-kselftest@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        shuah <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        ast@kernel.org, Petr Machata <petrm@nvidia.com>,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        nikolay@nvidia.com, gnault@redhat.com, vladimir.oltean@nxp.com,
        idosch@nvidia.com, baowen.zheng@corigine.com, danieller@nvidia.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 4:54 PM Petr Machata <petrm@nvidia.com> wrote:
>
>
> Po-Hsu Lin <po-hsu.lin@canonical.com> writes:
>
> > There are several test cases still using exit 0 when they need to be
> > skipped. Use kselftest framework skip code instead so it can help us
> > to distinguish the proper return status.
> >
> > Criterion to filter out what should be fixed in selftests directory:
> >   grep -r "exit 0" -B1 | grep -i skip
> >
> > This change might cause some false-positives if people are running
> > these test scripts directly and only checking their return codes,
> > which will change from 0 to 4. However I think the impact should be
> > small as most of our scripts here are already using this skip code.
> > And there will be no such issue if running them with the kselftest
> > framework.
> >
> > V2: router_mpath_nh.sh and outer_mpath_nh_res.sh sources lib.sh,
> > there is no need to assign ksft_skip value in these two.
> >
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
>
> I want to note that defining ksft_skip=4 in every test separately is the
> current practice. I agree with Willem (in a parallel thread) that this
> stuff should live in a library of its own, but there is none currently.
> When there is, it looks like the conversion would be mechanical.
>
> Which is to say, IMHO this patch makes sense on its own as an
> incremental improvement.
>
> Reviewed-by: Petr Machata <petrm@nvidia.com>

Hello folks,
any other comment on this patch? Or if I should break this down to
smaller patches for different suites in kselftests?
Thanks!
PHLin
