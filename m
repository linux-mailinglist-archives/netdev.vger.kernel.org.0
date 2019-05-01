Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A74EE10432
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfEAD0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:26:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43353 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfEAD0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:26:35 -0400
Received: by mail-lj1-f193.google.com with SMTP id t1so4529847lje.10
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 20:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W0h2UcYR7m6/sZil5T2HHxyvcwRmfJqw2U6FSdGaFy0=;
        b=OJrabn9goIjqZyD69xvhOHnyvm0N5S5rWwjABo7MAJVtksrGN3U68niREQRxPC12Z1
         LXOGu7oyPwirXjar4qO2fIQRjyjflsG+xCrjJx6Ir+H1jtGL/zfwXuwZPQdQLNh9jCqs
         k/iSnFGJq2OH9CCeNTH2pcgl7I5Exo+VfMZiXfUJZwF9c8//xVpZY83TcaQtgfh22ROL
         EYpITz43tq9PldzV2mUdxQG7yELAIpQVKZZjRU8W5BMVnkp7PIKJRdTF+4oU0cTrNQr7
         Xf/uqPsHfII9Yvq2KZTWAAGeeQUvNe9SF5uyRKeCgGAzy7MIEh/IEwcOpDXLYvonAaFG
         6A+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W0h2UcYR7m6/sZil5T2HHxyvcwRmfJqw2U6FSdGaFy0=;
        b=MxyxLzmE9h/v1JLJTvF3n1LDJX2BsTwj4Xi7QIc9Xrv+4FpweeR5HvxubCPyxpuWXn
         KS+wbRAhFsoLTaCUxRu4wyRWD3SYUnpvnO8GEwhCZzBuZUYbYar5l5tEuQoaGypT3kiu
         0u/jIe6xZ0WdVRIX3rU/qAyNZcrNxruE7fZaVl7mOx1VxjaL+sHOTlniLgvwY6gIPzXH
         gPrJDJvzxL/xrJ7qkGOpB7FFRTVDsFr648CT2IZL5lDVmuqdGvNoeoA4m9++qm9QWvc7
         fLtxWXC37kOFi6p65hXJi7j/a0vRhejqKfmzv538HTj7QjbEm2FjzI+bcCln9LlGhx79
         QgTQ==
X-Gm-Message-State: APjAAAW2Xqjt1YY9Zw89ok9EEGReywCS+KIRiDVHv4K2eyjv/KUg1wfp
        oGvEll1/wwvHAoDGaDhIPyGLYTQZWRrliJ9qRCPsrQ==
X-Google-Smtp-Source: APXvYqxPIZOH158rwrHgU+AjL9eIv7npz8JKZkqMUzHMJwbDm+jLiZrjLbfYsez0J5Bh0Gg+09Mew5lAG1LqPYcuTwc=
X-Received: by 2002:a2e:9241:: with SMTP id v1mr15376751ljg.6.1556681193158;
 Tue, 30 Apr 2019 20:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <bab2ed8b-70dc-4a00-6c68-06a2df6ccb62@lca.pw> <CALzJLG-TgHP8tgv_1eqYmWjpO4nRD3=7QRdyGXGp1x_qQdKErg@mail.gmail.com>
In-Reply-To: <CALzJLG-TgHP8tgv_1eqYmWjpO4nRD3=7QRdyGXGp1x_qQdKErg@mail.gmail.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Tue, 30 Apr 2019 20:26:22 -0700
Message-ID: <CALzJLG-5ZXeOrOa3rsVEF0nHrfkxJ=65nEH2H7Sfa9pYyDpmRg@mail.gmail.com>
Subject: Re: mlx5_core failed to load with 5.1.0-rc7-next-20190430+
To:     Qian Cai <cai@lca.pw>
Cc:     kliteyn@mellanox.com, ozsh@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 8:00 PM Saeed Mahameed
<saeedm@dev.mellanox.co.il> wrote:
>
> On Tue, Apr 30, 2019 at 6:23 PM Qian Cai <cai@lca.pw> wrote:
> >
> > Reverted the commit b169e64a2444 ("net/mlx5: Geneve, Add flow table capabilities
> > for Geneve decap with TLV options") fixed the problem below during boot ends up
> > without networking.
> >
>
> Hi Qian, thanks for the report, i clearly see where the issue is,
> mlx5_ifc_cmd_hca_cap_bits offsets are all off ! due to cited patch,
> will fix ASAP.
>

Hi Qian, can you please try the following commit :

[mlx5-next] net/mlx5: Fix broken hca cap offset1093551diffmboxseries
https://patchwork.ozlabs.org/patch/1093551/

$ curl -s https://patchwork.ozlabs.org/patch/1093551//mbox/ | git am

Thanks,
Saeed.
