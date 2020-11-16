Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FCF2B5454
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgKPW2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbgKPW2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:28:48 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5B4C0613CF;
        Mon, 16 Nov 2020 14:28:47 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id t143so20469607oif.10;
        Mon, 16 Nov 2020 14:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=pnvePOVqVIwLlt9y+r9agWs7y1K90D0MGiWqxse5S/k=;
        b=E0arDMs/GFaLcGxh0by2Hdztn+0I+35YJB37kzxMKiGMWmYitt6+frBYUmKuMMO9b4
         wQ34u5soxqDHI4MYuX4Bv2BXgKbspb5AfOPjnndJmhGV9tEkw03PZRXbdP6oNc2R7vcu
         mbhrGLszJH4Bksz9b5RIQAdX87tVtJCIZAfNiCR/OXn/mAc2QZ3fCzmSK5sgy/zJWeBq
         j4f0Bp6ZnfQnuLv7dufjVOFlewl7c+fprAChee+JegojEdlOhjimB5AfKTuxdSePT95N
         vKLTS34GAivpGqSh9CXUSV9cPND0nzjZkVExGT32Pgtfm2RrxZ/Tj+atDsyXLU0Y/p94
         jnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=pnvePOVqVIwLlt9y+r9agWs7y1K90D0MGiWqxse5S/k=;
        b=Fgt67gGXwBNgx5gSzlTcUHs6wB5wELOYhVoRtnh9oNWWq/LgsQ1JNssrRJfP/XNvnO
         34FYt/hSTMFMce4LM6jM+xUCsn80gywjqYhHEfwDa4Mk/8Cq6o9Ohc9Bwe0S10Knmc6T
         FO1CkNWB6KvFjIy507Ts2DYNCqoTzW8vmnzyhpO+qBFfQTKtHmBPBYjT0K/fm+xprR6i
         98YYmZTuSx+C2RK+/cISk85qlzrdiZF2im7/zaHvHN8jFNp6TbJ8Y+KmV4siDbZe3pbZ
         wLt8N0EvueWFzWffrosr7p9kdCiRfFAEl/yykWDMrwMVKNWDRm5JM1SgiDlisLUAJdkE
         hL8w==
X-Gm-Message-State: AOAM5333hLw9r9VbNg7gO9Z/13XfzW/u1q4pkCnrmO66YyMiLrv567+1
        nzJWW6nbt1At6wrVMO0qFqOP3tp8aaeZgQ==
X-Google-Smtp-Source: ABdhPJzYDQ/wAffb4t5JNyLcN2aZxuNqKBB1+yhUb81FBArTYmxzy0xfe4PoqcvufXUIzdhqYNPZ+g==
X-Received: by 2002:aca:4257:: with SMTP id p84mr584704oia.68.1605565727442;
        Mon, 16 Nov 2020 14:28:47 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l12sm2846815oos.23.2020.11.16.14.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:28:46 -0800 (PST)
Date:   Mon, 16 Nov 2020 14:28:39 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <5fb2fd1778fe5_b976208e5@john-XPS-13-9370.notmuch>
In-Reply-To: <87blfxweyj.fsf@cloudflare.com>
References: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
 <160522367856.135009.17304729578208922913.stgit@john-XPS-13-9370>
 <87blfxweyj.fsf@cloudflare.com>
Subject: Re: [bpf PATCH v2 5/6] bpf, sockmap: Handle memory acct if
 skb_verdict prog redirects to self
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Fri, Nov 13, 2020 at 12:27 AM CET, John Fastabend wrote:
> > If the skb_verdict_prog redirects an skb knowingly to itself, fix your
> > BPF program this is not optimal and an abuse of the API please use
> > SK_PASS. That said there may be cases, such as socket load balancing,
> > where picking the socket is hashed based or otherwise picks the same
> > socket it was received on in some rare cases. If this happens we don't
> > want to confuse userspace giving them an EAGAIN error if we can avoid
> > it.

[...]
 
> 
> I think all the added checks boil down to having:
> 
> 	struct sock *sk = psock->sk;
> 
>         if (unlikely(skb->sk == sk))
>                 return sk_psock_skb_ingress_self(psock, skb);
> 
> ... on entry to sk_psock_skb_ingress().

Agree made the change and sent out v3 thanks. I also carried your
Reviewed-by through on patches 1-4 and 6.

Thanks for reviewing!
