Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA3D4D6B77
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 01:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiCLAhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 19:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiCLAhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 19:37:42 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34641253
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:36:38 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id b7so6130280ilm.12
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=gNHcDn0XyW0WOhftlgrs7ODGHy0YZt2ZzJIfeiWQGG0=;
        b=pAmsUpdAmhx3k3Y0iBQ0bRRGQv3xa3aFcNr7cBAi3830qRBbmEOWvIt6ravzQxGhHL
         EYKrS+mXpa1nMzhMtp3ZJXV/uyeZx1lDn82ctIZDo7uIabx30cK5rJcPmAKMYtBtn6UP
         gyn0P9+A5STgidAI8n+3rgpPI7NeTFilC1iXIRQWVga5Z1QcguQAwDFIFdneNAjK06+c
         kE5BqW7veFsrhJF1vIfCFxnLfMPqWa8842lQRgOWp06yRHVIHfbwTAFrjU8NOHXkiI3t
         wzxmCRXcHYSQLSYpRfkjAfGWq/hywvaWmoIcTwwjAOG8IS9IuZwg2UCppA/s9yyxaZi9
         r7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gNHcDn0XyW0WOhftlgrs7ODGHy0YZt2ZzJIfeiWQGG0=;
        b=HL3fVTR861G4+LBXwkok6VDnTYKZpAFRtdAZKODm4ZYWQ+vSBN/t7mUQSuHST7cw1a
         nLmqVQmyA01YGq4HN6uWWf9t+jL6wRWs/YpcM6yH4Mo9mcEcHGxvKRvQHFO4tgXvnrYO
         ZBiPnV8YcPpO8kBtHEZrwDZ7sWoytLYZq9oTJq5rajChvQQfemp1icRel7zT2nACV/UQ
         UyQ04C9EPWKimLjIBGk37kiXwh11qV8xKGPad9/Qd7G+IAHdwmN8ze7QfrwDweYhAQPh
         GdRWBwPJtNhroUXp0qJhNNHiXY91AlT+INQZCV4oNVw20Z9EzsSUKwiVAUSXO6i0PjF5
         VD4Q==
X-Gm-Message-State: AOAM531KD+roSwiWjJ1NyNTIqiw9Kuz+aC/TgJyzgy0fIjn1yzlYCfjq
        jAtISKoNucYIIlWZfO3JDfzih9oPRAsMtA==
X-Google-Smtp-Source: ABdhPJz1XIm3PqK74sPIFtbRmt3K2yegQxtV7FxXMu2C6aE+3ygxBfBEnZ/emMwHbk1oYgPs86zg7w==
X-Received: by 2002:a92:d201:0:b0:2c6:4b38:634e with SMTP id y1-20020a92d201000000b002c64b38634emr10393283ily.148.1647045397581;
        Fri, 11 Mar 2022 16:36:37 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id b1-20020a926701000000b002c25d28d378sm5105446ilc.71.2022.03.11.16.36.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 16:36:36 -0800 (PST)
Message-ID: <a3ab5052-51ac-81d6-c65e-cfcfede3297a@gmail.com>
Date:   Fri, 11 Mar 2022 17:36:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: vrf and multicast problem
Content-Language: en-US
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <1e7b1aec-401d-9e70-564a-4ce96e11e1be@candelatech.com>
 <4c4f21f3-75b5-5099-7ee8-28e3c4d6b465@gmail.com>
 <50f1a384-c312-d6ec-0f42-2b9ce3a48013@candelatech.com>
 <38ecaaaf-1735-9023-2282-5feead8408b7@gmail.com>
 <08eeb237-5126-98ce-0990-5b7d7f6529f2@candelatech.com>
 <43de8172-0cd4-bf6f-b89b-864fd7bf4dee@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <43de8172-0cd4-bf6f-b89b-864fd7bf4dee@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 6:41 PM, Ben Greear wrote:
>>> can you reproduce this using namespaces and veth pairs? if so, send me
>>> the script and I will take a look.
>>
>> I think debugging it will be easier than writing something for you to
>> reproduce it...

A test case needs to be added to
tools/testing/selftests/net/fcnal-test.sh; nettest.c provides the
networking APIs so it should be fairly trivial to add.


> 
> After some more investigation of this code, I am questioning the need
> for this logic:
> 
>     /* update flow if oif or iif point to device enslaved to l3mdev */
>     l3mdev_update_flow(net, flowi4_to_flowi(flp));

that is fundamentally how VRF works. I would love to add the original
vrf port index to flowi4 for consideration with bind to device within a
VRF. I suspect your proposed patch is doing something close.

