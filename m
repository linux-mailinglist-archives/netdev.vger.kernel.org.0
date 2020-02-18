Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47D8162973
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 16:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgBRPb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 10:31:58 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:38781 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgBRPb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 10:31:58 -0500
Received: by mail-qv1-f66.google.com with SMTP id g6so9324030qvy.5
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 07:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kgJ5e0m8kd/eylgSGLtBqafsT7upwZtQRw5yQE+pirM=;
        b=f51uQV6i7RVkrbx35fo2wuAJb0tIk2Bd5VBqaE+QTvKvZM0H17D4jnCkx+P5LnsVS2
         0sLbnJHbsywlbXjspB/46wsxzvgT4fOl6Iny4AgvbwB77w+Qa/bSCBKiYtbIWF+XjzsH
         IJRwoqvZLP3lJ22QL/qCc1DCXiBpRKbBN5YSv3iFowWnKQ1VndIUytutUNa9CINZXtCY
         fagp3j8ephAPkFdN1O5oictuRN94608XOQGQ7Fii43pox2FDWjcLvyeIJICDmnaRbVUv
         VZjYooOw14reftQho/d9ydWUR3MFi8tIFFgRtjUxYzgcb66pLXFxxW4CmzD94J3oXgZH
         o9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kgJ5e0m8kd/eylgSGLtBqafsT7upwZtQRw5yQE+pirM=;
        b=ZxXoa7jbWYYmA2Gvu9ROG2SEWJc+FuOkFf3GK/5i7F30Od0iIvGfg+GCNzsGS00Jpk
         h7mbcwqyN/BIvc7kp2dLilmrptybB+NNsRA5IAfM8l0gxVFbzUuB1HnoMK2umnL/eWA5
         GQN/DXs/6JR4d2DXgiBED5CU5GEGANM6GG/BQ8fddE8Z0Jg9mwlxW2nA6ZGHVoufX6Dt
         yyUk0IPv/4OPU18sqa00K1FfnMzHDmKUNjkIwstsa3br0F3oWfKw8YIHas/b/IwOGvzO
         lU2AqZBbCD2mVv3on6FKUtebL9zcnSP+Ysy8VIe/Bpomdlaf1UOYzTZoBS4sGrwnmnNx
         uvRA==
X-Gm-Message-State: APjAAAXtM6cuwj6451BxfhYw09QUt9LHm006fiXbG5CillKgBhDkuWuG
        k4rNeOQm9hgK+JpWWVUX+k/q1Q==
X-Google-Smtp-Source: APXvYqw/R8COveSuTpqp0dXDAaA0eGnoHLgn18YUnQmKmhmu5CMtb9VaqHrK46bkt1Myyi7keMmjIA==
X-Received: by 2002:a05:6214:1090:: with SMTP id o16mr17291199qvr.105.1582039917062;
        Tue, 18 Feb 2020 07:31:57 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id v10sm1935968qtp.22.2020.02.18.07.31.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Feb 2020 07:31:56 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j44qq-0005P0-5P; Tue, 18 Feb 2020 11:31:56 -0400
Date:   Tue, 18 Feb 2020 11:31:56 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lang Cheng <chenglang@huawei.com>
Cc:     dledford@redhat.com, leon@kernel.org, davem@davemloft.net,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [RFC rdma-next] RDMA/core: Add attribute WQ_MEM_RECLAIM to
 workqueue "infiniband"
Message-ID: <20200218153156.GD31668@ziepe.ca>
References: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581996935-46507-1-git-send-email-chenglang@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:35:35AM +0800, Lang Cheng wrote:
> The hns3 driver sets "hclge_service_task" workqueue with
> WQ_MEM_RECLAIM flag in order to guarantee forward progress
> under memory pressure.

Don't do that. WQ_MEM_RECLAIM is only to be used by things interlinked
with reclaimed processing.

Work on queues marked with WQ_MEM_RECLAIM can't use GFP_KERNEL
allocations, can't do certain kinds of sleeps, can't hold certain
kinds of locks, etc.

Jason
