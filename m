Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04103425BB
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCSTGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCSTFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 15:05:47 -0400
X-Greylist: delayed 3463 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Mar 2021 12:05:46 PDT
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB38C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 12:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
        References:Message-ID:In-Reply-To:Subject:cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qVZuZEyZBAS/ZgAMPEp7JyONmLh5M9RY5PXbkJLE8m0=; b=XLXLK8zZRT9V/6koOVD1foe6jE
        uuj+c6QAkeX8KkWg+jAASxyGFpAMOKaNb+2Qol5C3U1HonK5LYEns4EPApR+4TBPb7i2CYTbIySi6
        quBjuwU5uhBVzZSiuhRL0siaVa5JmCqz2pilOlrPBff/WU9E5qFbicBBBKIJRq3FP6s9O9rjioAdI
        xaP8/7JZpzk8vgFiIKS3yQEtaQ/1ddMZvXlfamG11MvUFAYePhClBbhSqhFE7ApPVzxwYpaDez/YY
        rMAqlAw6al5k9eA2BqxW/9yo7L1LWAWW6et39kh6572k9YxIfm7+hUjDYBla3phDr9q5aRb2kJvR/
        nM4RbcnQ==;
Received: from rdunlap (helo=localhost)
        by bombadil.infradead.org with local-esmtp (Exim 4.94 #2 (Red Hat Linux))
        id 1lNJXU-001RdU-Hv; Fri, 19 Mar 2021 18:08:01 +0000
Date:   Fri, 19 Mar 2021 11:08:00 -0700 (PDT)
From:   Randy Dunlap <rdunlap@bombadil.infradead.org>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sch_red: Fix a typo
In-Reply-To: <20210319044623.20396-1-unixbhaskar@gmail.com>
Message-ID: <ff38bd-991b-1e41-7b28-bfdeda3b4aba@bombadil.infradead.org>
References: <20210319044623.20396-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: Randy Dunlap <rdunlap@infradead.org>
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-646709E3 
X-CRM114-CacheID: sfid-20210319_110800_615482_E7D0A2CA 
X-CRM114-Status: GOOD (  12.98  )
X-Spam-Score: -0.0 (/)
X-Spam-Report: Spam detection software, running on the system "bombadil.infradead.org",
 has NOT identified this incoming email as spam.  The original
 message has been attached to this so you can view it or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Fri, 19 Mar 2021, Bhaskar Chowdhury wrote: > > s/recalcultion/recalculation/
    > > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com> Acked-by: Randy
    Dunlap <rdunlap@infradead.org> 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 NO_RELAYS              Informational: message was not relayed via SMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Fri, 19 Mar 2021, Bhaskar Chowdhury wrote:

>
> s/recalcultion/recalculation/
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>


> ---
> include/net/red.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/red.h b/include/net/red.h
> index 932f0d79d60c..6b418b69dc48 100644
> --- a/include/net/red.h
> +++ b/include/net/red.h
> @@ -287,7 +287,7 @@ static inline unsigned long red_calc_qavg_from_idle_time(const struct red_parms
> 	int  shift;
>
> 	/*
> -	 * The problem: ideally, average length queue recalcultion should
> +	 * The problem: ideally, average length queue recalculation should
> 	 * be done over constant clock intervals. This is too expensive, so
> 	 * that the calculation is driven by outgoing packets.
> 	 * When the queue is idle we have to model this clock by hand.
> --
> 2.26.2
>
>
