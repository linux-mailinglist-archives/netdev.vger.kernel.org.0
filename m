Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C8F21D940
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbgGMOyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729523AbgGMOyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:54:54 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50846C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 07:54:54 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id q17so6102339pfu.8
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 07:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cE8GTdGbJXQCBR6G3zTTxCnILfR4iaZdypgqRySEWvE=;
        b=WJvzCU60eG4WPdQ9oNQG5fQnEGn6071vhh+YkPGN1dzuQgtUKNLF35yu9gp6/0bgTq
         mU64JAc1ZN4lGfz9WHFcME5J2IEUvwQrs8Q865OE1XmUS17A3V/WyabNOHPTn9+JFqoL
         UZc/Zgv3AqZ9EPtMOOnxki9XjJXeXRlhS2GULucU6O75Ed+Npv2LhHoP08WdiqyvWHmE
         CRadIFjTqKOIDe5uXMN8J+GMKpggmth4IUUGlS0YEcha55kWjkcx0TNi4pJmAAf9yIo/
         fAW+/U+UMOHrhZOgg0wbKq5MshxHbVB/IZq4RYwPWoNBUu8aqySUNYVg38WYa9kMAo0P
         cgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cE8GTdGbJXQCBR6G3zTTxCnILfR4iaZdypgqRySEWvE=;
        b=ks564LsYPwx0QDm5i9+4vqJQTIsmgsphgHDEa9tDeBzZJ/sJGX7q+xwsnCHdL7J1s7
         i+Nl56Kd5AZTbZPgr/lbAIHzxw1xi7MVmuRPjBmH0UWaGg1ruHDcL2IpwdYPRsuMenKk
         ubervcBecfs175qKjPPA9Dv0fEKDcOdTxCtoV81uqshlo4BZgrvhtQvrugMl56S0nMoI
         AeTklvrSYwaSuYO1CCC2sXQNRV9+q6Ah4CR1Y/IVXyJs6pP8Q5sFwLe7fgg3DSdhlYV+
         +IoOzFdwtQiQcKod3kA6HeAvEaBflFZWsbCelg5bqkVkjyqWW3zi7VbJR+/Y9qSZ2t9R
         knMw==
X-Gm-Message-State: AOAM5338CHMef1Ah6GLYUjKHtyqd1FwlRbo/wm6O0iCld62HdGeSKXzg
        xYvOaXygEio0uCfuF8aHIg2BmA==
X-Google-Smtp-Source: ABdhPJyFSKiOZV27ihnH/3wqp8V8lFsoNhgGEy3UXkrgIUHl6xphksom4sv8dgmNvl3kSkmXKIecYA==
X-Received: by 2002:a63:5863:: with SMTP id i35mr64699166pgm.390.1594652093815;
        Mon, 13 Jul 2020 07:54:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b21sm14789530pfp.172.2020.07.13.07.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:54:53 -0700 (PDT)
Date:   Mon, 13 Jul 2020 07:54:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Julien Fortin <julien@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2-next master] bridge: fdb show: fix fdb entry
 state output for json context
Message-ID: <20200713075445.33aca679@hermes.lan>
In-Reply-To: <20200710005055.8439-1-julien@cumulusnetworks.com>
References: <20200710005055.8439-1-julien@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jul 2020 02:50:55 +0200
Julien Fortin <julien@cumulusnetworks.com> wrote:

> From: Julien Fortin <julien@cumulusnetworks.com>
> 
> bridge json fdb show is printing an incorrect / non-machine readable
> value, when using -j (json output) we are expecting machine readable
> data that shouldn't require special handling/parsing.
> 
> $ bridge -j fdb show | \
> python -c \
> 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4))'
> [
>     {
>         "master": "br0",
>         "mac": "56:23:28:4f:4f:e5",
>         "flags": [],
>         "ifname": "vx0",
>         "state": "state=0x80"  <<<<<<<<< with the patch: "state": "0x80"
>     }
> ]
> 
> Fixes: c7c1a1ef51aea7c ("bridge: colorize output and use JSON print library")
> Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
> ---
>  bridge/fdb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/bridge/fdb.c b/bridge/fdb.c
> index d2247e80..198c51d1 100644
> --- a/bridge/fdb.c
> +++ b/bridge/fdb.c
> @@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
>  	if (s & NUD_REACHABLE)
>  		return "";
>  
> -	sprintf(buf, "state=%#x", s);
> +	if (is_json_context())
> +		sprintf(buf, "%#x", s);
> +	else
> +		sprintf(buf, "state=%#x", s);
>  	return buf;
>  }
>  

Printing in non JSON case was also wrong.
i.e.
              ...  state state=0x80
should be:
	      ... state 0x80

Let's do that.


The state=xxx value only shows up if the FDB entry has a value bridge command
doesn't understand. The bridge command needs to be able to display the new flag values.

Please fixup the two patches and resubmit to iproute2
