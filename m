Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B2FE3E4B
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfJXVg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:36:56 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45083 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfJXVg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:36:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id y24so69033plr.12
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 14:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=sixVnj4yKDUJC5cBX1IyG/JA24r5ViFV6TeqsT0oMmA=;
        b=TvUvVuKRm4XGpO+Q8ynyBmdr3bejCqfltZ/piPvyYGFTnGvKvDp4/x4flCjG03GDc/
         eIrdI48/1FRPy4JrmWDR4qV1iWhFUadg/78XTUD7fk5K/zd/T4ni9UVFHwWH4zgRvKeL
         dI/c+TqNuQjQzoy9/fP+PVTGhIqVgIn3XtNG/nmMiJAeV99TZiOEGlUQB7eIqpAaWa2X
         NlUvf+ZGn/aM94ZtUH8m0gLYT3Jc4VNXWoELYtVn0Cq5YiSHSvAI51Rg2rL4nsLK1nSP
         wNPxEtqMR4aiITF29MgM9YWtaQxxiLkDxJGf02PxkNIJo6e51OC4ktSKo9o6NFCljvjw
         3yYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=sixVnj4yKDUJC5cBX1IyG/JA24r5ViFV6TeqsT0oMmA=;
        b=BqS+bAlT051M14kC3G1/IRgWG5idBjvLt0/ekrXNlAj92nNrI6eC72waMzZlgEo3BK
         S0QX1UVAytBgmXqtaf3CIRNXOoaZ3FTDJqeBrBoNVTF21D8UM+Re12EE+a39H6/E57Ls
         tTHqcoqNgcuTVofEb301W5sUUOqK/pW7gttLxHCTxvzNDmyEyyq+SG7ZNlHsTdaIWafT
         HnrYXeGT3vAH76FJNbz5itMT2aroQt2DniWGJLQdUuUAGUhBCCtJ2JPDqhe0TUgCAdWt
         FPSKt09UbsFUqub7z29jaiRFBbzBansluNZI5VWrN1enjZuImlIyWIqZomVUSJtsitK+
         0pQw==
X-Gm-Message-State: APjAAAV3VPPq44/dQrVTdx5Qqt/r7aAneGcxXForte+hWLoGvMsf/tFz
        Nyw15vJQ6UubjkFEI5Ewg2ZAgFtvDek=
X-Google-Smtp-Source: APXvYqz0cdV+gcpy7Q6+kA/c31tb+Q6POfspZkFVcQpdgmtr8YMDQ8RvTBbJ4sHp/Yj4DTr4TkZskQ==
X-Received: by 2002:a17:902:ab89:: with SMTP id f9mr18073475plr.295.1571953015530;
        Thu, 24 Oct 2019 14:36:55 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j4sm5952515pfh.187.2019.10.24.14.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 14:36:55 -0700 (PDT)
Date:   Thu, 24 Oct 2019 14:36:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 11/11] Documentation: TLS: Add missing counter description
Message-ID: <20191024143651.795705df@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191024193819.10389-12-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
        <20191024193819.10389-12-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 19:39:02 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> Add TLS TX counter description for the packets that skip the resync
> procedure and handled in the regular transmit flow, as they contain
> no data.
> 
> Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  Documentation/networking/tls-offload.rst | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
> index 0dd3f748239f..87db87099607 100644
> --- a/Documentation/networking/tls-offload.rst
> +++ b/Documentation/networking/tls-offload.rst
> @@ -436,6 +436,9 @@ by the driver:
>     encryption.
>   * ``tx_tls_ooo`` - number of TX packets which were part of a TLS stream
>     but did not arrive in the expected order.
> + * ``tx_tls_skip_no_sync_data`` - number of TX packets which were part of
> +   a TLS stream and arrived out-of-order, but skipped the HW offload routine
> +   and went to the regular transmit flow as they contained no data.

That doesn't sound right. It sounds like you're talking about pure Acks
and other segments with no data. For mlx5 those are skipped directly in
mlx5e_ktls_handle_tx_skb().

This counter is for segments which are retransmission of data queued to
the socket before kernel got the keys installed.

You explained it reasonably well in 46a3ea98074e ("net/mlx5e: kTLS,
Enhance TX resync flow"):

    However, in case the TLS SKB is a retransmission of the connection
    handshake, it initiates the resync flow (as the tcp seq check holds),
    while regular packet handle is expected.

Did this patch get stuck in the queue for so long you forgot what the
counter was? ;)

>   * ``tx_tls_drop_no_sync_data`` - number of TX packets which were part of
>     a TLS stream dropped, because they arrived out of order and associated
>     record could not be found.
