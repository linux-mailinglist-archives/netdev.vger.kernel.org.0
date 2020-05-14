Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942661D2DFD
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgENLQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:16:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29415 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726010AbgENLQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589454960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y8RbUxHYnrrR8+JblLME7HF9A4PH2pMKn/uDVIUW1T4=;
        b=QsuGcfZ7VKSaplEay58odTvNrNZ59RQtBZAPKh9v0DaEzE8pzXkwGXn9NXN6hTabg1xqcD
        CjUs13u2yX3k+C8xZ8dazY0YNQNMZGaxyH3+hnfxBp2bqiKNJaVNoohYp59Mg1v4RHKF3h
        0fk5vTNfIDwtUUJJ2vAD+PQ+QGgH4/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-h-yimdJeMiexqtghCnu3GA-1; Thu, 14 May 2020 07:15:58 -0400
X-MC-Unique: h-yimdJeMiexqtghCnu3GA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F11E21005512;
        Thu, 14 May 2020 11:15:56 +0000 (UTC)
Received: from [10.72.12.111] (ovpn-12-111.pek2.redhat.com [10.72.12.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 692D810013D9;
        Thu, 14 May 2020 11:15:54 +0000 (UTC)
Subject: Re: netfilter: does the API break or something else ?
To:     Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>
References: <cf0d02b2-b1db-7ef6-41b8-7c345b7d53d5@redhat.com>
 <20200514105422.GO17795@orbyte.nwl.cc>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <13fdc06c-42b2-7239-7c40-dc4814c5e5c4@redhat.com>
Date:   Thu, 14 May 2020 19:15:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200514105422.GO17795@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/5/14 18:54, Phil Sutter wrote:
> Hi,
>
> On Wed, May 13, 2020 at 11:20:35PM +0800, Xiubo Li wrote:
>> Recently I hit one netfilter issue, it seems the API breaks or something
>> else.
> Just for the record, this was caused by a misconfigured kernel.

Yeah, thanks Phil for your help.

BRs

Xiubo


> Cheers, Phil
>

