Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94648159D1A
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 00:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgBKXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 18:21:38 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43010 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727597AbgBKXVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 18:21:37 -0500
Received: by mail-qk1-f193.google.com with SMTP id p7so243756qkh.10
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 15:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k6wnqVPSgglSAa2jzfGrdcJSKkAA9j1ZzR0GOI//UxU=;
        b=do/IxJmSd/OubOQ5RwFhVD9QBIya7Z5mOcltWyrW01CJLjaUeStahjZB2dK+RLwse4
         TrZf0EWju1Wtn7/ulxCxLEMOU/XpFTs5gKtSagqjlCPKSIqxR0QBk53f0SL0AMOgezyj
         EdjEkz4vYUvhiQlky1q0zVczyxc8eQGTqzGoimqlenbot6qvplf+hp6CkmoF3zsdFkHd
         k+uBnyZPKo4jCmVz8jGIwuSdMKov3TX0wAVqCtaOW0sEKYs6JQvA2hIGjnSx9FxNWoT4
         zCrB6x0djWgnJwtA6viBNRZzVki8YKSWRgmsrARrF2pjBkUqzArmcfWBcjsVNMKKZFxE
         TQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k6wnqVPSgglSAa2jzfGrdcJSKkAA9j1ZzR0GOI//UxU=;
        b=kVnsgd/8rqsf0bVM/aA6x6nkmWBmilAiSEu+j07pUBpnxn8sZ8OUWKU9GW6D6O/+cA
         EqVQQEzCSFQjW6roFGln4zAYKwuSTTVipX7RXXI1tRrbg8wBiQbt8YywVszv4BxRISMt
         joBBVqkgafm521R/tD13IjrwM6pDpKrd3FCVfiMlDWpDp4gNPlBCyt16/ZrcSvTtRw2o
         dlXm+FnY+lFOLvzlMW0JcTEZKhsN5CvbKaUR6KL5ck3+9/VkrPjcuSURgfDkiJ/EeAd1
         7anRUyCc7wxGZsrwEDViLZo5+7DWbFvl3bS/7HxbP+Cdx2CgAWHYRNIsFCZGAQTRdJzL
         PRkQ==
X-Gm-Message-State: APjAAAVRTpiDDEmScKyz3Gpjflu7b7mvzN+UCD/zgGPZU34aNxyEPIf2
        Fijp4kUNd57FJ8v/WFzt79ZlDeui81yPny6AsrIMeg==
X-Google-Smtp-Source: APXvYqyap4aDivapOL3laxoS/w8LlCl/lS4w2877b7U5Zs7pf3zL+ax5VXySKpuoOzexWKAQpyjSWhKS9S//Xbsb1zg=
X-Received: by 2002:a37:a60d:: with SMTP id p13mr3203546qke.233.1581463296782;
 Tue, 11 Feb 2020 15:21:36 -0800 (PST)
MIME-Version: 1.0
References: <20200211223254.101641-1-saeedm@mellanox.com>
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date:   Tue, 11 Feb 2020 15:21:25 -0800
Message-ID: <CAL3LdT5Z1Ba5fsfCwqndcVgT+dYoeJAJ6Ph6BzuaQO=KBVppgg@mail.gmail.com>
Subject: Re: [pull request][net-next V3 00/13] Mellanox, mlx5 updates 2020-01-24
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 2:36 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> Hi Dave,
>
> This series adds some updates to mlx5 driver
> 1) Devlink health dump support for both rx and tx health reporters.
> 2) FEC modes supports.
> 3) two misc small patches.
>
> V3:
>  - Improve ethtool patch "FEC LLRS" commit message as requested by
>    Andrew Lunn.
>  - Since we've missed the last cycle, dropped two small fixes patches,
>    as they should go to net now.
>
> V2:
>  - Remove "\n" from snprintf, happened due to rebase with a conflicting
>    feature, Thanks Joe for spotting this.
>
> For more information please see tag log below.
>
> Please pull and let me know if there is any problem.
>
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
>
> Note about non-mlx5 change:
> For the FEC link modes support, Aya added the define for
> low latency Reed Solomon FEC as LLRS, in: include/uapi/linux/ethtool.h
>
> Thanks,
> Saeed.

Dave has not opened up net-next yet, or do you know something I don't...
