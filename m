Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F1D13BCF2
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 10:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgAOJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 04:58:00 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36466 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbgAOJ6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 04:58:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A346A2051F;
        Wed, 15 Jan 2020 10:57:58 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aGbe4I5w4W3B; Wed, 15 Jan 2020 10:57:56 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C5F3E200A3;
        Wed, 15 Jan 2020 10:57:56 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 Jan 2020
 10:57:56 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7A408318021B;
 Wed, 15 Jan 2020 10:57:56 +0100 (CET)
Date:   Wed, 15 Jan 2020 10:57:56 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xu Wang <vulab@iscas.ac.cn>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfrm: interface: do not confirm neighbor when do pmtu
 update
Message-ID: <20200115095756.GS8621@gauss3.secunet.de>
References: <1578906036-20623-1-git-send-email-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1578906036-20623-1-git-send-email-vulab@iscas.ac.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 09:00:36AM +0000, Xu Wang wrote:
> When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
> we should not call dst_confirm_neigh() as there is no two-way communication.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Patch applied to the ipsec tree, thanks a lot!
