Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9965432395C
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 10:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhBXJV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 04:21:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234613AbhBXJVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 04:21:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614158399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=izUCxT+tdv9xS2oKv6j2Eova2wbVLQ+mEJCClkNFIkg=;
        b=ZfupQcN1bUmJiYFLPCqo09ro1Q9pWJYIC+4ttEiA3fRdboumrWCCfzRXd1H04rkyPc1YUI
        9m5R9spgey/cABq+QnbZM0JiXo8ie/+3BAhkGxpOYzHvFemgY6TSyifbjQ8YqsPYnFZ8yL
        wIQXwNuDNuqQpSXH609I2BSa7+OZHR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-VAJqlxg6Nx2r5RHsdg7cng-1; Wed, 24 Feb 2021 04:19:55 -0500
X-MC-Unique: VAJqlxg6Nx2r5RHsdg7cng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C3B8CE642;
        Wed, 24 Feb 2021 09:19:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B11D410493BD;
        Wed, 24 Feb 2021 09:19:49 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:19:48 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, brouer@redhat.com
Subject: Re: [PATCHv2 bpf-next] bpf: remove blank line in bpf helper
 description
Message-ID: <20210224101948.1a7aa6a5@carbon>
In-Reply-To: <20210223131457.1378978-1-liuhangbin@gmail.com>
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
        <20210223131457.1378978-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 21:14:57 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") added an
> extra blank line in bpf helper description. This will make
> bpf_helpers_doc.py stop building bpf_helper_defs.h immediately after
> bpf_check_mtu, which will affect future add functions.
> 
> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2: remove the blank line directly instead of adding a *
> ---
>  include/uapi/linux/bpf.h       | 1 -
>  tools/include/uapi/linux/bpf.h | 1 -
>  2 files changed, 2 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4c24daa43bac..79c893310492 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3850,7 +3850,6 @@ union bpf_attr {
>   *
>   * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>   *	Description
> -
>   *		Check ctx packet size against exceeding MTU of net device (based
>   *		on *ifindex*).  This helper will likely be used in combination
>   *		with helpers that adjust/change the packet size.
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4c24daa43bac..79c893310492 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3850,7 +3850,6 @@ union bpf_attr {
>   *
>   * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>   *	Description
> -
>   *		Check ctx packet size against exceeding MTU of net device (based
>   *		on *ifindex*).  This helper will likely be used in combination
>   *		with helpers that adjust/change the packet size.



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

