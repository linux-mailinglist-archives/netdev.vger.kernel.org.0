Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFDB547AE6
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbiFLPzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 11:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbiFLPzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 11:55:09 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19A83B3CF
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 08:55:06 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id s23so3777402iog.13
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 08:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XyVvnb7Q7wEPVWN8IYvnf1V36f9VvQfLnASNcvGg/pE=;
        b=SVb1E5jNtdChoo3TSAaiMYVV2DtiszToj5rmWaUhemjWI1Kx+LsrMY5BKmLWOoRgl8
         gZS2zLfKHvojwnYNuFP4eJdSkMm4JWybnE/VguozEeBV8OeFsLewxGcQA8yr8iGXU1MF
         vKuSlQ2+lxvt1Y7VvPbDbxSzDmouqKGqjw174obwsqhDXCJ8Fg+LSEa5NmoQv8P3Hlfs
         gYbb3Wyj7JQozPpcUlbV69jRxTuc4RJhvlCAJHgNfnM5QurGK572VseCWybqx+OP076f
         Cqim65z+MTjvuPvO7EvlUHSw3Bb5IcjB9ft0gfe+PTvmxQ9cC0t43xRw6dTwBhxM4k8f
         +qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XyVvnb7Q7wEPVWN8IYvnf1V36f9VvQfLnASNcvGg/pE=;
        b=PTOdqalxZH6xvmQH1kTOVkCmIPqoGCVhjQPTJnURjYyEM68ggSKkC5t2qA2BIJ7NXM
         skZs+7HS5NM76BGkvsyWeRGAn62+2OOJcoNrQiOhye9JGEeK8SnF+v8pmvE1pwrWvrvt
         mvMfhDfGxND2wycNBL8GESAHLaiB2C5pZaE93y1Caz5oAkaSoHt6yvv4fSvdjPQTXGwP
         Ju8RDmZxFDc9XM7UWzn7uVukFPFIXDPGHmyrJyTzRcoK4+O9zRB7TE8Z4mcO1qsuAein
         xC/S86HFweZwgDu3fQDlGsGPpq10lZmo6dT+dTxhqoAzwASocnXZJ/ZqjW9+2nHH55Go
         2Fgw==
X-Gm-Message-State: AOAM532VPCx/Q+iHyLhd5Gz/BAPndqLmrqUUCONJDA0SnqSfNyWtC4ff
        VXvwiC5HL3MkzcqMCVRmPCG9yWOPQ8SQUg==
X-Google-Smtp-Source: ABdhPJwnQr3cNYXaQjsfy20rOllJIUYATI0+gv9ly/jS18cezJQHZ3bPHF8bLrIVPUqZzY64p69CeQ==
X-Received: by 2002:a02:cab3:0:b0:332:c2b:d815 with SMTP id e19-20020a02cab3000000b003320c2bd815mr8545595jap.79.1655049306293;
        Sun, 12 Jun 2022 08:55:06 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:71d0:ca72:803a:2d62? ([2601:282:800:dc80:71d0:ca72:803a:2d62])
        by smtp.googlemail.com with ESMTPSA id h25-20020a05660224d900b00669b8999911sm2744528ioe.15.2022.06.12.08.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 08:55:05 -0700 (PDT)
Message-ID: <6ea8a63f-dbf9-bc30-82f1-1a199ff1d1bc@gmail.com>
Date:   Sun, 12 Jun 2022 09:55:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next v2] show rx_otherehost_dropped stat in ip
 link show
Content-Language: en-US
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Brian Vazquez <brianvv@google.com>, netdev@vger.kernel.org,
        Jeffrey Ji <jeffreyji@google.com>
References: <20220609210516.2311379-1-jeffreyjilinux@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220609210516.2311379-1-jeffreyjilinux@gmail.com>
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

On 6/9/22 3:05 PM, Jeffrey Ji wrote:
> From: Jeffrey Ji <jeffreyji@google.com>
> 
> This stat was added in commit 794c24e9921f ("net-core: rx_otherhost_dropped to core_stats")
> 
> Tested: sent packet with wrong MAC address from 1
> network namespace to another, verified that counter showed "1" in
> `ip -s -s link sh` and `ip -s -s -j link sh`
> 
> Signed-off-by: Jeffrey Ji <jeffreyji@google.com>
> ---
> changelog:
> v2: otherhost <- otherhost_dropped
> 
>  ip/ipaddress.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 

...

> @@ -825,6 +834,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>  			print_num(fp, cols[5], s->rx_over_errors);
>  			if (s->rx_nohandler)
>  				print_num(fp, cols[6], s->rx_nohandler);
> +			if (s->rx_otherhost_dropped)
> +				print_num(fp, cols[7],
> +				s->rx_otherhost_dropped);

brought  that up to 1-line and applied to iproute2-next


