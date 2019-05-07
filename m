Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14630160C6
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfEGJXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:23:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35388 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfEGJXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:23:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id y197so18945902wmd.0
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GWMFFy2F73uQioGzc/atPqbskzKfI+KjLLT2AD39XqM=;
        b=QlqiBRnq5MeO6WyUYu58tC2adW0Dy1aOSpJJIKsvpiyk8mcOwUl6mrE6SZrXcGqC8L
         TOPe2/8CYhkuCE2QuICCzeYUkwWw6Pm5spncRPQVNzSqdxFAL8ezMNitllu5pFnr3qQ/
         5lavnJ5D99c16zVQsoanwHKnZm4d24syyxixouZPxU0c4oWz835xfWEW2P2biNMtVFtM
         1KXvisUtSAzy5q7lrCUzlJUeQfXh9d1b0zdYxww0tU/+sK1U1/5MCUMztLaNz9I6ZMdS
         f0+owXP0EAEDfOeLlsqS3J/RHLX16nBzMKadYke+ta+bOhszwGeqUesvhM9y6oeJKd/I
         Lg2Q==
X-Gm-Message-State: APjAAAWB0wq10hhoU1Rif62zA3VdoLzvQIADGuqFyCPMEIb82O8ACb+Y
        S9HO6sVN1PK84VbiEUBbOd5WhA==
X-Google-Smtp-Source: APXvYqznSrFaB6uyOHVbt0B0t1ukse7n+r+sBjTzNFN1gJDrpzuanPf8ms1kehTEDJTT1MzX9RHvpg==
X-Received: by 2002:a1c:4c09:: with SMTP id z9mr19795673wmf.87.1557220987708;
        Tue, 07 May 2019 02:23:07 -0700 (PDT)
Received: from linux.home (2a01cb05850ddf00045dd60e6368f84b.ipv6.abo.wanadoo.fr. [2a01:cb05:850d:df00:45d:d60e:6368:f84b])
        by smtp.gmail.com with ESMTPSA id s3sm26161021wre.97.2019.05.07.02.23.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 02:23:07 -0700 (PDT)
Date:   Tue, 7 May 2019 11:23:05 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, g.nault@alphalink.fr, jian.w.wen@oracle.com,
        edumazet@google.com, kafai@fb.com, xiyou.wangcong@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] l2tp: Fix possible NULL pointer dereference
Message-ID: <20190507092304.GA12570@linux.home>
References: <20190506144404.25220-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506144404.25220-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 06, 2019 at 10:44:04PM +0800, YueHaibing wrote:
> If alloc_workqueue fails in l2tp_init, l2tp_net_ops
> is unregistered on failure path. Then l2tp_exit_net
> is called which will flush NULL workqueue, this patch
> add a NULL check to fix it.
> 
Thanks!

Acked-by: Guillaume Nault <gnault@redhat.com>
