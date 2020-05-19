Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBF21DA17E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 21:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgESTyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 15:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgESTyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 15:54:31 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E37AC08C5C0;
        Tue, 19 May 2020 12:54:31 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l21so439977eji.4;
        Tue, 19 May 2020 12:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VByPDEeI1HK7d/TCXcFKwH3zVw0xUTWM0gH6oQ5n69Q=;
        b=tI4eOIondZmireFQzT/3ncbmAfwHibJSdTI1oEA2wKQLFDS37pqFWStyAvFkw5Vsr8
         7rTZCk2DeH5OLKxgcvCrnx1GKSP2NHMXdxUC9iSZQL+Qi9Ir7EKligf7jqu2s9haM3vS
         9xujT6dOPE8gUEOL54j7fmW13vWmTq0UFOwAL6EeSAi/DSbj4ABMboIt0h6zHgA2rdi8
         H1NBoU21t+YuiPTNky6HgHKMWLhrxMSsK73yjTn/06urGUAsCjEcRETTtQThsvcARCyD
         bvEYi+z9Z1OFtoy5aXV0MNhBiHCGykhQh18J8af/Uz8ldw+us4+TwbSd5PrpUxb0DPCq
         Qffg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VByPDEeI1HK7d/TCXcFKwH3zVw0xUTWM0gH6oQ5n69Q=;
        b=ECT/M0eEKiWMF0HPKmLg1jkSwfgIUSW63OLWai+bFr2OWLM8PSsDO0vGY6DIQb5ikG
         /rVrNBCLVeIhmNGSMacCtDbVStlzRMVKoLASgbFQZjKfxNeL6IZigwMxRbHvGp0krmOV
         Jq33PDw5/qSVPF2tiSxkfUUnMMHMudNyykzk4vBz2aJ0clMA4FtyQEkcS9/6V7yZmtih
         MeZbQiY+6Q0oFNo8YEnr0vFwdBv4VPkt9g96zIAymsWfg3W90NetlMRd7CwCJmpM2Xhb
         3EvHC4ihAWpYeZoFnZLwcjGy7cj03HM7k8/DgDTfSuzqC1DjHj+JmCZXJD8+iLcvpECE
         JjYQ==
X-Gm-Message-State: AOAM531WQnFkkloCN9xP8sMiNql29ENvDO/RhpBFqCr4yptlYAo9pkis
        SLhr0DGptAzWXs42CCd23OTt+0P+dfw=
X-Google-Smtp-Source: ABdhPJz94e36HUAjFGPfAXqLzJjcIkOxCqV3Rno8lBfEPU/7pk3+VG57xWRYWCBdsbPjMosbWcMfow==
X-Received: by 2002:a17:906:94c6:: with SMTP id d6mr888029ejy.88.1589918069702;
        Tue, 19 May 2020 12:54:29 -0700 (PDT)
Received: from ?IPv6:2001:a61:2482:101:a081:4793:30bf:f3d5? ([2001:a61:2482:101:a081:4793:30bf:f3d5])
        by smtp.gmail.com with ESMTPSA id g15sm184960edf.92.2020.05.19.12.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 12:54:29 -0700 (PDT)
Cc:     mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH] veth.4: Add a more direct example
To:     "Devin J. Pohly" <djpohly@gmail.com>
References: <20200518205828.13905-1-djpohly@gmail.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <f2833b9c-8619-c327-48dc-69fae97b20cc@gmail.com>
Date:   Tue, 19 May 2020 21:54:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518205828.13905-1-djpohly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Devin

On 5/18/20 10:58 PM, Devin J. Pohly wrote:
> iproute2 allows you to specify the netns for either side of a veth
> interface at creation time.  Add an example of this to veth(4) so it
> doesn't sound like you have to move the interfaces in a separate step.
> 
> Verified with commands:
>     # ip netns add alpha
>     # ip netns add bravo
>     # ip link add foo netns alpha type veth peer bar netns bravo
>     # ip -n alpha link show
>     # ip -n bravo link show

Nice patch, and nice commit message! Thanks. Applied.

Cheers,

Michael

> ---
>  man4/veth.4 | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/man4/veth.4 b/man4/veth.4
> index 20294c097..2d59882a0 100644
> --- a/man4/veth.4
> +++ b/man4/veth.4
> @@ -63,13 +63,23 @@ A particularly interesting use case is to place one end of a
>  .B veth
>  pair in one network namespace and the other end in another network namespace,
>  thus allowing communication between network namespaces.
> -To do this, one first creates the
> +To do this, one can provide the
> +.B netns
> +parameter when creating the interfaces:
> +.PP
> +.in +4n
> +.EX
> +# ip link add <p1-name> netns <p1-ns> type veth peer <p2-name> netns <p2-ns>
> +.EE
> +.in
> +.PP
> +or, for an existing
>  .B veth
> -device as above and then moves one side of the pair to the other namespace:
> +pair, move one side to the other namespace:
>  .PP
>  .in +4n
>  .EX
> -# ip link set <p2-name> netns <p2-namespace>
> +# ip link set <p2-name> netns <p2-ns>
>  .EE
>  .in
>  .PP
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
