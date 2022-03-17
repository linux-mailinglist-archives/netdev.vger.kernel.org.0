Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C864DCF9E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiCQUoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiCQUn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:43:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1779A133690;
        Thu, 17 Mar 2022 13:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=3Vg3YWtqMNGIO5AWtFE29onUKdIZ8x188s7SviF5pPg=; b=tiAHL3PCQ2t7+lPOxKztKxihGl
        vd4Y8NiotnXISBxPTEpDpjnfGwN/+2gCzocwX9f1n0YfUlqtTEW8abkTbOXNks1/pe9V0o1aeVqiU
        mg+cp1CpvBpg/qj5G5LZWflb4aiFP803B14dktG2eQTzUpOmEwNqtoyK5FiuDb0e8dEHA1UwaTcNb
        TjTsqtIXdQy5uDTkofF/krC+Z1b0PK1+/Sh9yQPukGAwmINpZ+kCjgEBdHe1EVJZaGIr2Nw3tHUkm
        Ajhuyth6TCxfsRDyg2dioL17ZEbHaHLKorjuGU+sNiNOS0MkF5l5E/OHgiJGeyQY6IVrPFktt2Xla
        WvlJyMgw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nUwxB-007IuO-IC; Thu, 17 Mar 2022 20:42:37 +0000
Message-ID: <15fdafd4-e753-2c0e-4e61-6b168e064e72@infradead.org>
Date:   Thu, 17 Mar 2022 13:42:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 4/9] netfilter: h323: eliminate anonymous module_init &
 module_exit
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
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
 <20220316192010.19001-5-rdunlap@infradead.org> <YjNYo2LKM3smgEJM@salvia>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <YjNYo2LKM3smgEJM@salvia>
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



On 3/17/22 08:49, Pablo Neira Ayuso wrote:
> On Wed, Mar 16, 2022 at 12:20:05PM -0700, Randy Dunlap wrote:
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
> 
> LGTM.
> 
> Should I route this through the netfilter tree?

Yes, please.
Thanks.

> 
>> Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
>> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
>> Cc: Florian Westphal <fw@strlen.de>
>> Cc: netfilter-devel@vger.kernel.org
>> Cc: coreteam@netfilter.org
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: netdev@vger.kernel.org
>> ---
>>  net/ipv4/netfilter/nf_nat_h323.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> --- lnx-517-rc8.orig/net/ipv4/netfilter/nf_nat_h323.c
>> +++ lnx-517-rc8/net/ipv4/netfilter/nf_nat_h323.c
>> @@ -580,7 +580,7 @@ static struct nf_ct_helper_expectfn call
>>  };
>>  
>>  /****************************************************************************/
>> -static int __init init(void)
>> +static int __init nf_nat_h323_init(void)
>>  {
>>  	BUG_ON(set_h245_addr_hook != NULL);
>>  	BUG_ON(set_h225_addr_hook != NULL);
>> @@ -607,7 +607,7 @@ static int __init init(void)
>>  }
>>  
>>  /****************************************************************************/
>> -static void __exit fini(void)
>> +static void __exit nf_nat_h323_fini(void)
>>  {
>>  	RCU_INIT_POINTER(set_h245_addr_hook, NULL);
>>  	RCU_INIT_POINTER(set_h225_addr_hook, NULL);
>> @@ -624,8 +624,8 @@ static void __exit fini(void)
>>  }
>>  
>>  /****************************************************************************/
>> -module_init(init);
>> -module_exit(fini);
>> +module_init(nf_nat_h323_init);
>> +module_exit(nf_nat_h323_fini);
>>  
>>  MODULE_AUTHOR("Jing Min Zhao <zhaojingmin@users.sourceforge.net>");
>>  MODULE_DESCRIPTION("H.323 NAT helper");

-- 
~Randy
