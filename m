Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339BA1BE736
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgD2TUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726635AbgD2TUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:20:04 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751F7C03C1AE;
        Wed, 29 Apr 2020 12:20:04 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id w4so3498640ioc.6;
        Wed, 29 Apr 2020 12:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Pe47CYwo9MusUFNbmbGCWLnQKikduAK0DHpOfLkCvmQ=;
        b=dB+YEKCw7X0BQUy0squ1VSgB7zfm07kgH0YiMHS9rhZSNAVByj54+aXKv5iMCo093L
         4v3htqGxqV3RBuK2rqXt6r8i3evJ7ZpQ/g+J/Wj/JWBf++W3+jzSd6TD9ilyd85FKIGa
         LGyB0b65Hwda+8QImI0MH6rLQlnIvnwbKYx2iPAiMX//oa2XNqVRFDf29uMYHQ+Hv+Y0
         4eM6cHJ+mHZXZzxCM2lRe0SKnDyutvbaG1/FzgGD+Sq7gs0POcGl2xmEIu8D1ot+n25f
         s9HcyJumApXQzYDf1MrCh0kl37jGu77Z5eNU8dzcrcpViwSnr2GCFBsPf2L7p9vat2zA
         3yiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Pe47CYwo9MusUFNbmbGCWLnQKikduAK0DHpOfLkCvmQ=;
        b=T3kayaWfT04ixCBcVlmLS9L+HSi8i1ciuTpv0b4ne0DxtpxHf02ncjGo+yOUXs0niX
         JOG4U3LhECsSRW25m9EQAmSpEbiD6v0r0LZXj5j1pPEflAxTUDz97wp5E95aACdrMe8Y
         +ac/ne8ELXQVlMEsQQnhgoeO00PrWyB+z1OQlNU4gvOROMYd1I60pxulRR//sGqq8TvV
         V8ZTS8utQbgZgYJJFfiC1HiUfvlqGN34vOaA1wrtQBV+imuzaXzqYt+bWOmFesQx4Te7
         tUltg1bI4BViv/7yl3CWBG+zgGWErrf8wNNhS913wtTah4B4FRBGXYn9laebNpAXnlLr
         vEjA==
X-Gm-Message-State: AGi0PuZtknZn1LWwKEZGV6y+eLbjSY3nzLo94b7zNP2nHCJ6TXo6JJdP
        NYrvakZdpgS7JpPx4PYETTE=
X-Google-Smtp-Source: APiQypIyap5pmzrbnNsNX5hwUyguBSKGznMyEZOnoXIvaX+WHeKNyLqXh2bxAzo0pCBNWz+YJEEqJQ==
X-Received: by 2002:a5d:8f02:: with SMTP id f2mr32606054iof.55.1588188003774;
        Wed, 29 Apr 2020 12:20:03 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n6sm1131041iog.16.2020.04.29.12.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 12:20:02 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:19:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5ea9d35a3244f_220d2ac81567a5b8ca@john-XPS-13-9370.notmuch>
In-Reply-To: <20200429181154.479310-2-jakub@cloudflare.com>
References: <20200429181154.479310-1-jakub@cloudflare.com>
 <20200429181154.479310-2-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 1/3] bpf: Allow bpf_map_lookup_elem for SOCKMAP
 and SOCKHASH
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> White-list map lookup for SOCKMAP/SOCKHASH from BPF. Lookup returns a
> pointer to a full socket and acquires a reference if necessary.
> 
> To support it we need to extend the verifier to know that:
> 
>  (1) register storing the lookup result holds a pointer to socket, if
>      lookup was done on SOCKMAP/SOCKHASH, and that
> 
>  (2) map lookup on SOCKMAP/SOCKHASH is a reference acquiring operation,
>      which needs a corresponding reference release with bpf_sk_release.
> 
> On sock_map side, lookup handlers exposed via bpf_map_ops now bump
> sk_refcnt if socket is reference counted. In turn, bpf_sk_select_reuseport,
> the only in-kernel user of SOCKMAP/SOCKHASH ops->map_lookup_elem, was
> updated to release the reference.
> 
> Sockets fetched from a map can be used in the same way as ones returned by
> BPF socket lookup helpers, such as bpf_sk_lookup_tcp. In particular, they
> can be used with bpf_sk_assign to direct packets toward a socket on TC
> ingress path.
> 
> Suggested-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM thanks!

Acked-by: John Fastabend <john.fastabend@gmail.com>
