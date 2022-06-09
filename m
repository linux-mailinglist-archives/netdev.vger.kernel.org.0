Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7115451CC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbiFIQY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbiFIQY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:24:56 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA871F2D0
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:24:54 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id e80so1182676iof.3
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 09:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aBEJp/u1BMRNkPURQUHiv4cdSIG1AzZEiThazTKabwk=;
        b=C28Pn2dKuZSsBk9D0iUHIbXo67KFlRLU/MCtXEncBGrjOI2SOpiwKG3urn53UcwqWV
         7ecdrBSNsCO2x8XKJ2I4lsV/NgHjBmWZ+mw0KBsp8CejqHrkpMLtYTtFhWdA0n5MvaqP
         cFBEu23NF4lcg8hKb6fWbD2e6umOTo+pQGQnbDdVS3n5TGGjvPHD/XIIDXldz4tt2ZKu
         ASnQd4vIJ32F+JfQCrx5KqM/vKBI6FcH7MTmiEeDSGIgUxJpF+I98j07stN75t8PDe6c
         FYn9siflVu++I8z3hKzP5qY2eA6PchojGEjIQFbxCsIOpZlHwbhf3fRtQymyOK6/uCSH
         dtwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aBEJp/u1BMRNkPURQUHiv4cdSIG1AzZEiThazTKabwk=;
        b=tusjDTL2fSqIqhpID/DMhWHDkmLijxmN5qUgx11v3duUFfwdK/zrNnyOyefEFRWhCo
         gzPDoVz3/iWHGW8UK2rAk0NWhTOwD0I3gHaD3VTZUt7WrPznmmSWy4H/34rDIaAp79kv
         uyPQDSoXceJV0oiMOSb6K2O+JfwCyBUJemuMjYuz5GQoXzh6nEVfc3t5TTY/0xCROF5o
         IWreYRA1ElBmqMMhSNrVy7oJyFhMWr8LUYOUFZYW8yWsjB9/6bglmnRjOYmRcEbVj+eO
         t6rf/1R1NzA0trN2ykoiCLJ+7dJZASR4fW99G+FtY1GgEPChqeHFvxk+GQmAVayP9gxg
         3wlw==
X-Gm-Message-State: AOAM530ry2aP2IDiZtVGjpIR4Xh6bc3q+WgY15PcGnsjFB4dw85sixO1
        Iqo61QdRafYVNKwoi0wQcgM=
X-Google-Smtp-Source: ABdhPJy9AYd1GcRI0+eUjYy2s3U/iWAt06h5hyhyYCfI5R+D+U4BHYlscBscR5yL3DSqeJiQAdaFpw==
X-Received: by 2002:a05:6638:22c3:b0:32e:ac50:aeb3 with SMTP id j3-20020a05663822c300b0032eac50aeb3mr23149634jat.186.1654791894420;
        Thu, 09 Jun 2022 09:24:54 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:71d0:ca72:803a:2d62? ([2601:282:800:dc80:71d0:ca72:803a:2d62])
        by smtp.googlemail.com with ESMTPSA id a30-20020a02735e000000b0032be3784b9bsm9682539jae.117.2022.06.09.09.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 09:24:53 -0700 (PDT)
Message-ID: <1057acd4-b5b3-ee5b-580b-3086973e71a8@gmail.com>
Date:   Thu, 9 Jun 2022 10:24:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next] show rx_otherehost_dropped stat in ip link
 show
Content-Language: en-US
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        edumazet@google.com, Jeffrey Ji <jeffreyji@google.com>
References: <20220603173016.1383423-1-jeffreyjilinux@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220603173016.1383423-1-jeffreyjilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/22 11:30 AM, Jeffrey Ji wrote:
> From: Jeffrey Ji <jeffreyji@google.com>
> 
> This stat was added in commit 794c24e9921f ("net-core:
> rx_otherhost_dropped to core_stats")
> 
> Tested: sent packet with wrong MAC address from 1
> network namespace to another, verified that counter showed "1" in
> `ip -s -s link sh` and `ip -s -s -j link sh`

Add example output for both commands.

> 
> Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
> ---
>  ip/ipaddress.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 142731933ba3..544c7450b7bf 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -692,6 +692,7 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>  		strlen("heartbt"),
>  		strlen("overrun"),
>  		strlen("compressed"),
> +		strlen("otherhost_dropped"),

This should be shortened to just "otherhost".


>  	};
>  
>  	if (is_json_context()) {
> @@ -730,6 +731,10 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>  			if (s->rx_nohandler)
>  				print_u64(PRINT_JSON,
>  					   "nohandler", NULL, s->rx_nohandler);
> +			if (s->rx_otherhost_dropped)
> +				print_u64(PRINT_JSON,
> +					   "otherhost_dropped", NULL,
> +					   s->rx_otherhost_dropped);
>  		}
>  		close_json_object();
>  
> @@ -811,11 +816,14 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>  		/* RX error stats */
>  		if (show_stats > 1) {
>  			fprintf(fp, "%s", _SL_);
> -			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s %*s%s",
> +			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s%*s%*s%s",
>  				cols[0] - 10, "", cols[1], "length",
>  				cols[2], "crc", cols[3], "frame",
>  				cols[4], "fifo", cols[5], "overrun",
> -				cols[6], s->rx_nohandler ? "nohandler" : "",
> +				s->rx_nohandler ? cols[6] + 1 : 0,
> +				s->rx_nohandler ? " nohandler" : "",
> +				s->rx_otherhost_dropped ? cols[7] + 1 : 0,
> +				s->rx_otherhost_dropped ? " otherhost_dropped" : "",

This is getting ugly. Just "otherhost" here as well.

Before this print there are a few calls to size_columns; seems like
rx_otherhost_dropped should be added to the rx one.


>  				_SL_);
>  			fprintf(fp, "%*s", cols[0] + 5, "");
>  			print_num(fp, cols[1], s->rx_length_errors);
> @@ -825,6 +833,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>  			print_num(fp, cols[5], s->rx_over_errors);
>  			if (s->rx_nohandler)
>  				print_num(fp, cols[6], s->rx_nohandler);
> +			if (s->rx_otherhost_dropped)
> +				print_num(fp, cols[7],
> +				s->rx_otherhost_dropped);
>  		}
>  		fprintf(fp, "%s", _SL_);
>  

