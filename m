Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30DA3D2D0F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 22:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhGVTT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 15:19:26 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:9442 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhGVTTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 15:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626983820;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=eRPThyCrbba7IjwgrNeznQfmf1Pi4vCOk29rXJTBOf8=;
    b=JFHQTgEI7rVQlxVpubFKt1x7KUCigoY198YKH0OdLCIHdZBQ+bWgm+zOzORf94nDTE
    W8NUbd3RDmwCJB8rA/8RD2hWXGe8LkGOqij52cipmOnPUdm9VQRhFcF4KapOOS7bQ9dA
    21jEX40XS3RGjfIdvQV0Yu/NVQSjve3HAjVotLgGMTBlxjcoWlotcirLzgov6DHZOtcI
    OvxSDqlFIScjJ9tEeere7S5kAwvUWA6+YTZcbUyUQ78HvXO9tFkJ+7QTNutlr8Op2Vu+
    lbpt4g5m67hU6LmPUVnG614cUSV9sDVecj/4vko68sqrYSK81Zrm4sYDBqTDKhRp0MkE
    SAJQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3htNmYasgbo6AhaFdcg=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a00:6020:1cee:8300::b82]
    by smtp.strato.de (RZmta 47.28.1 AUTH)
    with ESMTPSA id Z03199x6MJuxLhO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 22 Jul 2021 21:56:59 +0200 (CEST)
Subject: Re: [PATCH net v2] can: raw: fix raw_rcv panic for sock UAF
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210722070819.1048263-1-william.xuanziyang@huawei.com>
 <d684ef4d-d6c1-56b0-dc9e-b330fb92ba87@hartkopp.net>
 <dfb8e04b-257d-6de5-280b-e0326b4d0dbe@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <3e50531f-76bb-e689-c403-1c8184656912@hartkopp.net>
Date:   Thu, 22 Jul 2021 21:56:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <dfb8e04b-257d-6de5-280b-e0326b4d0dbe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.07.21 14:53, Ziyang Xuan (William) wrote:

> 
> So I think my modification is right. Thank you.
> 

Yes, you were!

Sorry for the noise.

I Acked the original V2 patch for further processing.

Thanks William!

Best regards,
Oliver
