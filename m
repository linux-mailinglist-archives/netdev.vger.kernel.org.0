Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590F1D34BA
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfJJX6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:58:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41905 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbfJJX6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:58:45 -0400
Received: by mail-qt1-f195.google.com with SMTP id v52so11328580qtb.8
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rqji17iCubgRMeC+Vycqe1vc47by57DEVQpEIqey9RM=;
        b=ky1ofrGgN+DSJKoqdlmG18Xi4TDC3Da0U/gfb1+titc8znZccW8jchnFYwhD6lhWSP
         mf0bQH4n1VumIhq8yZrF+DbjWfSCSfRXdWbuxl12qzykX2JGG8oRaNvdEKdDM8FfKX3u
         /EcvTmkmCAmGZmbe9N1KbAUDk0lDflp9ZMCkh99KlWLi5NRt0UnUEbF0Zs+2nikpmKmK
         WPMPHjZGhmwmHePZJzr043z1UN6FZwcjvcyssZqqFnYMvE2KtSsqrKNXtYegWy6hIy4j
         Eicnk+PeUT/5aINzRVP/yHFEUxklg/8IkI03k1uuJrjUAv6/ce93oS8pk8/Xr/NJ266o
         25FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rqji17iCubgRMeC+Vycqe1vc47by57DEVQpEIqey9RM=;
        b=Kr52C4O4kWJSYUFzNAjb0fl4GjK214qh6CKSudxk1jr+IWYKnBS7fCMl7yQKCm13QD
         AuTqDiZYBvZssutM2bGu8DWRpTrwOcuvz9NMi/oRwLYpgebWsmsYkTBwSi1S8CvPqv3P
         VcR9HH/GB/gjKGDOAgwJwLmmbz1A8qITM7wE3LVbtoaPxorlcE+wlfYv5aDyA4sXks8g
         J4d6yYAUKxLSiIYTW7nL0TgSxNe4HKP5i63dQZnl02PDVvlT2IN0dmZDkuVnW9OhJXJL
         4SEO8U0zSbHQBux4FaSfMerfBH8/KpwEAq9sBf+EHUX6EGZRu6NcPXx5NqTmtdDEz+Ob
         hEhw==
X-Gm-Message-State: APjAAAW7KCr4QbrNlAw6k0MqX9nX6bi9xkEiTwldhMmuTKjbBMmmeg83
        LALl5bzMR3fI+3LEKnyom0cd5Q==
X-Google-Smtp-Source: APXvYqzHvgIC6xGVEEyj6TbgfifR7ulMfirMgFM3I8dhnb12DZXvfJUuf6KBN0BSRVhb7GO4/tN1qg==
X-Received: by 2002:a0c:f709:: with SMTP id w9mr13179974qvn.237.1570751924697;
        Thu, 10 Oct 2019 16:58:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z8sm2957668qkf.37.2019.10.10.16.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:58:44 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:58:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tal Gilboa <talgi@mellanox.com>,
        David Miller <davem@davemloft.net>, linux-doc@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH] Documentation: networking: add a chapter for the DIM
 library
Message-ID: <20191010165828.0540d18d@cakuba.netronome.com>
In-Reply-To: <4c7f5563-2ca1-d37b-7639-f3df99a0219b@infradead.org>
References: <e9345b39-352e-cfc6-7359-9b681cb760e8@infradead.org>
        <20191010162003.4f36a820@cakuba.netronome.com>
        <4c7f5563-2ca1-d37b-7639-f3df99a0219b@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 16:34:59 -0700, Randy Dunlap wrote:
> On 10/10/19 4:20 PM, Jakub Kicinski wrote:
> > On Thu, 10 Oct 2019 15:55:15 -0700, Randy Dunlap wrote:  
> >> From: Randy Dunlap <rdunlap@infradead.org>
> >>
> >> Add a Documentation networking chapter for the DIM library.
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >> Cc: Tal Gilboa <talgi@mellanox.com>
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> >> Cc: netdev@vger.kernel.org
> >> Cc: linux-rdma@vger.kernel.org
> >> ---
> >>  Documentation/networking/index.rst   |    1 +
> >>  Documentation/networking/lib-dim.rst |    6 ++++++
> >>  2 files changed, 7 insertions(+)
> >>
> >> --- linux-next-20191010.orig/Documentation/networking/index.rst
> >> +++ linux-next-20191010/Documentation/networking/index.rst
> >> @@ -33,6 +33,7 @@ Contents:
> >>     scaling
> >>     tls
> >>     tls-offload
> >> +   lib-dim
> >>  
> >>  .. only::  subproject and html
> >>  
> >> --- /dev/null
> >> +++ linux-next-20191010/Documentation/networking/lib-dim.rst
> >> @@ -0,0 +1,6 @@
> >> +=====================================================
> >> +Dynamic Interrupt Moderation (DIM) library interfaces
> >> +=====================================================
> >> +
> >> +.. kernel-doc:: include/linux/dim.h
> >> +    :internal:
> >>
> >>  
> > 
> > CC: linux-doc, Jake
> > 
> > How does this relate to Documentation/networking/net_dim.txt ?
> > (note in case you want to edit that one there is a patch with 
> > updates for that file from Jake I'll be applying shortly)

Applied now.

> There is also a small patch from Jesse:
> https://lore.kernel.org/netdev/20191010193112.15215-1-jesse.brandeburg@intel.com/

Ack, as Jake said this duplicates part of what his patch covered, tho.

Will you try to convert and integrate the existing file instead, or do
you think the kdoc file should be separate?
