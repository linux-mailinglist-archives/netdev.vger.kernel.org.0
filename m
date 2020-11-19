Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DBD2B9C42
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgKSUu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39069 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgKSUu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 15:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605819025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xm4j3xfHTIGmXRRvxsdz866giYTVRYk7uSgQIas4XtQ=;
        b=ec5co+NAExoV3OevCRz2XVbssZuy7CxlZGAZ/7tydi2AFw/YGwprtj+3wvwYAj/IWv9wWZ
        fRnOdRVRK4atDuIWaTcriYyyoFdcrZv9uK3hRJRXb8DqsYvWeLB5YthM2U+mrpqjXRfCbR
        VkYqEVVSeevbP/yZn9D92Az4aXQm4ZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-FA3z3dwLO_ev-eqJCxFawA-1; Thu, 19 Nov 2020 15:50:21 -0500
X-MC-Unique: FA3z3dwLO_ev-eqJCxFawA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7472E107ACE3;
        Thu, 19 Nov 2020 20:50:19 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3C465C1D1;
        Thu, 19 Nov 2020 20:50:13 +0000 (UTC)
Date:   Thu, 19 Nov 2020 21:50:12 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, Joe Perches <joe@perches.com>,
        brouer@redhat.com
Subject: Re: [PATCH net-next] MAINTAINERS: Update XDP and AF_XDP entries
Message-ID: <20201119215012.57d39102@carbon>
In-Reply-To: <20201119100210.08374826@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <160580680009.2806072.11680148233715741983.stgit@firesoul>
        <20201119100210.08374826@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 10:02:10 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 19 Nov 2020 18:26:40 +0100 Jesper Dangaard Brouer wrote:
> > Getting too many false positive matches with current use
> > of the content regex K: and file regex N: patterns.
> > 
> > This patch drops file match N: and makes K: more restricted.
> > Some more normal F: file wildcards are added.
> > 
> > Notice that AF_XDP forgot to some F: files that is also
> > updated in this patch.
> > 
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>  
> 
> Ah! Sorry, I missed that you sent this before replying to Joe.
> 
> Would you mind respining with his regex?

Sure, I just send it... with your adjusted '(\b|_)xdp(\b|_)' regex, as
it seems to do the same thing (and it works with egrep).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

