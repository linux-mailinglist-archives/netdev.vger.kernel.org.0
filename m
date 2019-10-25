Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867F9E4EC3
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfJYOTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:19:06 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42872 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbfJYOTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:19:06 -0400
Received: by mail-io1-f68.google.com with SMTP id i26so2577615iog.9;
        Fri, 25 Oct 2019 07:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=2jFeG2dUcr+Q7csipkPUf6YfvtHqZfoRNXMbriXYupI=;
        b=mmafdueEKa7k1jkCLhfmsMo7VlYyA9wSpyIts4A3m+sDCCOCJyi0AQLe1Cy739Nb9r
         aY0Ie4Gb7MwS1bQPO253l4OJj7RgN07RnGlwPnXIHlgmR08RSYTD2A/LEbRthJ2zbcF9
         PgSjGf2a45K/0zZptIcYq9SKqQkdMrvKzf7mgdIjjQCdrDooUV+zEvWGQtHy7xvOGNt0
         2gf3zwEF9K3oMpXrb8H/eYt/CyNy9NZGn/f+/Dp/mnzOBxGgLkNs7mb2aNf6UdNZ3XoN
         VHqpVyfO+maovB+bhVybGF1A0azRUQD8KAHd8yzyEpjKHXOiNW8HpFGPV4jKX3Ca27ni
         bugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=2jFeG2dUcr+Q7csipkPUf6YfvtHqZfoRNXMbriXYupI=;
        b=Mp25H/eCOkn5rpr5OkqjGY3aR90/RaXHXgLQkPCOMgmjAMdNjPAe0RxUMMf4Y813bi
         FTEHuSY6cYuKOi90pQisqGygMhNnpPIDivRukteFGmAflS2IplRkRX18KmT0sjKi7Pz4
         RJfN6PsTlDt9bimT9Cs1Q90aLNYixFe6/j3v0UWt1U2FGCmKBlTfovcncpp6e1WaeDqb
         UW1An8/ixFycbuByADdoq6w3jQ9gUQFjuWr2ZwEwFDzK82TXxf0ML9n3xaMMtExWQNqv
         36fqMVsviK/4bzPpDkXHLFrSFK7HTS/N9jVmBPxxo8i4Rk8kcdzsX+7y6Mj16sRNUJJf
         /ZKQ==
X-Gm-Message-State: APjAAAXjXOnACStqqaixHIz+bbrzTvIU+SWQWaOjdLTJRV0fanNRxO96
        PShhUvgEU+odh/VmWT7lE+I=
X-Google-Smtp-Source: APXvYqx/wGZ0iiL3VvW2qhbOevq3mUSVhYVqkeqX1nFtKciqDcJKI+chDzAcMM67YScoeET3kYwrDw==
X-Received: by 2002:a6b:ee18:: with SMTP id i24mr3877990ioh.163.1572013144337;
        Fri, 25 Oct 2019 07:19:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t16sm296728iol.12.2019.10.25.07.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 07:19:02 -0700 (PDT)
Date:   Fri, 25 Oct 2019 07:18:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
Message-ID: <5db3044f82e10_36802aec12c585b83b@john-XPS-13-9370.notmuch>
In-Reply-To: <87lft9ch0k.fsf@cloudflare.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
 <5db1d7a810bdb_5c282ada047205c08f@john-XPS-13-9370.notmuch>
 <87lft9ch0k.fsf@cloudflare.com>
Subject: Re: [RFC bpf-next 0/5] Extend SOCKMAP to store listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Thu, Oct 24, 2019 at 06:56 PM CEST, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> 
> [...]
> 
> >> I'm looking for feedback if there's anything fundamentally wrong with
> >> extending SOCKMAP map type like this that I might have missed.
> >
> > I think this looks good. The main reason I blocked it off before is mostly
> > because I had no use-case for it and the complication with what to do with
> > child sockets. Clearing the psock state seems OK to me if user wants to
> > add it back to a map they can simply grab it again from a sockops
> > event.
> 
> Thanks for taking a look at the code.
> 
> > By the way I would eventually like to see the lookup hook return the
> > correct type (PTR_TO_SOCKET_OR_NULL) so that the verifier "knows" the type
> > and the socket can be used the same as if it was pulled from a sk_lookup
> > helper.
> 
> Wait... you had me scratching my head there for a minute.
> 
> I haven't whitelisted bpf_map_lookup_elem for SOCKMAP in
> check_map_func_compatibility so verifier won't allow lookups from BPF.
> 
> If we wanted to do that, I don't actually have a use-case for it, I
> think would have to extend get_func_proto for SK_SKB and SK_REUSEPORT
> prog types. At least that's what docs for bpf_map_lookup_elem suggest:

Right, so its not required for your series just letting you know I will
probably look to do this shortly. It would be useful for some use cases
we have.

> 
> /* If kernel subsystem is allowing eBPF programs to call this function,
>  * inside its own verifier_ops->get_func_proto() callback it should return
>  * bpf_map_lookup_elem_proto, so that verifier can properly check the arguments
>  *
>  * Different map implementations will rely on rcu in map methods
>  * lookup/update/delete, therefore eBPF programs must run under rcu lock
>  * if program is allowed to access maps, so check rcu_read_lock_held in
>  * all three functions.
>  */
> BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
> {
> 	WARN_ON_ONCE(!rcu_read_lock_held());
> 	return (unsigned long) map->ops->map_lookup_elem(map, key);
> }
> 
> -Jakub


