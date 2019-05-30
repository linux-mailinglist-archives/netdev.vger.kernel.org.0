Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04D630198
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfE3SNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:13:33 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46722 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3SNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:13:32 -0400
Received: by mail-qt1-f196.google.com with SMTP id z19so8081856qtz.13
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:13:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=swUKp54FsABaRx/HQxckmg32aK739BKT6ewItuokNDk=;
        b=b8eCgtO1H4D46inJJ91UlgtdYsJ3SzhiekGfNkAsX0dDoXU4gvj2hPKu+lkP15PtvU
         9svm0GOtJg9kYqyiWIiVIzd7lEqsNLllbKC+19iteuCFh+PEmjvJWX62vRc/6i3Un6rS
         53WAD2u6GmccXHxBNpDbL4YX82wWtVZcjfrTPycrvFZTj1wKhgYCa8hnOM22Ge0/I+QN
         RXTZACblLN8s2BUUX84/OBZ+JkKHDbv/4wrg2Yrb66JCVODenIBs8X0bLjMjtYchN6Nj
         LeQRdnyZoevfwQSKaqHvKRp1tqSG9lyVR7UC8qPJIIMuU1uzFmR6+9z9dbhXHLc7VcCM
         PfJw==
X-Gm-Message-State: APjAAAVaoHMqah6Z0RmLByhHlxTaV/9i614NRNPvmxhWt5XgE2Zjnc0q
        8TkoSxIs0cvFcxtfYk9h3migjQ==
X-Google-Smtp-Source: APXvYqyndgU/JBNxGTz081BydLXYPXGN+1/yzyTBopwAP5jF6DEPVUhyIlMc188XrJEeCGJfnA2k0g==
X-Received: by 2002:aed:2494:: with SMTP id t20mr4813376qtc.135.1559240011968;
        Thu, 30 May 2019 11:13:31 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net. [100.0.197.103])
        by smtp.gmail.com with ESMTPSA id k9sm1894099qki.20.2019.05.30.11.13.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 11:13:31 -0700 (PDT)
Date:   Thu, 30 May 2019 14:13:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com,
        James.Bottomley@hansenpartnership.com, hch@infradead.org,
        jglisse@redhat.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        christophe.de.dinechin@gmail.com, jrdr.linux@gmail.com
Subject: Re: [PATCH net-next 0/6] vhost: accelerate metadata access
Message-ID: <20190530141243-mutt-send-email-mst@kernel.org>
References: <20190524081218.2502-1-jasowang@redhat.com>
 <20190530.110730.2064393163616673523.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530.110730.2064393163616673523.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 11:07:30AM -0700, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Fri, 24 May 2019 04:12:12 -0400
> 
> > This series tries to access virtqueue metadata through kernel virtual
> > address instead of copy_user() friends since they had too much
> > overheads like checks, spec barriers or even hardware feature
> > toggling like SMAP. This is done through setup kernel address through
> > direct mapping and co-opreate VM management with MMU notifiers.
> > 
> > Test shows about 23% improvement on TX PPS. TCP_STREAM doesn't see
> > obvious improvement.
> 
> I'm still waiting for some review from mst.
> 
> If I don't see any review soon I will just wipe these changes from
> patchwork as it serves no purpose to just let them rot there.
> 
> Thank you.

I thought we agreed I'm merging this through my tree, not net-next.
So you can safely wipe it.

Thanks!

-- 
MST
