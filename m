Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D2319D04E
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 08:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388520AbgDCGih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 02:38:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36819 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387655AbgDCGih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 02:38:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585895916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FoY5mkBeMkeyo7y0OE/A/cmKtuN2NtQ3ZqEZt21GFCU=;
        b=JfSrU9/hAaBZofUCjhNvHfrxGQVt0BwDeS5mRYL/gJz3nRgRskoQD53WWCSmfLLch34cDH
        miLrxSQe+4CucaKIjwO15P1sVnLugU72DYOoPXy6dm79fFSu8IvH8oece/01MpU7QGlF7D
        cBmCelYprpwcPmPTlo9z4mV3U79KKzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-pOpQyYxoPhyAEITttS26fg-1; Fri, 03 Apr 2020 02:38:34 -0400
X-MC-Unique: pOpQyYxoPhyAEITttS26fg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A9298017CE;
        Fri,  3 Apr 2020 06:38:33 +0000 (UTC)
Received: from [10.72.13.110] (ovpn-13-110.pek2.redhat.com [10.72.13.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A2B094960;
        Fri,  3 Apr 2020 06:38:29 +0000 (UTC)
Subject: Re: [PATCH v2] vhost: drop vring dependency on iotlb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200402144519.34194-1-mst@redhat.com>
 <44f9b9d3-3da2-fafe-aa45-edd574dc6484@redhat.com>
 <20200402122544-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f811f02e-5681-33c0-f970-f60c62ff0041@redhat.com>
Date:   Fri, 3 Apr 2020 14:38:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200402122544-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/3 =E4=B8=8A=E5=8D=8812:27, Michael S. Tsirkin wrote:
> On Thu, Apr 02, 2020 at 11:01:13PM +0800, Jason Wang wrote:
>> On 2020/4/2 =E4=B8=8B=E5=8D=8810:46, Michael S. Tsirkin wrote:
>>> vringh can now be built without IOTLB.
>>> Select IOTLB directly where it's used.
>>>
>>> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
>>> ---
>>>
>>> Applies on top of my vhost tree.
>>> Changes from v1:
>>> 	VDPA_SIM needs VHOST_IOTLB
>> It looks to me the patch is identical to v1.
>>
>> Thanks
> you are right. I squashed the description into
>      virtio/test: fix up after IOTLB changes
> take a look at it in the vhost tree.


Looks fine.

Thanks


>

