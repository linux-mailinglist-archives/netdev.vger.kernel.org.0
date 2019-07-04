Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9CA5FDB2
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGDUMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:12:42 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:34374 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfGDUMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:12:42 -0400
Received: by mail-pg1-f179.google.com with SMTP id p10so3299926pgn.1
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=plx6kx2mQbXqrWYytsJSBVQtVpKcK3KMpXPKAs1zP08=;
        b=FsiOhai5lg+1msWCmp6oinYuLACIRH5F/ZayO46ZNWsNhqKT22qYCaYX3M60G93g/u
         bKDa1stJMAKpnfoFWmSkZR9gKYheqfAFP6EdqSqkT6P0KcLOE9m3L3AcYg5Y5igLCMNS
         0E2BZgkif9bvZaW6jUqDFdv/CwPbDmz4zzhmAAROOy6jQwcb59oz3H6n1KNriCm+DA9+
         Ryjk+6IIs0cSMB4s1i896QCe1qZVPqkgepZScnGO6ldveyUR6wdFnPjER5trDC6+G/ov
         wcNEzudXoSlz7h9tfSek3aiWVD7i5y1HKBfpmsX1jHxfuIaXSm6+cDf3KI7fOnEfM67K
         tq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=plx6kx2mQbXqrWYytsJSBVQtVpKcK3KMpXPKAs1zP08=;
        b=lHSZPt14m9wKnO75UJM7yJu6ZaxyaPPaoP5ku9smYWsjCYIYRcjRbMZv5sT+LJNuwE
         8y9R3BgO7WnuYsJo7JtX/lbpxRUWD9v3ptCi79MBQAdl2IX+KDp8k7ssLwUXjRSCBnip
         eoJ/lZC+VEazPk6UAQo4QEod4hOI/UKylQSW5jmEaydWdK5rJICM2AZd/mz1G3vzq02f
         q4GKHt2G95yoSRaQAWJp+5foQoKmRyDUO8y4zUIwwSrSyTW+IlFyOqY933Csw/vK1+Mn
         PjnAQ+PJs1p6ufb577kcFSbAFnoOxcWUpCT60hOIQ2okXXzkHBY9WuLMQC6ggd+tKyF5
         lHAw==
X-Gm-Message-State: APjAAAV81tk2kV9lP+Bsgh55Mvdr/tzDKulLiQFQee8vtzeM0QjjrOrn
        79EEQHVKfBwg3N9Fn6BDNt61BHva2Lk=
X-Google-Smtp-Source: APXvYqy1NKYhjVAHlE9bmTM6Cc9sZcqONl+MGWEWdw9vSDGTTp4HjMJpMWMINeFkplZj4pwTzUgE1w==
X-Received: by 2002:a17:90a:b883:: with SMTP id o3mr1406255pjr.50.1562271161369;
        Thu, 04 Jul 2019 13:12:41 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id o12sm5120149pjr.22.2019.07.04.13.12.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 13:12:41 -0700 (PDT)
Date:   Thu, 4 Jul 2019 13:12:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Message-ID: <20190704131237.239bfa56@cakuba.netronome.com>
In-Reply-To: <20190704181235.8966-15-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
        <20190704181235.8966-15-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 18:16:15 +0000, Saeed Mahameed wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> index 483d321d2151..6854f132d505 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -50,6 +50,15 @@ static const struct counter_desc sw_stats_desc[] = {
>  #ifdef CONFIG_MLX5_EN_TLS
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
> +
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo) },

Why do you call this stat tx_ktls_ooo, and not tx_tls_ooo (extra 'k')?

For nfp I used the stats' names from mlx5 FPGA to make sure we are all
consistent.  I've added them to the tls-offload.rst doc and Boris has
reviewed it.

 * ``rx_tls_decrypted`` - number of successfully decrypted TLS segments
 * ``tx_tls_encrypted`` - number of in-order TLS segments passed to device
   for encryption
 * ``tx_tls_ooo`` - number of TX packets which were part of a TLS stream
   but did not arrive in the expected order
 * ``tx_tls_drop_no_sync_data`` - number of TX packets dropped because
   they arrived out of order and associated record could not be found

Why can't you use the same names for the stats as you used for your mlx5
FPGA?

> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_no_sync_data) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_bypass_req) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_bytes) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_packets) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_packets) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_bytes) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ctx) },
>  #endif
>  
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },

Dave, please don't apply this, I will review in depth once I get
through the earlier 200 emails ;)
