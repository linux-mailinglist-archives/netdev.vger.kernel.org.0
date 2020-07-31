Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC56233D90
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 05:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbgGaDLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 23:11:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21653 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730820AbgGaDLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 23:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596165101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yBkzE1GY4sKZofWxL1HoI+rHXtmD6ULkP6+Di1oBJyg=;
        b=DnRxJiV1UdIdhqpn7hjBcjLiK66sBmmPYfRahrmzSqAJM9uS8wG30giC3CD6PZaBHw0IiG
        Jdmw+kAwh5p+XWSiXEuwgTRKDK+IIAOXg2a57AOPMzsCDOkqntarTwjPKhbdpFEjvghUs0
        Lp6cdqScJeJ0G+wRTAoF5wLrcsTVnYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-t8GgYqvBMOqL9Lemag7LTw-1; Thu, 30 Jul 2020 23:11:39 -0400
X-MC-Unique: t8GgYqvBMOqL9Lemag7LTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 636FFE918;
        Fri, 31 Jul 2020 03:11:37 +0000 (UTC)
Received: from [10.72.13.197] (ovpn-13-197.pek2.redhat.com [10.72.13.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C19471929;
        Fri, 31 Jul 2020 03:11:26 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Eli Cohen <eli@mellanox.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, shahafs@mellanox.com, parav@mellanox.com
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
 <20200728090438.GA21875@nps-server-21.mtl.labs.mlnx>
 <c87d4a5a-3106-caf2-2bc1-764677218967@redhat.com>
 <20200729095503.GD35280@mtl-vdi-166.wap.labs.mlnx>
 <45b7e8aa-47a9-06f6-6b72-762d504adb00@redhat.com>
 <20200729141554.GA47212@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bef51630-f81e-2b59-6bb8-23c89f530410@redhat.com>
Date:   Fri, 31 Jul 2020 11:11:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729141554.GA47212@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/29 下午10:15, Eli Cohen wrote:
> OK, we have a mode of operation that does not require driver
> intervention to manipulate the event queues so I think we're ok with
> this design.


Good to know this.

Thanks


