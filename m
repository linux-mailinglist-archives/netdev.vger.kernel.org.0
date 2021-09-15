Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025A740BFB9
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 08:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhIOGmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 02:42:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229484AbhIOGmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 02:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631688092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXoAex5h5K9hGtyrBd5LTSnixWgehD/sSo1nO1W/QHY=;
        b=f4uTmqmAGpY5qXSyNdXU0VoiPjrft3AfnA+CEUSg5U4oFrhctx9uOQ51CiMyf3ibmL6gtQ
        qSPBbobJicYi61/vh3mTmAoJiwb+Y0E7Qt7SsSvOm3wuXu5pvtxgrIxF1V71b8sYROzgGo
        oNRwV92qu5+bBzA0rTwft9UgjhcHHvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-9vKSrezqN2WGm3b7DLq0ag-1; Wed, 15 Sep 2021 02:41:30 -0400
X-MC-Unique: 9vKSrezqN2WGm3b7DLq0ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE416800FF4;
        Wed, 15 Sep 2021 06:41:29 +0000 (UTC)
Received: from localhost (unknown [10.40.193.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7036E1001281;
        Wed, 15 Sep 2021 06:41:28 +0000 (UTC)
Date:   Wed, 15 Sep 2021 08:40:22 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     <netdev@vger.kernel.org>, Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH net] i40e: fix endless loop under rtnl
Message-ID: <20210915084009.4260d7ae@redhat.com>
In-Reply-To: <b94eb5b1-04b7-a1ba-3040-a8f35d40f426@intel.com>
References: <4d94f7fbd9dd6476c5adc8967f3db84bc9204f47.1630319620.git.jbenc@redhat.com>
        <b94eb5b1-04b7-a1ba-3040-a8f35d40f426@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 16:37:55 -0700, Jesse Brandeburg wrote:
> The fix seems fine to me on initial review.
> you can add my
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Thanks!

> but...
> Missing Fixes: tag?

I should have added that, yes. I sent a v2 yesterday with the tag
included,

https://patchwork.kernel.org/project/netdevbpf/patch/452ff4ddfef7fc8f558a8c8eb7a8050688760e11.1631609537.git.jbenc@redhat.com/

Could you reply with your Reviewed-by to that one? Alternatively, I can
send a v3.

Thanks,

 Jiri

