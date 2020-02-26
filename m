Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D96E16F640
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 04:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgBZDxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 22:53:07 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726024AbgBZDxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 22:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582689186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pX9Cylpbp8u1yluJWyAC4cbOt92DeRnpwyxkzw7eOqc=;
        b=OwRhC2y9ZAou0MNvnzqZgvneuVghQJqkgMdzyi02S4/spbnWec3lxllaeJEf504kATPVji
        PbfTzST6sqtgflmXcqLeVYcBeM7pdwprsUsfv3njK2qxN670vCT5cc67WoIbnJUnoFP8Z5
        hOPzOSNaatYFZk4YHPDf1gVsfB1qzz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-A9Sgg-C7PoOXr4WH258aQg-1; Tue, 25 Feb 2020 22:53:02 -0500
X-MC-Unique: A9Sgg-C7PoOXr4WH258aQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B52531882CD1;
        Wed, 26 Feb 2020 03:53:00 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EE6692966;
        Wed, 26 Feb 2020 03:52:45 +0000 (UTC)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     David Ahern <dahern@digitalocean.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <772b6d6f-0728-c338-b541-fcf4114a1d32@redhat.com>
 <3ab884ab-f7f8-18eb-3d18-c7636c84f9b4@digitalocean.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cf132d5f-5359-b3a5-38c2-34583aae3f36@redhat.com>
Date:   Wed, 26 Feb 2020 11:52:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <3ab884ab-f7f8-18eb-3d18-c7636c84f9b4@digitalocean.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/26 =E4=B8=8A=E5=8D=8811:34, David Ahern wrote:
> On 2/25/20 8:29 PM, Jason Wang wrote:
>> TAP uses spinlock for XDP_TX.
> code reference? I can not find that.
>

In tun_xdp_xmit(), ptr_ring is synchronized through producer_lock.

Thanks


