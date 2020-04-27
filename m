Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E81B957D
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 05:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgD0DbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 23:31:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726340AbgD0DbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 23:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587958275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0WoA+56dUoJ/42TBfEa8gnCTKtqRiC7Gj8GgqmhVbnk=;
        b=Dz8JzZTVTOo9q8Ox1Vo90CQ5LtyLYbTaQKLE78KvPL0/5pTAFP+4KpEEyxB24HDTFCtA6e
        Wkixeo0/rPqg5eiXFsMW6dM5E9FIn0JgfDAkXy9JEoXIO/XWauaYtNHzWWP/5c26/Dwlqj
        XFI/FrgPIe9kUCz8nyF4Nj5bjvi60uo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-mbCEEtQlNV2GbyXyosO0mw-1; Sun, 26 Apr 2020 23:31:14 -0400
X-MC-Unique: mbCEEtQlNV2GbyXyosO0mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 072B918FE863;
        Mon, 27 Apr 2020 03:31:13 +0000 (UTC)
Received: from [10.72.12.205] (ovpn-12-205.pek2.redhat.com [10.72.12.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57E371001281;
        Mon, 27 Apr 2020 03:31:07 +0000 (UTC)
Subject: Re: [PATCH V4 0/3] vdpa: Support config interrupt in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1587901406-27400-1-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ff2471ae-254e-7697-72b7-6601a561c3d9@redhat.com>
Date:   Mon, 27 Apr 2020 11:31:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587901406-27400-1-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/26 =E4=B8=8B=E5=8D=887:43, Zhu Lingshan wrote:
> This series includes two patches, one introduced
> config interrupt support in VDPA core, the other
> one implemented config interrupt in IFCVF.
>
> changes from V3:
> move changes in driver/vhost/vhost.c to a
> separated patch.
>
> changes from V2:
> move VHOST_FILE_UNBIND to the uapi header.
>
> changes from V1:
> vdpa: more efficient code to handle eventfd unbind.
> ifcvf: add VIRTIO_NET_F_STATUS feature bit.


5.8 material I think.

Acked-by: Jason Wang <jasowang@redhat.com>


>
> Zhu Lingshan (3):
>    vdpa: Support config interrupt in vhost_vdpa
>    vhost: replace -1 with  VHOST_FILE_UNBIND in iotcls
>    vdpa: implement config interrupt in IFCVF
>
>   drivers/vdpa/ifcvf/ifcvf_base.c |  3 +++
>   drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
>   drivers/vdpa/ifcvf/ifcvf_main.c | 22 ++++++++++++++++++-
>   drivers/vhost/vdpa.c            | 47 ++++++++++++++++++++++++++++++++=
+++++++++
>   drivers/vhost/vhost.c           |  8 +++----
>   include/uapi/linux/vhost.h      |  4 ++++
>   6 files changed, 82 insertions(+), 5 deletions(-)
>

