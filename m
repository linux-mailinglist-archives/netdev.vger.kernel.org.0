Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ACB412AD1
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbhIUB6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237797AbhIUB4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:56:46 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7415C0313C1
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 16:49:11 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 194so23654318qkj.11
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 16:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/WanOXb8th8F0F1g07yxLSvetmY7K9FA4s62pfwxvZY=;
        b=aS2NiJ7nEKG2K+mCegzepnWkIfRbvKu2FO44BfBU7JCVdq/QYiz7wrTmi+hVFWrzxW
         oPJp8J7vowG6V/3mgeq4ut2+fvYMIx25V0U2Ke9hQJz3GFhMRfhnahqC2UGxECmr4y6c
         iMJMI/SPiH9aBM9GzkMHLrfKjap+hn0poXdnf48aEgBjjj3al4yKvTjglrGgROQ8BX6/
         4a1jmrnyRBxA3k/QVw7YXhBsyEaUL6lz462Mtk8TH5TFEBQ2xZF48eJg7GH1juxHD2sL
         lYmiBxYphlQs/mKd0U/lhuM7hcpM7bygZiyIQnKZorOQTxWpLx32nzVnjLXcd2sfGNDo
         eIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/WanOXb8th8F0F1g07yxLSvetmY7K9FA4s62pfwxvZY=;
        b=33Uhgk46AlM+RnigKkpXMrJjkWY0u4vSPZxcDwqmBU+nPyh2ixMqzva4am4P8q3CQ6
         tOmJdhkF8lNSEKkFl0zKh69H0v99AjUb+4aueXS+Hov0H5MPjhPY10znXGDArWDbNxIY
         zy65b/BAXx/mnyn9xkABsZYroXraaxV34LjxJyW2aVtSCppfukNKkFFMg4gjDRDs3ZWM
         Kb9bMVI1yqKH81Km7LPETurK1xiSP9QHMDzVGSpy739bEdMJeSG65cy1zluIFdTA7YVd
         6SuB1dGTLkXXoNGYy7LdztxzSaHbqp0Ic+KqvWgAmaIXq6omWcM/kyxyyQwnEDvWwLuw
         2QRA==
X-Gm-Message-State: AOAM530Hd6vx7E1OQx4R/VsSCX5f5BIaGByaEp2nIyfmIaVANTPZWm2x
        DWGPN9dsXTaSiXvVaq5VRYIaeBFeVg==
X-Google-Smtp-Source: ABdhPJxqEs1ILHVtBxFFMQ2G9N2dKVP+JoGQkN2MOrDOwjRRBAcczVW7Y7gVAVkxqL/tjJkMAl9dUw==
X-Received: by 2002:a37:9c12:: with SMTP id f18mr18345691qke.18.1632181751181;
        Mon, 20 Sep 2021 16:49:11 -0700 (PDT)
Received: from ssuryadesk ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id b13sm9548781qtb.13.2021.09.20.16.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 16:49:10 -0700 (PDT)
Date:   Mon, 20 Sep 2021 19:49:09 -0400
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipmr: ip6mr: Add ability to display non default
 caches and vifs
Message-ID: <20210920234909.GB5695@ssuryadesk>
References: <20210818200951.7621-1-ssuryaextr@gmail.com>
 <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
 <20210818225022.GA31396@ICIPI.localdomain>
 <e7a1828a-d5bf-fa88-1798-1d77f9875189@nvidia.com>
 <44c43842-2e5a-4e20-b2e6-9f2f2ae6cf0f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44c43842-2e5a-4e20-b2e6-9f2f2ae6cf0f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 06:04:12PM -0600, David Ahern wrote:
> On 8/18/21 5:12 PM, Nikolay Aleksandrov wrote:
> > I do not. You can already use netlink to dump any table, I don't see any point
> > in making those available via /proc, it's not a precedent. We have a ton of other
> > (almost any) information already exported via netlink without any need for /proc,
> > there really is no argument to add this new support.
> 
> agreed. From a routing perspective /proc files are very limiting. You
> really need to be using netlink and table dumps. iproute2 and kernel
> infra exist to efficiently request the dump of a specific table. What is
> missing beyond that?

On this, I realized now that without /proc the multicast caches can be
displayed using iproute2. But, it doesn't seem to have support to
display vifs. Is there a public domain command line utility that can
display vifs on non default table, i.e. the one that uses the support in
the kernel in commit 772c344dbb23 ("net: ipmr: add getlink support")?

Thanks.
