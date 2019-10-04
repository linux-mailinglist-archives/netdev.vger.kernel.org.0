Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF04CB40D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 06:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387992AbfJDE57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 00:57:59 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34612 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387872AbfJDE56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 00:57:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0D14D20504;
        Fri,  4 Oct 2019 06:57:57 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vnIbkSf-BQcR; Fri,  4 Oct 2019 06:57:56 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A0A18201E5;
        Fri,  4 Oct 2019 06:57:56 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 06:57:56 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2D2183180086;
 Fri,  4 Oct 2019 06:57:56 +0200 (CEST)
Date:   Fri, 4 Oct 2019 06:57:56 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCHv2 ipsec-next] xfrm: remove the unnecessary .net_exit for
 xfrmi
Message-ID: <20191004045756.GT5772@gauss3.secunet.de>
References: <0e9b72a6caf695dd99c02bd223168897977daaef.1568017810.git.lucien.xin@gmail.com>
 <20190917090229.GC2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190917090229.GC2879@gauss3.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 11:02:29AM +0200, Steffen Klassert wrote:
> On Mon, Sep 09, 2019 at 04:30:10PM +0800, Xin Long wrote:
> > The xfrm_if(s) on each netns can be deleted when its xfrmi dev is
> > deleted. xfrmi dev's removal can happen when:
> > 
> >   a. netns is being removed and all xfrmi devs will be deleted.
> > 
> >   b. rtnl_link_unregister(&xfrmi_link_ops) in xfrmi_fini() when
> >      xfrm_interface.ko is being unloaded.
> > 
> > So there's no need to use xfrmi_exit_net() to clean any xfrm_if up.
> > 
> > v1->v2:
> >   - Fix some changelog.
> > 
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> I've queued this for applying until after the merge window,
> no need to resend.

This is now applied to ipsec-next.

Thanks!
