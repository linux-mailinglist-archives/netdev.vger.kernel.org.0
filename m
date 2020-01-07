Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDA6131CCD
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 01:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgAGAjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 19:39:47 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727228AbgAGAjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 19:39:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578357586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WpcYMvOyg6EdL+sJ/qoxt77vYeujMEcskFueY35/2Bw=;
        b=IUSZyt1QRV0PY4Q/GKKvd+iVg1xfaXDc+wg8QX3/PFhYdp4f6AJiURteW73pPNQlY1VNHC
        YQEr8NXPia0GxZyL2SxA6gAHfazCHCSk4cnxkoodBuueeVQRcI2jchtfFyWlERn+B8/xXU
        XwYVB7w5n51eQj2lh9gaALpXAyW6L/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-l75FqxgqO2qJWF5f3asirQ-1; Mon, 06 Jan 2020 19:39:44 -0500
X-MC-Unique: l75FqxgqO2qJWF5f3asirQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0955C801E7A;
        Tue,  7 Jan 2020 00:39:43 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A32D80600;
        Tue,  7 Jan 2020 00:39:40 +0000 (UTC)
Date:   Mon, 06 Jan 2020 16:39:39 -0800 (PST)
Message-Id: <20200106.163939.1819867450425607038.davem@redhat.com>
To:     linus.walleij@linaro.org
Cc:     netdev@vger.kernel.org, arnd@arndb.de,
        jakub.kicinski@netronome.com, stable@vger.kernel.org
Subject: Re: [PATCH net-next 9/9 v3] net: ethernet: ixp4xx: Use parent dev
 for DMA pool
From:   David Miller <davem@redhat.com>
In-Reply-To: <CACRpkdagGWBcQz8mVj9OqH+xL_tr1hbVv7sTnJ9GeLVq0dRamw@mail.gmail.com>
References: <20200106074647.23771-10-linus.walleij@linaro.org>
        <20200106.140130.1426441348209333206.davem@redhat.com>
        <CACRpkdagGWBcQz8mVj9OqH+xL_tr1hbVv7sTnJ9GeLVq0dRamw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 6 Jan 2020 23:39:19 +0100

> On Mon, Jan 6, 2020 at 11:01 PM David Miller <davem@redhat.com> wrote:
>> If you want to submit this bug fix, submit to 'net' and provide an
>> appropriate Fixes: tag.
> 
> It's no big deal so let's skip that, do you want me to resend the lot
> or can you just strip the stable tag when applying?

Please resubmit, it helps me a lot.

Thanks.

