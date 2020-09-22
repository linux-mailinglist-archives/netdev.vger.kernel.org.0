Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27752743B0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVN6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32010 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbgIVN6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600783101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZaXDoAzKG8QFfLjgXSpCqC7fAJRkD0zUcrE69p4mvFk=;
        b=fdNLECKCNtu7OxNw3rOIMG6h/c786TF9KQ13kvgd1DI6wMYtbHye5bicxUKBFWF9Lv/ZK5
        NaC6jmWwW5aXod1rCuDms0t7SEVjzi3Zt4Byp8zOLbiRZAXknuff4EaUFRXAwfZI/zTmPQ
        7nyDEtIv0cyA5t5i1Kgy+tZz+XAxvyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-0LveFFvRMNq_IicZhSo63Q-1; Tue, 22 Sep 2020 09:58:19 -0400
X-MC-Unique: 0LveFFvRMNq_IicZhSo63Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1059A8C435F;
        Tue, 22 Sep 2020 13:57:57 +0000 (UTC)
Received: from ceranb (unknown [10.40.192.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4438D1055A65;
        Tue, 22 Sep 2020 13:57:53 +0000 (UTC)
Date:   Tue, 22 Sep 2020 15:57:53 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     <jiri@resnulli.us>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: switchdev: Fixed kerneldoc warning
Message-ID: <20200922155753.4010aa81@ceranb>
In-Reply-To: <1600781539-31676-1-git-send-email-tiantao6@hisilicon.com>
References: <1600781539-31676-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 21:32:19 +0800
Tian Tao <tiantao6@hisilicon.com> wrote:

> Update kernel-doc line comments to fix warnings reported by make W=1.
> net/switchdev/switchdev.c:413: warning: Function parameter or
> member 'extack' not described in 'call_switchdev_notifiers'
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  net/switchdev/switchdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
> index 865f3e0..23d8685 100644
> --- a/net/switchdev/switchdev.c
> +++ b/net/switchdev/switchdev.c
> @@ -404,7 +404,7 @@ EXPORT_SYMBOL_GPL(unregister_switchdev_notifier);
>   *	@val: value passed unmodified to notifier function
>   *	@dev: port device
>   *	@info: notifier information data
> - *
> + *	@extack: netlink extended ack
>   *	Call all network notifier blocks.
>   */
>  int call_switchdev_notifiers(unsigned long val, struct net_device *dev,

Acked-by: Ivan Vecera <ivecera@redhat.com>

