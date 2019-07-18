Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E235D6CA03
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfGRHhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 03:37:41 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44100 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfGRHhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 03:37:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4CFB520250;
        Thu, 18 Jul 2019 09:37:40 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id z2dBpsUiSK1C; Thu, 18 Jul 2019 09:37:39 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E8AB6201C6;
        Thu, 18 Jul 2019 09:37:39 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 18 Jul 2019
 09:37:39 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9FF653180529;
 Thu, 18 Jul 2019 09:37:39 +0200 (CEST)
Date:   Thu, 18 Jul 2019 09:37:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec v2 0/4] xfrm interface: bugs fixes
Message-ID: <20190718073739.GT17989@gauss3.secunet.de>
References: <df990564-819a-314f-dda6-aab58a2e7b6e@6wind.com>
 <20190715100023.8475-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190715100023.8475-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 12:00:19PM +0200, Nicolas Dichtel wrote:
> 
> Here is a bunch of bugs fixes. Some have been seen by code review and some when
> playing with x-netns.
> The details are in each patch.
> 
> v1 -> v2:
>  - add patch #3 and #4

Series applied, thanks Nicolas!

