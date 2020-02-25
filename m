Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F10216B946
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 06:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgBYFqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 00:46:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58047 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726019AbgBYFqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 00:46:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582609572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wlfZHi7K31IEzsSyN0TR6qKfuLEZhiUXhJhGkDqDhGM=;
        b=IRTRVwf87h5Rpw/8aSfMX5W/Iip1sEJmRT5Tj/RxdB7GsuAnF+lP4g20z4kbfVZ4UkwrrR
        GodffJM9RkTPS8yeIT5xh9VlBOhWmQWy/tiVPsrx7U8NC18T0LPLJgpzJlsKwxwFSOjbf5
        672nrOmTVt7AgWDM3gZqmicUUMDKUXA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-PDwaCRNBMDKJk1t0HT-9Hg-1; Tue, 25 Feb 2020 00:46:05 -0500
X-MC-Unique: PDwaCRNBMDKJk1t0HT-9Hg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ED101005512;
        Tue, 25 Feb 2020 05:46:03 +0000 (UTC)
Received: from [10.72.13.170] (ovpn-13-170.pek2.redhat.com [10.72.13.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E06FA60BF7;
        Tue, 25 Feb 2020 05:45:55 +0000 (UTC)
Subject: Re: [PATCH bpf-next v6 2/2] virtio_net: add XDP meta data support
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
References: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
 <20200225033212.437563-1-yuya.kusakabe@gmail.com>
 <20200225033212.437563-2-yuya.kusakabe@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4c3ca8e7-2ab0-8d57-7361-7909fba3905d@redhat.com>
Date:   Tue, 25 Feb 2020 13:45:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225033212.437563-2-yuya.kusakabe@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/25 =E4=B8=8A=E5=8D=8811:32, Yuya Kusakabe wrote:
> Implement support for transferring XDP meta data into skb for
> virtio_net driver; before calling into the program, xdp.data_meta point=
s
> to xdp.data, where on program return with pass verdict, we call
> into skb_metadata_set().
>
> Tested with the script at
> https://github.com/higebu/virtio_net-xdp-metadata-test.
>
> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>


Acked-by: Jason Wang <jasowang@redhat.com>

