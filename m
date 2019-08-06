Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBDA82A0F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 05:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbfHFDiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 23:38:00 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45628 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbfHFDh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 23:37:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so37274106plr.12
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 20:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iTUIZrn2UCx1jsCAA6lR14LBO0TeNKIe7IeoTHeBk+g=;
        b=UeowZqZ6UlZTZMBrx71f+LilHHiFuZm1ZhGrxSNw1/b2riKOr9eFixDJc0WdzFBkO/
         VaHIk71IDeT7eQT6pwoQg09TjPg9LjcpZc4V0rakSaYvKKF/MiZYTRKpvy1+EgRLHmlp
         FCUKSjAv7VGdt7ZlXtN5XVyqN1UoJbeIe4NqDzsYQW7PG0ZE6ndLSAIycQnbtWAmk5zB
         +LPvdoR939tFTdTEJxkK/UFTFUpXRKHUu/JqglM5Ek1jez+wsQtqMzk7HDz+mSZhAxoq
         PBCS8Ok0duNrVKs5zmflhGxFl5xDusyHcvV0wjuFdIQQGcUSjQlefi7RwiBfbUy2nKw/
         hDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iTUIZrn2UCx1jsCAA6lR14LBO0TeNKIe7IeoTHeBk+g=;
        b=Lmqd7OaqVr4PD2aq1/m//G2i/n8B08przSST8nxncQKgr6PQtJeV7GcToapXkhhDwn
         P9HCRT3+I3Vfc+7LaqlPoTtmdp9MpM4zLGrNfXAo5DWGw4yHazGA/UidMqvKHUH2XWy/
         5FCb0ovdOiNx8RHMM+vO7w5Ff3bvYJmMhaGwqHt48wUINyNIAltPdgGch7ZVFYFKSZSo
         yuSlFTqf1yeLaMYdtuXbkbMBAc20z4VcjR3HWBi4VP/nVrJULOX2+UPSaVJKyDAzMdxP
         WsEM0rRtOy8jagt38H5GnKZmwe5PGZy2VEtRFtp308nUIPYMDTe0UCiCk97Ap0BMVllx
         SMGQ==
X-Gm-Message-State: APjAAAWAKdTh21xT7VxE6obN9EF0y6PIswqznF+NffrtpNhQD8MtuJch
        1NTvc4D7R3tFk8NqFmUzzh9Ge5EmZGU=
X-Google-Smtp-Source: APXvYqwKWTmq1ez4TP1y+z2irCx0ekSwXiQ3zg18mb/u64Fp9c4PxsuBOgscnSq+2fAsYwDRp6KI7A==
X-Received: by 2002:a17:902:b608:: with SMTP id b8mr990842pls.303.1565062679099;
        Mon, 05 Aug 2019 20:37:59 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y12sm96170564pfn.187.2019.08.05.20.37.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:37:58 -0700 (PDT)
Date:   Mon, 5 Aug 2019 20:37:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     jiri@resnulli.us, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/6] flow_offload: add indr-block in
 nf_table_offload
Message-ID: <20190805203734.79f81124@cakuba.netronome.com>
In-Reply-To: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  4 Aug 2019 21:23:55 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This series patch make nftables offload support the vlan and
> tunnel device offload through indr-block architecture.
> 
> The first four patches mv tc indr block to flow offload and
> rename to flow-indr-block.
> Because the new flow-indr-block can't get the tcf_block
> directly. The fifth patch provide a callback list to get 
> flow_block of each subsystem immediately when the device
> register and contain a block.
> The last patch make nf_tables_offload support flow-indr-block.

Looks good to me, thanks for the changes!

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
