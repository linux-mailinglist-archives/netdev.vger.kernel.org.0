Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBA41981CC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgC3RBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:01:19 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35820 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgC3RBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 13:01:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AAC6420491;
        Mon, 30 Mar 2020 19:01:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Rank_v2KDCRf; Mon, 30 Mar 2020 19:01:18 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0B2B0201A0;
        Mon, 30 Mar 2020 19:01:18 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-01.secunet.de
 (10.53.40.201) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 30 Mar
 2020 19:01:17 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 91B2D3180136; Mon, 30 Mar 2020 19:01:17 +0200 (CEST)
Date:   Mon, 30 Mar 2020 19:01:17 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] udp: initialize is_flist with 0 in udp_gro_receive
Message-ID: <20200330170117.GT13121@gauss3.secunet.de>
References: <6014932c7cdef91c11cdb0dcf73dbf77b65f8638.1585582305.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6014932c7cdef91c11cdb0dcf73dbf77b65f8638.1585582305.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-01.secunet.de (10.53.40.201)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 11:31:45PM +0800, Xin Long wrote:
> Without NAPI_GRO_CB(skb)->is_flist initialized, when the dev doesn't
> support NETIF_F_GRO_FRAGLIST, is_flist can still be set and fraglist
> will be used in udp_gro_receive().
> 
> So fix it by initializing is_flist with 0 in udp_gro_receive.
> 
> Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

