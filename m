Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83695EFA2C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbfKEJy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:54:27 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:39628 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730571AbfKEJy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 04:54:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EF16620270;
        Tue,  5 Nov 2019 10:54:24 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EtUoAYUUqEcP; Tue,  5 Nov 2019 10:54:24 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9176C201E2;
        Tue,  5 Nov 2019 10:54:24 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 5 Nov 2019
 10:54:25 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 243A0318028C;
 Tue,  5 Nov 2019 10:54:24 +0100 (CET)
Date:   Tue, 5 Nov 2019 10:54:24 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     JD <jdtxs00@gmail.com>
CC:     <netdev@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
Message-ID: <20191105095424.GW13225@gauss3.secunet.de>
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
 <20191101075335.GG14361@gauss3.secunet.de>
 <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 12:25:37PM -0600, JD wrote:
> 
> Hello Steffen,
> 
> I left the stress test running over the weekend and everything still looks
> great. Your patch definitely resolves the leak.

Thanks for testing this!

> 
> Everything kernel 4.11 and above will need this fix afaik. CC'ed Greg KH.
> Will need backporting to 4.14/4.19.

It is a bit early to Cc the -stable maintainers, but I make
sure it is going to be backported :-)

