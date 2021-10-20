Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F87434345
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 04:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhJTCEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 22:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhJTCEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 22:04:45 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722F1C06161C;
        Tue, 19 Oct 2021 19:02:31 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id g2so20471226ild.1;
        Tue, 19 Oct 2021 19:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=q2jYWlCNWClrtqnlx7YbYB8lDGyrA8nXyrUF7zcT2Ys=;
        b=MI3Hog3FAWN6fF7dLObyz2Z0USsjwtbicgkCFam/SIeOR2khvc0oyogVAgVXzd2USR
         6XnUIGkVfGJd8SOBIScfmAEeAb47IddWW7ZnysxnfUnUqm6Sb0gBt6n++TgDXzrF0+eq
         +IoQgIgTWFmI/23q+3XY3octW5+GfPG4gGOql415iwdaHiLpYg6kba9Tq/qZSHNdtkm+
         oIdITBdse66wY8VpC/gz23kRpXfnJfuc2QDkpEl7mTgOdaS0sl5p27qPE4ojpoOqzxDM
         8Jxes8E6eV8Rz+H2N9nE/ARhWcJqVRBOa0lj2cTW0ttJaMklt/u3fA4yo2FqmUQwkG9X
         vT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q2jYWlCNWClrtqnlx7YbYB8lDGyrA8nXyrUF7zcT2Ys=;
        b=qXCU6YMVS642ko+DZWfNzQQpbbyHD99vRJSx0ltpJUp51F0bLgmWbj8gCfXvaSjQx2
         /XpLQUpsAg8F+LfgX9U3zo+seV1lN1YJOu79KwQ+BZtg0mPjPSCxc/YTGpTA31YASRWF
         u/7C8hSxAjDmhF0rnyhGrPZy0khtWBu/iN55de1WWxsAmGNGJFsq3RPBxSmhXCH0rW+0
         +Vyft3uaK/oyhX7USZZRw2BI1Uat0BaPXQd+il7q71uYl55bTP9poWG+Tav0szSnG1Do
         E/XncIvbiNKM/G8hp9R0GdD4GAWc90kOziSwx07GPFhYMDjreW0nmB409HU5bt47JQBM
         MraA==
X-Gm-Message-State: AOAM531bGuXdumTqN/akbv8+OEotY+p9yDZSUsodFTZZhIHXEarKNVWe
        uCJ8IuxTbMlImKKgbp2Mgn/rfKE8aEw=
X-Google-Smtp-Source: ABdhPJwxw21nRHUZFUsJ3fel6NOQ3L8wQpmCK+GvpHLkzfDBnhqDDPf3klO4UprFCGgkmO7SnThVTw==
X-Received: by 2002:a05:6e02:1bae:: with SMTP id n14mr22086374ili.253.1634695350651;
        Tue, 19 Oct 2021 19:02:30 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id v26sm407208iox.35.2021.10.19.19.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 19:02:30 -0700 (PDT)
Message-ID: <e8dca460-7f5a-ee90-865c-dbb8bb0aa5d6@gmail.com>
Date:   Tue, 19 Oct 2021 20:02:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH net 1/1] vrf: Revert "Reset skb conntrack connection..."
Content-Language: en-US
To:     Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
References: <20211018182250.23093-1-crosser@average.org>
 <20211018182250.23093-2-crosser@average.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211018182250.23093-2-crosser@average.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/21 12:22 PM, Eugene Crosser wrote:
> This reverts commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1.
> 
> When an interface is enslaved in a VRF, prerouting conntrack hook is
> called twice: once in the context of the original input interface, and
> once in the context of the VRF interface. If no special precausions are
> taken, this leads to creation of two conntrack entries instead of one,
> and breaks SNAT.
> 
> Commit above was intended to avoid creation of extra conntrack entries
> when input interface is enslaved in a VRF. It did so by resetting
> conntrack related data associated with the skb when it enters VRF context.
> 
> However it breaks netfilter operation. Imagine a use case when conntrack
> zone must be assigned based on the original input interface, rather than
> VRF interface (that would make original interfaces indistinguishable). One
> could create netfilter rules similar to these:
> 
>         chain rawprerouting {
>                 type filter hook prerouting priority raw;
>                 iif realiface1 ct zone set 1 return
>                 iif realiface2 ct zone set 2 return
>         }
> 
> This works before the mentioned commit, but not after: zone assignment
> is "forgotten", and any subsequent NAT or filtering that is dependent
> on the conntrack zone does not work.
> 
...

> 
> Signed-off-by: Eugene Crosser <crosser@average.org>
> ---
>  drivers/net/vrf.c | 4 ----
>  1 file changed, 4 deletions(-)
> 

Acked-by: David Ahern <dsahern@kernel.org>


