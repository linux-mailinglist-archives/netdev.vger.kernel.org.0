Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12E5E2873
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437189AbfJXCvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:51:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44365 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437184AbfJXCvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 22:51:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so13287577pgd.11
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 19:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kgq6bwrdt0N8zaEwrbY4mexZoLqoqU2GhM3hAiaw0F8=;
        b=cbzVBg/Hmhgb86sDPg8Xmeu1crJNYqUKIeVM/9hItnb6LB7zynTA7txUpe2MJAh/By
         EQuQKa2WvfQLoeK++l/KR6LEwN5hxrhWTT+2Bvcw4VZh0a1INPepyWauSuiEiUp12T3z
         7gZNVPysa8+DAtqcTulx51MUGHuIKQn2vxNfeMuPXs0wHFqI92zniCMILMm/R3aSjTJ0
         Nq8zXIXbUfbeqYwf6UjejXNqHyxtge6AXUZgvLkYPsPkzACH66BsgNZG5ASkAesIOWDf
         YiLHxCAFELMChXUPgUsZ8xIEcFg5HAFgIVl13gvJLsYCSv1vdw70BWQv5TWuaX87mOrL
         1NIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kgq6bwrdt0N8zaEwrbY4mexZoLqoqU2GhM3hAiaw0F8=;
        b=ti1Iv5KSggR4YefKXUtahD/Rg1NFzKxQZ/ZCJg+hI+L3DJrdXhAnXbVHV8mygNaa1v
         38jMvtvBseVeZHOELoWrKvG9pFiXIl/zstYpeyHN1JMQZrhwwlLUf/tsQ9ZRx+cK2Cj5
         LyMtTybt5nPNnjV04pEEFaq6Sv/BKDoIBAPA9YxXSbpa8pgI955jKWDGkiSh0kv0hrv+
         U13ZNy3H+NK+nuxgg18PBHfH5as8k+XDlQ0hHwqHfxgxn79wxISBJBQJZv4xV1sbE25l
         nNJnKFt/A8l+J3KsjGnp5KnQY3Kh0KE2hZB4506C2YBxTK3d3m5qrNB86W8YrP55/n6n
         07CQ==
X-Gm-Message-State: APjAAAVATCujcrvr8DdjfaXxtZf0zT6CyfOz+hgkj8j2DJb5ARjazq1R
        fVekahyiqt7wjj2SB70O3CHiHQ==
X-Google-Smtp-Source: APXvYqzRzjhEHzO9MafCmuRL7q+4OP7q8TGuHz2aESAO9+BAwYhgy1LRS2SOc0U6clouqOZSFGsgtA==
X-Received: by 2002:a17:90a:9201:: with SMTP id m1mr4146717pjo.42.1571885506458;
        Wed, 23 Oct 2019 19:51:46 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v9sm8684822pfm.85.2019.10.23.19.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 19:51:46 -0700 (PDT)
Date:   Wed, 23 Oct 2019 19:51:41 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        andrew.gospodarek@broadcom.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
        <20191023120046.0f53b744@cakuba.netronome.com>
        <20191023192512.GA2414@nanopsycho>
        <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
        <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 00:11:48 +0000, Yuval Avnery wrote:
> >>> We need some proper ontology and decisions what goes where. We have
> >>> half of port attributes duplicated here, and hw_addr which honestly
> >>> makes more sense in a port (since port is more of a networking
> >>> construct, why would ep storage have a hw_addr?). Then you say you're
> >>> going to dump more PCI stuff in here :(  
> >> Well basically what this "vdev" is is the "port peer" we discussed
> >> couple of months ago. It provides possibility for the user on bare metal
> >> to cofigure things for the VF - for example.
> >>
> >> Regarding hw_addr vs. port - it is not correct to make that a devlink
> >> port attribute. It is not port's hw_addr, but the port's peer hw_addr.  
> > Yeah, I remember us arguing with others that "the other side of the
> > wire" should not be a port.
> >  
> >>> "vdev" sounds entirely meaningless, and has a high chance of becoming
> >>> a dumping ground for attributes.  
> >> Sure, it is a madeup name. If you have a better name, please share.  
> > IDK. I think I started the "peer" stuff, so it made sense to me.
> > Now it sounds like you'd like to kill a lot of problems with this
> > one stone. For PCIe "vdev" is def wrong because some of the config
> > will be for PF (which is not virtual). Also for PCIe the config has
> > to be done with permanence in mind from day 1, PCI often requires
> > HW reset to reconfig.
>
> The PF is "virtual" from the SmartNic embedded CPU point of view.

We also want to configure PCIe on local host thru this in non-SmartNIC
case, having the virtual in the name would be confusing there.

> Maybe gdev is better? (generic)

Let's focus on the scope and semantics of the object we are modelling
first. Can we talk goals, requirements, user scenarios etc.?

IMHO the hw_addr use case is kind of weak, clouds usually do tunnelling
so nobody cares which MAC customer has assigned in the overlay.

CCing Andy and Michael from Broadcom for their perspective and
requirements.

> >> Basically it is something that represents VF/mdev - the other side of
> >> devlink port. But in some cases, like NVMe, there is no associated
> >> devlink port - that is why "devlink port peer" would not work here.  
> > What are the NVMe parameters we'd configure here? Queues etc. or some
> > IDs? Presumably there will be a NVMe-specific way to configure things?
> > Something has to point the NVMe VF to a backend, right?
> >
> > (I haven't looked much into NVMe myself in case that's not obvious ;))  
