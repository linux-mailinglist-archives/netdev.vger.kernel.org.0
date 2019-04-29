Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA161E7D8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfD2QdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:33:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45658 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728658AbfD2QdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:33:07 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id B68071C00FC;
        Mon, 29 Apr 2019 16:33:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 09:33:01 -0700
Subject: Re: [PATCH net-next] sfc: mcdi_port: Mark expected switch
 fall-through
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Solarflare linux maintainers" <linux-net-drivers@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
References: <20190429153755.GA10596@embeddedor>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <868472ed-29e9-9e9c-fbba-e10b9a9cda10@solarflare.com>
Date:   Mon, 29 Apr 2019 17:33:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429153755.GA10596@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-6.551600-4.000000-10
X-TMASE-MatchedRID: +c13yJDs9029RoRMIcfOgH/vIGFxULe8jLOy13Cgb4+qvcIF1TcLYCqz
        9bm0+YwHXiSIvUL/7sfc+0V24WCpMVr6zeO3/gBbULGoTjCGdeUNwryf5xHtclc/CedjlcvkfMr
        dD3NIUvvaFM5TPGLdCIAGGZdCG6IYv1l2Uvx6idpWdFebWIc3VsRB0bsfrpPI0PU0TdJoUtfgHh
        Ytb7lu11txDPP/0YTMxa4J+jHZ5EVVJ1rq+IcxDSe2DxJHD59fxGSSRjLzG8m9o4SAHpQc8790q
        q3qAMrd/VEPcph09jWFcgJc+QNMwu8bJovJYm8FYupx0XjSQPLDOFVmKqGJ4bPn3tFon6UK
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.551600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556555586-ZkJinuE-NKWe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2019 16:37, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch
> cases where we are expecting to fall through.
>
> This patch fixes the following warning:
>
> drivers/net/ethernet/sfc/mcdi_port.c: In function ‘efx_mcdi_phy_decode_link’:
> ./include/linux/compiler.h:77:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
>  # define unlikely(x) __builtin_expect(!!(x), 0)
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/asm-generic/bug.h:125:2: note: in expansion of macro ‘unlikely’
>   unlikely(__ret_warn_on);     \
>   ^~~~~~~~
> drivers/net/ethernet/sfc/mcdi_port.c:344:3: note: in expansion of macro ‘WARN_ON’
>    WARN_ON(1);
>    ^~~~~~~
> drivers/net/ethernet/sfc/mcdi_port.c:345:2: note: here
>   case MC_CMD_FCNTL_OFF:
>   ^~~~
>
> Warning level 3 was used: -Wimplicit-fallthrough=3
>
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Edward Cree <ecree@solarflare.com>
