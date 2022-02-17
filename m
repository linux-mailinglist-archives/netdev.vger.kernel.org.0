Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CFA4B95AF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiBQBw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:52:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiBQBw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:52:58 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277CE1074E6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 17:52:45 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id e19-20020a4ab993000000b0031a98fe3a9dso4218339oop.6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 17:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7JOFveTFH58WpjqbtLe7B5RD9lKkGG7Np2UsKboINi0=;
        b=e2QyCCeRjUh4H/h0hwfFie13p2qXFKZNRj5O2qagZPlie4ySqC3Bck/azO4pLkYVuK
         0mrjdz2T1oF5mqnGk2RKe2RkBelEjNGEBO0gjuJcHc9bR/4y7UuimLQUhNRenmG1ZoXw
         hw/1y11DSbNPQHTLxUTtNcTS8L/CWjDN1wiMHxSinRPEethRRCuQLU/4BJ5zIqx5pCZa
         5JkDGgdItCQIH3H0MrdHSUgFOOMITgFz9hTsMBH4e4ftU7gQHvn/RQSu9tJ6mOPM5QsO
         K7CHOPYGOtOeORxGWykyKJZu0gk+yGv/PNjlk8JpXdhz7j0Rdm54ZNxwZ52a9wSE93Ai
         4YvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7JOFveTFH58WpjqbtLe7B5RD9lKkGG7Np2UsKboINi0=;
        b=3WLnEbP4ONQkJQsLov7MKuyYeIXZZwKyBPwhJIyHfFi34i6Qa4if4HwNk2eC15MT/Z
         HdsLbut8JH42d4EkajZGYHpUSQTfQzbBeLfyN9l2v16hOYgjs3fj3zFGb/UoFfvgE9GV
         U04CJ3BAB9k1ljZs/EcQrNQWU7QfUT2flsPzOqwEgv5J4D/agBk2Ju80GVpdKKHLITk8
         wlYeZiLzITP8QXUgt/3dEjKdTwTKo2Q6SM/B5clJrqzNJyDjMyIeXGYhuI91ZaHcCZq6
         pjraqw4/QXnpcqb40EgslnX+sOu6RlFKXtSKCWaC5su2o2Y9+N0rXavhA2eipwnRoYyX
         EdrQ==
X-Gm-Message-State: AOAM531U49ykb5RQF7rSGwtEtcJ23p7u7EUpYG5pYXX2cha32kxUL5GG
        vNBhDuUCnw1Fumm1DkreSxRT0LJxT6E=
X-Google-Smtp-Source: ABdhPJz3Yb4b1V+BbGKO7NLVgdMagdpcg0UCZF+2nm4LPLTwGzK60jekYuooL8zQOV10yCYBVAqoXA==
X-Received: by 2002:a4a:4cd0:0:b0:318:dac1:1f34 with SMTP id a199-20020a4a4cd0000000b00318dac11f34mr148192oob.92.1645062764455;
        Wed, 16 Feb 2022 17:52:44 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:7844:9da9:9581:42ec? ([2601:282:800:dc80:7844:9da9:9581:42ec])
        by smtp.googlemail.com with ESMTPSA id x17sm15426962oop.1.2022.02.16.17.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 17:52:44 -0800 (PST)
Message-ID: <6dbf4b79-70d4-ed6c-0fd4-c393ab1c90b3@gmail.com>
Date:   Wed, 16 Feb 2022 18:52:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [RFC iproute2] tos: interpret ToS in natural numeral system
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org
References: <20220216194205.3780848-1-kuba@kernel.org>
 <20220216222352.GA3432@pc-4.home>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220216222352.GA3432@pc-4.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 3:23 PM, Guillaume Nault wrote:
> On Wed, Feb 16, 2022 at 11:42:05AM -0800, Jakub Kicinski wrote:
>> Silently forcing a base numeral system is very painful for users.
>> ip currently interprets tos 10 as 0x10. Imagine user's bash script
>> does:
>>
>>   .. tos $((TOS * 2)) ..
>>
>> or any numerical operation on the ToS.
>>
>> This patch breaks existing scripts if they expect 10 to be 0x10.
> 
> I agree that we shouldn't have forced base 16 in the first place.
> But after so many years I find it a bit dangerous to change that.

I agree. In this case the change in behavior will not be very obvious
and could lead to confusion. I think this is something we have to live with.

> 
> What about just printing a warning when the value isn't prefixed with
> '0x'? Something like (completely untested):
> 
> @@ -535,6 +535,12 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
>  	if (!end || end == arg || *end || res > 255)
>  		return -1;
>  	*id = res;
> +
> +	if (strncmp("0x", arg, 2))
> +		fprintf(stderr,
> +			"Warning: dsfield and tos parameters are interpreted as hexadecimal values\n"
> +			"Use 'dsfield 0x%02x' to avoid this message\n", res);
> +
>  	return 0;
>  }

That seems reasonable to me to let users know of this behavior.

> 
> 
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> --
>> I get the feeling this was discussed in the past.
>>
>> Also there's more:
>>
>> devlink/devlink.c:	val = strtoull(str, &endptr, 10);
>> devlink/devlink.c:	val = strtoul(str, &endptr, 10);
>> devlink/devlink.c:	val = strtoul(str, &endptr, 10);
>> devlink/devlink.c:	val = strtoul(str, &endptr, 10);

I think the devlink ones all check out. I think those functions can be
updated to use get_uNN from lib/utils.c.

>> lib/utils.c:	res = strtoul(arg, &ptr, base);

This is get_unsigned and those users outside of tc look ok.

>> lib/utils.c:		n = strtoul(cp, &endp, 16);

ipv6 address conversion which is hex based.

>> lib/utils.c:		tmp = strtoul(tmpstr, &endptr, 16);
>> lib/utils.c:		tmp = strtoul(arg + i * 3, &endptr, 16);

both of these are valid hex conversions


>> misc/lnstat_util.c:			unsigned long f = strtoul(ptr, &ptr, 16);
>> tc/f_u32.c:	htid = strtoul(str, &tmp, 16);
>> tc/f_u32.c:		hash = strtoul(str, &tmp, 16);
>> tc/f_u32.c:			nodeid = strtoul(str, &tmp, 16);
>> tc/tc_util.c:	maj = strtoul(str, &p, 16);
>> tc/tc_util.c:	maj = strtoul(str, &p, 16);
>> tc/tc_util.c:		min = strtoul(str, &p, 16);
> 
> After a very quick look, many of these seem to make sense though. For
> example lnstat_util.c parses output from /proc, hexstring_a2n() is used
> by ipmacsec.c to parse crypto keys, etc.
> 
> But I agree that we should probably audit the strtol() (and variants)
> that don't use base 0.

Added Jamal and Cong for the tc references. Hopefully those are
documented to be hex values.
