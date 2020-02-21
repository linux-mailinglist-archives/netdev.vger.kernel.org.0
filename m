Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA8A1678B8
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbgBUIud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:50:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24531 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728609AbgBUIuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 03:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582275031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EXWvx43O9g/ijJ52j/YuLCYIbjQQg+Dy1xNnaG2kadU=;
        b=ffv3OMEhOl1ikMBkfvWep9kyYX7qQjxP4EJ5Vdkh4HtLcTg3FAH5MBLJHGT/FqNkm4ildw
        a5cODwZmnv/T6hx82vMkacFeJaXPDpb5oF2Akpgr8nKHK36+vWq+bdYDaebw2dYepuAuC8
        hx7ACIxuJaNXdaw6fHi1Ak6sEGNLx/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-JRoNw5u6PxuSrSphnI0hbA-1; Fri, 21 Feb 2020 03:50:30 -0500
X-MC-Unique: JRoNw5u6PxuSrSphnI0hbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70707107ACC9;
        Fri, 21 Feb 2020 08:50:27 +0000 (UTC)
Received: from [10.72.13.208] (ovpn-13-208.pek2.redhat.com [10.72.13.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87ECB5DD73;
        Fri, 21 Feb 2020 08:50:11 +0000 (UTC)
Subject: Re: [PATCH V4 5/5] vdpasim: vDPA device simulator
To:     Harpreet Singh Anand <hanand@xilinx.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-6-jasowang@redhat.com>
 <BY5PR02MB637195ECE0879F5F7CB72CE3BB120@BY5PR02MB6371.namprd02.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2c0ad54d-c8bd-bb2e-5dff-ce79cf0d45b9@redhat.com>
Date:   Fri, 21 Feb 2020 16:50:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BY5PR02MB637195ECE0879F5F7CB72CE3BB120@BY5PR02MB6371.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/21 =E4=B8=8B=E5=8D=884:33, Harpreet Singh Anand wrote:
> +       ret =3D device_register(&vdpasim->dev);
> +       if (ret)
> +               goto err_init;
> +
> +       vdpasim->vdpa =3D vdpa_alloc_device(dev, dev, &vdpasim_net_conf=
ig_ops);
> +       if (ret)
> +               goto err_vdpa;
>
> [HSA] Incorrect checking of the return value of vdpa_alloc_device.


Yes, fixed.

Thanks

