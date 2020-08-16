Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7815245585
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 04:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgHPC5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 22:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729929AbgHPC5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 22:57:22 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEC7C061786;
        Sat, 15 Aug 2020 19:57:22 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y206so6434001pfb.10;
        Sat, 15 Aug 2020 19:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JIK358VUoo1CD174mKzy+Qk9J6wTA6d4kRpN62If/zg=;
        b=RZREbcnXErKUQleWvwvYCoWzsPsm9cnxIX1aghrSxuphK7/2JqT8r6KyxBFZU9gRUg
         Wz149j8KIArOMwfTCTDe0/Ncc6rTabEZkhq9QIz+qXZ10UfAuuvHR5pvNAkpflYIoCoy
         bHodDeXuzktpMm0P0mxJtT9YbU5hNs000rYifo/479k/qCRTU1Ltq7JX1pfBhQl9/ACq
         KFgfWPn6mvIYFQF0ARBiRnStCaNm5Bp6pQuXRxejEjXvTpSvuTOJUgqF4/4jP/yi+UQL
         nG+r/6AFOyfHKxFrYTUaZeS7xU+JMZZ09iDdQjBH76qutOMJLEp/OJJHIZaRqb0c+Frr
         Kw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JIK358VUoo1CD174mKzy+Qk9J6wTA6d4kRpN62If/zg=;
        b=sswQEIPBO7dYqS10fnjnNTafRpLZoZ2clyJkcrgdYzkERtcOoJ1l3JY1EsNidc5vz/
         oi4UgdrMOqf4XX4avfLuLdLFf0cp6icLzvsh0XLZzcK8u9uikRWK268Hm5iozTgPqrlI
         hxYu/M6qLXrjVZ8bodrR74dl8ZTXKMOB8MC6QtA3+W7ktLmV6ReTTcUToD6OFQaa0xyW
         +n3+mSiXyl75b0dj1tQ+k4AkpSmNIGUDQy40f4F4ZtCiwajWBh2E+DX7SoIyWDfAPw1j
         mSyDfNJ1SMmEatskmrsM4qpEGgsfcrq8GZG6aMBxMExuJQdbZN+/t1OfRxMS2rwulwt3
         2ttQ==
X-Gm-Message-State: AOAM531fP73/fTAsAw2JseBEWgJ+dvW42tDRIJPpnGTtyBGB43ArPc9L
        77da68jNl8p0C9OKaEEcNE4=
X-Google-Smtp-Source: ABdhPJxqxC64YNpIV4UVBdpa3RDRiVyqOYxgw5o33bHO2Vs+UCh8QRRk6SiXqTNqGgB7TPxjCTvCiQ==
X-Received: by 2002:a63:d812:: with SMTP id b18mr5844818pgh.353.1597546641805;
        Sat, 15 Aug 2020 19:57:21 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id z9sm12935865pfn.59.2020.08.15.19.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 19:57:21 -0700 (PDT)
Date:   Sun, 16 Aug 2020 11:57:17 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/3] staging: qlge: clean up code that dump info to dmesg
Message-ID: <20200816025717.GA28176@f3>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
 <20200814160601.901682-4-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814160601.901682-4-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-15 00:06 +0800, Coiby Xu wrote:
> The related code are not necessary because,
> - Device status and general registers can be obtained by ethtool.
> - Coredump can be done via devlink health reporter.
> - Structure related to the hardware (struct ql_adapter) can be obtained
>   by crash or drgn.

I would suggest to add the drgn script from the cover letter to
Documentation/networking/device_drivers/qlogic/

I would also suggest to submit a separate patch now which fixes the
build breakage reported in <20200629053004.GA6165@f3> while you work on
removing that code.

> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h         |  82 ----
>  drivers/staging/qlge/qlge_dbg.c     | 672 ----------------------------
>  drivers/staging/qlge/qlge_ethtool.c |   1 -
>  drivers/staging/qlge/qlge_main.c    |   6 -
>  4 files changed, 761 deletions(-)
> 
[...]
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 058889687907..368394123d16 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -1326,675 +1326,3 @@ void ql_mpi_core_to_log(struct work_struct *work)
>  		       sizeof(*qdev->mpi_coredump), false);
>  }
> 
> -#ifdef QL_REG_DUMP
> -static void ql_dump_intr_states(struct ql_adapter *qdev)
> -{
[...]
> -	}
> -}
> -#endif

This leaves a stray newline at the end of the file and also does not
apply over latest staging.
