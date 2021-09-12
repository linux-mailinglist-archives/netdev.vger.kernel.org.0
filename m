Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDDC407D43
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhILM1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:27:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229635AbhILM1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 08:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631449576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EJMlOn/j5HizvznJgRuFL+IRjjUfX6If1Q1A7oRa4dE=;
        b=RkQeG1ZQcx93ummTjWEC9/uPMbsWYQ9lYpuNtnT2X0s6ANTFGglD+7EWNXhwAA5isU2Utg
        10gkshM2S4bmW7UC9X9jh0v+ZCWsUhyBifsZfeLPPRq9rIBcU4uQKgPjZ8IoDuDHnki/9O
        2oM8ZmsmVYGRv/2dtFCE5/bjwXt+6KQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-I1tXsz_rPZ62FnZksjFWLA-1; Sun, 12 Sep 2021 08:26:12 -0400
X-MC-Unique: I1tXsz_rPZ62FnZksjFWLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98A48362F8;
        Sun, 12 Sep 2021 12:26:11 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4417260C04;
        Sun, 12 Sep 2021 12:26:08 +0000 (UTC)
Date:   Sun, 12 Sep 2021 14:26:06 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [ipsec:testing 1/2] include/linux/compiler_types.h:328:38:
 error: call to '__compiletime_assert_633' declared with attribute error:
 BUILD_BUG_ON failed: XFRM_MSG_MAX != XFRM_MSG_MAPPING
Message-ID: <20210912122606.GA28726@asgard.redhat.com>
References: <202109082146.dl8o0gJv-lkp@intel.com>
 <20210909101602.GG9115@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909101602.GG9115@gauss3.secunet.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 12:16:02PM +0200, Steffen Klassert wrote:
> On Wed, Sep 08, 2021 at 09:15:53PM +0800, kernel test robot wrote:
> >    In file included from <command-line>:
> >    security/selinux/nlmsgtab.c: In function 'selinux_nlmsg_lookup':
> > >> include/linux/compiler_types.h:328:38: error: call to '__compiletime_assert_633' declared with attribute error: BUILD_BUG_ON failed: XFRM_MSG_MAX != XFRM_MSG_MAPPING
> 
> Eugene, I had to drop this patch for now.
> Please fix and resend, thanks!

My apologies, cutting corners with build checking doesn't do me any
favors.  The patch is updated[1].

[1] https://lore.kernel.org/lkml/20210912122234.GA22469@asgard.redhat.com/

