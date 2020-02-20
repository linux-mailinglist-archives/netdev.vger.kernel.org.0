Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B18165DCF
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 13:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgBTMph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 07:45:37 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50322 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgBTMph (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 07:45:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5624720501;
        Thu, 20 Feb 2020 13:45:36 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id NVcq__Td03fg; Thu, 20 Feb 2020 13:45:35 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E8E5C2027C;
        Thu, 20 Feb 2020 13:45:35 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 13:45:35 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9546E318028C;
 Thu, 20 Feb 2020 13:45:35 +0100 (CET)
Date:   Thu, 20 Feb 2020 13:45:35 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Raed Salem <raeds@mellanox.com>
CC:     <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>,
        <kuznet@ms2.inr.ac.ru>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Message-ID: <20200220124535.GY8274@gauss3.secunet.de>
References: <1582116597-23065-1-git-send-email-raeds@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1582116597-23065-1-git-send-email-raeds@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 02:49:57PM +0200, Raed Salem wrote:
> The esp fill trailer method is identical for both
> IPv6 and IPv4.
> 
> Share the implementation for esp6 and esp to avoid
> code duplication in addition it could be also used
> at various drivers code.
> 
> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Applied to ipsec-next, thanks Raed!
