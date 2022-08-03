Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2765858894A
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 11:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbiHCJVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 05:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiHCJVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 05:21:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89ED458B7D
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 02:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659518512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wC3/PO//oorDVUr2wMWH5HeOq129lBqXeyqiPu4d5kY=;
        b=LLug/YxOpuUiLdJGsPupsn5dSMcEWoCe7s20Trd/dqEHtlWypP3uofpuUJNuOo412PGLUn
        M8GgsTDqn6ma2bpPA5R7AgUXvgrWPl9ikwGtBfq/wvYB/MH1H0t2L76rNSLp/X1X/vVFQj
        uhLkdXBoDmRdqMYmZ4ioCgaV7loK5PY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-pfCCUwv0NiOp6IpbbF09sw-1; Wed, 03 Aug 2022 05:21:47 -0400
X-MC-Unique: pfCCUwv0NiOp6IpbbF09sw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20B4D1C06ED1;
        Wed,  3 Aug 2022 09:21:46 +0000 (UTC)
Received: from localhost (ovpn-13-216.pek2.redhat.com [10.72.13.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FB4E2026D4C;
        Wed,  3 Aug 2022 09:21:44 +0000 (UTC)
Date:   Wed, 3 Aug 2022 17:21:41 +0800
From:   Baoquan He <bhe@redhat.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Xiaoming Ni <nixiaoming@huawei.com>
Subject: Re: [PATCH v2 02/13] notifier: Add panic notifiers info and purge
 trailing whitespaces
Message-ID: <Yuo+JVGsYm1V8Asx@MiWiFi-R3L-srv>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-3-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719195325.402745-3-gpiccoli@igalia.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/19/22 at 04:53pm, Guilherme G. Piccoli wrote:
> Although many notifiers are mentioned in the comments, the panic
> notifiers infrastructure is not. Also, the file contains some
> trailing whitespaces. Fix both issues here.
> 
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Valentin Schneider <valentin.schneider@arm.com>
> Cc: Xiaoming Ni <nixiaoming@huawei.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V2:
> - no change.
> 
>  include/linux/notifier.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/notifier.h b/include/linux/notifier.h
> index aef88c2d1173..d5b01f2e3fcc 100644
> --- a/include/linux/notifier.h
> +++ b/include/linux/notifier.h
> @@ -208,12 +208,12 @@ static inline int notifier_to_errno(int ret)
>  
>  /*
>   *	Declared notifiers so far. I can imagine quite a few more chains
> - *	over time (eg laptop power reset chains, reboot chain (to clean 
> + *	over time (eg laptop power reset chains, reboot chain (to clean
>   *	device units up), device [un]mount chain, module load/unload chain,
> - *	low memory chain, screenblank chain (for plug in modular screenblankers) 
> + *	low memory chain, screenblank chain (for plug in modular screenblankers)
>   *	VC switch chains (for loadable kernel svgalib VC switch helpers) etc...
>   */
> - 
> +
>  /* CPU notfiers are defined in include/linux/cpu.h. */
>  
>  /* netdevice notifiers are defined in include/linux/netdevice.h */
> @@ -224,6 +224,8 @@ static inline int notifier_to_errno(int ret)
>  
>  /* Virtual Terminal events are defined in include/linux/vt.h. */
>  
> +/* Panic notifiers are defined in include/linux/panic_notifier.h. */
> +

LGTM,

Reviewed-by: Baoquan He <bhe@redhat.com>

>  #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
>  
>  /* Console keyboard events.
> -- 
> 2.37.1
> 

