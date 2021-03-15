Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075BF33C899
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhCOVjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:39:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233136AbhCOVjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:39:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615844383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qkdqntrkesd0zsgt86ODqpue66pp2ATokoiM4RMTzrY=;
        b=Chfa3PvWs5O4zRX4PlHcKESA6pFb/b1MNotXWcqXVoDy27gSxaVmK0dg0TvO7zBlqFvtGH
        D1DhRzK8V7YYgLSzzLwU2UpY/MttT9wg1vm/grZGRYzURU3B+a58NOcyIJIAMqm7EOIkF7
        I/uxCmHcL4Phu4gDKeKRIG62JVBLyCM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-Sj3oSMX9MzyFVnnvkG8hOQ-1; Mon, 15 Mar 2021 17:39:39 -0400
X-MC-Unique: Sj3oSMX9MzyFVnnvkG8hOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C52CF87A83A;
        Mon, 15 Mar 2021 21:39:37 +0000 (UTC)
Received: from localhost (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A83145C3E6;
        Mon, 15 Mar 2021 21:39:34 +0000 (UTC)
Date:   Mon, 15 Mar 2021 14:39:33 -0700 (PDT)
Message-Id: <20210315.143933.939938434416308507.davem@redhat.com>
To:     cristian.ciocaltea@gmail.com
Cc:     andrew@lunn.ch, kuba@kernel.org, robh+dt@kernel.org,
        afaerber@suse.de, mani@kernel.org, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
From:   David Miller <davem@redhat.com>
In-Reply-To: <a93430bc30d7e733184a2fa3ab5c66180a76d379.1615807292.git.cristian.ciocaltea@gmail.com>
References: <cover.1615807292.git.cristian.ciocaltea@gmail.com>
        <a93430bc30d7e733184a2fa3ab5c66180a76d379.1615807292.git.cristian.ciocaltea@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Date: Mon, 15 Mar 2021 13:29:17 +0200

> +
> +#define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
> +static int debug = -1;
> +module_param(debug, int, 0);
> +MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");

Module parameters are strongly discouraged in networking drivers, pplease delete this
ad just pass the default to netif_mdg_init(), thanks!

