Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C722164400
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgBSMPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:15:53 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:55208 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgBSMPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 07:15:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3831620299;
        Wed, 19 Feb 2020 13:15:52 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CO4tRHGQipD3; Wed, 19 Feb 2020 13:15:51 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C0090201E2;
        Wed, 19 Feb 2020 13:15:51 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 13:15:51 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5C58F3180098;
 Wed, 19 Feb 2020 13:15:51 +0100 (CET)
Date:   Wed, 19 Feb 2020 13:15:51 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Raed Salem <raeds@mellanox.com>
CC:     <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Message-ID: <20200219121551.GT8274@gauss3.secunet.de>
References: <1582113718-16712-1-git-send-email-raeds@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1582113718-16712-1-git-send-email-raeds@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 02:01:58PM +0200, Raed Salem wrote:
> The esp fill trailer method is identical for both
> IPv6 and IPv4.
> 
> Share the implementation for esp6 and esp to avoid
> code duplication in addition it could be also used
> at various drivers code.
> 
> Change-Id: Iebb4325fe12ef655a5cd6cb896cf9eed68033979

For what do you need the above line?

> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Your patch does not apply to ipsec-next, please rebase
on this tree and resend.

Thanks!
