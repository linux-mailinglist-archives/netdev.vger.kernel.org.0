Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67192037AF
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgFVNQ6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 09:16:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38931 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728243AbgFVNQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:16:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-mi0QBs-wNfqlYDGUsiP3LQ-1; Mon, 22 Jun 2020 09:16:54 -0400
X-MC-Unique: mi0QBs-wNfqlYDGUsiP3LQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 867CB1005512;
        Mon, 22 Jun 2020 13:16:53 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-112-149.ams2.redhat.com [10.36.112.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2EEF100164C;
        Mon, 22 Jun 2020 13:16:51 +0000 (UTC)
Date:   Mon, 22 Jun 2020 15:16:50 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec-next 02/10] tunnel4: add cb_handler to struct
 xfrm_tunnel
Message-ID: <20200622131650.GD2557669@bistromath.localdomain>
References: <cover.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-17, 01:36:27 +0800, Xin Long wrote:
> @@ -231,6 +255,7 @@ static int __init tunnel4_init(void)
>  		goto err;
>  	}
>  #endif
> +	xfrm_input_register_afinfo(&tunnel4_input_afinfo);

This can fail. Shouldn't you handle that error?

>  	return 0;
>  
>  err:

-- 
Sabrina

