Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D07142DDA9
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhJNPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhJNPMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 11:12:38 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6304EC08E8AA
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:59:43 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c28so5965781qtv.11
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bPeSyysCSlApJJpAiwym5EbmvmyXQs5ifoWtIvHKJZM=;
        b=pkFzLQnKsjqu2w39JuQ68ceSIYqA966dXpq962G4XyJ3xObMrNoU2QZyPVNa8w4AeL
         sJHz050tZfiTx7X/2qDj0rRspiNoISEC+FXiPsxPzbAjWwH/YWfw90ulYfzggvFODoEF
         vpcxCDGnbFBucYEVdrobQXua3Jw+aultlRFYRvRw55gRJlEyruHdZPmzjmd9LujVaPMP
         nX28TIM+slum5LTJK2vjBeiAo15d1RSU/AjQ8ZJE1tUDzE0apIOh4nWKuP67zvU9UDV4
         NEcqImCkLlIKAFxHAKC3G1J2vk9yZ7SIQO5UbmG+QhUNsznI+qF4GVoKFfjrJRINLJOS
         aDLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bPeSyysCSlApJJpAiwym5EbmvmyXQs5ifoWtIvHKJZM=;
        b=uMZyPs/B8ucJWdAur5YpjT0yz0rtW0tDs0I/F07+ps6V3K9Zd6WXrJRCKUIJ2+pe8k
         Ma97Wu8G4Nu5cT4qCJ9ZV6wOrsZ3VVMbjGNCmaoX27MVpJY+GoWg70O5klziYG9pbvTi
         eLmHPiOQs8Jw1uZAOeYZNNoQ1Wahs+hWrmpURrgrk9ixu0jobJI5GqfQFDGekhIEPECC
         AITZLvmM3YKiTH9jyBgWR2wbjTSDFnXNJSbot3QcC6qRfaqp6Y8bUEmmVfI3xThtgcFb
         NJyn+kXkArE7tGwVqqmgZoY5H4a8s1jcVtaxGmtXd2ZoYbgTasXuz2RPo5TDrYXbrVH7
         Xqmw==
X-Gm-Message-State: AOAM530fs8EH86nHlf4XF41kbDhc5aVNptMx0yxbW3SD9+9Y+o9/0Ps9
        G5Tot67mmzvn4tAPiXpkxg==
X-Google-Smtp-Source: ABdhPJzyjjZ7i1oBjL3PNi4O4puF9JNk1Uh/eUg2TZiAUgllMZo7cOqjWHt5pmX3rKvMv82zw3hj9Q==
X-Received: by 2002:a05:622a:20f:: with SMTP id b15mr7143915qtx.399.1634223582564;
        Thu, 14 Oct 2021 07:59:42 -0700 (PDT)
Received: from ICIPI.localdomain ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id u189sm1368378qkh.14.2021.10.14.07.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:59:42 -0700 (PDT)
Date:   Thu, 14 Oct 2021 10:59:40 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: Anybody else getting unsubscribed from the list?
Message-ID: <20211014145940.GC11651@ICIPI.localdomain>
References: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
 <20211014144337.GB11651@ICIPI.localdomain>
 <ce98b6b2-1251-556d-e6c8-461467c3c604@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce98b6b2-1251-556d-e6c8-461467c3c604@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe it is around the 11th like what you experienced. I came to
realize when I thought that the 12th seems to be very quiet in term of
patches. I went to patchwork and saw that are patches on the day, so
I suspected that I've been unsubscribed.

I'm using gmail like you see, so not sure if there was a long outage for
gmail. Doubtful about gmail outage...

I didn't see any suspicious email around the 11th.

Regards,
Stephen.

On Thu, Oct 14, 2021 at 10:51:15AM -0400, Jamal Hadi Salim wrote:
> On 2021-10-14 10:43, Stephen Suryaputra wrote:
> > +1. Had to re-subscribe.
> > 
> 
> Thanks for confirming. Would be nice to be able maybe
> to check somewhere when you suspect you are unsubscribed.
> The mailing list is incredibly solid otherwise (amazing
> spam filtering for one).
> 
> cheers,
> jamal
