Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F9E20E018
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388079AbgF2Umd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731646AbgF2TOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:14:04 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A259CC08E876;
        Sun, 28 Jun 2020 22:30:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s14so6638498plq.6;
        Sun, 28 Jun 2020 22:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=RTxiRpvzpRJD0gmX8PNYXY4R+aOe0063njB+b000qww=;
        b=kzY0/e2RlK+glH8fy5i/IPcEaya89/gQceJy2XZKwDnqL9d5r3Ads9fMwoiYC8dQFl
         tGsiAxw6E1ivm5fMdTBlKLC2CDsBgTh3imQyb0NLPG4Sg5A1O/hEpKhplEcaBlh9nFfL
         Bxft3462dCCwN5bySfhnFQFNHIAa2M3LEyxk5MmP0XFEQeHAXPnJCeza+8oisGQWe0gI
         krWpMT5EVtn8JYUJrsUv9ZV7lUlvL56dzOCzpnbcGqzgd+vLGAM2gNEZw+2prJ4zsXrL
         5/s+Jtx8Qj6WEw7yVEHmakIDZ98JG8s3oDxv5v5RMik7n8iIZMkwxQk4GDBv+HcOeKOR
         tt/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RTxiRpvzpRJD0gmX8PNYXY4R+aOe0063njB+b000qww=;
        b=dbkCYOEE90lSntQi1IsdYNfb9ky42hz+hHKrtMFTap8ol72056lJDATwZn/mKtpbNz
         Wvo+ikzBLx8lXH4ekLyAPsm0KzqO4rEjs9BoJDXbUHPrfliC5cthWqVyu6C+5u2F/lAW
         053MVbTRVDNnPBfhyex/dkgGL1uDsyWNpmBOOsdS1x/CAJ+47CZhub/7O7bnJL4VvZsz
         60TbOo4LJzRq+WHNlDz437aAWbm/deILm4Us9/FC05WsiqYzJOesKhsq1DGol+crxBhr
         x0iskV9i97USqyw14QMgkeMHN0oQg4OdXKHZ/ER2dElHco7IT7r3fWZYc/L8565r+zGf
         UR7A==
X-Gm-Message-State: AOAM533seudzrXH/S3WzJJoQxtwLUMl85/uW4CVSx3GHEgj0MR7/FjFk
        l1k7BQs/iS4vs0axnEoNTRU=
X-Google-Smtp-Source: ABdhPJzbaDbjKQDAWCduVkv0WZ13VTrbYwK7Ufzf0M0t0w6OPbJqunP2vGqA4bI1Cdxiyv0yoaY3PQ==
X-Received: by 2002:a17:90b:381:: with SMTP id ga1mr16047548pjb.232.1593408609732;
        Sun, 28 Jun 2020 22:30:09 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id nl5sm19526826pjb.36.2020.06.28.22.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 22:30:08 -0700 (PDT)
Date:   Mon, 29 Jun 2020 14:30:04 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, joe@perches.com,
        dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] staging: qlge: replace pr_err with netdev_err
Message-ID: <20200629053004.GA6165@f3>
References: <20200627145857.15926-1-coiby.xu@gmail.com>
 <20200627145857.15926-5-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200627145857.15926-5-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-27 22:58 +0800, Coiby Xu wrote:
[...]
>  void ql_dump_qdev(struct ql_adapter *qdev)
>  {
> @@ -1611,99 +1618,100 @@ void ql_dump_qdev(struct ql_adapter *qdev)
>  #ifdef QL_CB_DUMP
>  void ql_dump_wqicb(struct wqicb *wqicb)
>  {
> -	pr_err("Dumping wqicb stuff...\n");
> -	pr_err("wqicb->len = 0x%x\n", le16_to_cpu(wqicb->len));
> -	pr_err("wqicb->flags = %x\n", le16_to_cpu(wqicb->flags));
> -	pr_err("wqicb->cq_id_rss = %d\n",
> -	       le16_to_cpu(wqicb->cq_id_rss));
> -	pr_err("wqicb->rid = 0x%x\n", le16_to_cpu(wqicb->rid));
> -	pr_err("wqicb->wq_addr = 0x%llx\n",
> -	       (unsigned long long)le64_to_cpu(wqicb->addr));
> -	pr_err("wqicb->wq_cnsmr_idx_addr = 0x%llx\n",
> -	       (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
> +	netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");

drivers/staging/qlge/qlge_dbg.c:1621:13: error: ‘qdev’ undeclared (first use in this function); did you mean ‘cdev’?
 1621 |  netdev_err(qdev->ndev, "Dumping wqicb stuff...\n");
      |             ^~~~
      |             cdev

[...]
and many more like that

Anyways, qlge_dbg.h is a dumpster. It has hundreds of lines of code
bitrotting away in ifdef land. See this comment from David Miller on the
topic of ifdef'ed debugging code:
https://lore.kernel.org/netdev/20200303.145916.1506066510928020193.davem@davemloft.net/
