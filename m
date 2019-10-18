Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E6CDD579
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfJRXcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:32:13 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42477 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387700AbfJRXcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:32:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id f14so4151666pgi.9
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=H/TQjNeNKxKr1wMUHNfad1MrCG9TgOKr/P3RNrPzY2M=;
        b=in7df1+CnzZOQfNJwxWO0fosUZecRxsNJEvmAfl4SG3MZu3QiGpG2AzeQ5qntBnA4p
         MkKVtATlsHR98w5e0uEGaqTxy8TFSkhNC3xrmTTXxWGCx8/SMSPauaB/G4Efdvn3A31X
         3Imx5SXLJYLMIucfiqb1NMF5nvPB23qdeX+58lTNmCpjgg4Xq0rjamse9XlKQQInrhZe
         Vqu21B5LtXoHqfdvCoIKUr+vgpiVJqIecq5McD/YSabkrsOICZ98hQSlYpY0gSIyDLJx
         nvZQ3/vjV2ZNzbapRigfHNpOvarnfTuBDstJJd//wAUKZOkAq6vP2cjY7Kl6sjDyHG+T
         irWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=H/TQjNeNKxKr1wMUHNfad1MrCG9TgOKr/P3RNrPzY2M=;
        b=FZzqaeRMwpSgSbfNx2kXPxeCMbhrS7/OPl5Ax0mZEj414yC/e0YyE4p/dj1YLoUuNA
         mgwXiBGIVhX766ww2zeKjyqxjAt4A/gRjbSnj3PgB3IfQcwtx2ejxgY77widud8NboEt
         E7GRsx3eDfNJ7Ei0UKlmFS59n+9osfU/dHSNTJLVn9brGtDOpuVTIyaphKOOEUuhc1ws
         /ffLKwS1hiyCzedjV3mWsmN1oNPEVPz660YJSxijn56iHgUG+cL8s7UxoDNiI9Oq7kge
         E5LIzHIIGWGyVpv6+jXHNaDz8WRLPlBSTaLEXb5zMEvhNs5BIGqIytLY/6FKYqoMrtwK
         bP9g==
X-Gm-Message-State: APjAAAX/tkna2rN/fxgaAgbFbNQUBrm6z/TNPrDafL4uXz8wx2OhhQS2
        3S5BBbp3gN7+SBGmEO/u6ag=
X-Google-Smtp-Source: APXvYqxFfUxBYW4wfOk2g6J+8ggoe00A8jSJh0ZLO4GocVexTX6lPoWoAIYEqXRDNQOX4YkCR2gh4g==
X-Received: by 2002:a63:1945:: with SMTP id 5mr12495184pgz.157.1571441532459;
        Fri, 18 Oct 2019 16:32:12 -0700 (PDT)
Received: from [172.20.162.151] ([2620:10d:c090:180::d0dd])
        by smtp.gmail.com with ESMTPSA id u11sm9714144pgo.65.2019.10.18.16.32.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 16:32:11 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     ilias.apalodimas@linaro.org, "Tariq Toukan" <tariqt@mellanox.com>,
        brouer@redhat.com, kernel-team@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH 00/10 net-next] page_pool cleanups
Date:   Fri, 18 Oct 2019 16:32:07 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <A6D1D7E1-56F4-4474-A7E7-68627AEE528D@gmail.com>
In-Reply-To: <1df61f9dedf2e26bbc94298cc2605002a4700ce6.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <1df61f9dedf2e26bbc94298cc2605002a4700ce6.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18 Oct 2019, at 13:50, Saeed Mahameed wrote:

> On Wed, 2019-10-16 at 15:50 -0700, Jonathan Lemon wrote:
>> This patch combines work from various people:
>> - part of Tariq's work to move the DMA mapping from
>>   the mlx5 driver into the page pool.  This does not
>>   include later patches which remove the dma address
>>   from the driver, as this conflicts with AF_XDP.
>>
>> - Saeed's changes to check the numa node before
>>   including the page in the pool, and flushing the
>>   pool on a node change.
>>
>
> Hi Jonathan, thanks for submitting this,
> the patches you have are not up to date, i have new ones with tracing
> support and some fixes from offlist review iterations, plus performance
> numbers and a  cover letter.
>
> I will send it to you and you can post it as v2 ?

Sure, I have some other cleanups to do and have a concern about
the cache effectiveness for some workloads.
-- 
Jonathan


>
>
>> - Statistics and cleanup for page pool.
>>
>> Jonathan Lemon (5):
>>   page_pool: Add page_pool_keep_page
>>   page_pool: allow configurable linear cache size
>>   page_pool: Add statistics
>>   net/mlx5: Add page_pool stats to the Mellanox driver
>>   page_pool: Cleanup and rename page_pool functions.
>>
>> Saeed Mahameed (2):
>>   page_pool: Add API to update numa node and flush page caches
>>   net/mlx5e: Rx, Update page pool numa node when changed
>>
>> Tariq Toukan (3):
>>   net/mlx5e: RX, Remove RX page-cache
>>   net/mlx5e: RX, Manage RX pages only via page pool API
>>   net/mlx5e: RX, Internal DMA mapping in page_pool
>>
>>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  18 +-
>>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  12 +-
>>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  19 +-
>>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 128 ++--------
>>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  39 ++--
>>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  19 +-
>>  include/net/page_pool.h                       | 216 +++++++++-------
>> -
>>  net/core/page_pool.c                          | 221 +++++++++++-----
>> --
>>  8 files changed, 319 insertions(+), 353 deletions(-)
>>
