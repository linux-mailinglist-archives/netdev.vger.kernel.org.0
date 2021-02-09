Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9169314AA0
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhBIIp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhBIIoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:44:34 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DAAC061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:43:54 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 133so4709557ybd.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QKD+LfgYPVad1KdNmmugXgXYrqECs6LKgXsefo95DaI=;
        b=bm9iiYDjySpATAfMkMsb9IZ/v0iTwBtWYe9OjYxcrtvJK+SrZk/AdN7Y+fc2pMHkJN
         PY66FFRkOzViqqPpaLg0pxP8E2bgJ5333P16i1ZRGS/cDEqRV+n4Y3rL3614IT6QcLDv
         i1EjAVJXbKtFhBZ6DT2+0SQfdUUhtC2cSQXupH8+MJjjnNi4nNwQG6WwfUpADdCZp/pQ
         x4yMYMtHKq8M+U7j00XpRhUD7I7H29PBLx5haGdED4+Sp6hPe0WyxhvBQjIcFRqULpR3
         p8uvfwdtrI41F/+XJ79Ad1taEGJACoXnQlB1lzLcjP/NVVSOgFsADxyjIotpNZ2SOsK8
         o2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QKD+LfgYPVad1KdNmmugXgXYrqECs6LKgXsefo95DaI=;
        b=kg3jwqXmC+NHwL76Aw8x8/a2TKHNVIfRoziRivRYhOqkVBpWX7+qL3vhCQD2LxXnD2
         JMsKVHEIZGhT55KpibRdSsbn4AzlcrxhgLO0k4qhhR1+vtArnZHcg783Qvvt7STfrrTy
         obcXIBn+d2tE80ftS6vTiuQt4jhd/bS+S63IS4Wd9+oY7sQ8eEA7eNHVovby6mzYzY8k
         X2MJk0+bfxE3hlLjkq9Ll4kPm+UFrV+rW681DsEoRxp/D9kjp1JXIQHfIkwzHxVpnL1M
         sF2LEHiQswSmo5E03Vs9WBf8gOUJlxGHqqTXDwP7bLVqCBOMzV6aSjDlbpe4F5t2fL6m
         exyg==
X-Gm-Message-State: AOAM531a6MCBZJodRvx9w1cA7PJq8S2Cu+EgA0SVLkO2F3tmHIMfVUrC
        em2m6fUsbbiBIJoz2PujzkB13+vhcAZXZwmL3i8=
X-Google-Smtp-Source: ABdhPJwX993nSgCzGM3PeFTDeANG+qUExV3YCzvQtpk2p3v1spjD5xuFh7t66MijvyJ6ZmAMs5K1m1KN6G1tK7/ikkU=
X-Received: by 2002:a25:9383:: with SMTP id a3mr3858900ybm.215.1612860233652;
 Tue, 09 Feb 2021 00:43:53 -0800 (PST)
MIME-Version: 1.0
References: <20210206050240.48410-1-saeed@kernel.org> <CAJ3xEMhPU=hr-wNN+g8Yq4rMqFQQGybQnn86mmbXrTTN6Xb8xw@mail.gmail.com>
In-Reply-To: <CAJ3xEMhPU=hr-wNN+g8Yq4rMqFQQGybQnn86mmbXrTTN6Xb8xw@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 9 Feb 2021 10:43:42 +0200
Message-ID: <CAJ3xEMi3SMP2vqjWYuX8RFJeXSrr9gPdxYF4UqiNtmCt=QL2NA@mail.gmail.com>
Subject: Re: [pull request][net-next V2 00/17] mlx5 updates 2021-02-04
To:     Saeed Mahameed <saeed@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 10:42 AM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> On Sat, Feb 6, 2021 at 7:10 AM Saeed Mahameed <saeed@kernel.org> wrote:
> > Vlad Buslov says:
>
> > Implement support for VF tunneling
>
> > Currently, mlx5 only supports configuration with tunnel endpoint IP address on
> > uplink representor. Remove implicit and explicit assumptions of tunnel always
> > being terminated on uplink and implement necessary infrastructure for
> > configuring tunnels on VF representors and updating rules on such tunnels
> > according to routing changes.
>
> > SW TC model
>
> maybe before SW TC model, you can explain the vswitch SW model (TC is
> a vehicle to implement the SW model).

I thought my earlier post missed the list, so I reposted, but realized
now it didn't,
feel free to address either of the posts
