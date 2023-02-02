Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345976886A3
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjBBSfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjBBSfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:35:32 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0811EC15A;
        Thu,  2 Feb 2023 10:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=k90MIssqyam+q/fNqVWcdWv6u/roh3dY62Y5GGa0m3Q=; b=Ft0/UsXxcr5hj4gqLIpY8Ysilb
        B8QOeuXrktyjajavKoE7RjNIiAds31D2IFowNxouTzytlk6Lh/QpeSxyz9L4nFlEYO2uCctLcnzBj
        z7tq2zTXyYaa48UMnRvkYQk4QmxMsGB8t6+j2JB6LwAMdQFvlI93boSPh5mdpSwZSWviVqMyDUFE3
        WGKVgPWdtLA/Sm/oS2SYPgL37SfwXeQ4zT1k+oDQp9jIvAcrMp8wZv+oUzUs07Ubqf42BzCy5MnDR
        M6nXaXJif3CSPfJ32CKVQBapoTzjadXnu7VgZbP5gLj14ow8jiV4NvS2BIT8lkXnN6fu1BCTTC1JE
        c+Ccrcxw==;
Received: from [2601:1c2:d00:6a60::9526]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pNeOf-00Gxdl-15; Thu, 02 Feb 2023 18:33:21 +0000
Message-ID: <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
Date:   Thu, 2 Feb 2023 10:33:17 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors
 (series 2)
Content-Language: en-US
To:     Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-hwmon@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <875yckvt1b.fsf@meer.lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/23 10:09, Jonathan Corbet wrote:
> Randy Dunlap <rdunlap@infradead.org> writes:
> 
>> Maintainers of specific kernel subsystems are only Cc-ed on their
>> respective patches, not the entire series. [if all goes well]
>>
>> These patches are based on linux-next-20230127.
> 
> So I've applied a bunch of these
> 

>>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>  [PATCH 7/9] Documentation: scsi: correct spelling
> 
> I've left these for the SCSI folks for now.  Do we *really* want to be
> fixing spelling in ChangeLog files from almost 20 years ago?

That's why I made it a separate patch -- so the SCSI folks can decide that...

-- 
~Randy
