Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2831E6BAE
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406846AbgE1TuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:50:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30222 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406693AbgE1Tt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:49:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590695398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bGEwxwS7tZTWjiMY8Vu7E2VO0RKA+bB59w6D9Y1acyk=;
        b=VMsiw/WcSkQ6BxW/byxfLd7iowMrAxD/7bUMUDmslvEYRandxU9RBKD5GHQqhDfhri+9qO
        hj9vPFeRA7dh7/h53D6jtb2MnRbHTfk6X2KfBF0Uw02tuvjlhMBXLuLTkO+pkvnVaQrsMr
        gIcOBKofaHDFzc9XZVQdqo5w3FlQRXk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-DMIMTC5sN_WX3GnguJDP0Q-1; Thu, 28 May 2020 15:49:51 -0400
X-MC-Unique: DMIMTC5sN_WX3GnguJDP0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 164AB107ACCA;
        Thu, 28 May 2020 19:49:50 +0000 (UTC)
Received: from localhost (unknown [10.10.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DF991992F;
        Thu, 28 May 2020 19:49:47 +0000 (UTC)
Date:   Thu, 28 May 2020 12:49:46 -0700 (PDT)
Message-Id: <20200528.124946.275321353658990898.davem@redhat.com>
To:     arnd@arndb.de
Cc:     linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, kuba@kernel.org, amaftei@solarflare.com,
        tzhao@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] sfc: avoid an unused-variable warning
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200527134113.827128-1-arnd@arndb.de>
References: <20200527134113.827128-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 27 May 2020 15:41:06 +0200

> 'nic_data' is no longer used outside of the #ifdef block
> in efx_ef10_set_mac_address:
> 
> drivers/net/ethernet/sfc/ef10.c:3231:28: error: unused variable 'nic_data' [-Werror,-Wunused-variable]
>         struct efx_ef10_nic_data *nic_data = efx->nic_data;
> 
> Move the variable into a local scope.
> 
> Fixes: dfcabb078847 ("sfc: move vport_id to struct efx_nic")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applid, thanks.

