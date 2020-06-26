Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A302D20B3FB
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgFZOs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729460AbgFZOsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 10:48:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58848C03E979;
        Fri, 26 Jun 2020 07:48:25 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so9615727ejb.11;
        Fri, 26 Jun 2020 07:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uFkU3CTu0x26snxvjGxWKaEDCMpwNzU6I/jnielwKPU=;
        b=mXcWS3tlV88c2J5fXkNnahhb55+0qc7DNjnqu/NTkjeP+C++AgPYnvBH8GwfIJT6at
         t3LLpWHfB9DA6W9dBYDNEpuVfn1G3IjSVQQp8GDYzG9S+54uGNxGe1jt4tNwyW0kzntO
         ZmoEKNcZaVnbdPS0Y0bmt2fkaUm1BOBATwmU1w4UFpclqbXeBF+jjveJrr5DnKs7IOTD
         EHQYjjPGyySpQs9gq27ygFWvOxzTqoT7IiP56ozDRQDRwnOvwzdIRtz+Z3Sy5IJTDl0q
         3kF6EZq0Y69AB9agzv0P3QpGJnLTzNXlXccwKL+yehk2cjI2YQD1bdZwh6EbJL0EWpyi
         H5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uFkU3CTu0x26snxvjGxWKaEDCMpwNzU6I/jnielwKPU=;
        b=NiySxcgOJIGNHXmjoLNyD14TG4NVdCGt7HXEO4v+xVvYlkh7IntTM27A17r3ohdsZq
         VzRyhYniIUUMReau9VLfQWe30us/Gqi1T6K3gu7Al3nreBbKbqHX0x92WN2kOKwGk3DN
         iqwDTMTfPS0eaKDcMv058vv3gNuKGybfYqW5TJkRUK2uycxKx0B7tOystRwfRkWqG/rW
         2GTv+S8eTyR84InE8O6OkY6oMO9Vkm74K/FTz6am1MAGpsPyTSEBhPSsHr0LRkUpG+5O
         EWAGU/e/TEa0VZdbV0QZ5OP7Xx40s9SZEntqo/GjFLS6Du65wNlt+BWuNV2lcsaG50GM
         +wpg==
X-Gm-Message-State: AOAM531D46Ug/4k6mDZlYyoAoEZrsGUFycQqUOO6rBZLyQT36eW858ET
        UtKjna+XBJR/GIVF46ouwmq9hy90w40e9Hxw
X-Google-Smtp-Source: ABdhPJzwjxRk5el3GSGQTCppEokhkYfYXybbRsAJ8LuoXMZT8IpDF6hSoTtKnAr/1tNEmrfLgSqjOA==
X-Received: by 2002:a17:906:bb0c:: with SMTP id jz12mr2789278ejb.27.1593182903901;
        Fri, 26 Jun 2020 07:48:23 -0700 (PDT)
Received: from andrea (ip-213-220-210-175.net.upcbroadband.cz. [213.220.210.175])
        by smtp.gmail.com with ESMTPSA id ay27sm613733edb.81.2020.06.26.07.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 07:48:23 -0700 (PDT)
Date:   Fri, 26 Jun 2020 16:48:17 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Andres Beltran <lkmlabelt@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 0/3] Drivers: hv: vmbus: vmbus_requestor data structure
Message-ID: <20200626144817.GA1023610@andrea>
References: <20200625153723.8428-1-lkmlabelt@gmail.com>
 <20200626134227.ka4aghqjpktdupnu@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626134227.ka4aghqjpktdupnu@liuwe-devbox-debian-v2>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 01:42:27PM +0000, Wei Liu wrote:
> On Thu, Jun 25, 2020 at 11:37:20AM -0400, Andres Beltran wrote:
> > From: Andres Beltran (Microsoft) <lkmlabelt@gmail.com>
> > 
> > Currently, VMbus drivers use pointers into guest memory as request IDs
> > for interactions with Hyper-V. To be more robust in the face of errors
> > or malicious behavior from a compromised Hyper-V, avoid exposing
> > guest memory addresses to Hyper-V. Also avoid Hyper-V giving back a
> > bad request ID that is then treated as the address of a guest data
> > structure with no validation. Instead, encapsulate these memory
> > addresses and provide small integers as request IDs.
> > 
> > The first patch creates the definitions for the data structure, provides
> > helper methods to generate new IDs and retrieve data, and
> > allocates/frees the memory needed for vmbus_requestor.
> > 
> > The second and third patches make use of vmbus_requestor to send request
> > IDs to Hyper-V in storvsc and netvsc respectively.
> > 
> 
> Per my understanding, this new data structure is per-channel, so it
> won't introduce contention on the lock in multi-queue scenario. Have you
> done any testing to confirm there is no severe performance regression?

I did run some performance tests using our dev pipeline (storage and
network workloads).  I did not find regressions w.r.t. baseline.

  Andrea
