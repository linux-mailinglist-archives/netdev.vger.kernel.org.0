Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0163444E01B
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 03:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhKLCI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 21:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhKLCI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 21:08:56 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B962C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 18:06:06 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id e65so6734744pgc.5
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 18:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iow1j5KGPzD6IKSmlivC0bzKgqzOFY5UBkfy+UDAuSo=;
        b=qnUCtWt+1T6KHxlkAqGnmjsS4klN+RxVYDiDWx6pEOK2USLxown0kZZ0btxT1ZoS9f
         +y/I7awZh367sqP01RPDquSj2mQ8PUjB9x0DBbTzaQqQsahPZK3P+W4VYWW8J2PwY+fs
         N1FO/aMboqIN0K9+y9STwW81gQwQN8JtFz6x5pOwxWrXM/zZVavhU1jXqpDfczZ8deGJ
         cumo2l0pjgi6GYs7p9V9iDUdtfn/03MsjdQ0yOz2cwfJuzcDqrYd1guAoxgKxXbCriBj
         KAmUkSsqREoQZjCMr+IgiJ1x1PKlr5H6U7u9YsUccEpi0fzFtZEVrf63c7RKuDN3Czzg
         YL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iow1j5KGPzD6IKSmlivC0bzKgqzOFY5UBkfy+UDAuSo=;
        b=0ZCL/7VarPe0CTeKVQqSjxzidRF5jGWEklLJb11QbRM9Oqfj9phD0++sk6sG/ZQpaD
         1gk73ANLkZ/ocVEZorlJe/TZS7puVoptRE39IVb9mXUnO39wRScxZ0H4r8GtIvPI1zWC
         1DkntnWooPYGhxMBBs+ltzs4Y6g2tTOkU0hCqszMyLiHPWAhmZO5RMsdM+6qNnByxTeT
         SggsvO5fCQCmEcDu8NEP5tg+mZSH71FTAXRKsojPUBfoLl9ICVb2irhDJajfljAFwA01
         Zmkz/FHiyruBTof7TtW56iw7cfJE24Z3K0XaeoYO0qc6B/3KW8a5DWWMhSybrL6m9s8g
         t8zA==
X-Gm-Message-State: AOAM532c8xe4BvM2rAtIkPXhjtdgcU9+/z7sv2y/uMacOq85j3A5+y2W
        kUBHZ4jNZFRVOPYQTmE9FUM=
X-Google-Smtp-Source: ABdhPJxYZHJ6aHX4SMBF/bVf8V3mQR95vshKyARhLDaUCNvQMbI3q/RYhaeEkliQxvm3wBnpHppkdA==
X-Received: by 2002:a63:5f16:: with SMTP id t22mr7563260pgb.362.1636682766014;
        Thu, 11 Nov 2021 18:06:06 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p17sm3241670pgj.93.2021.11.11.18.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 18:06:05 -0800 (PST)
Date:   Thu, 11 Nov 2021 18:06:03 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Min Li <min.li.xe@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2] ptp: ptp_clockmatrix: repair non-kernel-doc comment
Message-ID: <20211112020603.GA464@hoboy.vegasvil.org>
References: <20211111155034.29153-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111155034.29153-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 07:50:34AM -0800, Randy Dunlap wrote:
> Do not use "/**" to begin a comment that is not in kernel-doc format.
> 
> Prevents this docs build warning:
> 
> drivers/ptp/ptp_clockmatrix.c:1679: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Maximum absolute value for write phase offset in picoseconds
> 
> Then remove the kernel-doc-like function parameter descriptions
> since they don't add any useful info. (suggested by Jakub)
> 
> Fixes: 794c3dffacc16 ("ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Min Li <min.li.xe@renesas.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>

Acked-by: Richard Cochran <richardcochran@gmail.com>
