Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC5529288A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgJSNsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbgJSNsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 09:48:45 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68764C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 06:48:44 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c2so7778134qkf.10
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 06:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RYiDVZoGpVj44jx8tHHfoDfUQPS2AdMAiB3HH1NTatQ=;
        b=nlaaeqZ1Jfl/Ms4tkTJQsEfu0JxR3HAnQVIx/qiuGGAtcfQ/MbepJUOPQ+TSdgzZcF
         Y1CzToqRFT6egYK68jozwrHALKgGnM1DcVFycLn5dGIpwYGL5WM23++J7oGpes8YdpXx
         7n1/Dybw1yI/RwzMFy/4cF2yGLXYOtutyReQ0ly2oEh0KzNt5Tto+XpM6/n9zpqa6Jml
         z9UmuEH8sUBgevYUMM31Bug8YhEp/gU9kB0dtzsicGw6KAA+wYMHbwoAdeV0v1c0qdWp
         mXkfQkt5Vn0+naM2QwNGUXwUCsuphMSjxAI8SC0sU1dGIKNA3jL5lbBJL8M6OBqxYR6B
         E8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RYiDVZoGpVj44jx8tHHfoDfUQPS2AdMAiB3HH1NTatQ=;
        b=Jlc5hs6OB53xWCcpgJaIvJ+WU3h++lL0y+zhHeH7l+GaCPY1RNvAD+tWZOT/SIdRRV
         5aQbTp24hwczRwEd/ioUrwZhI2JSLIuSGOwItFtjF4YmKZMtxWN2g1ixBTC+e3eMaYXi
         zWTsiWgfQpHMTGMjFKc4+Kvzw5FyCMNIRm0ALbW8w0J2+ariI96m/xB5YvE9yB3WBtv/
         lBQA/oqRhGr+iDqng+ivTqZyODg8e7hUKpv2YxXR2G7wEXaFWCDethYmAGQtG7CQX/kh
         li9ISeKwBlR0Sp9GHEtYzz6S1pADL6KYQHRXmjF+ea6ke3g7zSKGcNt0QbnHKDS+u+rI
         r2Ug==
X-Gm-Message-State: AOAM532ndqSSju2wpPu3G2YkSotKkQ7T1kxjlROawTYkwTxT9HMga1Ik
        uVL2RwH6kALcEqFN+/DNt1NjXQ==
X-Google-Smtp-Source: ABdhPJx4L70Hru3wJ8ZLeUoOvouNCEM6ZywGK19AoXkx6ZKJU1aeEy5eG6hFmpRJKY19F397KuqrHw==
X-Received: by 2002:a37:664f:: with SMTP id a76mr16972606qkc.370.1603115323567;
        Mon, 19 Oct 2020 06:48:43 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id j92sm4217406qtd.1.2020.10.19.06.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 06:48:42 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
Date:   Mon, 19 Oct 2020 09:48:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <877drn20h3.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-18 8:16 a.m., Vlad Buslov wrote:
> On Sat 17 Oct 2020 at 14:20, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2020-10-16 12:42 p.m., Vlad Buslov wrote:
>>

>> Either one sounds appealing - the refactoring feels simpler
>> as opposed to a->terse_print().
> 
> With such refactoring we action type will be printed before some basic
> validation which can lead to outputting the type together with error
> message. Consider tunnel key action output callback as example:
> 
> static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
> {
> 	struct rtattr *tb[TCA_TUNNEL_KEY_MAX + 1];
> 	struct tc_tunnel_key *parm;
> 
> 	if (!arg)
> 		return 0;
> 
> 	parse_rtattr_nested(tb, TCA_TUNNEL_KEY_MAX, arg);
> 
> 	if (!tb[TCA_TUNNEL_KEY_PARMS]) {
> 		fprintf(stderr, "Missing tunnel_key parameters\n");
> 		return -1;
> 	}
> 	parm = RTA_DATA(tb[TCA_TUNNEL_KEY_PARMS]);
> 
> 	print_string(PRINT_ANY, "kind", "%s ", "tunnel_key");
> 
> If print "kind" call is moved before checking the arg it will always be
> printed, even when immediately followed by "Missing tunnel_key
> parameters\n" string. Is this a concern?
> 

That could be a good thing, no? you get to see the action name with the
error. Its really not a big deal if you decide to do a->terse_print()
instead.

>>
>> BTW: the action index, unless i missed something, is not transported
>> from the kernel for terse option. It is an important parameter
>> when actions are shared by filters (since they will have the same
>> index).
>> Am i missing something?
> 
> Yes, tc_action_ops->dump(), which outputs action index among other data,
> is not called at all by terse dump.

I am suggesting it is an important detail that is currently missing.
Alternatively since you have the cookies in there - it is feasible that
someone who creates the action could "encode" the index in the cookie.
But that makes it a "proprietary" choice of whoever is creating
the filter/action.

cheers,
jamal

