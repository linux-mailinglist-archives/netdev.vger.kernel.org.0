Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DEC481FCB
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237545AbhL3TSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:18:25 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:52675 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237300AbhL3TSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:18:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1702A3200E31;
        Thu, 30 Dec 2021 14:18:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 30 Dec 2021 14:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dJvLYk
        x8jZmUJhQJWBujO+10mRq4CP24N1KjlDAmYuU=; b=lFoeUvPquTQdXjPqEX1K5P
        drmgr0BAUMdMtlDorM63wBFSVWHY8rTXwlIyR0XAV1I5zaAdgK6hultYrRCBrxuB
        dqaWdChI4h+eEFgiAKpvndXxuT9Q83WHXPEZcO7mIPov9SFoYK69DsjaUGnEgaDJ
        t38250Hl/hNrVOVIIsLe9TThChFuACMvpq62sx5f8pmov5Z4ro5HsIYlaa3gykG5
        ip8oRdAwYAUyL+ZaazPd/vB6NeUXYG9+WG2HkyHEyl+Wkbb05sguHeBEZCX57218
        yJ9tD9Bz1JIMgbK5rWJXiWPA3gCHgdqWObFtY5P8thp+7HyDpf+DEyLJZMkbJBIg
        ==
X-ME-Sender: <xms:_wXOYbRdOzqIc7xcex8zxgiZ1223-kZ_X1rhw1X0aKxKst4xCxgXUw>
    <xme:_wXOYcy5XONOygU4HoqBFleyH-ZSxYfvTyW7vT9x4fy6Ykmn2QnZvkz0UJd9HpWce
    GJyoeT5yqPof6w>
X-ME-Received: <xmr:_wXOYQ282ETJ3h4BtpECh4GjZstZsLNi8W0Mj70RkJaFNovRsPHZ_EPqR0-zoztHLtXuVnSz9Rtsiq2HRich5mo0tTTm3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddruddvfedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgeevfeejleffhfdtffeitefhjeeuteffffekjeeggfdtkeeikedtueevtdeg
    hfevnecuffhomhgrihhnpehivghtfhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_wXOYbArG_Bjv5Iq_bzTNy427DvjfpjGcXKUFY2IZepqLw1iYqhMQw>
    <xmx:_wXOYUh-VccR8J_l_f-3C6drZUFQdbVxFKImzwzZuYJcoi5O7sq7Yw>
    <xmx:_wXOYfoQIgrPov80nwvR-q4q3QabRfoD7HzQRCkXMoxJdRQWd8MtXQ>
    <xmx:_wXOYdvbuRYCvyoMq7gJOCu727d6o9H5kAQWv9orXth_VKawvpQgIg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Dec 2021 14:18:22 -0500 (EST)
Date:   Thu, 30 Dec 2021 21:18:19 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next v3] ipv6: ioam: Support for Queue depth data
 field
Message-ID: <Yc4F+w447cs1SBuD@shredder>
References: <20211230171004.16368-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230171004.16368-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 06:10:04PM +0100, Justin Iurman wrote:
> v3:
>  - Report 'backlog' (bytes) instead of 'qlen' (number of packets)
> 
> v2:
>  - Fix sparse warning (use rcu_dereference)
> 
> This patch adds support for the queue depth in IOAM trace data fields.
> 
> The draft [1] says the following:
> 
>    The "queue depth" field is a 4-octet unsigned integer field.  This
>    field indicates the current length of the egress interface queue of
>    the interface from where the packet is forwarded out.  The queue
>    depth is expressed as the current amount of memory buffers used by
>    the queue (a packet could consume one or more memory buffers,
>    depending on its size).
> 
> An existing function (i.e., qdisc_qstats_qlen_backlog) is used to
> retrieve the current queue length without reinventing the wheel.
> 
> Note: it was tested and qlen is increasing when an artificial delay is
> added on the egress with tc.
> 
>   [1] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.2.7
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
