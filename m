Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1298B4DC92F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbiCQOtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiCQOtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:49:06 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEAF2016B9
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:47:50 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id z7so6157147iom.1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 07:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fX2usQW7VgeZMIAWoRfD3t8cBll4opaLh+6N8QASKf8=;
        b=QwD61V6jtzGk9aRtoIOEdfATT+bRHQugc1LTVNtgvAtC3x5bGNcr+o+9afIqvlchiC
         SKD802dlJnZbV9ciODxS+dHAmG+Hl0JwG308TkSaXsyo7ggb2NNZR6ERSp3GqlKLc29V
         2szRd7By5nO5/dWzJTaepwf63AA1SfMP/6dUtU6E/WYCfjdw4J/k0SCfQ8OqJ98YksQD
         RmHT6NyuJrif6gNlok028FE9p9GCQSl/+LGP9K2Ok+03/vf7hi21IGSU09Y210d4YrZa
         oq1sW9PMi+sQ08sPN5JjCVuh5awE/nc6V5SeohxfkPGDv6uec/5T+mirAMOKVj4uuMee
         ohww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fX2usQW7VgeZMIAWoRfD3t8cBll4opaLh+6N8QASKf8=;
        b=VaZErSSRkK34lPRSjxCxYvbkPNFLySMi9nYKPgNtRetG8lG+rpvr7WnaUEr9MkXagk
         1HAX+Hy4tcHdu+g/iKYdXO6DZO46kFR7u0W5DwcS1ULtz2B/BdvtpSOU/P8fWJ0Tggnl
         cod8r9S05A4THVtY2YVHQ3U7NACwVql0iWqGPpKcSWeULutxdh5tkDucn8DuiVJzgMmh
         xKYex+pGB1ceYlTEztP5WcqWvRYLpyF9ToSk5ziqjkQAiujFB2lzN/dGj+x3oUTcwI1F
         0ZlEXT3QpS/Y9TkFvWBxhngaUzlWXPs5ynNYbonsz0ND07tAI7ItI9ahcg6O6eCMuxEq
         drSQ==
X-Gm-Message-State: AOAM532Hbs92dLjvlvzFw1O6BziNe3TSuUnSkS23YpoVI4esfP4YJkem
        toJM0GxH8OyKRCm1Sv92KDY=
X-Google-Smtp-Source: ABdhPJyclkD6A1WBncVP/qBDNKh+lLZS4AGojQYto/QfCmPP+9wuPu2oF013ntKB2QbVzIOHoEVDIw==
X-Received: by 2002:a05:6638:531:b0:317:af7d:d934 with SMTP id j17-20020a056638053100b00317af7dd934mr2110519jar.307.1647528470038;
        Thu, 17 Mar 2022 07:47:50 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id y12-20020a056e021bec00b002c786b37889sm3278916ilv.47.2022.03.17.07.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 07:47:49 -0700 (PDT)
Message-ID: <5d2d7c77-2c08-7c6e-b816-bbab21c36171@gmail.com>
Date:   Thu, 17 Mar 2022 08:47:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH iproute2-next v5 1/2] ip: GTP support in ip link
Content-Language: en-US
To:     Harald Welte <laforge@gnumonks.org>,
        "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
References: <20220316110815.46779-1-wojciech.drewek@intel.com>
 <20220316110815.46779-2-wojciech.drewek@intel.com>
 <c1cb87c2-0107-7b0d-966f-b26f44b23d80@gmail.com>
 <MW4PR11MB57765F252A537045612889E4FD129@MW4PR11MB5776.namprd11.prod.outlook.com>
 <YjM/jXnaCDaBrTNX@nataraja>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YjM/jXnaCDaBrTNX@nataraja>
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

On 3/17/22 8:02 AM, Harald Welte wrote:
> Hi Wojciech, David,
> 
> On Thu, Mar 17, 2022 at 11:11:40AM +0000, Drewek, Wojciech wrote:
>>> as a u32 does that mean more roles might get added? Seems like this
>>> should have a attr to string converter that handles future additions.
>>
>> I think no more roles are expected but we can ask Harald.
> 
> I also don't currently know of any situation where we would want to add
> more roles.
> 

Better safe than giving users wrong information. I would prefer if this
attribute to string conversion handle the 2 known roles and return
"unknown" if a new value pops up.
