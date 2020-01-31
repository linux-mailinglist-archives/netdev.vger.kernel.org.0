Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8801F14E9A0
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 09:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgAaIjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 03:39:04 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35222 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgAaIjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 03:39:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id g17so7638938wro.2;
        Fri, 31 Jan 2020 00:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FoKfCmWfNgqHkhotqXl/ixOYix4Lzf/o3uYst0hF2UA=;
        b=VLx0SPVk3erxoohzVjmMM5bwQxKcDqDMF0lYxtUvC587AjI8a6v1jpeIs6H8U8cFwk
         UFyHh5LfCL+bAiO+wV0P8uY6ba3usoJ+/UyJu/R+aQV8hXW4cnNkVPNFWEluhtU3EqVT
         IqwLzZKvMkVz4Tfe6gufZujFHg+AtdeJGG4Q1jaWSRYglDJFLYXh0Su3umNtC2g1H/He
         MxajuBoza96LrvOZc1ccSoQJpC+FpXQWlH/mw7VZZ7ywaKB9hzv2ptROuGsejPdY6mLs
         z4M240EyTFeIGM4kjzPaLUxXyvbPqpIVMWv2roDUN92OnjpKPTQKjRnAmrMx3T6CNXCE
         ibOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FoKfCmWfNgqHkhotqXl/ixOYix4Lzf/o3uYst0hF2UA=;
        b=UsfMkI4atASmd+2NFlLIj5Nn2DAeqamq25ISF2kTh/2hJv58kD92RKZc4oWtjnjCyw
         KLQhTCPiLrrHog5QpElb4ZFVuMUaX7qDvplhylxcOPonWygvrH7gd5fcI9YLLrXxhr4S
         UQuAeJDshoFfjk4Rz3irS4uW456fcnrI3RmkIHIepwpILzMbvxEYPajsznA4vL+TT93t
         oARaQNh+lNb7Ly1yOu6wNNNU/Ky43w7emlitkFwe2lSIPdbeJqLJ/zCjdjEMyD4b+wL4
         sLFeTQ6DGcs1COn7WH1gyFS0QUeIwxwrP+kq+MTM2Kw+xQsrXZdsOz/rryzL1M7koTS7
         8cSg==
X-Gm-Message-State: APjAAAVsbo06+VHImuz+4fRv3qwzk4XOnvw9rQx7f4YNBpNZ/ZKxTYBF
        G5UZx+Lz1RgLftb0+F8Pb/dHgH4p5qs=
X-Google-Smtp-Source: APXvYqy9LfLp7An1Q2b5wirRcJvPO1Z6lbAngUDPPZW0ZGTDAvuAgC3HzBXA0Dbx0Qfr8HidAsN6jA==
X-Received: by 2002:adf:e609:: with SMTP id p9mr10602775wrm.397.1580459940732;
        Fri, 31 Jan 2020 00:39:00 -0800 (PST)
Received: from quaco.ghostprotocols.net (catv-212-96-54-169.catv.broadband.hu. [212.96.54.169])
        by smtp.gmail.com with ESMTPSA id v17sm10526092wrt.91.2020.01.31.00.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 00:39:00 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id F3C2940A7D; Fri, 31 Jan 2020 09:38:58 +0100 (CET)
Date:   Fri, 31 Jan 2020 09:38:58 +0100
To:     Cengiz Can <cengiz@kernel.wtf>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] tools: perf: add missing unlock to maps__insert error
 case
Message-ID: <20200131083858.GH3841@kernel.org>
References: <20200120141553.23934-1-cengiz@kernel.wtf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120141553.23934-1-cengiz@kernel.wtf>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Jan 20, 2020 at 05:15:54PM +0300, Cengiz Can escreveu:
> `tools/perf/util/map.c` has a function named `maps__insert` that
> acquires a write lock if its in multithread context.
> 
> Even though this lock is released when function successfully completes,
> there's a branch that is executed when `maps_by_name == NULL` that
> returns from this function without releasing the write lock.
> 
> Added an `up_write` to release the lock when this happens.
> 
> Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
> ---
> 
> Hello Arnaldo,
> 
> I'm not exactly sure about the order that we must call up_write here.
> 
> Please tell me if the `__maps__free_maps_by_name` frees the
> `rw_semaphore`. If that's the case, should we change the order to unlock and free?

No it doesn't free the rw_semaphore, that is in 'struct maps', what is
being freed is just something protected by rw_semaphore,
maps->maps_by_name, so your patch is right and I'm applying it, thanks.

- Arnaldo
 
> Thanks!
> 
>  tools/perf/util/map.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index fdd5bddb3075..f67960bedebb 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -549,6 +549,7 @@ void maps__insert(struct maps *maps, struct map *map)
> 
>  			if (maps_by_name == NULL) {
>  				__maps__free_maps_by_name(maps);
> +				up_write(&maps->lock);
>  				return;
>  			}
> 
> --
> 2.25.0
> 

-- 

- Arnaldo
