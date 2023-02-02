Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEA8E688704
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjBBSrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjBBSra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:47:30 -0500
X-Greylist: delayed 2270 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 10:46:56 PST
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B732D163;
        Thu,  2 Feb 2023 10:46:56 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id A8666739;
        Thu,  2 Feb 2023 18:46:55 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A8666739
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1675363615; bh=LWxEU72zl68liFRHK4qAaq/94gJ5U5MPeKaaBgQ+tzQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=IluSlawEh1lqfD3VE0Kr0lf7AKU/1bsSpHf52ekCzPrJkyCmWEesOx8n/34iWHP1l
         YD6uRTgtbiEoHnDflnOcd8eq+mn9Zn15QuGp5+ldYfwirT8bYSUtM7ZIcF3jyllkhj
         M+MnpPLKVT1BvMPHS66IlPs6NRg02abR7lsUptRqLdHVwbeynKQFpd8BBcH/vtII6Q
         LmA0cxt3YulQtJZ+Cun0ZxE0YMAy7/yWq2Z1kr0HTa/FZuk6yWVcv208QpTU9nFFpY
         4VpgeQhgD3zIAIfVS7Q5LBHM6BfRyr3e67CdEoQ7rkJ00JLai/QvRb7zJDsh4QSj6W
         nCzlihE+cuqeA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Bart Van Assche <bvanassche@acm.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org
Cc:     nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        netdev@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>,
        sparclinux@vger.kernel.org,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Alasdair Kergon <agk@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-media@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mike Snitzer <snitzer@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, cgroups@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-hwmon@vger.kernel.org, rcu@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-mm@kvack.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vinod Koul <vkoul@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
In-Reply-To: <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
 <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
 <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
Date:   Thu, 02 Feb 2023 11:46:54 -0700
Message-ID: <87o7qbvra9.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 2/2/23 10:33, Randy Dunlap wrote:
>> On 2/2/23 10:09, Jonathan Corbet wrote:
>>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>>   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>>>   [PATCH 7/9] Documentation: scsi: correct spelling
>>>
>>> I've left these for the SCSI folks for now.  Do we *really* want to be
>>> fixing spelling in ChangeLog files from almost 20 years ago?
>> 
>> That's why I made it a separate patch -- so the SCSI folks can decide that...
>
> How about removing the Documentation/scsi/ChangeLog.* files? I'm not 
> sure these changelogs are still useful since these duplicate information 
> that is already available in the output of git log ${driver_directory}.

Actually, the information in those files mostly predates the git era, so
you won't find it that way.  I *still* question their value, though...

jon
