Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091026C5BBC
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 02:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCWBLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 21:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCWBLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 21:11:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F422821974;
        Wed, 22 Mar 2023 18:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=CrpTn9lvYigrfXxtBR9DCJe2InrjtfALjMgbgV2Q4Oo=; b=J8qcx8Nhj8rXI0dnlAat00ng5/
        3p6v0GI3C9mpU6owl4hLLyA1G7yG49NphCLngbdEp6NQx1sv7xjpS8lrqvtDfTkSAeUsxG6RQk1Xx
        vJiSKVE07g3ojNLHBCnfUfzjHdftwfKvDBqpHpKKbNJ1rQGJRKjHxjoGYD/5TqzszvBwbD3hp/EiM
        r0iNjSAEtpK2/kNbtJCaPlGSkuleMaD4QtGYwtU82LehRlhOG8HKYiI/M5jRNV0Ut6jr8R+Lpjwnb
        pbeGg7oWpGmcT4b1iTuQXrHd9mNWpk0c1qnA6wfeEgdZyvLDPIOUgvXDB45KNjIv/CkVMY8IQRPoQ
        Mk8RH6JQ==;
Received: from [2601:1c2:980:9ec0::21b4]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pf9Tq-000QBw-1O;
        Thu, 23 Mar 2023 01:11:02 +0000
Message-ID: <3c62aad7-02f1-32df-8404-6702ee2e2a8c@infradead.org>
Date:   Wed, 22 Mar 2023 18:11:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] docs: netdev: add note about Changes Requested
 and revising commit messages
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, sean.anderson@seco.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
References: <20230322231202.265835-1-kuba@kernel.org>
 <af2e9958-d624-d5fc-9403-a082ff15df9a@infradead.org>
 <20230322180657.41903d30@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230322180657.41903d30@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/23 18:06, Jakub Kicinski wrote:
> On Wed, 22 Mar 2023 16:38:53 -0700 Randy Dunlap wrote:
>>> +had to ask in previous discussions. Occasionally the update of  
>>
>> asked in previous discussions.
> 
> "had to ask" as in were forced to ask due to a poor commit message,
> is that not a valid use of "had to"?

Oh, that's OK. I didn't get that from reading it.
Thanks.

-- 
~Randy
