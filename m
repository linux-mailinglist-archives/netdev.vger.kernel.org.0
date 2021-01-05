Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4262EB3BC
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbhAETxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729141AbhAETxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:53:13 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077E9C061798;
        Tue,  5 Jan 2021 11:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=SdUFP2ePSXIv2SoV8OnW8gve6qG5OxS1cjrVJPu/IfI=; b=xfjFEPFEEIFEgtlaRwdW+oHi+6
        fbu40M6Be8fH1P5hwmUDY0JA4bfFUgHYxgfPttA4fmdYd4K/mgfJj2SwmNqhMQLXPLwCHBUczDTOC
        bn0Zy67NSMqMl32GjmoTLxsBlCn2AoPNFfPC0FKWplSIVzPnsnaclWXOhHLDxYbs812FqAt1V0pYa
        GLfLsHQv1FlL+0UzyXYuidx6OtOmi7LS+nX8u18JcJW7xPL1vtH1wZH/2t1plIbPaFB6JMNJovV89
        dLd/i1ibW7yFwP/rZurXVz7WXTERVozwYh/j+CQwDA7QcY0B0U2C9gk0Qa4X/WbWwoMlO1mik1WXQ
        k7p0VHFA==;
Received: from [2601:1c0:6280:3f0::64ea]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kwsNY-00029G-JO; Tue, 05 Jan 2021 19:52:28 +0000
Subject: Re: [PATCH] net-next: docs: Fix typos in snmp_counter.rst
To:     Masanari Iida <standby24x7@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210105144029.219910-1-standby24x7@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c92a8ae4-10eb-1d8d-653f-daf42f8870d5@infradead.org>
Date:   Tue, 5 Jan 2021 11:52:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210105144029.219910-1-standby24x7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/21 6:40 AM, Masanari Iida wrote:
> This patch fixes some spelling typos in snmp_counter.rst
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  Documentation/networking/snmp_counter.rst | 28 +++++++++++------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

thanks.
-- 
~Randy
