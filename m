Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEED0B214B
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390528AbfIMNoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:44:00 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:45488 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388331AbfIMNn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:43:59 -0400
Received: by mail-vs1-f65.google.com with SMTP id s3so18612488vsi.12;
        Fri, 13 Sep 2019 06:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=RXJnZ+nPgE9agHywMSnWPQ7t9VoBgm2R0CEtC5otomY=;
        b=CUOYo1guETjrYNQEhNyJG1uIGxnJ1ZmaQsuceauYUPtMTJiqGbiT/kWdtVH5EcwVkB
         E4B4NaFUxLu/m+BmxEWXWZ7trw1d0IaJxvUrKqN+y9udk4PLYwSbSXaznaIeMOHlrjQG
         n3ZDK5IhR3Yu0gdc1xMw3rqnkfdEcp/5e0F6zmiHz9pj724sVjzahRh/cSA0oMvQS61S
         OsJOh/4CkzqZ63Klvrz6Nqw1IQaFyFqfNOQhj33sjtuyt6DTImJoEE1EZMw8jC9I8is6
         WYYZZh8X1r42SENsaTQMDfXvGc0DBYfg86kkkHUJcpVAMwnMVWUtVKjNpDVaZVx/bHUB
         gcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=RXJnZ+nPgE9agHywMSnWPQ7t9VoBgm2R0CEtC5otomY=;
        b=TxOB4ctLA2BjYN4fjIlHRq3PSMGGFU5WyOMhk7f2MqltkThH8u4mxRrLaonmEdzTRn
         OXJdmoTeLc5QA/MwTdpKTFBkYLUiKs72CAilrgT8KO3OThilGKEK4eK3Ujo4V0ayMz+M
         nkHcOaPsJZS/ysV2NbbqJwQ/7EItq9uaE57bSpY5VhJeKNfQiQ1AVaCU6u923p/7zHBz
         YB/KY1AEAd/r9V4HP7mFxAoIjHmwSIzI6i+C4418FtiIqrxBXA4Narj27Bt9xamxIXW6
         uk01PNgXwIj4cRguZ1V6QCJRjIyZQPffw3hICgXsfz33EJcMN5oMtYrjJSbyVHx92Rl4
         rlZg==
X-Gm-Message-State: APjAAAX902rIcGg46DbNM2y6D4G2g+cahcfMclSekCRhDHBHGSGL2SAm
        UH1KcuPULfcwGjJ7AxUrkI7y3S3RG8IkWjOA5qwk
X-Google-Smtp-Source: APXvYqw9PNt4u6KSrpSVrBXM2L7xr6JaasI+kZg3SKmYAITPc2ir9OYfofSEVx6LRX7xFiHf6Yn19MCoEVskqy8b7jM=
X-Received: by 2002:a67:6187:: with SMTP id v129mr5104474vsb.230.1568382238685;
 Fri, 13 Sep 2019 06:43:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190724143733.17433-1-rsalvaterra@gmail.com>
In-Reply-To: <20190724143733.17433-1-rsalvaterra@gmail.com>
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Fri, 13 Sep 2019 14:43:47 +0100
Message-ID: <CALjTZvYi+3VdYJ4Od4Epx08VTFg0TReo_-NkqYxFonR_-=GN6A@mail.gmail.com>
Subject: Re: [PATCH] netfilter: trivial: remove extraneous space from message
To:     pablo@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Friendly ping.

On Wed, 24 Jul 2019 at 15:37, Rui Salvaterra <rsalvaterra@gmail.com> wrote:
>
> Pure ocd, but this one has been bugging me for a while.
>
> Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
> ---
>  net/netfilter/nf_conntrack_helper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 8d729e7c36ff..209123f35b4a 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -218,7 +218,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
>                         return NULL;
>                 pr_info("nf_conntrack: default automatic helper assignment "
>                         "has been turned off for security reasons and CT-based "
> -                       " firewall rule not found. Use the iptables CT target "
> +                       "firewall rule not found. Use the iptables CT target "
>                         "to attach helpers instead.\n");
>                 net->ct.auto_assign_helper_warned = 1;
>                 return NULL;
> --
> 2.22.0
>
