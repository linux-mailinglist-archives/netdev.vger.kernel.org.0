Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB54E4690AB
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 08:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbhLFHQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 02:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbhLFHQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 02:16:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A80C0613F8;
        Sun,  5 Dec 2021 23:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09BA561170;
        Mon,  6 Dec 2021 07:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F96C341C4;
        Mon,  6 Dec 2021 07:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638774790;
        bh=RSgUA+v+bp+L38dAAFB/hBDb/dXcbT2mhCOpspbaGnY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JQBKdVhg15n7HyItHcM093NDs+sQSHY/dxi+0pQy6yJ1VADqQCLwYNAh08nkjNbVH
         N458Hf/XOKeT83zefnavdTzLG0c/07Ouy4F8YBjGUS45JvJSB6p27i36O+6wrZy5nu
         JO43hauKfKbVspsI0ER5f4zA9uTD8ympqLnSqM9RlhT61R9gbCQCwIkhlCRT2EFfRG
         UgWyQsdr0c2xAx4+I1dx8rf8NOO7x/vV6knAuzZ8ms02ZSqtyZDOwZ+vZR+S4f8KRt
         eM0E78APA9fRMf1Brk+jYifnTF2YnRZzYHPQ6VWpxykCJrp1f0vCyuYqBrmh2BmatQ
         mwwkOdu5ID3nA==
Date:   Mon, 6 Dec 2021 09:13:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Subject: Re: [PATCH v1 1/7] pid: Introduce helper task_is_in_root_ns()
Message-ID: <Ya24AjNDpO+uuLMT@unreal>
References: <20211205145105.57824-1-leo.yan@linaro.org>
 <20211205145105.57824-2-leo.yan@linaro.org>
 <Ya2yXZAn+36yhfdU@unreal>
 <20211206070358.GC42658@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206070358.GC42658@leoy-ThinkPad-X240s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 03:03:58PM +0800, Leo Yan wrote:
> Hi Leon,
> 
> On Mon, Dec 06, 2021 at 08:49:01AM +0200, Leon Romanovsky wrote:
> > On Sun, Dec 05, 2021 at 10:50:59PM +0800, Leo Yan wrote:
> 
> [...]
> 
> > > +static inline bool task_is_in_root_ns(struct task_struct *tsk)
> > 
> > It is bad that this name doesn't reflect PID nature of this namespace.
> > Won't it better to name it task_is_in_init_pid_ns()?
> 
> Yes, task_is_in_init_pid_ns() is more clear.
> 
> Will respin for this.  Thank you for suggestion!

Thanks

> 
> Leo
