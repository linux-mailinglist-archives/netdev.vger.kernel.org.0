Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7407D142476
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgATHud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:50:33 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34141 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726417AbgATHuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:50:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579506631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U004lfJPbgC8DDvgY0vYrnnQi6voPmz5PbAj1bvuBr0=;
        b=WHFUwt/1xYWgox8NL8DpKdh7AARRj+DDNhEiPPIqz/4jgUQDy36BRzxOW6+RbOV1SHEqBH
        ZPj2D2JOg2BXlorJvMwrEIABnl9/kvFqyHDoeKqGKy6MyWzejYbwfJum75Ii0wSFyOFAo8
        jZReMH4sVGHYQPwCBzAR1gCbNoRpUz0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-8P1DRx1hN7GiWnnH17Bchg-1; Mon, 20 Jan 2020 02:50:28 -0500
X-MC-Unique: 8P1DRx1hN7GiWnnH17Bchg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCE4F10054E3;
        Mon, 20 Jan 2020 07:50:25 +0000 (UTC)
Received: from [10.72.12.173] (ovpn-12-173.pek2.redhat.com [10.72.12.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23C8E84DB4;
        Mon, 20 Jan 2020 07:50:02 +0000 (UTC)
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200116152209.GH20978@mellanox.com>
 <03cfbcc2-fef0-c9d8-0b08-798b2a293b8c@redhat.com>
 <20200117135435.GU20978@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ea4639ba-d991-c95c-8cb1-48588e5b42c0@redhat.com>
Date:   Mon, 20 Jan 2020 15:50:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200117135435.GU20978@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/1/17 =E4=B8=8B=E5=8D=889:54, Jason Gunthorpe wrote:
> On Fri, Jan 17, 2020 at 11:03:12AM +0800, Jason Wang wrote:
>> On 2020/1/16 =E4=B8=8B=E5=8D=8811:22, Jason Gunthorpe wrote:
>>> On Thu, Jan 16, 2020 at 08:42:29PM +0800, Jason Wang wrote:
>>>> vDPA device is a device that uses a datapath which complies with the
>>>> virtio specifications with vendor specific control path. vDPA device=
s
>>>> can be both physically located on the hardware or emulated by
>>>> software. vDPA hardware devices are usually implemented through PCIE
>>>> with the following types:
>>>>
>>>> - PF (Physical Function) - A single Physical Function
>>>> - VF (Virtual Function) - Device that supports single root I/O
>>>>     virtualization (SR-IOV). Its Virtual Function (VF) represents a
>>>>     virtualized instance of the device that can be assigned to diffe=
rent
>>>>     partitions
>>>> - VDEV (Virtual Device) - With technologies such as Intel Scalable
>>>>     IOV, a virtual device composed by host OS utilizing one or more
>>>>     ADIs.
>>>> - SF (Sub function) - Vendor specific interface to slice the Physica=
l
>>>>     Function to multiple sub functions that can be assigned to diffe=
rent
>>>>     partitions as virtual devices.
>>> I really hope we don't end up with two different ways to spell this
>>> same thing.
>> I think you meant ADI vs SF. It looks to me that ADI is limited to the=
 scope
>> of scalable IOV but SF not.
> I think if one looks carefully you'd find that SF and ADI are using
> very similar techiniques. For instance we'd also like to use the code
> reorg of the MSIX vector setup with SFs that Intel is calling IMS.
>
> Really SIOV is simply a bundle of pre-existing stuff under a tidy
> name, whatever code skeleton we come up with for SFs should be re-used
> for ADI.


Ok, but do you prefer to mention ADI only for the next version?


>
>>> Shouldn't there be a device/driver matching process of some kind?
>>
>> The question is what do we want do match here.
>>
>> 1) "virtio" vs "vhost", I implemented matching method for this in mdev
>> series, but it looks unnecessary for vDPA device driver to know about =
this.
>> Anyway we can use sysfs driver bind/unbind to switch drivers
>> 2) virtio device id and vendor id. I'm not sure we need this consider =
the
>> two drivers so far (virtio/vhost) are all bus drivers.
> As we seem to be contemplating some dynamic creation of vdpa devices I
> think upon creation time it should be specified what mode they should
> run it and then all driver binding and autoloading should happen
> automatically. Telling the user to bind/unbind is a very poor
> experience.
>
> Jason


Ok, I will add the type (virtio vs vhost) and driver matching method back=
.

Thanks

