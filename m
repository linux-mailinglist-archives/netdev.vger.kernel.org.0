Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DA52293B6
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgGVIiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:38:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43236 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbgGVIiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595407084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5Ur/JiuSfAvGpyf44Ed7p+M7oqZ4YkeXEa6MXSiWu6M=;
        b=dyWq0AFxwCNIO51ulaaRoHOhx5px2UsmvJ9eEFOmUREg/s1JZVTAKR8H42fZxTk/3D/EZU
        /AjILTqXER8jo0qCH8nbwC5/GwsMIiYLIclOYJAXJs6gMklxipRe9vIjaxqucoTJ90u04B
        KK66wrodcAbnJM58MSedwNEIca13Uj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-WUjcPjvFMomcV3r28n_nGQ-1; Wed, 22 Jul 2020 04:38:00 -0400
X-MC-Unique: WUjcPjvFMomcV3r28n_nGQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81E481005510;
        Wed, 22 Jul 2020 08:37:59 +0000 (UTC)
Received: from [10.36.112.226] (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D20F72696;
        Wed, 22 Jul 2020 08:37:58 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next 0/2] net: openvswitch: masks cache enhancements
Date:   Wed, 22 Jul 2020 10:37:56 +0200
Message-ID: <4051B3C1-93EA-41DD-8D22-7260DD604D7D@redhat.com>
In-Reply-To: <159540642765.619787.5484526399990292188.stgit@ebuild>
References: <159540642765.619787.5484526399990292188.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Jul 2020, at 10:27, Eelco Chaudron wrote:

> This patchset adds two enhancements to the Open vSwitch masks cache.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
> Eelco Chaudron (2):
>       net: openvswitch: add masks cache hit counter
>       net: openvswitch: make masks cache size configurable
>
>
>  include/uapi/linux/openvswitch.h |    3 +
>  net/openvswitch/datapath.c       |   16 +++++-
>  net/openvswitch/datapath.h       |    3 +
>  net/openvswitch/flow_table.c     |  105 
> +++++++++++++++++++++++++++++++++-----
>  net/openvswitch/flow_table.h     |   13 ++++-
>  5 files changed, 122 insertions(+), 18 deletions(-)

FYI the userspace patch can be found here:

https://mail.openvswitch.org/pipermail/ovs-dev/2020-July/373159.html

