Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1019156ED4
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 06:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgBJF1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 00:27:43 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41165 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgBJF1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 00:27:43 -0500
Received: by mail-qk1-f194.google.com with SMTP id d11so5360841qko.8
        for <netdev@vger.kernel.org>; Sun, 09 Feb 2020 21:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RKGkXdmU+Bvw20Zld49Nf8Rz+6LKuOe4WDBMvdWjcCs=;
        b=ju9d4lJykdFPeKcAWE+BU7DIOhbFn/XrEvF5XOtojvMjb44O7moiXzkIuvPRsOpMQI
         3UcbHv3Qa0mRDKKF3pYgjClr0c+d/hus5EanEm6Q6aZkppfvr5RxT4NFeLtbNG9oqKcn
         kddvt4Re9H3OjbDGYaXVuOY3QC9g6GFjoTKoiGIRJi1WTApBwVRjreTTsM2JHB5EIIBW
         KulOf3IeXcQP0DxnBLfSa1hh05SD7ff41uRwK6SeYhi+JBAXlj3aE1/EdDa8pcv/vUzG
         hg9mX4eKsxZpBqMLryWeBIqpg4/GSaKxffioBrmcSNolARotIG3fg2dw5SQWhPvV8cmp
         4X8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RKGkXdmU+Bvw20Zld49Nf8Rz+6LKuOe4WDBMvdWjcCs=;
        b=f+cxNmIDi+oKd7HpICT9PWzBrqOGV+VwNvl7n5nT/vvqS3tzd6mmTKOHDW4mdepj1Y
         E0D0203oPVfRqioTe7kABthG6Vlxl6jEGqPKBvOCVl8wf5lRZfrrL4uBqwIgDG7m4cr+
         z8uBqql6BZb5x+sIZtw2N9DzZez4DaM9bhQWiNvlX7+hFoL7CNioOUfB7wIQgANpp2Mw
         KrLUuBu72jQGR7Kp0hXwtrAnNFwNl0+waYkm2MFol+R89se1hK0R6Cu6utQRWcrUKFvs
         YZ/azu56ra/uxL5zDhg8APohA8TdkSEA2m6f254QXdgeZhFlT4DomKazE4jx4j6b1llA
         OylA==
X-Gm-Message-State: APjAAAV/Nir4Dz0HKPp6Vgx0tqySNp6m6xKFvAzS1D+pla11sEFEwcQQ
        M2hRdXcjVKy9aOADczWpR7Ccif3C
X-Google-Smtp-Source: APXvYqy6qY4rAp72dwi9dfLRillWQXWKJ3NGvGxJWnEUckK8vzPFuQDRZmzweyzilrgnVZGU8r6DmA==
X-Received: by 2002:a05:620a:1f1:: with SMTP id x17mr9118928qkn.141.1581312462533;
        Sun, 09 Feb 2020 21:27:42 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:ecaf:dd70:4bb2:820f? ([2601:282:803:7700:ecaf:dd70:4bb2:820f])
        by smtp.googlemail.com with ESMTPSA id g62sm5245298qkd.25.2020.02.09.21.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Feb 2020 21:27:41 -0800 (PST)
Subject: Re: [PATCH iproute2-next] nstat: print useful error messages in
 abort() cases
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <0dd54edffe6edd9f0a15dbe9590c251782b743a4.1581012315.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c37151bd-af96-6d7d-e72a-672841458aa1@gmail.com>
Date:   Sun, 9 Feb 2020 22:27:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0dd54edffe6edd9f0a15dbe9590c251782b743a4.1581012315.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/20 11:08 AM, Andrea Claudi wrote:
> @@ -221,8 +231,11 @@ static void load_ugly_table(FILE *fp)
>  		}
>  		n = db;
>  		nread = getline(&buf, &buflen, fp);
> -		if (nread == -1)
> -			abort();
> +		if (nread == -1) {
> +			fprintf(stderr, "%s:%d: error parsing history file\n",
> +				__FILE__, __LINE__);
> +			exit(-2);
> +		}
>  		count2 = count_spaces(buf);
>  		if (count2 > count1)
>  			skip = count2 - count1;
> 

I see 2 more aborts after this one; seems like you should cover those as
well.

Also, given that it is a straightforward replace of abort with error
message + exit, this should probably go to master.
