Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FD71C282A
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 22:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgEBUJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 16:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728107AbgEBUJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 16:09:09 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D047C061A0C;
        Sat,  2 May 2020 13:09:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id p25so3381982pfn.11;
        Sat, 02 May 2020 13:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=em8vZ+PgEWtvxg7M8kYifNWj1sZL7mr8nrqD/vdWn/o=;
        b=SA1u9wHD+JYjE7MAjNxdtKNHBBVQmvRN4hrVMsVqiTBuDUluzk++VjK11bKGpMiTB5
         AlaOT+PCDnELLGmNoNMVx7fybtoGi1V+tloNv3SSfzoNDVY6bEOsd3kJNUhBhw0itGBE
         De5qKtDXYDJCHFhNI06Th1E7bl7IDiJKmlekLmmcATEK0g2N6h80maZT2d/PkZUnGpRA
         YPWxuDXsVVprg901yQNi0jhJHx2AHkhCZBiczGUXHT2EnvmmRHQqxAmi4MhLoAK+j3Bi
         mKtfgZTpP8kInoxDAX6zIILFJYTWEVI6M/h3UGRU12t0BwTVYuqdCLKjo+jRvDNWiBdn
         K/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=em8vZ+PgEWtvxg7M8kYifNWj1sZL7mr8nrqD/vdWn/o=;
        b=TMsP4y0Lu7+TVKLS1/UOHI8lyl1R9Yqx/q5eAbIbWAFJ/n5DkJbm1M2KtopqxnWyhI
         BlvbMUn4ef6rrHfa6HBE/umDtH7gECclCVxS5sSc/s3uR/v5T5+gyhrGVNruhj9rR47e
         9ofKRKt0k0bDVK/4ABfV90DWgbZfgYSXhI8SPWLPjs0RFeGDjHn4dNUrdYgvUVmEv0+0
         uXuqnteixbZkOQdmJzCgHMbiGGK0x6IQ61cHKV/0cCFwVUGZ2BJLk2ps8GbhjOJCN7u6
         1NTgQ4p6pR08zqfE+5/I3HuAZc9x+DEda9HuaAS2dQawfsoYO4iPvC7ucizIYHxjvF1T
         Ja4A==
X-Gm-Message-State: AGi0PuYNpbqU7zmo40plL+nfVNPIfF+p0EQ31DfEEtiPzVS7xs5qLgPo
        rG0z007X01wApnuCKJD8qFGjylsQ
X-Google-Smtp-Source: APiQypLLNL3K9X2yQT7/iIgkr2pAUhFAJdbV8AYJr6+l9jhIL8YNQy2v0TCcDJYcs0ajVbp3Bs5sVQ==
X-Received: by 2002:a63:e550:: with SMTP id z16mr10218280pgj.104.1588450148757;
        Sat, 02 May 2020 13:09:08 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z23sm5084937pfr.136.2020.05.02.13.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 13:09:08 -0700 (PDT)
Date:   Sat, 2 May 2020 13:09:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     vincent.cheng.xh@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/3] ptp: Add adjphase function to support
 phase offset control.
Message-ID: <20200502200906.GA30104@localhost>
References: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588390538-24589-2-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588390538-24589-2-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 11:35:36PM -0400, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Adds adjust phase function to take advantage of a PHC
> clock's hardware filtering capability that uses phase offset
> control word instead of frequency offset control word.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
