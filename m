Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406A851B4B2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 02:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiEEAeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 20:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbiEEAdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 20:33:53 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB73110F;
        Wed,  4 May 2022 17:30:15 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so6567116pjb.5;
        Wed, 04 May 2022 17:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=vXjQm31zmug0ZJajiOXjsOsVqx4TK9fapdQ9fvw0pGQ=;
        b=k21Uk51OpmNTv6LT6RzmMWWRVWXYnQUPImMmJ/DstgPMvA/3UT7fiDsSiHnzC+LxQH
         YZyUHt+owO8Zzcciv5z+IWJEmf2sJiApDAwdJCeQGesvpuJpeRjdUew4WetUkFr0vS50
         saf+gxHkN+vcEP1uK7VBU2LA3BckmUsALtz7Usb75IRxO/DhmT2QFR2xz3JK8pvJzRlI
         nRowVBFWB81VA7v99hp15JGd7wwyPCr1z/52tvkRsUZ/4cIgSCW8588V90DBkLc9SM7p
         gMH0xenIYyrHN28qKtF13Vs55Xbj7wHxt8z/YQCkXljyzjytAU9jy4OVGqAXkySePj0P
         i58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=vXjQm31zmug0ZJajiOXjsOsVqx4TK9fapdQ9fvw0pGQ=;
        b=nZpplMMxkFBfXL/Pu+gz+RwpiZrJtKRqMCeoXJqBFV5/AGxU14gtMNohemvy4RTwsV
         uzFMoLqqKxK7XY6CXKstamRr2HGkD/z2xQdVrB1IRI+W9ax3p8IP5cdRDlc4+x8AU584
         gQlYuF0sEavYWUifLg8txhA55zfe0aoAgmZQOG7SXUwy0sFYQ6a3S9Nr8qmNCAXowmMy
         FxS7YS0QF9Kt4ex0qoltoD0oBiDclEmeioWa+9F18oaUk3ONj0Mbmsv328Iq6TsONdQa
         9MShnPLF6eJD1x81+3qy1mvifK8oA+OxEv9gqVds9FeoDMuKHBYluVHC0618AVczL4Sk
         Es9g==
X-Gm-Message-State: AOAM530HbKYjiJaq3rIeIRDwztH+TSWskyZsC+u4KmX/Vv5sHeupdZyP
        MSU0jQgJBdqSlp/DagMRNbQ=
X-Google-Smtp-Source: ABdhPJx9yIRqIj0VFgSzl+cbOT9204rAjJzMbIvxhmoNmRrS9Ih0GGt3+DB2pseO7zjTeBll6bgEYA==
X-Received: by 2002:a17:90b:4d0c:b0:1d9:aee3:fac1 with SMTP id mw12-20020a17090b4d0c00b001d9aee3fac1mr2758961pjb.15.1651710615158;
        Wed, 04 May 2022 17:30:15 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id ie13-20020a17090b400d00b001da3920d985sm3921742pjb.12.2022.05.04.17.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 17:30:14 -0700 (PDT)
Message-ID: <ad80d41e-3e82-3188-f1e5-631e631a1fe4@gmail.com>
Date:   Thu, 5 May 2022 09:30:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Akira Yokosawa <akiyks@gmail.com>
Subject: Re: [PATCH net-next] net/core: Remove comment quote for
 __dev_queue_xmit()
To:     Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <9d8b436a-5d8d-2a53-a2a1-5fbab987e41b@gmail.com>
 <c578c9e6-b2a5-3294-d291-2abfda7d1aed@gmail.com>
 <20220504073707.5bd851b0@kernel.org>
Content-Language: en-US
In-Reply-To: <20220504073707.5bd851b0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+To: Ben]
[-Cc: unreachable addresses]

Hi,

On 2022/05/04 23:37,
Jakub Kicinski wrote:
> On Wed, 4 May 2022 22:43:12 +0900 Akira Yokosawa wrote:
>>> I can't think of preserving delineation between actual documentation
>>> and the quote without messing up kernel-doc.  
> 
> That's not what I'm complaining about, I'm saying that you rewrote 
> the documentation. There were 3 paragraphs now there are 2.
> 
>> Actually, it is possible.
>>
>> See "Block Quotes" in ReST documentation at:
>> https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#block-quotes
>>
>> kernel-doc is basically ReST within comment blocks with several kernel-doc
>> specific implicit/explicit markers.
> 
> With all due respect I don't even know who (what?) "BLG" is.

In case this might help, this comment block was added in commit
af191367a752 ("[NET]: Document ->hard_start_xmit() locking in
comments.") authored by Ben way back in 2005.

Ben, if you want to see the circumstances, here is a link to the lore
archive.
    https://lore.kernel.org/all/20220504073707.5bd851b0@kernel.org/#r

> 
> Let's just get rid of the delineation and the signature and make 
> the text of the quote normal documentation.

I'm not sure but Ben might be interested in helping rephrase the quote.

        Thanks, Akira

> 
>>> Actually the "--BLG" signature is the culprit.  
> 
