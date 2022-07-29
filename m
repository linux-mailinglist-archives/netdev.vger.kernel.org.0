Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35FE5851FD
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiG2PA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiG2PAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:00:54 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399C5E3E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:00:54 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id l188so6053503oia.4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=djbBxnzCv4stT/4u6XcDsaeh6DJggF934ace9onesHg=;
        b=LnLhHwMcvPzFF+H5k7tQoCEj3m8czGukTuJ/isnrPD3JOejVcDVQchX6RTSxqk6ZYV
         ph8YKcFtqPp1unAXGmiTEO7KCS+O7nIFiXQI/OLkJpy8e7Ya8MsOR/w43ICH+YuFwQEK
         SOX4xlIx/rGGdEI9up61TsUt3bUY1rlLPko5DTx6IEgfobI6lUjAvDFHRVYj4DX/ZpR+
         uuE0Ib1KMwjrJ5zQKBiUBjEl7EcmrzfI4nR9aonMJQM57XTExvUeHGCkigfMuHRGpLLs
         LggXFWqEUyOjPLyWYw00vt6Fy/kqpoEYOSMVzFyWjuKeHW983bFaEs2UQ4BY3dyKfQyB
         qtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=djbBxnzCv4stT/4u6XcDsaeh6DJggF934ace9onesHg=;
        b=xxVtT5HjI9rP+kYgprahtm/LNJn/uQ10+fH7vvoWe8hyvnJhIGjDCP82rbA6yI7UrU
         pD5lnFtN81ll9baC8DRfkoONOzPVidK58jDjoVPIep4je3hR7Q04/Xwua996j0T5f+nc
         T3mPKnzY9wE3uBSlZfU19ntRUZICMoGV4smQwVfADYyji7TXkiyDdgTbiuM/ibltLO4q
         O5LPknERpqKfquBpRLo6BryKfZzzA3F8c82dKznTfTXk21S5+T5ikClw08IbyzpDfm5F
         9Mhus47lCaOJkO6WFBkNRxfJCbDTwJHMneCClTNgUtym9WyV7AjDFzYEjOx4pHYAUyQp
         lJHw==
X-Gm-Message-State: AJIora9bjEY5nUadVX0AidFHrZqadPWFtbTx1/E2OhvGctuwYdE2KcUJ
        /5mbm9DWPb1FzUrmPZa2YKk=
X-Google-Smtp-Source: AGRyM1shReCB7BR+M4rJdOJs8XQZqJJKgQOU/xKJoYQKllqTc54RpGEs3kWhxsiVbMeGvwajYRg8EA==
X-Received: by 2002:a05:6808:1928:b0:33a:af6b:643b with SMTP id bf40-20020a056808192800b0033aaf6b643bmr1742189oib.91.1659106853500;
        Fri, 29 Jul 2022 08:00:53 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id h23-20020a056830035700b0061c9c0e858fsm1281871ote.70.2022.07.29.08.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 08:00:53 -0700 (PDT)
Message-ID: <48df4e83-a9b8-11db-aeaf-2015666af5a5@gmail.com>
Date:   Fri, 29 Jul 2022 09:00:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute-next v3 2/3] lib: Introduce ppp protocols
Content-Language: en-US
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "gnault@redhat.com" <gnault@redhat.com>
References: <20220728110117.492855-1-wojciech.drewek@intel.com>
 <20220728110117.492855-3-wojciech.drewek@intel.com>
 <4cc470f9-cfed-a121-ccd0-0ba8673ad47d@gmail.com>
 <MW4PR11MB577651A1E86058570D617CB0FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <MW4PR11MB577651A1E86058570D617CB0FD999@MW4PR11MB5776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 2:59 AM, Drewek, Wojciech wrote:
> What is the standard procedure in such situation?
> Should I create separate commit with uapi update, should
> I not include uapi changes and ask you to update it?

I always pull uapi files from a kernel header sync point. If a patch or
set contains a uapi update, it is removed before applying.

If uapi changes are included in a set, a separate patch file is best. I
can ignore it and apply the rest without modifying patch files.
