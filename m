Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7595C2A1899
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbgJaPhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbgJaPhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:37:48 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15F2C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:37:47 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z17so10615383iog.11
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HA9JMVMVy33+WgX26UU86gsuFGgvCzguZle4arn2nVY=;
        b=cRSnfu0cBOlQ1jYeM5+g5A2K5OjEeZx4Jd7D92fX42N/7clRna+JAQ1e8/KISv/hJy
         oVu73VxYmafjXpEk05E39KrlJhVOjr88yHCWkBM6TdPX7g8nl+ETmPIDFj5H1CbvzvmU
         NcZqryV9VTab5iO18dBrHjKmuzs3DKvkVHo543Wtjho7ayVSmpe7GUbe58KHNAR8Q7rR
         kXJly1UO2qFKzLZJzVcsQQkP4s/XHqoVx08qtQ80MDSEvJK+ZfmXNSNzx0EscfY5tFaB
         /NpiK/xbdliSS5lOMeOu2TRhVUwvluGUW0D7/71fG3jKBAZvSXThK9PEOr3mpMBGJ0FL
         KqDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HA9JMVMVy33+WgX26UU86gsuFGgvCzguZle4arn2nVY=;
        b=fFuuYkMUxw/izrluOUysgGEUNRIrDcKHvtpWVmZKjTUkdFTmchcaw71u/C7L3TYTI0
         0/V9RYBlIiGkDDwt+i8I6FuaWGc7odg/c251jYUP3NctSuqUrqK7NVMqjWCsx4sGISsH
         Gpf+wMznxlHDeR0rEM4kvxEe+zx687h09KfQA+TYseOaA0HGyJK9UGxqdbTM+XqyziNM
         zJuIRYMQz9DPHD9etDOfU+sOetNyIiGz6K5aFJzvGFaCTnzrEWOSuryUCT+PIF6OU9b4
         Kdg+/zkCvVO6Li0kx5jpk8YNLlL8alClDSa6rzycrrDDFy8NMj3m502Xx5D4vWF9S3fn
         xg+A==
X-Gm-Message-State: AOAM530O+BKyx4nWQNtyViG/VFOWi7IFQCbrBq6JQO7JU9bqTvkuK5vG
        85AV073Ohj7OhyLMIgInPiQ=
X-Google-Smtp-Source: ABdhPJycl8sq7PnRKnec1To28jNqa1l7X+XbB1zI1o4oeJoWJUs0c3chRlwenyB8T4eZW6pB8drBkw==
X-Received: by 2002:a5d:9656:: with SMTP id d22mr5409420ios.50.1604158667175;
        Sat, 31 Oct 2020 08:37:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:10cc:b439:52ba:687f])
        by smtp.googlemail.com with ESMTPSA id v26sm6462933iot.35.2020.10.31.08.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 08:37:46 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 02/11] lib: Add parse_one_of(),
 parse_on_off()
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
References: <cover.1604059429.git.me@pmachata.org>
 <194ae677df465086d6cd1d7962c07d790e6d049d.1604059429.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a814a899-f811-d634-2f0c-8e3240bfcfa4@gmail.com>
Date:   Sat, 31 Oct 2020 09:37:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <194ae677df465086d6cd1d7962c07d790e6d049d.1604059429.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/20 6:29 AM, Petr Machata wrote:
> diff --git a/lib/utils.c b/lib/utils.c
> index 9815e328c9e0..930877ae0f0d 100644
> --- a/lib/utils.c
> +++ b/lib/utils.c
> @@ -1735,3 +1735,31 @@ int do_batch(const char *name, bool force,
>  
>  	return ret;
>  }
> +
> +int parse_one_of(const char *msg, const char *realval, const char * const *list,
> +		 size_t len, int *p_err)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++) {
> +		if (list[i] && matches(realval, list[i]) == 0) {
> +			*p_err = 0;
> +			return i;
> +		}
> +	}
> +
> +	fprintf(stderr, "Error: argument of \"%s\" must be one of ", msg);
> +	for (i = 0; i < len; i++)
> +		if (list[i])
> +			fprintf(stderr, "\"%s\", ", list[i]);
> +	fprintf(stderr, "not \"%s\"\n", realval);
> +	*p_err = -EINVAL;
> +	return 0;
> +}
> +
> +int parse_on_off(const char *msg, const char *realval, int *p_err)
> +{
> +	static const char * const values_on_off[] = { "off", "on" };
> +
> +	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
> +}
> 

This has weird semantics to me. You have a buried array of strings and
returning the index of the one that matches. Let's use a 'bool' return
for parse_on_off that makes it clear that the string is 'off' = false or
'on' = true.
