Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162A49DE55
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 09:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfH0HBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 03:01:39 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49952 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfH0HBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 03:01:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 91F9520563;
        Tue, 27 Aug 2019 09:01:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vlnPFy3i39bJ; Tue, 27 Aug 2019 09:01:37 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 312A320189;
        Tue, 27 Aug 2019 09:01:37 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 09:01:37 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id CACEA3182772;
 Tue, 27 Aug 2019 09:01:36 +0200 (CEST)
Date:   Tue, 27 Aug 2019 09:01:36 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH net] xfrm: remove the unnecessary .net_exit for xfrmi
Message-ID: <20190827070136.GY2879@gauss3.secunet.de>
References: <120f5509a5c9292b437041e8a4193653adb9a019.1566807951.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <120f5509a5c9292b437041e8a4193653adb9a019.1566807951.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 04:25:51PM +0800, Xin Long wrote:
> The xfrm_if(s) on each netns can be deleted when its xfrmi dev is
> deleted. xfrmi dev's removal can happen when:
> 
>   1. Its phydev is being deleted and NETDEV_UNREGISTER event is
>      processed in xfrmi_event() from my last patch.
>   2. netns is being removed and all xfrmi devs will be deleted.
>   3. rtnl_link_unregister(&xfrmi_link_ops) in xfrmi_fini() when
>      xfrm_interface.ko is being unloaded.
> 
> So there's no need to use xfrmi_exit_net() to clean any xfrm_if up.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

We already have a bunch of xfrm interface fixes in the ipsec tree.
Please base this patch onto the ipsec tree and adjust if needed.

Thanks!
