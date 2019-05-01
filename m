Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5646010905
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfEAOYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:24:38 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:44690 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfEAOYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:24:38 -0400
Received: by mail-qk1-f175.google.com with SMTP id d14so6089432qkl.11
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1nDe3Q8lVrKLHD6e8iJ+WnXX7G5B73AT07ShH3QN+rY=;
        b=swluUk2V/bh3HjKNZICmITYVs/tov0A0sMmEMtxfMv32xhz7XcyHy9dfIj+kupBJ28
         Z7zCu+CVrOdz4JL08wzCNtgihRG9ZBFy/1LxVh8IsRSYvUZhmHfWbPxUAbq5pcl8j/sU
         RfRNCQXLdeZeweSiiLfHTGwg122gfYoZcoNbmUPrsouXWZqLD9BebvhWNkOsm5ZViZYr
         TnO2+15K+OcRrfxCBEfvSCx5y56I1qYjnaJHjBHFziPbVr+SJKVGQQJTbikXJAVNVz45
         nsui+G38ntKJDfbXFddXdAygz/NaoVhvfblerBV9H67BgI5CkopE3z479A/pfooRHIEf
         oivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1nDe3Q8lVrKLHD6e8iJ+WnXX7G5B73AT07ShH3QN+rY=;
        b=tdeYluuJj498JSKodGBeqXeFwBcQbfQnRoxSH2Vd9dBA3p+bgxkRLH+MMPZLDeAw7T
         xJxxiiN7Td/sVVYLHpCoqOqTHe10TaAiSUNojJRYdJGbv86DQjGLafIBFyyYU3EV4j1D
         JQm/7L2rn8GdznWf3FZFkGelLTMKQUuiHuIh1obYUap9Hjk2CzCNegf1ySePsByG0G85
         2S3Nr3aVotmDftCxLfsnRUBy4z6Xkj0MKyUXmoyy6M/2pi2ZnFhBK8yLJFKLhf9SfH1n
         Z+HApq6LSvBZgtFxuqlw7WvSH15sArtTEbblwFIW5QIgz5ivYuXRc4NJmovauWFRKUiI
         3hGw==
X-Gm-Message-State: APjAAAUDw2ocZr3+JaCaXCaVsB/62xxoEtEW6qtS/cFTZc3dqMPgp4xx
        MkfHQa5jC/9KfqcDisXvzXsHVQ==
X-Google-Smtp-Source: APXvYqxV5XfxqjY+SCPkXMvZD7CovAe5BjMtLdYKn/gXQa7IE6AxjkR1qb/HdWpRFZZQH+Kbf0Lh0Q==
X-Received: by 2002:a05:620a:129c:: with SMTP id w28mr3993092qki.232.1556720677380;
        Wed, 01 May 2019 07:24:37 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id l127sm6227761qkc.81.2019.05.01.07.24.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 07:24:36 -0700 (PDT)
Message-ID: <1556720675.6132.15.camel@lca.pw>
Subject: Re: mlx5_core failed to load with 5.1.0-rc7-next-20190430+
From:   Qian Cai <cai@lca.pw>
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>
Cc:     kliteyn@mellanox.com, ozsh@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 01 May 2019 10:24:35 -0400
In-Reply-To: <CALzJLG-5ZXeOrOa3rsVEF0nHrfkxJ=65nEH2H7Sfa9pYyDpmRg@mail.gmail.com>
References: <bab2ed8b-70dc-4a00-6c68-06a2df6ccb62@lca.pw>
         <CALzJLG-TgHP8tgv_1eqYmWjpO4nRD3=7QRdyGXGp1x_qQdKErg@mail.gmail.com>
         <CALzJLG-5ZXeOrOa3rsVEF0nHrfkxJ=65nEH2H7Sfa9pYyDpmRg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-04-30 at 20:26 -0700, Saeed Mahameed wrote:
> On Tue, Apr 30, 2019 at 8:00 PM Saeed Mahameed
> <saeedm@dev.mellanox.co.il> wrote:
> > 
> > On Tue, Apr 30, 2019 at 6:23 PM Qian Cai <cai@lca.pw> wrote:
> > > 
> > > Reverted the commit b169e64a2444 ("net/mlx5: Geneve, Add flow table
> > > capabilities
> > > for Geneve decap with TLV options") fixed the problem below during boot
> > > ends up
> > > without networking.
> > > 
> > 
> > Hi Qian, thanks for the report, i clearly see where the issue is,
> > mlx5_ifc_cmd_hca_cap_bits offsets are all off ! due to cited patch,
> > will fix ASAP.
> > 
> 
> Hi Qian, can you please try the following commit :
> 
> [mlx5-next] net/mlx5: Fix broken hca cap offset1093551diffmboxseries
> https://patchwork.ozlabs.org/patch/1093551/
> 
> $ curl -s https://patchwork.ozlabs.org/patch/1093551//mbox/ | git am

Yes, it works great!
