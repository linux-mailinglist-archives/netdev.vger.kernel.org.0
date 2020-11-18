Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A892B85B1
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgKRUgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgKRUgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:36:18 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87580C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=hd3CjQieU/QNIsveqllFDBhFyucJHOi2e5hWzqr9ObE=; b=l8cCAtp7g1mJq2msRcW57W3R1M
        QzSpJgh1cm5FNk6PdpDLr6BBigODy8DWre8wQZCBlCOWPkoNmcMfY6NiTIwPTi5PS4Y5aMoQYcQl5
        8SqI39sfgEq+MPc6qFx+aSA9GjsgEyvXB/6cfTYdmvy+dg5jUNXucd3Ah1ZX9p17ZlBSbrJz88So0
        MUpONDT82dIgQyj1HJWGaLyPIKiCA6XDIQMPjVe66a5SViwzKMuVcFXzsVBlNKW0g2g2afrA7/n/t
        eMm8n3oXNc8X6FylLsmZk3TWINZJtrZ9jKWnV1+cJOPoXjYkCyr37pNa6bU6OfZF9A6OS8RdEZi6G
        Tp2ZgPLg==;
Received: from [2601:1c0:6280:3f0::bcc4]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kfUBT-00063a-KE; Wed, 18 Nov 2020 20:36:07 +0000
Subject: Re: [PATCH net-next v3 2/5] net: add sysfs attribute to control napi
 threaded mode
To:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>
References: <20201118191009.3406652-1-weiwan@google.com>
 <20201118191009.3406652-3-weiwan@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8578cfd8-dcaf-5a86-7803-922ee27d9e90@infradead.org>
Date:   Wed, 18 Nov 2020 12:36:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201118191009.3406652-3-weiwan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 11:10 AM, Wei Wang wrote:
> From: Paolo Abeni <pabeni@redhat.com> 
> 
> this patch adds a new sysfs attribute to the network
> device class. Said attribute is a bitmask that allows controlling
> the threaded mode for all the napi instances of the given
> network device.
> 
> The threaded mode can be switched only if related network device
> is down.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Hi,

Could someone describe the bitmask (is it a bit per instance of the
network device?).
And how to use the sysfs interface, please?

> ---
>  net/core/net-sysfs.c | 103 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 103 insertions(+)
> 
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 94fff0700bdd..df8dd25e5e4b 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c


thanks.
-- 
~Randy

