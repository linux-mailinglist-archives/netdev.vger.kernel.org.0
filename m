Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD12BE0E24
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 00:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbfJVW0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 18:26:05 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34988 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731712AbfJVW0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 18:26:05 -0400
Received: by mail-lj1-f196.google.com with SMTP id m7so18899380lji.2
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 15:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zyVBsTyeuK8exQz7uSYQwdsxGdhjYLow8oX5vGt2F/c=;
        b=lcXDohfgOnbx7TXbgUm4VMI+uk3OyUyfK2CRjgW8nUbpj1mYGechfdG73lQX6EqufG
         a2eCV8+eaW0ZtqTiMH9967z0RKOexKyX24PlFg3uKQBGXwIRAIog2i2aclI5/unG9HE4
         iMl/AO5AAc+oDh0AWhnFdJIk6Mi+Fr2PxrW40XVI0Hw0aAyDk0DirtgWbmV7WZe12ep4
         bBdZ27K1LD9Pr17nHwA/u526pml3DtsgxPB9SLuugjD51/HwmBVdGk2I/wG7eHQhIDTR
         Eiqe0K3kmGPRYQb6jJC0ClIlupHA/l+5AzGD7lv2tP8GetLk30BfZsjh7Glwx1UN34oh
         jPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zyVBsTyeuK8exQz7uSYQwdsxGdhjYLow8oX5vGt2F/c=;
        b=K0OLxtPXqDd+OgPxkC3YbpjSBic35ghyWqDksc+7nUZomJ7E6puqoI9AJ3DCzToTqU
         BsCivVf6S1B2eXlzM0XkxGC6mgvTQlU2RXgWnBG/J2vkWfg8gvJIMjUuj5HVJzNo2hJY
         MAF3AVR9/ixhrB3q82XcGSAZX0T0PgEaTjQureOx9weXZXz8ZiPuN0vcKbxf+Kiq2iOO
         yExkcORNbARcFyGiTQ7XqiZN1VBike/NLGZcYtfXI97IcfYG56cd4My8GitThf/3UOVy
         SvCK6wVMqwhn/kIdN8gbQ0b09mwpEhOvx+aiBz6EI4jXmw/zulXwo0G5xoY5YilwCvWX
         2PWQ==
X-Gm-Message-State: APjAAAW51OGhU+F/upPNJleNGc3y0wQ04X/05vF4WuNMbuXe63ADe1R8
        E5qo4yJOPEkeVlVzp+VSPWmG8A==
X-Google-Smtp-Source: APXvYqz6GvtPBXEdvYogP8HTZ4WdOZhDKd0gF/nGW9a+kQSEprgmY0IHuP1ltVctdf3Z4M3WUqH+LA==
X-Received: by 2002:a2e:8544:: with SMTP id u4mr445073ljj.158.1571783162792;
        Tue, 22 Oct 2019 15:26:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c76sm12184600lfg.11.2019.10.22.15.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 15:26:02 -0700 (PDT)
Date:   Tue, 22 Oct 2019 15:25:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     linux-kernel@lists.codethink.co.uk,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvneta: make stub functions static inline
Message-ID: <20191022152554.251d36ef@cakuba.netronome.com>
In-Reply-To: <20191022152205.11815-1-ben.dooks@codethink.co.uk>
References: <20191022152205.11815-1-ben.dooks@codethink.co.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 16:22:05 +0100, Ben Dooks (Codethink) wrote:
> If the CONFIG_MVNET_BA is not set, then make the stub functions
> static inline to avoid trying to export them, and remove hte
> following sparse warnings:
> 
> drivers/net/ethernet/marvell/mvneta_bm.h:163:6: warning: symbol 'mvneta_bm_pool_destroy' was not declared. Should it be static?
> drivers/net/ethernet/marvell/mvneta_bm.h:165:6: warning: symbol 'mvneta_bm_bufs_free' was not declared. Should it be static?
> drivers/net/ethernet/marvell/mvneta_bm.h:167:5: warning: symbol 'mvneta_bm_construct' was not declared. Should it be static?
> drivers/net/ethernet/marvell/mvneta_bm.h:168:5: warning: symbol 'mvneta_bm_pool_refill' was not declared. Should it be static?
> drivers/net/ethernet/marvell/mvneta_bm.h:170:23: warning: symbol 'mvneta_bm_pool_use' was not declared. Should it be static?
> drivers/net/ethernet/marvell/mvneta_bm.h:181:18: warning: symbol 'mvneta_bm_get' was not declared. Should it be static?
> drivers/net/ethernet/marvell/mvneta_bm.h:182:6: warning: symbol 'mvneta_bm_put' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>

Looks like this one will require a bit more work.

>  drivers/net/ethernet/marvell/mvneta_bm.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta_bm.h b/drivers/net/ethernet/marvell/mvneta_bm.h
> index c8425d35c049..9c0c6e20cf80 100644
> --- a/drivers/net/ethernet/marvell/mvneta_bm.h
> +++ b/drivers/net/ethernet/marvell/mvneta_bm.h
> @@ -160,14 +160,14 @@ static inline u32 mvneta_bm_pool_get_bp(struct mvneta_bm *priv,
>  			     (bm_pool->id << MVNETA_BM_POOL_ACCESS_OFFS));
>  }
>  #else
> -void mvneta_bm_pool_destroy(struct mvneta_bm *priv,
> -			    struct mvneta_bm_pool *bm_pool, u8 port_map) {}
> -void mvneta_bm_bufs_free(struct mvneta_bm *priv, struct mvneta_bm_pool *bm_pool,
> -			 u8 port_map) {}
> -int mvneta_bm_construct(struct hwbm_pool *hwbm_pool, void *buf) { return 0; }
> -int mvneta_bm_pool_refill(struct mvneta_bm *priv,
> -			  struct mvneta_bm_pool *bm_pool) {return 0; }
> -struct mvneta_bm_pool *mvneta_bm_pool_use(struct mvneta_bm *priv, u8 pool_id,
> +static inline void mvneta_bm_pool_destroy(struct mvneta_bm *priv,
> +					  struct mvneta_bm_pool *bm_pool, u8 port_map) {}
> +static inline void mvneta_bm_bufs_free(struct mvneta_bm *priv, struct mvneta_bm_pool *bm_pool,
> +				       u8 port_map) {}

You're going over 80 characters now.

> +static inline int mvneta_bm_construct(struct hwbm_pool *hwbm_pool, void *buf) { return 0; }
> +static inline int mvneta_bm_pool_refill(struct mvneta_bm *priv,
> +					struct mvneta_bm_pool *bm_pool) {return 0; }
> +static inline struct mvneta_bm_pool *mvneta_bm_pool_use(struct mvneta_bm *priv, u8 pool_id,
>  					  enum mvneta_bm_type type, u8 port_id,
>  					  int pkt_size) { return NULL; }

The follow up lines need to be adjusted so that they start on the same
column as the opening bracket.

checkpatch.pl catches those. Please run it with --strict while at it.

> @@ -178,7 +178,7 @@ static inline void mvneta_bm_pool_put_bp(struct mvneta_bm *priv,
>  static inline u32 mvneta_bm_pool_get_bp(struct mvneta_bm *priv,
>  					struct mvneta_bm_pool *bm_pool)
>  { return 0; }
> -struct mvneta_bm *mvneta_bm_get(struct device_node *node) { return NULL; }
> -void mvneta_bm_put(struct mvneta_bm *priv) {}
> +static inline struct mvneta_bm *mvneta_bm_get(struct device_node *node) { return NULL; }
> +static inline void mvneta_bm_put(struct mvneta_bm *priv) {}
>  #endif /* CONFIG_MVNETA_BM */
>  #endif
