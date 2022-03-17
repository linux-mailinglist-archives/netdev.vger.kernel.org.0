Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098D14DBF40
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiCQGUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiCQGUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:20:07 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F164AFA233;
        Wed, 16 Mar 2022 23:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=bTtyCTv8jHiRySjv+joBkY5T4kiLsInhhDpfMbwTL1s=; b=os+6uLP+YQvzPOsl13Jv5guvuH
        c88qjXZH5IySVlxqAYUihC2hbNJHZhERaN/9M1O+TRZA8WFEmSQGTv+E/uOHf9IEu5y58HmvUView
        tJqv1oexE/7GCbLX/RqjjjPHc0Nz4QT1PCSUsF7D8Jb/EYTGiFjELEvWYE7Gu9MYUTFHov/uRCRY7
        /x9sJUmFziSe300ACpWlnZupzoQCtmqCqtEMV0UdvwGyry98Nfw5QdyjOvLJ0JePVDhb/0YX8qdJT
        w7vRAVMjNtBdhuXSlAfQdRkRsVo81YE8w/5mlAJkMGGTpqeQHzUxEbTrcOVom5D0PCqAQ3d5CQPbP
        DH34JIfA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nUiEF-001mlP-TU; Thu, 17 Mar 2022 04:59:16 +0000
Message-ID: <5db1feea-f630-79e6-15cc-77babf58a429@infradead.org>
Date:   Wed, 16 Mar 2022 21:59:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 6/9] usb: gadget: eliminate anonymous module_init &
 module_exit
Content-Language: en-US
To:     Ira Weiny <ira.weiny@intel.com>
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
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
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
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        Felipe Balbi <balbi@kernel.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-7-rdunlap@infradead.org>
 <YjKrMyRvHh7nzHwW@iweiny-desk3>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <YjKrMyRvHh7nzHwW@iweiny-desk3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/16/22 20:29, Ira Weiny wrote:
> On Wed, Mar 16, 2022 at 12:20:07PM -0700, Randy Dunlap wrote:
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
>> Fixes: bd25a14edb75 ("usb: gadget: legacy/serial: allow dynamic removal")
>> Fixes: 7bb5ea54be47 ("usb gadget serial: use composite gadget framework")
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> I continue to be confused about the latest rules for the Fixes tag but this one
> in particular seems completely useless.  This is the 'beginning of time' commit
> by Linus AFAICT.  So do any of these Fixes tags need to be in this series?

I guess it mostly depends on whether they get applied to stable trees, but
it's entirely fine with me if they don't.

{I also corrected Felipe's email address here.}

> Regardless:
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Thanks.

> 
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
>> Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: linux-usb@vger.kernel.org
>> ---
>>  drivers/usb/gadget/legacy/inode.c  |    8 ++++----
>>  drivers/usb/gadget/legacy/serial.c |   10 +++++-----
>>  drivers/usb/gadget/udc/dummy_hcd.c |    8 ++++----
>>  3 files changed, 13 insertions(+), 13 deletions(-)
>>
>> --- lnx-517-rc8.orig/drivers/usb/gadget/legacy/serial.c
>> +++ lnx-517-rc8/drivers/usb/gadget/legacy/serial.c
>> @@ -273,7 +273,7 @@ static struct usb_composite_driver gseri
>>  static int switch_gserial_enable(bool do_enable)
>>  {
>>  	if (!serial_config_driver.label)
>> -		/* init() was not called, yet */
>> +		/* gserial_init() was not called, yet */
>>  		return 0;
>>  
>>  	if (do_enable)
>> @@ -283,7 +283,7 @@ static int switch_gserial_enable(bool do
>>  	return 0;
>>  }
>>  
>> -static int __init init(void)
>> +static int __init gserial_init(void)
>>  {
>>  	/* We *could* export two configs; that'd be much cleaner...
>>  	 * but neither of these product IDs was defined that way.
>> @@ -314,11 +314,11 @@ static int __init init(void)
>>  
>>  	return usb_composite_probe(&gserial_driver);
>>  }
>> -module_init(init);
>> +module_init(gserial_init);
>>  
>> -static void __exit cleanup(void)
>> +static void __exit gserial_cleanup(void)
>>  {
>>  	if (enable)
>>  		usb_composite_unregister(&gserial_driver);
>>  }
>> -module_exit(cleanup);
>> +module_exit(gserial_cleanup);
>> --- lnx-517-rc8.orig/drivers/usb/gadget/udc/dummy_hcd.c
>> +++ lnx-517-rc8/drivers/usb/gadget/udc/dummy_hcd.c
>> @@ -2765,7 +2765,7 @@ static struct platform_driver dummy_hcd_
>>  static struct platform_device *the_udc_pdev[MAX_NUM_UDC];
>>  static struct platform_device *the_hcd_pdev[MAX_NUM_UDC];
>>  
>> -static int __init init(void)
>> +static int __init dummy_hcd_init(void)
>>  {
>>  	int	retval = -ENOMEM;
>>  	int	i;
>> @@ -2887,9 +2887,9 @@ err_alloc_udc:
>>  		platform_device_put(the_hcd_pdev[i]);
>>  	return retval;
>>  }
>> -module_init(init);
>> +module_init(dummy_hcd_init);
>>  
>> -static void __exit cleanup(void)
>> +static void __exit dummy_hcd_cleanup(void)
>>  {
>>  	int i;
>>  
>> @@ -2905,4 +2905,4 @@ static void __exit cleanup(void)
>>  	platform_driver_unregister(&dummy_udc_driver);
>>  	platform_driver_unregister(&dummy_hcd_driver);
>>  }
>> -module_exit(cleanup);
>> +module_exit(dummy_hcd_cleanup);
>> --- lnx-517-rc8.orig/drivers/usb/gadget/legacy/inode.c
>> +++ lnx-517-rc8/drivers/usb/gadget/legacy/inode.c
>> @@ -2101,7 +2101,7 @@ MODULE_ALIAS_FS("gadgetfs");
>>  
>>  /*----------------------------------------------------------------------*/
>>  
>> -static int __init init (void)
>> +static int __init gadgetfs_init (void)
>>  {
>>  	int status;
>>  
>> @@ -2111,12 +2111,12 @@ static int __init init (void)
>>  			shortname, driver_desc);
>>  	return status;
>>  }
>> -module_init (init);
>> +module_init (gadgetfs_init);
>>  
>> -static void __exit cleanup (void)
>> +static void __exit gadgetfs_cleanup (void)
>>  {
>>  	pr_debug ("unregister %s\n", shortname);
>>  	unregister_filesystem (&gadgetfs_type);
>>  }
>> -module_exit (cleanup);
>> +module_exit (gadgetfs_cleanup);
>>  

-- 
~Randy
