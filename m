Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F9137A3C8
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhEKJhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:37:36 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:43620 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhEKJh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 05:37:28 -0400
Received: by mail-wr1-f48.google.com with SMTP id s8so19430824wrw.10;
        Tue, 11 May 2021 02:36:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lKvDqLFt4pSvW/UjUfuGxRK9wnc82UFlNv4lfSox3SQ=;
        b=TuyL4C/k18fwrHfpsEM15BqzMjJ0K5QlHBgddl7GgePT54vrlRCE2nCbfrp28DynJR
         HemxwqOyXkaHDiXWD6vtKozmUPiKKVitfk5QTnI7HbGG8/ZamX9hBETmnocFfRYsiees
         OQYm22RW55dKFChV4bhJQNQtx+uojImviXyFei47WYhRph0xULgJswc/Jt+Noag+PCTO
         H3+eu0796nKRCz9bTv3QhZpFB8SBfOoX3HHH0WdP0+a/RMQn8KxXilqARFq5jXhv6No8
         NCFFBbwIj5lTnBYisaTXhXWLfjObEnkY6agLOBnlwYX+rtBaCgGjt/MCSOhhWRhCtdEG
         LfeA==
X-Gm-Message-State: AOAM532DLtNOevsO8HRlaDCnKVllYRCRJRpKVDhe4Over0VqWhnF9aiG
        FQIIppJKVloRUhs4UC7yvjo=
X-Google-Smtp-Source: ABdhPJzoPFT2EMMBDiIncbIHfUAbvXVf3ZD01iti4VHoAS+8gLGYEXHj0HcWmLvh5qXK2Pv0JB5KYg==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr32595880wrp.274.1620725780762;
        Tue, 11 May 2021 02:36:20 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id e17sm1256536wme.9.2021.05.11.02.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 02:36:20 -0700 (PDT)
Date:   Tue, 11 May 2021 09:36:18 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, mikelley@microsoft.com
Subject: Re: [PATCH v2] scsi: storvsc: Use blk_mq_unique_tag() to generate
 requestIDs
Message-ID: <20210511093618.fqcbno4iuvhnl66g@liuwe-devbox-debian-v2>
References: <20210510210841.370472-1-parri.andrea@gmail.com>
 <yq1k0o6ez1h.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1k0o6ez1h.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 11:22:25PM -0400, Martin K. Petersen wrote:
> 
> Andrea,
> 
> > Use blk_mq_unique_tag() to generate requestIDs for StorVSC, avoiding
> > all issues with allocating enough entries in the VMbus requestor.
> 
> Dropped v1 from the SCSI staging tree. OK with this change going through
> hv if that is easier.
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks Martin.

> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
