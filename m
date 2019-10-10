Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7ABDD2529
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 11:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390039AbfJJIyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49456 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388945AbfJJIuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:25 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C72B07FDCA
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 08:50:24 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id v18so2392733wro.16
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 01:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kbUGk/zH7Jd7BlhB+4/oDRz4mPdioNN/Nf5e+ZFx1KA=;
        b=g195XDEvYjCFZcr0CuQJIbOE2OcVU+mFCQ0F7K8Q0B8sCbStH4KSH0KOfN896H9rin
         fLKqkw620/ugylUktfJZeS/Y/NXKJoqChQ0rcU6XIPkkqdgv5DTuES1FUnnCzCuv/4MU
         /KnIgMP5JPQiGcQ+DR+BedWvaPuAoxr6gnj6eyjA2HnvMkTV143VtzO2ctwBcB6aZjHq
         O54A1YyKIysLAywoiuHknoz6T1NYVjuwKtAEjuRymeyHVAlNr2V4yESxrFISjlP2CgSM
         GM+NyCBfU4R0RP3pFJL/PSP0bMs8GYpT1/H3m0/fy/1AZRuQV1nEzFiq5B/CR7jLafYU
         Hj2g==
X-Gm-Message-State: APjAAAViiIP+NBQvxBpsnqVsBHN3I2WqDYPLKnT1zQcHDnRvyF6egYFW
        TXPRIo8I7CTGXW7xaWt0Qm6DUv6tJ19xUCj8x7kOrgcuqUCYou8cZQ6eRHvKWfI+RODjSipUeaO
        rIned0GKuIm3Gb9K0
X-Received: by 2002:a5d:6a4e:: with SMTP id t14mr7690225wrw.286.1570697423408;
        Thu, 10 Oct 2019 01:50:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwoCA81jZEGW66oRDsEIESbM+AgkqiF20vI6cPaP0YoBTkJocF4+GdZwig79Aeir6Qomx30bw==
X-Received: by 2002:a5d:6a4e:: with SMTP id t14mr7690208wrw.286.1570697423217;
        Thu, 10 Oct 2019 01:50:23 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id y8sm6284711wrm.64.2019.10.10.01.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:50:22 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:50:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 06/13] vsock: add 'struct vsock_sock *' param to
 vsock_core_get_transport()
Message-ID: <20191010085020.w5mbse7mnpzalhyr@steredhat>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-7-sgarzare@redhat.com>
 <20191009115433.GG5747@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009115433.GG5747@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 12:54:33PM +0100, Stefan Hajnoczi wrote:
> On Fri, Sep 27, 2019 at 01:26:56PM +0200, Stefano Garzarella wrote:
> > -const struct vsock_transport *vsock_core_get_transport(void)
> > +const struct vsock_transport *vsock_core_get_transport(struct vsock_sock *vsk)
> >  {
> >  	/* vsock_register_mutex not taken since only the transport uses this
> >  	 * function and only while registered.
> >  	 */
> > -	return transport_single;
> 
> This comment is about protecting transport_single.  It no longer applies
> when using vsk->transport.  Please drop it.

Right, dropped.

> 
> Otherwise:
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks,
Stefano
