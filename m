Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029AF3033F8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbhAZFKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:10:32 -0500
Received: from forward101p.mail.yandex.net ([77.88.28.101]:35958 "EHLO
        forward101p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728926AbhAYNdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:33:35 -0500
Received: from myt2-0bcf81a4c8f9.qloud-c.yandex.net (myt2-0bcf81a4c8f9.qloud-c.yandex.net [IPv6:2a02:6b8:c00:3b24:0:640:bcf:81a4])
        by forward101p.mail.yandex.net (Yandex) with ESMTP id 30ADD3280AEB;
        Mon, 25 Jan 2021 16:32:22 +0300 (MSK)
Received: from myt3-5a0d70690205.qloud-c.yandex.net (myt3-5a0d70690205.qloud-c.yandex.net [2a02:6b8:c12:4f2b:0:640:5a0d:7069])
        by myt2-0bcf81a4c8f9.qloud-c.yandex.net (mxback/Yandex) with ESMTP id T6IozmAtdQ-WLH8nZPn;
        Mon, 25 Jan 2021 16:32:22 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1611581542;
        bh=7ngRG6nrQB3McavML2flSJugM2lIRtBmprXfxP0B64w=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=H/bVPIORQBfFXqXnEavEvdE3dw5oXaButNeMgmfIi7mvugJ0wyYX5b1JImRZ6LavQ
         O0l7GDgL2VuOt2RB6Uxv4j2wLEUF0gwgwXXujedOtrQTjAHfuESeOJ4rgHBLdLwv1z
         M0YO2fRN9fTk7j0lhh5FMDm2sa7eyxe0nn78qHI8=
Authentication-Results: myt2-0bcf81a4c8f9.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt3-5a0d70690205.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 9fRHntulNw-WKI0NkLI;
        Mon, 25 Jan 2021 16:32:20 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [RFC PATCH v3 03/13] af_vsock: implement SEQPACKET rx loop
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
 <20210125111239.598377-1-arseny.krasnov@kaspersky.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <6a92dc1a-d4ef-37e9-c67b-e8789cf144e3@yandex.ru>
Date:   Mon, 25 Jan 2021 16:32:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210125111239.598377-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

25.01.2021 14:12, Arseny Krasnov пишет:
> This adds receive loop for SEQPACKET. It looks like receive loop for
> SEQPACKET,
     ^^^
You meant "STREAM"?
