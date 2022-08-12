Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2ED591487
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239521AbiHLRBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 13:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbiHLRA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 13:00:59 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3225FAED;
        Fri, 12 Aug 2022 10:00:57 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x5so1198590qtv.9;
        Fri, 12 Aug 2022 10:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=HGYCPjo9Ox5Yihgn+X42WcT7OjqP49HxXrJuPQjVfRQ=;
        b=oZ2nrEbsLdGC7yM5lY4Mw5LY90jJ2tl9s+pcVmRyLOoMjlX/2LMO0Q4hx9AgXi5Y19
         0NAyYmibeQ+HbFAMIHQPtGjckT1orCv/QAYmRaV+W5Q4sHiflDLeN+Tn+ZotYWOO++VH
         yhMDvCz461+qL4GovCK1B8YrlhyoIsQW8gOOwEjU2z1uuC9jJ+4fVO7JYieZRKfcRYvJ
         2Xumw4lRkCVKmCjjWKCW2artlEYq+F1O5vue+Tk8OhctdYWTUZ1ONODon31V4+EFfAsd
         jqatgDe7n5mC7+1TC0lQ8rfTHaEGYQK6F3mfEEbocDUFpoygsPMOBjvPCghEQAI+Teva
         EdPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=HGYCPjo9Ox5Yihgn+X42WcT7OjqP49HxXrJuPQjVfRQ=;
        b=Eg5if2EZX8ZryV3INTwLvMEz7LirlnTZv1s0OyztfPCCVVp3gSS5KCIg5puuxdZmhU
         0T/DH3CBox1p24eKNSwd+48M55jecILTgaqRD7lmcWyf5jGIdtYZpQ/x1SK21zXEx0Ok
         KFC/+i0T1jx90/eevqIDqMBVbiacjhoVVZJtcSa7rUg+OHenmRtxPxFVrAUhji4FmCs9
         Q8pzQuFRKEt6/lPdJoP/8dnT/183JTFxPMqN9B6gP/sr+yixIsMkhyXAenvdZskTaFx7
         uhNjciUURSHCATymgNK0Ysz9D0KM83uXyKJlSMW+9fzen/iqD2oXA52Dxk0lT+oIBvVY
         n/Pg==
X-Gm-Message-State: ACgBeo2LA/iTQDVEqFlqb8Yt7lf15tgXT8xWatw+pCxzPdt8c9sRNhXd
        /VveOwsSIznmLTP9RpllkoN7S9CRSW0=
X-Google-Smtp-Source: AA6agR7T4QQ6CtB3Q8iFKDtFI8IrQWGaZFVvxmrn8D2gaTBBT5YY0Dn6Op2hCQn1+1B/WGCNp+Bt/g==
X-Received: by 2002:ac8:7d90:0:b0:326:b431:6cd3 with SMTP id c16-20020ac87d90000000b00326b4316cd3mr4361676qtd.511.1660323656373;
        Fri, 12 Aug 2022 10:00:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cp5-20020a05622a420500b0031f41ea94easm1910796qtb.28.2022.08.12.10.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 10:00:55 -0700 (PDT)
Message-ID: <9208fec1-60e9-dd2b-af27-ada3dfa50121@gmail.com>
Date:   Fri, 12 Aug 2022 10:00:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC net-next 0/4] ynl: YAML netlink protocol descriptions
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
References: <20220811022304.583300-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220811022304.583300-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 8/10/22 19:23, Jakub Kicinski wrote:
> Netlink seems simple and reasonable to those who understand it.
> It appears cumbersome and arcane to those who don't.
> 
> This RFC introduces machine readable netlink protocol descriptions
> in YAML, in an attempt to make creation of truly generic netlink
> libraries a possibility. Truly generic netlink library here means
> a library which does not require changes to support a new family
> or a new operation.
> 
> Each YAML spec lists attributes and operations the family supports.
> The specs are fully standalone, meaning that there is no dependency
> on existing uAPI headers in C. Numeric values of all attribute types,
> operations, enums, and defines and listed in the spec (or unambiguous).
> This property removes the need to manually translate the headers for
> languages which are not compatible with C.
> 
> The expectation is that the spec can be used to either dynamically
> translate between whatever types the high level language likes (see
> the Python example below) or codegen a complete libarary / bindings
> for a netlink family at compilation time (like popular RPC libraries
> do).
> 
> Currently only genetlink is supported, but the "old netlink" should
> be supportable as well (I don't need it myself).
> 
> On the kernel side the YAML spec can be used to generate:
>   - the C uAPI header
>   - documentation of the protocol as a ReST file
>   - policy tables for input attribute validation
>   - operation tables
> 
> We can also codegen parsers and dump helpers, but right now the level
> of "creativity & cleverness" when it comes to netlink parsing is so
> high it's quite hard to generalize it for most families without major
> refactoring.
> 
> Being able to generate the header, documentation and policy tables
> should balance out the extra effort of writing the YAML spec.
> 
> Here is a Python example I promised earlier:
> 
>    ynl = YnlFamily("path/to/ethtool.yaml")
>    channels = ynl.channels_get({'header': {'dev_name': 'eni1np1'}})
> 
> If the call was successful "channels" will hold a standard Python dict,
> e.g.:
> 
>    {'header': {'dev_index': 6, 'dev_name': 'eni1np1'},
>     'combined_max': 1,
>     'combined_count': 1}
> 
> for a netdevsim device with a single combined queue.
> 
> YnlFamily is an implementation of a YAML <> netlink translator (patch 3).
> It takes a path to the YAML spec - hopefully one day we will make
> the YAMLs themselves uAPI and distribute them like we distribute
> C headers. Or get them distributed to a standard search path another
> way. Until then, the YNL library needs a full path to the YAML spec and
> application has to worry about the distribution of those.
> 
> The YnlFamily reads all the info it needs from the spec, resolves
> the genetlink family id, and creates methods based on the spec.
> channels_get is such a dynamically-generated method (i.e. grep for
> channels_get in the python code shows nothing). The method can be called
> passing a standard Python dict as an argument. YNL will look up each key
> in the YAML spec and render the appropriate binary (netlink TLV)
> representation of the value. It then talks thru a netlink socket
> to the kernel, and deserilizes the response, converting the netlink
> TLVs into Python types and constructing a dictionary.
> 
> Again, the YNL code is completely generic and has no knowledge specific
> to ethtool. It's fairly simple an incomplete (in terms of types
> for example), I wrote it this afternoon. I'm also pretty bad at Python,
> but it's the only language I can type which allows the method
> magic, so please don't judge :) I have a rather more complete codegen
> for C, with support for notifications, kernel -> user policy/type
> verification, resolving extack attr offsets into a path
> of attribute names etc, etc. But that stuff needs polishing and
> is less suitable for an RFC.
> 
> The ability for a high level language like Python to talk to the kernel
> so easily, without ctypes, manually packing structs, copy'n'pasting
> values for defines etc. excites me more than C codegen, anyway.

This is really cool BTW, and it makes a lot of sense to me that we are 
moving that way, especially with Rust knocking at the door. I will try 
to do a more thorough review, than "cool, I like it".
-- 
Florian
