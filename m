Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B36A3DA674
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbhG2Ocq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbhG2Ocp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 10:32:45 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C0AC061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 07:32:41 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id y18so8713386oiv.3
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 07:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FJ3kUlNELV+mdj9rT/U5undxji+b29Ou2maAMwlkq8Y=;
        b=I/mmYjOK/WRsmQIiDGwsk9UJpTZmx9qoUEB66sMwnK+7KFpERvIEKRpJDqETGxC0m7
         7+LseWp1MGtL7m2HtO1eJ470T/vd+e1r5wFv7oujeEvuvMlCICxVQVpg/58LPZNL09DJ
         oIyPZJD5pLSiUv4MCIh9lXon5NdSrh+XQQ0CMDCAPFh8N+hIAM0Dy4RNNzyJkIuAbtbe
         sLL9WeJI8Lq7UoV3bxEs8W3J2oKqjGOnSPINFn1AHaV6TZPqLF1Xoho2A6okZqdmIXBf
         ERtaim0/q1HEN4rlqN6sash/knketq3XJY+G2nZ3rXHapNwiiuMwsGHV5stvwxtkt1c5
         wT8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FJ3kUlNELV+mdj9rT/U5undxji+b29Ou2maAMwlkq8Y=;
        b=kOXVhqyR5UwPZyQC6Gz9bO/8DMCxT8NFAVUV36fkoU2QtRib9FLzpSO/HYOGT9/RZL
         UU0zWvLUoZ6WDoNriCchE5xf9Y5GQvudJpi1uQa1z/WsXsZ8F/0h1qCBmAuPEtY4jFqt
         H9LK3cFRzs5K6MogfsGd3jwfUgDO+f6vwpzah6ExlpAwKLid8qbl5VTt6Q4cG8oNmo7l
         dmY1D92ASmTA4Cf4qxv4Z4zdRUIhxhrp5dQDVg2sSPx6IJIaQcCGLLl42+K4KpUOqxFh
         USyhohvJzQMCrTZWtPUJh5VY8jmaLRTWywaVFSH5G13/1r8a0T27c9y+6KnH7scN0yx5
         Qg4g==
X-Gm-Message-State: AOAM5314pSk5UN75gSEoBhlt2laN5Kit/85wwiIYNvFLRqBqXnocB6XG
        aG1mLjdARcJ2wQeZvvsq+O8=
X-Google-Smtp-Source: ABdhPJyGU2CKW5keUjUyQoktUpQSSny5U2d/ymegv2OANJLTzS33GPJWnEyfb2MIqX8v0n3WjXvgtA==
X-Received: by 2002:a05:6808:1309:: with SMTP id y9mr3311632oiv.134.1627569160988;
        Thu, 29 Jul 2021 07:32:40 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id g39sm546667otg.62.2021.07.29.07.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 07:32:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 1/3] Add, show, link, remove IOAM
 namespaces and schemas
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
References: <20210724172108.26524-1-justin.iurman@uliege.be>
 <20210724172108.26524-2-justin.iurman@uliege.be>
 <54514656-7e71-6071-a5b2-d6aa8eed6275@gmail.com>
 <506325411.28069607.1627552295593.JavaMail.zimbra@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6c6b379e-cf9e-d6a8-c009-3e1dbbafb257@gmail.com>
Date:   Thu, 29 Jul 2021 08:32:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <506325411.28069607.1627552295593.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/21 3:51 AM, Justin Iurman wrote:
> Hi David,
> 
>>> +static void print_schema(struct rtattr *attrs[])
>>> +{
>>> +	__u8 data[IOAM6_MAX_SCHEMA_DATA_LEN + 1];
>>> +	int len;
>>> +
>>> +	print_uint(PRINT_ANY, "schema", "schema %u",
>>> +		   rta_getattr_u32(attrs[IOAM6_ATTR_SC_ID]));
>>> +
>>> +	if (attrs[IOAM6_ATTR_NS_ID])
>>> +		print_uint(PRINT_ANY, "namespace", " [namespace %u]",
>>> +			   rta_getattr_u16(attrs[IOAM6_ATTR_NS_ID]));
>>> +
>>> +	len = RTA_PAYLOAD(attrs[IOAM6_ATTR_SC_DATA]);
>>> +	memcpy(data, RTA_DATA(attrs[IOAM6_ATTR_SC_DATA]), len);
>>> +	data[len] = '\0';
>>> +
>>> +	print_string(PRINT_ANY, "data", ", data \"%s\"", (const char *)data);
>>
>> The attribute descriptions shows this as binary data, not a string.
> 
> Indeed. Maybe should I print it as hex... What do you think is more appropriate for this?

./tc/em_meta.c has print_binary() but it is not json aware.

devlink has pr_out_binary_value which is close. You could probably take
this one and generalize it.


> 
> 
>>> +static int ioam6_do_cmd(void)
>>> +{
>>> +	IOAM6_REQUEST(req, 1036, opts.cmd, NLM_F_REQUEST);
>>> +	int dump = 0;
>>> +
>>> +	if (genl_family < 0) {
>>> +		if (rtnl_open_byproto(&grth, 0, NETLINK_GENERIC) < 0) {
>>> +			fprintf(stderr, "Cannot open generic netlink socket\n");
>>> +			exit(1);
>>> +		}
>>> +		genl_family = genl_resolve_family(&grth, IOAM6_GENL_NAME);
>>
>> The above 2 calls can be done with genl_init_handle.
> 
> Didn't know that one, thx for the pointer.
> 
> 
>>> +int do_ioam6(int argc, char **argv)
>>> +{
>>> +	bool maybe_wide = false;
>>> +
>>> +	if (argc < 1 || matches(*argv, "help") == 0)
>>> +		usage();
>>> +
>>> +	memset(&opts, 0, sizeof(opts));
>>> +
>>> +	if (matches(*argv, "namespace") == 0) {
>>
>> matches has been shown to be quite frail. Convenient for shorthand
>> typing commands, but frail in the big picture. We should stop using it -
>> especially for new commands.
> 
> Sure. What do you suggest as an alternative?
> 

full strcmp.
