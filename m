Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138B44DCF83
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiCQUmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiCQUmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:42:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDB3C6EE6;
        Thu, 17 Mar 2022 13:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ROV+N7/7nL9ebCMUk84kLWbG+brDW++VtuozCZVdtkw=; b=Jqch/btFqW+CCJM0MuFijvZBnR
        bKqVKg8MJPsG7xgEbyq8GpqXB7A8dE9YvSejZgGKMwlrFERInyVW/NwSKf4kQ/UA6psueuXc8llbi
        tXp3gLO4A62BpBOiR5EK3lKKSfjt468nR9YWHbd0+I9WP14Gea0xgxgt+KOMxkIpTtW+MOsIHvwgj
        hM+KtvJ/9csmz19wnZcmlJxpYZuCql/Ep3kcCjBTlQo66UU7MNW7TyDClTi6xfWHMMGkptDRxOs/s
        kZkV9zPnBYwNqiK7nc3Q5CI7k99U6h5ic0GJ7k9j/2cf6pf3fSTuSgb5ZJ6Kw6nbakmqXx6kZ8nsy
        H+5jNfRw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nUwvV-007InG-0P; Thu, 17 Mar 2022 20:40:53 +0000
Message-ID: <da13fa80-83e7-f7cc-abf8-97b9e23a6737@infradead.org>
Date:   Thu, 17 Mar 2022 13:40:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/9] virtio_console: eliminate anonymous module_init &
 module_exit
Content-Language: en-US
To:     Amit Shah <amit@infradead.org>, linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Joachim Fritschi <jfritschi@freenet.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-3-rdunlap@infradead.org>
 <f7b858bb438d1979c1f092e105e0db4c7af47758.camel@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <f7b858bb438d1979c1f092e105e0db4c7af47758.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/22 08:47, Amit Shah wrote:
> On Wed, 2022-03-16 at 12:20 -0700, Randy Dunlap wrote:
>> Eliminate anonymous module_init() and module_exit(), which can lead to
>> confusion or ambiguity when reading System.map, crashes/oops/bugs,
>> or an initcall_debug log.
>>
>> Give each of these init and exit functions unique driver-specific
>> names to eliminate the anonymous names.
>>
>> Example 1: (System.map)
>>  ffffffff832fc78c t init
>>  ffffffff832fc79e t init
>>  ffffffff832fc8f8 t init
>>
>> Example 2: (initcall_debug log)
>>  calling  init+0x0/0x12 @ 1
>>  initcall init+0x0/0x12 returned 0 after 15 usecs
>>  calling  init+0x0/0x60 @ 1
>>  initcall init+0x0/0x60 returned 0 after 2 usecs
>>  calling  init+0x0/0x9a @ 1
>>  initcall init+0x0/0x9a returned 0 after 74 usecs
>>
>> Fixes: 31610434bc35 ("Virtio console driver")
>> Fixes: 7177876fea83 ("virtio: console: Add ability to remove module")
>> Signed-off-by: Randy Dunlap <
>> rdunlap@infradead.org
>>>
>> Cc: Amit Shah <
>> amit@kernel.org
>>>
>> Cc: 
>> virtualization@lists.linux-foundation.org
>>
>> Cc: Arnd Bergmann <
>> arnd@arndb.de
>>>
>> Cc: Greg Kroah-Hartman <
>> gregkh@linuxfoundation.org
>>>
>> ---
>>  drivers/char/virtio_console.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Reviewed-by: Amit Shah <amit@kernel.org>
> 
> I don't think the Fixes-by really applies here, though - we don't
> really want to push this into stable, nor do we want any automated
> tools to pick this up because of that tag..

Yeah, I'm fine with that.

thanks.

-- 
~Randy
