Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FAD402C1E
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345502AbhIGPr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:47:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345471AbhIGPr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 11:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631029580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R5YpzENjCAZnWmxZYt06aJmKsAklnr4SbSNukeD66ZY=;
        b=M8Mi+lWHF6m/5U40nL8DR9sb/XxSGUjUR4yW4C9h0k33y59uftRgIJLQAE+NRisl4IBAl/
        FrKF6XkrphJpKb9EjbW5zxo1/1TDytaEtkLj+b3wuCdFTo8+jEuOr5R+K5aFnLTbskMbPd
        P9E5tYMDb+CpGCyAuGynVxnz3uEQ22g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-en613WuYNfyH8-ZK_RomYg-1; Tue, 07 Sep 2021 11:46:19 -0400
X-MC-Unique: en613WuYNfyH8-ZK_RomYg-1
Received: by mail-wr1-f69.google.com with SMTP id y13-20020adfe6cd000000b00159694c711dso2258805wrm.17
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 08:46:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R5YpzENjCAZnWmxZYt06aJmKsAklnr4SbSNukeD66ZY=;
        b=eDVjQLRaP8+hK4/zPLR162f6QRI8WM8w0uxfa4j+rU8ddyU2c4PLy6WAdfp3OwM9bc
         FmVqn8+bPbCV7yOfxTQMcrizOFw72PUmPa1eStk51OIzgIqp/1UJTLnDW2vNl7e4cgRv
         Y8YCfibZPu3Q9N9wvzeXdZPQ7Hw3iUj6r1RPj1n/3J+P6cOn562m/9FQas0vFUZd1ebi
         YhUcStzd9ycOv391qq8g85xVdSZCBYGkM/vtPdnvzGgIMLfjdwCx62LmmW1TVNVkD6dp
         sDNdddraxW7IMzqKrv1TeerPJzHU8nkPhSap9eJ8CBboNdudplRWvo3sUociylxl3WIh
         LrpA==
X-Gm-Message-State: AOAM5337O0vKI4baE62kjVsklKDKdKiru7UbaDHplk2C4y2shNKMJXgB
        Y4qX8RUj1oCexLee8bfQHbOKLjodGkzsR3DIdDpHDk/yApb+Ks0xR7edWOH6mrAvT2YXy54X8K3
        aoaN/8ca3JVAu/PrI
X-Received: by 2002:adf:c452:: with SMTP id a18mr19749354wrg.225.1631029577960;
        Tue, 07 Sep 2021 08:46:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR7NtlmqRSHHR1ITnCSj/B6npbV8/LRO0ab8hROGdN62Oo5l2Mai/J6BetaH8CoYnWqEl7QA==
X-Received: by 2002:adf:c452:: with SMTP id a18mr19749342wrg.225.1631029577740;
        Tue, 07 Sep 2021 08:46:17 -0700 (PDT)
Received: from localhost (net-188-218-11-235.cust.vodafonedsl.it. [188.218.11.235])
        by smtp.gmail.com with ESMTPSA id a6sm11734433wrh.97.2021.09.07.08.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 08:46:16 -0700 (PDT)
Date:   Tue, 7 Sep 2021 17:46:16 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Wen Liang <liangwen12year@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com, aclaudi@redhat.com
Subject: Re: [PATCH iproute2 1/2] tc: u32: add support for json output
Message-ID: <YTeJSHTGMbzdbQg5@dcaratti.users.ipa.redhat.com>
References: <cover.1630978600.git.liangwen12year@gmail.com>
 <5c4108ba5d3c30a0366ad79b49e1097bd9cc96e1.1630978600.git.liangwen12year@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c4108ba5d3c30a0366ad79b49e1097bd9cc96e1.1630978600.git.liangwen12year@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 09:57:50PM -0400, Wen Liang wrote:
> Currently u32 filter output does not support json. This commit uses
> proper json functions to add support for it.
> 
> Signed-off-by: Wen Liang <liangwen12year@gmail.com>


hello Wen,

this series does not break TDC selftests for the u32 classifier (well,
on net-next those tests are temporarily broken because it still misses
[1]. However, the fix should propagate soon - and I verified that the
tests keep passing after applying [1] and your series).

> ---
>  tc/f_u32.c | 66 ++++++++++++++++++++++++++----------------------------
>  1 file changed, 32 insertions(+), 34 deletions(-)
> 
> diff --git a/tc/f_u32.c b/tc/f_u32.c
> index a5747f67..136fb740 100644
> --- a/tc/f_u32.c
> +++ b/tc/f_u32.c
> @@ -1213,11 +1213,11 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
>  
>  	if (handle) {
>  		SPRINT_BUF(b1);
> -		fprintf(f, "fh %s ", sprint_u32_handle(handle, b1));
> +		print_string(PRINT_ANY, "fh", "fh %s ", sprint_u32_handle(handle, b1));
>  	}
>  
>  	if (TC_U32_NODE(handle))
> -		fprintf(f, "order %d ", TC_U32_NODE(handle));
> +		print_int(PRINT_ANY, "order", "order %d ", TC_U32_NODE(handle));
>  
>  	if (tb[TCA_U32_SEL]) {
>  		if (RTA_PAYLOAD(tb[TCA_U32_SEL])  < sizeof(*sel))
> @@ -1227,15 +1227,13 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
>  	}
>  
>  	if (tb[TCA_U32_DIVISOR]) {
> -		fprintf(f, "ht divisor %d ",
> -			rta_getattr_u32(tb[TCA_U32_DIVISOR]));
> +		print_int(PRINT_ANY, "ht divisor", "ht divisor %d ", rta_getattr_u32(tb[TCA_U32_DIVISOR]));

the JSON specification [2] does not forbid spaces in names (if they are
enclosed in double quotes, like it happens in the the iproute2 case),
however I think that "ht_divisor" should sound better than "ht divisor"
in the JSON name.

Look at this example (done on my fedora that uses fq_codel):

 $ tc -j qdisc show | jq '.[1].options.memory limit'
 jq: error: syntax error, unexpected IDENT, expecting $end (Unix shell
 quoting issues?) at <top-level>, line 1:
 .[1].options.memory limit                    
 jq: 1 compile error
 $ tc -j qdisc show | jq '.[1].options.memory_limit'
 33554432
 $ tc -j -j qdisc show | jq '.[1].options."memory limit"'
 
 $ 

Since it's a "memory_limit", and not a "memory limit", I can forget
about quotes and my jq is happy either ways. Do you think it's worth
respinning your patches with those names converted to avoid whitespaces
in names? the same applies for other elements in your series.

(Sorry if this comment might sound nit-picking, but the iproute2 output is
known to be used thoroughly in scripts. So, maybe it's better to do a
robust design)

thanks!
-- 
davide

[1] https://lore.kernel.org/netdev/20210804091828.3783-1-phil@nwl.cc/
[2] https://www.ecma-international.org/wp-content/uploads/ECMA-404_2nd_edition_december_2017.pdf

