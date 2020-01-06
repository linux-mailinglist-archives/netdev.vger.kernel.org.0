Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11532131AEF
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgAFWBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:01:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23739 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726735AbgAFWBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 17:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578348098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFTZUEOpMofr3BSdyrQCr+64xrakrWkVSbyTJ0XeW+A=;
        b=R5EsiXHcE2LqKtfBZ5jBZAlvH0ayDtbk2HGLxKGMe0r38c9KTgQGS0r8m8FfRt4/jbtfZw
        pmN+IYpqOKjhkCZfucOor/mHAfeXF17Nnyhi7JLCu1dm1//oLaIkjOiJPb/37ihaKQ0Trk
        tPRQV/7fbnm6C9U6eamcWuzNeGt/MhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-vit5IhfUNzC76YA62FjYPQ-1; Mon, 06 Jan 2020 17:01:34 -0500
X-MC-Unique: vit5IhfUNzC76YA62FjYPQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A21B91800D4A;
        Mon,  6 Jan 2020 22:01:33 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1ADC7C01C;
        Mon,  6 Jan 2020 22:01:31 +0000 (UTC)
Date:   Mon, 06 Jan 2020 14:01:30 -0800 (PST)
Message-Id: <20200106.140130.1426441348209333206.davem@redhat.com>
To:     linus.walleij@linaro.org
Cc:     netdev@vger.kernel.org, arnd@arndb.de,
        jakub.kicinski@netronome.com, stable@vger.kernel.org
Subject: Re: [PATCH net-next 9/9 v3] net: ethernet: ixp4xx: Use parent dev
 for DMA pool
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200106074647.23771-10-linus.walleij@linaro.org>
References: <20200106074647.23771-1-linus.walleij@linaro.org>
        <20200106074647.23771-10-linus.walleij@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon,  6 Jan 2020 08:46:47 +0100

> Use the netdevice struct device .parent field when calling
> dma_pool_create(): the .dma_coherent_mask and .dma_mask
> pertains to the bus device on the hardware (platform)
> bus in this case, not the struct device inside the network
> device. This makes the pool allocation work.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Networking changes don't use CC:'ing stable, please see the netdev
FAQ under Documentation/

And net-next changes don't go to stable.

If you want to submit this bug fix, submit to 'net' and provide an
appropriate Fixes: tag.

Thank you.

