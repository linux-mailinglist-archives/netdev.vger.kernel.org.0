Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CC06176AF
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 07:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiKCGVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 02:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKCGVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 02:21:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D811611A13;
        Wed,  2 Nov 2022 23:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=O6247AfvaUgQ4rTBCdd6tE2mIQfoQgtQipevCW2V8Gc=; b=b9/Cvzcw/DDnuJJ9vN3ipvsaju
        4oQ6egvCVXOHGrJRyzLcqIzr62msYSqb1p31F4mewQMUowUDW1oPtTP/W4KtsPEukjnatcZjSgmqW
        QpCKUK4mTlZt78BA9EjdLA6Z+MrJnq/kgPRMV54ZG5TW3gsHYN75WpJLs4jwNhJpRQFSKy31eLa/6
        xZUR6N76Myq+Oc2qCEZBmn4VKAsUxIr8nvjHIYHCaQ0w6UQRt3ymgvpMlLcphCw7mNSHDQOwCpHE1
        gAyTHnTsV+mg9hyv7w9yaGXLqEKQ7exlT381hJeOB1vMpuQElWndJ5yjZCF9mN+MKrQ0qLj8bN+Nh
        y9a1WwiQ==;
Received: from [2601:1c2:d80:3110:e65e:37ff:febd:ee53]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqTb6-00GHKc-C8; Thu, 03 Nov 2022 06:21:04 +0000
Message-ID: <3efd119a-6814-7f39-3c7c-c17490adc876@infradead.org>
Date:   Wed, 2 Nov 2022 23:21:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] ath11k (gcc13): synchronize
 ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        linux-kernel@vger.kernel.org, Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20221031114341.10377-1-jirislaby@kernel.org>
 <55c4d139-0f22-e7ba-398a-e3e0d8919220@quicinc.com>
 <833c7f2f-c140-5a0b-1efc-b858348206ec@kernel.org> <87bkprgj0b.fsf@kernel.org>
 <503a3b36-2256-a9ce-cffe-5c0ed51f6f62@infradead.org>
 <87tu3ifv8z.fsf@kernel.org>
 <1041acdb-2978-7413-5567-ae9c14471605@infradead.org>
 <87cza4ftkf.fsf@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <87cza4ftkf.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/22 23:20, Kalle Valo wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
> 
>>>>> Yeah, using "wifi:" is a new prefix we started using with wireless
>>>>> patches this year.
>>>>>
>>>>
>>>> It would be nice if that was documented somewhere...
>>>
>>> It is mentioned on our wiki but I doubt anyone reads it :)
>>
>> I think that you are correct. ;)
>>
>>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject
>>>
>>> Do let me know if there are other places which should have this info.
>>
>> Ideally it would be in the subsystem's profile document as described in the
>> MAINTAINERS file:
>>
>> 	P: Subsystem Profile document for more details submitting
>> 	   patches to the given subsystem. This is either an in-tree file,
>> 	   or a URI. See Documentation/maintainer/maintainer-entry-profile.rst
>> 	   for details.
>>
>> although that seems to be overkill IMHO just to add a prefix: setting.
>>
>> You could just clone some other maintainer's Profile document and then modify it
>> to anything that you would like to have in it as far as Maintaining and patching
>> are concerned.
> 
> Ah, we should add that doc for wireless. Thanks for the idea, I added
> that to my todo list.
> 

Thank you. :)

-- 
~Randy
