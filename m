Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EF522950C
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 11:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgGVJgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 05:36:03 -0400
Received: from mail.xenproject.org ([104.130.215.37]:58748 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgGVJgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 05:36:02 -0400
X-Greylist: delayed 1652 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2020 05:36:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wX1Eu/u/kjAZ3efLZ2Y25RplLLxRiLVlINm0rbq4U98=; b=6D2J+hGtF1HieE1ujaUHTZTQKX
        0uqZCfxIEafhkFu/2+tPlCCIQh74oBBdRFhDZAKdYAKi9ZRrhEodcK0n5QuMZ8nQPdHF6MJXkCxUR
        PQwIjoJj5gT95SKVKt+68ABn3KlLeURHFXRUw6T4IMIKT1d9g4yuGxKJjIi+WonW2tiI=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1jyAjS-0001t0-P2; Wed, 22 Jul 2020 09:08:10 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=a483e7b01a66.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <julien@xen.org>)
        id 1jyAjS-0001i7-E0; Wed, 22 Jul 2020 09:08:10 +0000
Subject: Re: [PATCH v2 04/11] x86/xen: add system core suspend and resume
 callbacks
To:     Anchal Agarwal <anchalag@amazon.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        xen-devel@lists.xenproject.org, vkuznets@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dwmw@amazon.co.uk, benh@kernel.crashing.org
References: <cover.1593665947.git.anchalag@amazon.com>
 <20200702182205.GA3531@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Julien Grall <julien@xen.org>
Message-ID: <b8445e93-deed-1a28-cd3b-993d42c78251@xen.org>
Date:   Wed, 22 Jul 2020 10:08:05 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200702182205.GA3531@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 02/07/2020 19:22, Anchal Agarwal wrote:
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index 2521d6a306cd..9fa8a4082d68 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -41,6 +41,8 @@ u64 xen_steal_clock(int cpu);
>   int xen_setup_shutdown_event(void);
>   
>   bool xen_is_xen_suspend(void);
> +void xen_setup_syscore_ops(void);

The function is only implemented and used by x86. So shouldn't this be 
declared in an x86 header?

Cheers,

-- 
Julien Grall
