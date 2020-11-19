Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262562B981C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgKSQfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:35:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728665AbgKSQfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:35:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605803753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rmz4vMCo9cJbvNaKXKHUnIBAy5VUu+3pBNzGePwX/CQ=;
        b=LGJcQBr5v4/qtQY4U20Y3P1ZzzIIcmQAvmcArL7LT3uiqZN3xX3TnZkT04DCNyZZky7vhr
        kEpWlxATej7TV53dtKKBvKtVvGJGA9JN+nDF/KKJk3lopuV67cXZ+r73FRG9zHqxP2pThZ
        xuNJEkf7/yp3RmIIZxp28ZhWetj7pqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-5cgFMGosMYiOELAYXE56dw-1; Thu, 19 Nov 2020 11:35:48 -0500
X-MC-Unique: 5cgFMGosMYiOELAYXE56dw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A21D91005D5F;
        Thu, 19 Nov 2020 16:35:44 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BD6B60636;
        Thu, 19 Nov 2020 16:35:36 +0000 (UTC)
Date:   Thu, 19 Nov 2020 17:35:35 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Joe Perches <joe@perches.com>
Cc:     brouer@redhat.com, Guenter Roeck <linux@roeck-us.net>,
        Tao Ren <rentao.bupt@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Subject: XDP maintainer match (Was  [PATCH v2 0/2] hwmon: (max127) Add Maxim
 MAX127 hardware monitoring)
Message-ID: <20201119173535.1474743d@carbon>
In-Reply-To: <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
        <20201118232719.GI1853236@lunn.ch>
        <20201118234252.GA18681@taoren-ubuntu-R90MNF91>
        <20201119010119.GA248686@roeck-us.net>
        <20201119012653.GA249502@roeck-us.net>
        <20201119074634.2e9cb21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 07:46:34 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed, 18 Nov 2020 17:26:53 -0800 Guenter Roeck wrote:
> > On Wed, Nov 18, 2020 at 05:01:19PM -0800, Guenter Roeck wrote:  
> > > On Wed, Nov 18, 2020 at 03:42:53PM -0800, Tao Ren wrote:    
> > > > On Thu, Nov 19, 2020 at 12:27:19AM +0100, Andrew Lunn wrote:    
> > > > > On Wed, Nov 18, 2020 at 03:09:27PM -0800, rentao.bupt@gmail.com wrote:    
> > > > > > From: Tao Ren <rentao.bupt@gmail.com>
> > > > > > 
> > > > > > The patch series adds hardware monitoring driver for the Maxim MAX127
> > > > > > chip.    
> > > > > 
> > > > > Hi Tao
> > > > > 
> > > > > Why are using sending a hwmon driver to the networking mailing list?
> > > > > 
> > > > >     Andrew    
> > > > 
> > > > Hi Andrew,
> > > > 
> > > > I added netdev because the mailing list is included in "get_maintainer.pl
> > > > Documentation/hwmon/index.rst" output. Is it the right command to find
> > > > reviewers? Could you please suggest? Thank you.    
> > > 
> > > I have no idea why running get_maintainer.pl on
> > > Documentation/hwmon/index.rst returns such a large list of mailing
> > > lists and people. For some reason it includes everyone in the XDP
> > > maintainer list. If anyone has an idea how that happens, please
> > > let me know - we'll want to get this fixed to avoid the same problem
> > > in the future.  
> > 
> > I found it. The XDP maintainer entry has:
> > 
> > K:    xdp
> > 
> > This matches Documentation/hwmon/index.rst.
> > 
> > $ grep xdp Documentation/hwmon/index.rst
> >    xdpe12284
> > 
> > It seems to me that a context match such as "xdp" in MAINTAINERS isn't
> > really appropriate. "xdp" matches a total of 348 files in the kernel.
> > The large majority of those is not XDP related. The maintainers
> > of XDP (and all the listed mailing lists) should not be surprised
> > to get a large number of odd review requests if they want to review
> > every single patch on files which include the term "xdp".  
> 
> Agreed, we should fix this. For maintainers with high patch volume life
> would be so much easier if people CCed the right folks to get reviews,
> so we should try our best to fix get_maintainer.
> 
> XDP folks, any opposition to changing the keyword / filename to:
> 
> 	[^a-z0-9]xdp[^a-z0-9]
> 
> ?

I think it is a good idea to change the keyword (K:), but I'm not sure
this catch what we want, maybe it does.  The pattern match are meant to
catch drivers containing XDP related bits.

Previously Joe Perches <joe@perches.com> suggested this pattern match,
which I don't fully understand... could you explain Joe?

  (?:\b|_)xdp(?:\b|_)

For the filename (N:) regex match, I'm considering if we should remove
it and list more files explicitly.  I think normal glob * pattern
works, which should be sufficient.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

