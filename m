Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF1043B234
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhJZMV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:21:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235845AbhJZMVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:21:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635250771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KFPz44uMCA8jG3GT1BjTNBoKbQpxmMtkFkAqywB2zac=;
        b=F4XM6/E42pYjiQ2U8+E28Vfx7TRsSWFENBSrKNb81+qF61zGJtccT32Au8YfM+BfBSkBZc
        uszDQOVC451rWiIrasKdRUrmlDS0RhDFBo2k7kU3juk3EeLko+wquuD/rBKFILQnSvw+xt
        2PGHJJ8XGnNE/Hl3nio6mi6gaCdvqdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-j0oLsr_rPSmtVp4qNDRLjQ-1; Tue, 26 Oct 2021 08:19:25 -0400
X-MC-Unique: j0oLsr_rPSmtVp4qNDRLjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B846A879500;
        Tue, 26 Oct 2021 12:19:24 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E03845C1A1;
        Tue, 26 Oct 2021 12:19:22 +0000 (UTC)
Date:   Tue, 26 Oct 2021 14:19:19 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Jeremy Kerr' <jk@codeconstruct.com.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: Re: [PATCH net-next v6] mctp: Implement extended addressing
Message-ID: <20211026121919.GA19385@asgard.redhat.com>
References: <20211026015728.3006286-1-jk@codeconstruct.com.au>
 <f5b11b52cf0644088a919fb2a1a07c18@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5b11b52cf0644088a919fb2a1a07c18@AcuMS.aculab.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:45:05AM +0000, David Laight wrote:
> Oh and how did MAX_ADDR_LEN ever get into a uapi header??

It is defined in <linux/netdevice.h> since v1.1.4 and has its current
value of 32 since v2.5.55~64^2^2~8 (before increasing for 7 to 8 in v2.4.6.9).

