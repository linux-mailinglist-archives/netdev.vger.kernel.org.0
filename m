Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BAF42E91E
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 08:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhJOGjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 02:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbhJOGjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 02:39:11 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13B2C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 23:37:05 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oa4so6567454pjb.2
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 23:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TusiGY9Id/oD51908hOFhgKlKHw5g+jeF6Iv+dmRSBk=;
        b=lH9JGXfqRpprxbxWiOgi7OJko8JZ8+8+6XeISMXirHJVIR1lKakRAJjNZHlW+Ib8Qg
         R06emWD2DUsOGIITYlNDoWmJBlsSUAW3pSxbFkRWd5Ja8GLQLy3s485DZdGV8tZdaSGl
         SzT8Lo137Pgaft698OjxGWfqcTP5eYLS6kXOLUsyOy/wZydy28IyYoUBapOX627T8FDO
         75420c5x7tEC7mcO93KdjdGD2emIMQhILzb1DbhNX59cwHU9+vMMQsVHANGoa4Bl/EPa
         8kigD20bdOqXz7zPbaLzzVmFGNJSXRpOY8myukx8UDna1MFZZFf8gt6dcM4Mo2yBJ8Rj
         4Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TusiGY9Id/oD51908hOFhgKlKHw5g+jeF6Iv+dmRSBk=;
        b=bJtFeqCbXfgrtiVGc3ng7zj0oEfYDE/+LH9QH4edgqy48K3eVsQtYuuTsPx4I/ITFy
         CD/G4bIGjFFfal+gH9FN0W0JehRLzBo+souyWmg3W2OGVbsLAewaHnKNI3AXPtsWkrvg
         QGLhTuamG9aKyGqaGiPOj3Qd7R3ItdSD0sNB1b0mehXaKCtDWBAGNuLwzO8kT1MzsstM
         /vSZUfUCRVm8XrAg5lRRIleUxXdCPuGltCL4RX0q9hzl9j5LoUPfOlPG0m5DPyCxVeSe
         it4oWJdn2nBUHhdWzaP3j+Q9sB/2ZnrS6EOfKowXwoVpkrJ4AkbL6nCijApcrG0BAU1T
         BO6w==
X-Gm-Message-State: AOAM530ni6w/j5k0CHOFvE6tVlqrYWEGECWNXL1UlbOj0seIXp4uBsnA
        7FQvbuZOy5eo8kFJ1LzNimk=
X-Google-Smtp-Source: ABdhPJxoo/72MfW/Ipk59ge8/0C3/EX3KvsLs8fmgcTPXQMutahjP+xjfaVAFsKx6lc0uOzC7S3YeA==
X-Received: by 2002:a17:90a:8912:: with SMTP id u18mr11213252pjn.69.1634279825506;
        Thu, 14 Oct 2021 23:37:05 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 14sm4095129pfu.29.2021.10.14.23.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 23:37:04 -0700 (PDT)
Date:   Fri, 15 Oct 2021 14:36:59 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 10/15] net: bridge: mcast: support for
 IGMPv3/MLDv2 ALLOW_NEW_SOURCES report
Message-ID: <YWkhi7iABEKygKaL@Laptop-X1>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
 <20200907095619.11216-11-nikolay@cumulusnetworks.com>
 <YWjsyk/Dzg2/zVbw@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWjsyk/Dzg2/zVbw@Laptop-X1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 10:52:00AM +0800, Hangbin Liu wrote:
> > -	mod_timer(&p->timer, now + br->multicast_membership_interval);
> > +	if (igmpv2_mldv1)
> > +		mod_timer(&p->timer, now + br->multicast_membership_interval);
> 
> Hi Nikolay,
> 
> Our engineer found that the multicast_membership_interval will not work with
> IGMPv3. Is it intend as you said "IGMPv3/MLDv2 handling is not yet
> implemented" ?

Ah, I saw in br_multicast_group_expired() it wait for mp->ports be freed
before delete the mdb entry.

And in br_multicast_port_group_expired() it wait for src entry freed first.

But when mod group src timer, we use
__grp_src_mod_timer(ent, now + br_multicast_gmi(brmctx));

instead of user configured multicast_membership_interval. I think we should
fix it. WDYT?

Thanks
Hangbin
