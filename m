Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 320D6A22E7
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfH2R7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:59:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfH2R7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 13:59:01 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C56272F30C1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:59:00 +0000 (UTC)
Received: by mail-ed1-f69.google.com with SMTP id w15so2617956edv.17
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 10:59:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vXyDcpJzTd5p/KMVvOob/xE2M48IW9jsvqrOA8CmTz0=;
        b=LMFyDFYyQRvyrM2v4AJj58IFFD79ql6DCg0Tf0geajAFbqPkIhJTC1YqKpp04PSoqN
         FB+zZTQkb9WXMubbijc+HXNCoQB83+iyb0zuyF35FhoVnBtScnkXiLW+lkwf2mSAm1r0
         +yKIyGQSybjddBjyBQ7YMIO69VP3BSFqIa4SbryuBjJ+hMwUgJ78SCLSa4NrCjoqNKVz
         BuBYgxPg32sqN0ny/ZEcH+mL8sr615yAYQO18Ty/ZzvtEAEjc0Dg3hk8lTXawh0pUX2o
         qiAyAuEdCb/5P/p+/3940G0UvTx+IPCgmF0AYI/ccHLzSSr+y0rjgK/JgwJHpcNd2u9V
         1/YQ==
X-Gm-Message-State: APjAAAWsCRA1IkSX/EOQE8iv7bhXflL/txIsmfpXsC4VWEWLBks9GkEf
        WXLotDIkaGzCO46yw+t91xsyn5dt0yLcHhc6VI4aU5Bliui7OTWkjgHH9nHlec3zRZRjGVZfexf
        WjWLfD/GPW155nG5o
X-Received: by 2002:a17:906:a2cd:: with SMTP id by13mr9362198ejb.182.1567101539495;
        Thu, 29 Aug 2019 10:58:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyPz4t6r4A7CUfYi5mhv6MVRoXML2uPaai3OXbXjjP76nMbNjhhJGFBX9NOilRFWF4msKGbwg==
X-Received: by 2002:a17:906:a2cd:: with SMTP id by13mr9362185ejb.182.1567101539293;
        Thu, 29 Aug 2019 10:58:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i18sm469032ejy.74.2019.08.29.10.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 10:58:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D9138181C2E; Thu, 29 Aug 2019 19:58:57 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "David Z. Dai" <zdai@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zdai@us.ibm.com
Subject: Re: [v1] net_sched: act_police: add 2 new attributes to support police 64bit rate and peakrate
In-Reply-To: <1567100185.20025.3.camel@oc5348122405>
References: <1567032687-973-1-git-send-email-zdai@linux.vnet.ibm.com> <7a8a5024-bbff-7443-71b3-9e3976af269f@gmail.com> <1567100185.20025.3.camel@oc5348122405>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 29 Aug 2019 19:58:57 +0200
Message-ID: <87lfvbhmzi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"David Z. Dai" <zdai@linux.vnet.ibm.com> writes:

> On Thu, 2019-08-29 at 10:32 +0200, Eric Dumazet wrote:
>> 
>> On 8/29/19 12:51 AM, David Dai wrote:
>> > For high speed adapter like Mellanox CX-5 card, it can reach upto
>> > 100 Gbits per second bandwidth. Currently htb already supports 64bit rate
>> > in tc utility. However police action rate and peakrate are still limited
>> > to 32bit value (upto 32 Gbits per second). Add 2 new attributes
>> > TCA_POLICE_RATE64 and TCA_POLICE_RATE64 in kernel for 64bit support
>> > so that tc utility can use them for 64bit rate and peakrate value to
>> > break the 32bit limit, and still keep the backward binary compatibility.
>> > 
>> > Tested-by: David Dai <zdai@linux.vnet.ibm.com>
>> > Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
>> > ---
>> >  include/uapi/linux/pkt_cls.h |    2 ++
>> >  net/sched/act_police.c       |   27 +++++++++++++++++++++++----
>> >  2 files changed, 25 insertions(+), 4 deletions(-)
>> > 
>> > diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
>> > index b057aee..eb4ea4d 100644
>> > --- a/include/uapi/linux/pkt_cls.h
>> > +++ b/include/uapi/linux/pkt_cls.h
>> > @@ -159,6 +159,8 @@ enum {
>> >  	TCA_POLICE_AVRATE,
>> >  	TCA_POLICE_RESULT,
>> >  	TCA_POLICE_TM,
>> > +	TCA_POLICE_RATE64,
>> > +	TCA_POLICE_PEAKRATE64,
>> >  	TCA_POLICE_PAD,
>> >  	__TCA_POLICE_MAX
>> >  #define TCA_POLICE_RESULT TCA_POLICE_RESULT
>> 
>> Never insert new attributes, as this breaks compatibility with old binaries (including
>> old kernels)
> Thanks for reviewing it!
> My change is only contained within the police part. I am trying to
> follow the same way htb and tbf support their 64 bit rate.
>
> I tested the old tc binary with the newly patched kernel. It works fine.
>
> I agree the newly compiled tc binary that has these 2 new attributes can
> cause backward compatibility issue when running on the old kernel.
>
> If can't insert new attribute, is there any
> comment/suggestion/alternative on how to support 64bit police rate and
> still keep the backward compatibility?

Just put the new attributes *after* PAD instead of before :)

-Toke
