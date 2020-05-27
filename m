Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FD11E43CB
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388315AbgE0Ndo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:33:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52000 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387730AbgE0Ndk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 09:33:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=opjoqZxCQdaB3EzLhcpxSqBTfSFuC3UOtI1l3JqnwoU=; b=Kgft5gaHZhY6Kt4LopUAPR1ibt
        iemlkwvFnSOxJ271VosIgscoX/KwtN7xZ/kuhmVq/CrBp6KE281qC0tv5OMou0Hw+rqgRrij29HCQ
        DV/oOV3I+Uk2wVTQGSfJ4hCiCskj0zzroOumECHC2x/r/e0C7rvWilX+xSTk/WUs3nc8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdwBB-003PI5-M7; Wed, 27 May 2020 15:33:09 +0200
Date:   Wed, 27 May 2020 15:33:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Emanuele Giuseppe Esposito <e.emanuelegiuseppe@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Statsfs: a new ram-based file system for Linux
 kernel statistics
Message-ID: <20200527133309.GC793752@lunn.ch>
References: <20200526110318.69006-1-eesposit@redhat.com>
 <20200526153128.448bfb43@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <6a754b40-b148-867d-071d-8f31c5c0d172@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a754b40-b148-867d-071d-8f31c5c0d172@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't really know a lot about the networking subsystem, and as it was
> pointed out in another email on patch 7 by Andrew, networking needs to
> atomically gather and display statistics in order to make them consistent,
> and currently this is not supported by stats_fs but could be added in
> future.

Hi Emanuele

Do you have any idea how you will support atomic access? It does not
seem easy to implement in a filesystem based model.

     Andrew
