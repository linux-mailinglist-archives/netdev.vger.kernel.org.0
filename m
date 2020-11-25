Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01A2C42B2
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgKYPLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbgKYPLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 10:11:13 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A45C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 07:11:06 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id f15so1757030qto.13
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 07:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u4fYhpbHv+klYT57sVo28ZCDDhB/8Nbf3n1S9NPpwqg=;
        b=UiWbFYz44KU16024nnnFZdzFe2c5bUlp3/22mFTCHmMeypi+x8sr8FcKbKdUQx0WPb
         rcctrRRocoTdZ88DFqMFraiVeJIm6h6J7cmoxtj1VJwgsWoZJJquvKeHYl5eMSrg9zej
         wayrMY90gWGiF/gD6gmj7ayFpsGlkB76iWEGlIZpOzzFs2DjRtOAoKEPDKutqBJVijXN
         grXKjaKU3Rulml4zgTMouTv+fLTyX5PXxKlHa3Np8rvHd+kdII9f0ZQaPW5/I0yrpKGs
         e0yeavRo1RwtmjsII28mBgZTbRvYmMCCyk2cc/h9cbcz79rjOJ+bN5mnCa2KPI/5pXcw
         odtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4fYhpbHv+klYT57sVo28ZCDDhB/8Nbf3n1S9NPpwqg=;
        b=JINzEAy2AA4xASVYuL3lrIqlTfrKfmUCdivwjJtvEyHuFp44yFBLqLL4afYEUdokxF
         SWcbzMXSiOaLafec6qVTotQyGVATt/zDaviLrLZR0VOa4dCdWWy/AoCC60wI15iJrFt7
         Pyp257h/G6WXfWswMgp1O8WPUVzzNSgkbs6Mh+UY7mHzL6qUf3a171O/8Rkx0tAIQO0F
         NpkyPVWcNGi00+IVNPVMCsM3PxJk4fZ++HUFLFONz0F8nGLFTwITlXws7CtuAcOTGyl/
         bR3nad0hz7w+D+2Ipb3tLIYr+94RmzM0ot7w6hzbIKqFJtNKGv1g8uOSVkxufrFgNA5V
         L4Fw==
X-Gm-Message-State: AOAM531nJOyitb8kL4TImGxpkrcsIZ2LVvRgjBg3G7sS1NqqF1e4CHDw
        WvLT6KndPhxnFYPkbQmgtBN1m6rUayhE
X-Google-Smtp-Source: ABdhPJwtbZNsv7UgeKaLKrjahqBqzqvhC2nBf7+HKYQ134467CbtvJjaZ/kzS+wjmhKTa7CpqF7a/w==
X-Received: by 2002:a05:622a:294:: with SMTP id z20mr3356954qtw.321.1606317065213;
        Wed, 25 Nov 2020 07:11:05 -0800 (PST)
Received: from ssuryadesk ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id t51sm2809658qtb.11.2020.11.25.07.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 07:11:04 -0800 (PST)
Date:   Wed, 25 Nov 2020 10:10:56 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: VRF NS for lladdr sent on the wrong interface
Message-ID: <20201125151056.GA4062@ssuryadesk>
References: <20201124002345.GA42222@ubuntu>
 <6d0df155-ef2e-f3eb-46df-90d5083c0dc0@gmail.com>
 <20201124205748.GA18698@EXT-6P2T573.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124205748.GA18698@EXT-6P2T573.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 03:57:48PM -0500, Stephen Suryaputra wrote:
> On Tue, Nov 24, 2020 at 01:43:54PM -0700, David Ahern wrote:
> > On 11/23/20 5:23 PM, Stephen Suryaputra wrote:
> > > Hi,
> > > 
> > > I'm running into a problem with lladdr pinging all-host mcast all nodes
> > > addr. The ping intially works but after cycling the interface that
> > > receives the ping, the echo request packet causes a neigh solicitation
> > > being sent on a different interface.
> > > 
> > > To repro, I included the attached namespace scripts. This is the
> > > topology and an output of my test.
> > 
> > Can you run your test script on 4.14-4.17 kernel? I am wondering if the
> > changes in 4.19-next changed this behavior.
> > 
> We found the issue on 4.14.200-based kernel.

To be clear, our platform is based on 4.14.200 kernel. We found the
issue there and I reproduced it on the net tree using the scripts I
provided. Looks to me that it is a day 1 problem.

Regards,
Stephen.
