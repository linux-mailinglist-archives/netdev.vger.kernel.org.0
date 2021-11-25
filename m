Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5200A45D30A
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhKYCRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:17:40 -0500
Received: from mga06.intel.com ([134.134.136.31]:2212 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238078AbhKYCPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:15:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="296229680"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="296229680"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 18:12:30 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510105330"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.31.197]) ([10.255.31.197])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 18:12:27 -0800
Message-ID: <0f4608f0-16e1-c458-3a9b-dcfc0a9d4df8@intel.com>
Date:   Thu, 25 Nov 2021 10:12:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [PATCH V4 0/3] vDPA/ifcvf: enables Intel C5000X-PL virtio-blk
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Cindy Lu <lulu@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20210419063326.3748-1-lingshan.zhu@intel.com>
 <CAGxU2F622pzZkh8WC7J+jGYu-_ozSDx1Tvvvtw-z52xwC3S38A@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CAGxU2F622pzZkh8WC7J+jGYu-_ozSDx1Tvvvtw-z52xwC3S38A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stefano,

Thanks for your review and advices, I will fix them

Thanks,
Zhu Lingshan

On 11/24/2021 11:39 PM, Stefano Garzarella wrote:
> Hi Zhu,
>
> On Mon, Apr 19, 2021 at 8:39 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> This series enabled Intel FGPA SmartNIC C5000X-PL virtio-blk for vDPA.
> Looking at the IFCVF upstream vDPA driver (with this series applied), it
> seems that there is still some cleaning to be done to support virtio-blk
> devices:
>
> - ifcvf_vdpa_get_config() and ifcvf_vdpa_set_config() use
>    `sizeof(struct virtio_net_config)` to check the inputs.
>    This seems wrong for a virtio-blk device. Maybe we can set the config
>    size for each device in ifcvf_vdpa_dev_add() and use that field to
>    check the inputs. We can reuse the same field also in
>    ifcvf_vdpa_get_config_size().
>
> - Just for make the code more readable we should rename `net_cfg` field
>    to `device_cfg`in `struct ifcvf_hw`.
>
> What do you think?
>
> Thanks,
> Stefano
>

