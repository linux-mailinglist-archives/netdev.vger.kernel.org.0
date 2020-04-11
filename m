Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF01A536D
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 20:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgDKSl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 14:41:57 -0400
Received: from forward103p.mail.yandex.net ([77.88.28.106]:54879 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgDKSl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 14:41:57 -0400
Received: from mxback17o.mail.yandex.net (mxback17o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::68])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id A66A818C0D18;
        Sat, 11 Apr 2020 21:41:54 +0300 (MSK)
Received: from iva4-bca95d3b11b1.qloud-c.yandex.net (iva4-bca95d3b11b1.qloud-c.yandex.net [2a02:6b8:c0c:4e8e:0:640:bca9:5d3b])
        by mxback17o.mail.yandex.net (mxback/Yandex) with ESMTP id fHBCnzA5Eh-fslWbXSX;
        Sat, 11 Apr 2020 21:41:54 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586630514;
        bh=jYd3s4YqKV9Bk1IZymSZ/UKvRBqonGqjzdtesMGkVug=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=op3iQKchJviCM1upfEQhPQoc1YyefrBhZrxxOfRTr81Bb1n0sotz+Ii5QAOZYBpOn
         tzIL3ltz5/EAtzvAoC+l1oCD85zTb0y6FiP/Lllal88elXlQfMT6lpShj2K1P6qfJI
         fDxxPLCN+kFzUPjUOC87bjD3F5D7s8o4v23d1of8=
Authentication-Results: mxback17o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva4-bca95d3b11b1.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id TrVax7K8o8-frWKduIK;
        Sat, 11 Apr 2020 21:41:53 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH] scsi: cxgb3i: move docs to functions documented
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20200410170732.411665-1-Hi-Angel@yandex.ru>
 <20200410184216.0a64b1c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Konstantin Kharlamov <hi-angel@yandex.ru>
Message-ID: <72154193-c0a1-919f-8b42-a9656360737f@yandex.ru>
Date:   Sat, 11 Apr 2020 21:41:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200410184216.0a64b1c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB-large
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, good point! On my way.

On 11.04.2020 04:42, Jakub Kicinski wrote:
> On Fri, 10 Apr 2020 20:07:32 +0300 Konstantin Kharlamov wrote:
>> Move documentation for push_tx_frames near the push_tx_frames function,
>> and likewise for release_offload_resources.
>>
>> Signed-off-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>
> 
> While at this could you also update the name of the parameter?
> s/c3cn/csk/.
> 
>> +/**
>> + * release_offload_resources - release offload resource
>> + * @c3cn: the offloaded iscsi tcp connection.
>> + * Release resources held by an offload connection (TID, L2T entry, etc.)
>> + */
>>   static void release_offload_resources(struct cxgbi_sock *csk)
