Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF1628ED00
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 08:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgJOGQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 02:16:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725208AbgJOGPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 02:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602742547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7fm8AP60agWOcduC0GJGvPeW6g0rnJZZasC9gE26Q2w=;
        b=EWylWwTA+Tq0o7byi2drwAGiXqGDirm+hvm6sIYs2nufUhAiHJTqdEAshiP6iLEOC53xqG
        usVSkyeWjpyJiaY4mlTDeNfcQCLkPmwFZT8UzGki3nYr/1v7x0yEJ97Dnxe3RJ3XFEfYut
        1GAD609uEiTCzYn5Nu3rWUQ3mL0DwYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-sG7un7QEOgKOQMoETVk6Hg-1; Thu, 15 Oct 2020 02:15:42 -0400
X-MC-Unique: sG7un7QEOgKOQMoETVk6Hg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E816803640;
        Thu, 15 Oct 2020 06:15:41 +0000 (UTC)
Received: from [10.72.13.96] (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18919610F3;
        Thu, 15 Oct 2020 06:15:33 +0000 (UTC)
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error path
To:     si-wei liu <si-wei.liu@oracle.com>, mst@redhat.com,
        lingshan.zhu@intel.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com>
 <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com>
 <5F863B83.6030204@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <835e79de-52d9-1d07-71dd-d9bee6b9f62e@redhat.com>
Date:   Thu, 15 Oct 2020 14:15:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5F863B83.6030204@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/14 上午7:42, si-wei liu wrote:
>>
>>
>> So what I suggest is to fix the pinning leakage first and do the 
>> possible optimization on top (which is still questionable to me).
> OK. Unfortunately, this was picked and got merged in upstream. So I 
> will post a follow up patch set to 1) revert the commit to the 
> original __get_free_page() implementation, and 2) fix the accounting 
> and leakage on top. Will it be fine?


Fine.

Thanks

