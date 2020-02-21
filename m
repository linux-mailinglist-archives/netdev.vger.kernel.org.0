Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1EA1682D0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 17:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgBUQIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 11:08:44 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34962 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgBUQIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 11:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=KTT0E0eHtK9iaFEgp/GyKN6Cahb/bDzU9NGIlliNXuE=; b=O+J0/hANyZSaZZDyMAD54epWYk
        URQJFqncg6SEeuzg34vszaSSwvwqXVuGN/L0Ln/t4gY/r2nU/6utGYHLJUne5hMaKlrAbf6dBCbWu
        lIuFRE6VYrDUpH4VD7JaFsDC15cLs2Ic8cXRjL/uhFC/0v6bEuKynY3nvxzYmWsUlifiMUg/bemVQ
        VS+t++mo59KXSeomXx8clJAgpNFW6Sr3bKf/r6Cs4U3ckZL0HcUH3MfQkg0o3qoqs0xihUCVSniTQ
        TrQmAuZy/Ne8admcJ4bHyKVUyWAfw8kz3IQR8Qp/P4/LP3A51nVwHDusT79qVtl2oiYJMICPqaymu
        0b841j9w==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5Ar4-0003VY-PW; Fri, 21 Feb 2020 16:08:42 +0000
Subject: Re: [PATCH net-next v3] net: page_pool: Add documentation on
 page_pool API
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>, brouer@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     lorenzo@kernel.org, toke@redhat.com
References: <20200221091519.916438-1-ilias.apalodimas@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a073ec17-8301-9b72-4828-827a459456b6@infradead.org>
Date:   Fri, 21 Feb 2020 08:08:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221091519.916438-1-ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/20 1:15 AM, Ilias Apalodimas wrote:
> Add documentation explaining the basic functionality and design
> principles of the API
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> Changes since:
> v1:
> - Rephrase sentences that didn't make sense (Randy)
> - Removed trailing whitespaces (Randy)
> v2:
> - Changed order^n pages description to 2^order which is the correct description
>  for the lage allocator (Randy)
> 
>  Documentation/networking/page_pool.rst | 159 +++++++++++++++++++++++++
>  1 file changed, 159 insertions(+)
>  create mode 100644 Documentation/networking/page_pool.rst


-- 
~Randy
