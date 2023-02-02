Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4886886D7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjBBSlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbjBBSlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:41:20 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE6611161;
        Thu,  2 Feb 2023 10:40:46 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id b5so2789095plz.5;
        Thu, 02 Feb 2023 10:40:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=44Tbffij6x8u6hWa9nzBypn4C/WCHwZ/yEGRnTnWNXY=;
        b=rjnWzErP110NEcFFiTyfqcQ6xcLE5gMNRpNMeRBoWB1t6rDsl7kuyEWITkxTo/NNQm
         4pSwc3LkFezu3cPR0AV+rOsT6/su4KFBIuOsAeMVmBoNtmyx5g8paPDsyZJm622BaDjB
         Vi2nT0WFruIPR/CpxyQPtw2Sltf0xMZOXlg0m/ekKYQFL2l7mT0iN4OTg3i9whljpcO5
         dM3WwIqFA2ei2fbrxWtqpJKK5du9htLMypIbdtQOXqJOaYdIUVH3d0aK1guSY3rkiGhg
         cZEHSXDPXvGI7Ca9N8GhylUQAfUB6BIq+Rb7qQ9yk8Z7chjtOm3yB1l5/pDnVaUh5cQR
         2vzA==
X-Gm-Message-State: AO0yUKVQxXVwwbz+Tfey46h2aYEzSK/KTJRzmbxJv3o4bF5UkokGMbII
        5XxwsUg3dQ2JFZfo/EPCUoc=
X-Google-Smtp-Source: AK7set8fNbiiFYW7OdcSiJFzCCcd6PnkVskd+HRqyruGtnlqpt0Vn1V/D3WSUtrSKyM8at7NMHKKxw==
X-Received: by 2002:a17:902:c403:b0:196:6599:3538 with SMTP id k3-20020a170902c40300b0019665993538mr8710126plk.22.1675363146577;
        Thu, 02 Feb 2023 10:39:06 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:bf7f:37aa:6a01:bf09? ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id l2-20020a170902ec0200b00198a96c6b7csm4082247pld.305.2023.02.02.10.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 10:39:05 -0800 (PST)
Message-ID: <8540c721-6bb9-3542-d9bd-940b59d3a7a4@acm.org>
Date:   Thu, 2 Feb 2023 10:39:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [dm-devel] [PATCH 0/9] Documentation: correct lots of spelling
 errors (series 2)
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
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
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <875yckvt1b.fsf@meer.lwn.net>
 <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a2c560bb-3b5c-ca56-c5c2-93081999281d@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/23 10:33, Randy Dunlap wrote:
> On 2/2/23 10:09, Jonathan Corbet wrote:
>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>   [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>>>   [PATCH 7/9] Documentation: scsi: correct spelling
>>
>> I've left these for the SCSI folks for now.  Do we *really* want to be
>> fixing spelling in ChangeLog files from almost 20 years ago?
> 
> That's why I made it a separate patch -- so the SCSI folks can decide that...

How about removing the Documentation/scsi/ChangeLog.* files? I'm not 
sure these changelogs are still useful since these duplicate information 
that is already available in the output of git log ${driver_directory}.

Thanks,

Bart.


