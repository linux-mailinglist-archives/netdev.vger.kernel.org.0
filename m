Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6053C5E11
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 16:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhGLOQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 10:16:05 -0400
Received: from novek.ru ([213.148.174.62]:54406 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234808AbhGLOQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 10:16:02 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 95B6A50048B;
        Mon, 12 Jul 2021 17:10:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 95B6A50048B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626099057; bh=i/ibc4LSbFCRZAcj/R+yYlmYHQm1otuGCBCdSQrqk+4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gS+nmg8LZzi0cnqmVJ6LpCXuRtKl9e1ECZckVkxoMa9zb529u4vcg/48OYoOGApgt
         S8eSnI0RoUI8Xcz7Z+FWO09OS3Mna5Kz87ZTKaYfWL6nuHqlFwI2j1VIrkA072vSKY
         b0/w9QjnM599FPQ+F54TjdaGNbvEtKUcHeiqY49I=
Subject: Re: [PATCH net 1/3] udp: check for encap using encap_enable
To:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210712005554.26948-1-vfedorenko@novek.ru>
 <20210712005554.26948-2-vfedorenko@novek.ru>
 <b076d20cb378302543db6d15310a4059ded08ecf.camel@redhat.com>
 <6fbf2c3d-d42a-ecae-7fff-9efd0b58280a@novek.ru>
 <970fa58decaef6c86db206c00d6c7ab6582b45d3.camel@redhat.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <7da0e1e0-7814-4179-ba04-d578b380fd8a@novek.ru>
Date:   Mon, 12 Jul 2021 15:13:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <970fa58decaef6c86db206c00d6c7ab6582b45d3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.07.2021 15:05, Paolo Abeni wrote:
> On Mon, 2021-07-12 at 13:32 +0100, Vadim Fedorenko wrote:
>> On 12.07.2021 09:37, Paolo Abeni wrote:
>>>> Fixes: 60fb9567bf30 ("udp: implement complete book-keeping for encap_needed")
>>>
>>> IMHO this not fix. Which bug are you observing that is addressed here?
>>>
>> I thought that introduction of encap_enabled should go further to switch the
>> code to check this particular flag and leave encap_type as a description of
>> specific type (or subtype) of used encapsulation.
> 
> Than to me it looks more like a refactor than a fix. Is this strictly
> needed by the following patch? if not, I suggest to consider net-next
> as a target for this patch, or even better, drop it altogether.
> 
Looks like it isn't strictly needed for the following patch. Do you think that
such refactor would lead to more harm than benefits provided by clearness of
usage of encap_enable and encap_type fields? I mean why do you think that it's
better to drop it?
Thanks!
