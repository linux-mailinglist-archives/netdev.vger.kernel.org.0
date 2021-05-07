Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FAD3764F6
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 14:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhEGMR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 08:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEGMR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 08:17:26 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DB1C061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 05:16:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ge1so5006090pjb.2
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 05:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=osLA+N5+/yPxUTkyQAvhQjWeRK9OI8nDjHvyfTBAKBA=;
        b=MC6iUnrC3GhBMGMuIooOcJcOFIznF4cuIq2rSz4t1yJ9KV2t+NLf8DBpGojj69vTth
         74XUQZ03oJtRXeGyw/rnBCGAAvKicyjUlKB9T4T3il3UWln295iJm4Dz7YplGT+qILjP
         2CILxlaIO00QlSoZaxO+w7r5O/szYlVzwNeCGCsrKp90aPSdV5IV1bxyFOxasBjyICW8
         MsqEJ2ujDI/TVwc9wWYkTEgp8cMp6seHAPFOfIWNQWDKH8y7zeIRZGk6DXm6XKpIaCvZ
         g28MZFd/GCPeR152DQCLV4yPtFaXdPYy7yEMl4uwcnNl40wCg/adT6sQcRJQCRkEZnbO
         BnhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=osLA+N5+/yPxUTkyQAvhQjWeRK9OI8nDjHvyfTBAKBA=;
        b=pvM2qlG3gWX1gyhtJETSwxU7Gh0uD7P/gpavNgXzuLXwRi2ZvSwNKknKcq5fh1A6ow
         LHRxUseRsyY/IGk2pcCU/IQsyfH8OIsryrYte6KYFKXMVdIHzLZvVOpi0MZ3Vdi0SVKw
         5r+XjsLd8a3gCbohZx0oJVfhhcYn/xUtfcfmB8Vo+W/zrZQkPZPHIDQHvvdlwUF2eVuN
         1v6m9CAY7wTZC3ymhpsU0LI7Fxhu3eJ5g2vo6Wn/W87KLkkrrhAOQ4+Zy2eQ3KChEVuz
         E/hsHbvKgA5ReK9FaZRkefCF02UkmSyk7GqiIFZnshDJpq5C3qZJOOISZxI9dVKDMreC
         vEdQ==
X-Gm-Message-State: AOAM531x8AWO/xe7YkbzH58mB2n7sdKt9qRUlfK6uz35skI+0hxLBbNV
        kgqUAogsM2fsGauH6ONv4mECuVeB9Ivlrg==
X-Google-Smtp-Source: ABdhPJx56GYI1hjW33t8ygTwRYATeIy83E4ZUlD23kIRhvHONyXZYbqfMwayvdQfi65VfnTS39yjkg==
X-Received: by 2002:a17:90b:893:: with SMTP id bj19mr10134512pjb.6.1620389785398;
        Fri, 07 May 2021 05:16:25 -0700 (PDT)
Received: from f3 ([2405:6580:97e0:3100:aa70:cc22:57b3:3739])
        by smtp.gmail.com with ESMTPSA id e24sm1765692pgi.17.2021.05.07.05.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 05:16:24 -0700 (PDT)
Date:   Fri, 7 May 2021 21:16:20 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: About improving the qlge Ethernet driver by following
 drivers/staging/qlge/TODO
Message-ID: <YJUvlC6RVGuonNmu@f3>
References: <20210504131421.mijffwcruql2fupn@Rk>
 <YJJegiK9mMvAEQwU@f3>
 <20210507013239.4kmzsxtxnrpdqhuk@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507013239.4kmzsxtxnrpdqhuk@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-07 09:32 +0800, Coiby Xu wrote:
[...]
> > > > * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
> > > >   qlge_set_multicast_list()).
> > > 
> > > This issue of weird line wrapping is supposed to be all over. But I can
> > > only find the ql_set_routing_reg() calls in qlge_set_multicast_list have
> > > this problem,
> > > 
> > > 			if (qlge_set_routing_reg
> > > 			    (qdev, RT_IDX_PROMISCUOUS_SLOT, RT_IDX_VALID, 1)) {
> > > 
> > > I can't find other places where functions calls put square and arguments
> > > in the new line. Could you give more hints?
> > 
> > Here are other examples of what I would call weird line wrapping:
> > 
> > 	status = qlge_validate_flash(qdev,
> > 				     sizeof(struct flash_params_8000) /
> > 				   sizeof(u16),
> > 				   "8000");
> 
> Oh, I also found this one but I think it more fits another TODO item,
> i.e., "* fix weird indentation (all over, ex. the for loops in
> qlge_get_stats())".
> 
> > 
> > 	status = qlge_wait_reg_rdy(qdev,
> > 				   XGMAC_ADDR, XGMAC_ADDR_RDY, XGMAC_ADDR_XME);
> > 
> > [...]
> 
> Do you mean we should change it as follows,
> 
> 
> 	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
> 				               XGMAC_ADDR_XME);

	status = qlge_wait_reg_rdy(qdev, XGMAC_ADDR, XGMAC_ADDR_RDY,
				   XGMAC_ADDR_XME);

> 
> "V=" in vim could detect some indentation problems but not the line
> wrapping issue. So I just scanned the code manually to find this issue. Do
> you know there is a tool that could check if the code fits the kernel
> coding style?

See Documentation/process/coding-style.rst section 9.

You can search online for info about how to configure vim for the kernel
coding style, ex:
https://stackoverflow.com/questions/33676829/vim-configuration-for-linux-kernel-development
