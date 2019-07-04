Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0B15EFF2
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfGDAJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:09:17 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42930 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGDAJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:09:17 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so2061167plb.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5mOBbD0b6LpDmmqGjNnooS5lIbr3Uusp3YUIjpl0y/E=;
        b=Aqss6wjPKATPd0ySdPgcCOxC9/pOHqNLfZp79UbFb1H5O52aT2YvdDf+jM4X6AGqmr
         xrKW7o1HI2ivQU/oT4BVgiZEwM0By50VptDaR3lqn3bqS12dGTg/d2gYmfBEqrFVXi1h
         R9icY7Rviz4jecX6um4Xr6NZ3kFgUi47dU+AE87uosw+sJNfsBKzmMlDTHSUJ+xKn7ML
         6hST6HMqQcxkB02v+MrEz1hTzX3XymTFXfaGBl7/h6eIQr3ZV8riJnHnqWM81JBxhMbk
         Weq1ctOEWHThrlA0OMEx4sk2qEodn3N8nIcwJVeULrLL09ELIhEFAyOYmzN1l35Fsphd
         rbsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5mOBbD0b6LpDmmqGjNnooS5lIbr3Uusp3YUIjpl0y/E=;
        b=aJEVn6JsRTAdA0zXnWZCaQXJojB7SoCcwXhGm2YCJQsDjBVdDt6XstKMRN/zU7e+cO
         vppA27BdJuclg1u/fIiGwwO84BuQL8bzg4jmhJTIXBGsjb1HTACXJhwdn5K6crWH3CVQ
         Co/lBXl2OCkZfsTyNUhuCUgsmuLQXjnnKTvnhHN1zMC4NcuCqY0jO46xCWJmb+tTPte5
         8nWFQB9g5Aylo22dUTgIH/HOQojkFA/tRQxUb/ODgWnb5eHbvPaWfO8rYiNfaWQSKC5d
         tPvCYV1LX94QSiFryYLe11Ao+PJ/4bKqOvVepXcwxNAjotxAe/nAGiN60WraFTDBTRv4
         C2ag==
X-Gm-Message-State: APjAAAVwanAelOlWax28zoFlMv6gCXU/5oVnu97og9dSJSevSa3sHxjJ
        N/mFhVair1Jz3UbYCqhFdnz9DtZ6VKnd/VtBpY2U7rgc
X-Google-Smtp-Source: APXvYqw+N+b069XUhO72FWcih/V5nWltPZnb6SD+hVEkGkzHyo24Tb0AvTzjU2TjCFc/tUvHvNpHxzRHRagSyKbsClo=
X-Received: by 2002:a17:902:2aa8:: with SMTP id j37mr43484982plb.316.1562198956570;
 Wed, 03 Jul 2019 17:09:16 -0700 (PDT)
MIME-Version: 1.0
References: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1562113531-29296-1-git-send-email-john.hurley@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 3 Jul 2019 17:09:04 -0700
Message-ID: <CAM_iQpXkV_T9+q1txKFRFtBxSU3dKKHS8dNPnZfvrF0F21kM4w@mail.gmail.com>
Subject: Re: [PATCH net-next v5 0/5] Add MPLS actions to TC
To:     John Hurley <john.hurley@netronome.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 5:25 PM John Hurley <john.hurley@netronome.com> wrote:
>
> This patchset introduces a new TC action module that allows the
> manipulation of the MPLS headers of packets. The code impliments
> functionality including push, pop, and modify.
>
> Also included are tests for the new funtionality. Note that these will
> require iproute2 changes to be submitted soon.
>
> NOTE: these patches are applied to net-next along with the patch:
> [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
> This patch has been accepted into net but, at time of posting, is not yet
> in net-next.

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks for the update.
