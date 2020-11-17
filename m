Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB7A2B6738
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgKQOR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:17:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728971AbgKQOR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:17:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605622648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4oGqzmGwilPumqW8eOjecCD8crW06I2M62bjVlUNaMs=;
        b=gpQG6NnGe8Z4i5W4h8KfFWd2g3GdOkriwQXpo1DGAMlPzNJ6LGRFmKRw5Kk6oUemVB5vuf
        KAkvjK6Fa2THG1Wej8Xq4aVEkfvEVj51cjWimji38EPbsCC7bqoKKpKXNS8O1IbB0/qOcu
        E2nmjTue8sUjIm/LLQoxdKnmuIUb7QU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-bhCqd7JjN5GWu7hAAmxn0w-1; Tue, 17 Nov 2020 09:17:15 -0500
X-MC-Unique: bhCqd7JjN5GWu7hAAmxn0w-1
Received: by mail-wr1-f71.google.com with SMTP id g5so11601070wrp.5
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 06:17:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4oGqzmGwilPumqW8eOjecCD8crW06I2M62bjVlUNaMs=;
        b=o6uBFdI7e3bePvyF5hhAcnJGXFC86kmBMs2fmC+sjseP3O1r4LtVWqqHjlwuocZDGN
         X731Kvn27hEzZv+lYt5xg7dGPC6IyR+B0LLGh6ynETUt9xSTOx/e8ynqdB8+zwW7FnIj
         LR8KI4zwbIZJftrX8XcdtuY78mw/M+63fCQJLyH7Xj0220olR7T9g3SKF4SsDFchx3Vt
         RHVn4kfqa8DGzWWbzNYXSwMhZrThAUqABsCq1lnXv4IfjoA6Fy5WIjFtd2w41YrsaEhv
         0AH6b+e3CnBHDPyOB3f4tT+NZIx83EzXfH17K0hcvLZ2L9WlmRQoAAyW/2uuh8vFu4ks
         uL7A==
X-Gm-Message-State: AOAM530bg0lexg6C4euA/qNFhVjIv78Wm76uQ2SFH7tS5ny0tHygz3xz
        YsdB27T6OmquVwkWAdBynWsnO2WwmIkAR9PMg5/RP37vk2qYZk6GjhqEKtHy35AnouL3paed+2+
        jH3I1Qv6MXmv2cEQY
X-Received: by 2002:a5d:4ec2:: with SMTP id s2mr25077445wrv.258.1605622634673;
        Tue, 17 Nov 2020 06:17:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYn/7j++sdvTgDAY+S8beNSlCS1ifOA4Dy4x0CFjnQLHmoB9XdMiQsocA6CD77dshY5KwtRg==
X-Received: by 2002:a5d:4ec2:: with SMTP id s2mr25077430wrv.258.1605622634476;
        Tue, 17 Nov 2020 06:17:14 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id f19sm3643022wml.21.2020.11.17.06.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:17:13 -0800 (PST)
Date:   Tue, 17 Nov 2020 15:17:11 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201117141711.GB17578@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201110092834.GA30007@linux.home>
 <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201117125422.GC4640@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117125422.GC4640@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 12:54:22PM +0000, Tom Parkin wrote:
> On  Tue, Nov 10, 2020 at 08:47:40 -0800, Jakub Kicinski wrote:
> > On Tue, 10 Nov 2020 10:28:34 +0100 Guillaume Nault wrote:
> > > I think the question is more about long term maintainance. Do we want
> > > to keep PPP related module self contained, with low maintainance code
> > > (the current proposal)? Or are we willing to modernise the
> > > infrastructure, add support and maintain PPP features in other modules
> > > like flower, tunnel_key, etc.?
> > 
> > Right, it's really not great to see new IOCTLs being added to drivers,
> > but the alternative would require easily 50 times more code.
> 
> Jakub, could I quickly poll you on your current gut-feel level of
> opposition to the ioctl-based approach?
> 
> Guillaume has given good feedback on the RFC code which I can work
> into an actual patch submission, but I don't really want to if you're
> totally opposed to the whole idea :-)
> 
> I appreciate you may want to reserve judgement pending a recap of the
> ppp subsystem as it stands.

I've started writing some general explanations about the protocol and
the actual kernel implementation. I'm planning to send them in the days
to come. I just have to finish some higher priority tasks first. Sorry
for the delay.

