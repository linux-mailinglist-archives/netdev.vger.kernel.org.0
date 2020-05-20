Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659171DB8D2
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgETP46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:56:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52872 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726856AbgETP45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589990216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sno0GmQ/eQv+Rs74eF1UQLVprtgb41HhzSqFhBF9Z8s=;
        b=RScn9haiZyNpcqVRHR2LISRYxtfzc/yjpW5MALnYdN7PdzY5h5TJHqhxpdcClvWPcIYAdE
        Qs8QDbTTKz+LAVy48/4kK8k/i+B4Yp0DhLEtuOlRK1eNrgOtcJaDG4PgKWC6IrJsq1C0kZ
        0koJdXL07hlnXmJZAaMzqcLMuLmNbNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-sIzVUj7MM16DmhemM8TuYQ-1; Wed, 20 May 2020 11:56:52 -0400
X-MC-Unique: sIzVUj7MM16DmhemM8TuYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF91580183C;
        Wed, 20 May 2020 15:56:50 +0000 (UTC)
Received: from ceranb (unknown [10.40.192.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECE755D9CA;
        Wed, 20 May 2020 15:56:47 +0000 (UTC)
Date:   Wed, 20 May 2020 17:56:47 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <jiri@resnulli.us>, <davem@davemloft.net>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] switchdev: mrp: Remove the variable mrp_ring_state
Message-ID: <20200520175647.32e6f5eb@ceranb>
In-Reply-To: <20200520130923.3196432-3-horatiu.vultur@microchip.com>
References: <20200520130923.3196432-1-horatiu.vultur@microchip.com>
        <20200520130923.3196432-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 13:09:22 +0000
Horatiu Vultur <horatiu.vultur@microchip.com> wrote:

> Remove the variable mrp_ring_state from switchdev_attr because is not
> used anywhere.
> The ring state is set using SWITCHDEV_OBJ_ID_RING_STATE_MRP.
> 
> Fixes: c284b5459008 ("switchdev: mrp: Extend switchdev API to offload MRP")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/net/switchdev.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index ae7aeb0d1f9ca..db519957e134b 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -62,7 +62,6 @@ struct switchdev_attr {
>  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
>  		u8 mrp_port_state;			/* MRP_PORT_STATE */
>  		u8 mrp_port_role;			/* MRP_PORT_ROLE */
> -		u8 mrp_ring_state;			/* MRP_RING_STATE */
>  #endif
>  	} u;
>  };

Acked-by: Ivan Vecera <ivecera@redhat.com>

