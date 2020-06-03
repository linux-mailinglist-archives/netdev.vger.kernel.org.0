Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC091ECA8F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 09:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFCH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 03:29:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47080 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725810AbgFCH3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 03:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591169356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxS4hZGinRyO6v5MBswe9QYzQHzxWg+7TXgH/FRkvMM=;
        b=H314MoYoYgO64S3YlUbMwm5ddU2OmGEKx9lJpf56xTZVwCQ4DqbznPn8YCd3H9fm6tWjAi
        jJMGHSxFd7TKVffq5Y3N9LVdwWc9E8w0/MVVlEHQYGcjHYCqoyIk5Nz9aLc9BBC+O9L4xn
        ec3h8JHwHifb2DTGZrAG9eeLrw0BiFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-uTK2w6nSO0OwCHEMsepudw-1; Wed, 03 Jun 2020 03:29:14 -0400
X-MC-Unique: uTK2w6nSO0OwCHEMsepudw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00C66BFC0;
        Wed,  3 Jun 2020 07:29:13 +0000 (UTC)
Received: from [10.72.12.214] (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4273760C47;
        Wed,  3 Jun 2020 07:29:03 +0000 (UTC)
Subject: Re: [PATCH RFC 04/13] vhost: cleanup fetch_buf return code handling
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
References: <20200602130543.578420-1-mst@redhat.com>
 <20200602130543.578420-5-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7221afa5-bafd-f19b-9cfd-cc51a8d3b321@redhat.com>
Date:   Wed, 3 Jun 2020 15:29:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602130543.578420-5-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/2 下午9:06, Michael S. Tsirkin wrote:
> Return code of fetch_buf is confusing, so callers resort to
> tricks to get to sane values. Let's switch to something standard:
> 0 empty, >0 non-empty, <0 error.
>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>   drivers/vhost/vhost.c | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)


Why not squashing this into patch 2 or 3?

Thanks

