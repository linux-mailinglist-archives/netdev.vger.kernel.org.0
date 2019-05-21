Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1F25282
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbfEUOqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 10:46:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:50358 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbfEUOqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 10:46:54 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT62V-0001cR-QY; Tue, 21 May 2019 16:46:51 +0200
Received: from [178.197.249.20] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hT62V-0000Qo-Jz; Tue, 21 May 2019 16:46:51 +0200
Subject: Re: [PATCH] Documentation/networking: fix af_xdp.rst Sphinx warnings
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>
References: <ba3ef670-a8ff-abfd-5e86-9b14af626112@infradead.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <146acb09-0f2d-2521-eb3a-9b600a651815@iogearbox.net>
Date:   Tue, 21 May 2019 16:46:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <ba3ef670-a8ff-abfd-5e86-9b14af626112@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/20/2019 11:22 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix Sphinx warnings in Documentation/networking/af_xdp.rst by
> adding indentation:
> 
> Documentation/networking/af_xdp.rst:319: WARNING: Literal block expected; none found.
> Documentation/networking/af_xdp.rst:326: WARNING: Literal block expected; none found.
> 
> Fixes: 0f4a9b7d4ecb ("xsk: add FAQ to facilitate for first time users")
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>

Applied, thanks!
