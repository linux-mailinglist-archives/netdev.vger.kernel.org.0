Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D812E5ACE1
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2Sx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:53:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34992 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfF2Sx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:53:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so4558132pfd.2
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 11:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cxYWGW17XI/ND+W++7/fL9DbvzhUlqvuU2ZGsKQYeX4=;
        b=vyz/vyQ/TDwubkGVLrHlJDsUKXhzDShKpR/Euic0teIEV1ImTjgzZS9ktbu9vq2JhA
         IRAMDNpGxI9s7bjZOz3Q/HJUGoIHBtdHeMnadVKlyD8jOSJA8jfko0ClmixEoZm7+LHM
         +lY2UkW2YHNMcKCL/ULyfTk+VIAWukr/DpP0P9JzUJIOIcy/BWswlDSNLBxDrYph1hAn
         /Y/ptSMAaFJMiVabJ/XVyGaar6BT/77wY+JjJ6WP4ci2CqFEGYRrIZ/eB2Yd9hdXRiQu
         c5DABxi1nTQhVyctRkq5ibgojHKIs4O2PEjyteO/vv31KPnL05VRc5It7AIz4yM5dymE
         zIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cxYWGW17XI/ND+W++7/fL9DbvzhUlqvuU2ZGsKQYeX4=;
        b=EdK/B0h5CLhaPZEuPZnmEGWGJAIY0zbXX/QVVvLCn3YNVe868JrpOXSU5KMbrJPqdo
         ytNybh+H0fJFP41ROcjxvxEqnYMaT2ceMHJn/IJ1VP2wn0xu2sDOaVogMaZNClkqDZd8
         KwoXBlyX2eJ8mbhBoebHMugX5tiQMPAZtK+fb2ab16NGLo2N0lLh2xrNafWTT1k8Vd4P
         xv2uGPoI5iMZvKpFbE46+gQD1Ph07oxVR0HgxJ3pxmCbNKTWKm7noXLCVvw30i7u5+fq
         qYk2C3C68oGbNH2IZMA6MuFRnQ5/fqvVXYCXOevdBoP7iV8cetEGZ/0chOxgI3KITIR9
         3hXg==
X-Gm-Message-State: APjAAAW9rCax8MJbzUWq4nMjFIj7bDDOnckMW1sPM0ZmNF/FOsJXTWB/
        JjM3Qw+JnwqbPKMd0X07RX+OMfF6SWE=
X-Google-Smtp-Source: APXvYqyphSVyNMb2bME6dsUntVcOf8ryymFzvKlYEd7aU6/QvcxxyLyLCorkrGE33Q75VnUdgxB7FQ==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr21085171pjb.115.1561834406868;
        Sat, 29 Jun 2019 11:53:26 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id a15sm4625690pgw.3.2019.06.29.11.53.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 29 Jun 2019 11:53:26 -0700 (PDT)
Date:   Sat, 29 Jun 2019 11:53:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 16/19] ionic: Add driver stats
Message-ID: <20190629115324.7adfc3c9@cakuba.netronome.com>
In-Reply-To: <20190628213934.8810-17-snelson@pensando.io>
References: <20190628213934.8810-1-snelson@pensando.io>
        <20190628213934.8810-17-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 14:39:31 -0700, Shannon Nelson wrote:
> Add in the detailed statistics for ethtool -S that the driver
> keeps as it processes packets.  Display of the additional
> debug statistics can be enabled through the ethtool priv-flags
> feature.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
> index 0e2dc53f08d4..4f3cfbf36c23 100644
> --- a/drivers/net/ethernet/pensando/ionic/Makefile
> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
> @@ -4,4 +4,5 @@
>  obj-$(CONFIG_IONIC) := ionic.o
>  
>  ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o \
> -	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o
> +	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o \
> +	   ionic_stats.o
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index 2bbe5819387b..518e79c90fca 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -8,6 +8,84 @@
>  #include "ionic_bus.h"
>  #include "ionic_lif.h"
>  #include "ionic_ethtool.h"
> +#include "ionic_stats.h"
> +
> +static const char ionic_priv_flags_strings[][ETH_GSTRING_LEN] = {
> +#define PRIV_F_SW_DBG_STATS		BIT(0)
> +	"sw-dbg-stats",
> +};
> +#define PRIV_FLAGS_COUNT ARRAY_SIZE(ionic_priv_flags_strings)
> +
> +static void ionic_get_stats_strings(struct lif *lif, u8 *buf)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < ionic_num_stats_grps; i++)
> +		ionic_stats_groups[i].get_strings(lif, &buf);
> +}
> +
> +static void ionic_get_stats(struct net_device *netdev,
> +			    struct ethtool_stats *stats, u64 *buf)
> +{
> +	struct lif *lif;
> +	u32 i;
> +
> +	lif = netdev_priv(netdev);
> +
> +	memset(buf, 0, stats->n_stats * sizeof(*buf));
> +	for (i = 0; i < ionic_num_stats_grps; i++)
> +		ionic_stats_groups[i].get_values(lif, &buf);
> +}
> +
> +static int ionic_get_stats_count(struct lif *lif)
> +{
> +	int i, num_stats = 0;
> +
> +	for (i = 0; i < ionic_num_stats_grps; i++)
> +		num_stats += ionic_stats_groups[i].get_count(lif);
> +
> +	return num_stats;
> +}
> +
> +static int ionic_get_sset_count(struct net_device *netdev, int sset)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	int count = 0;
> +
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		count = ionic_get_stats_count(lif);
> +		break;
> +	case ETH_SS_TEST:
> +		break;
> +	case ETH_SS_PRIV_FLAGS:
> +		count = PRIV_FLAGS_COUNT;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +	return count;
> +}
> +
> +static void ionic_get_strings(struct net_device *netdev,
> +			      u32 sset, u8 *buf)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +
> +	switch (sset) {
> +	case ETH_SS_STATS:
> +		ionic_get_stats_strings(lif, buf);
> +		break;
> +	case ETH_SS_PRIV_FLAGS:
> +		memcpy(buf, ionic_priv_flags_strings,
> +		       PRIV_FLAGS_COUNT * ETH_GSTRING_LEN);
> +		break;
> +	case ETH_SS_TEST:
> +		// IONIC_TODO
> +	default:
> +		netdev_err(netdev, "Invalid sset %d\n", sset);

Not really an error, as long as sset_count() returns a 0 nothing will
happen.  Also you can drop the SS_TEST if you don't report it.

> +	}
> +}

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.h b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
> new file mode 100644
> index 000000000000..b5487e7fd4fb
> --- /dev/null
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
> +
> +#ifndef _IONIC_STATS_H_
> +#define _IONIC_STATS_H_
> +
> +#define IONIC_STAT_TO_OFFSET(type, stat_name) (offsetof(type, stat_name))
> +
> +#define IONIC_STAT_DESC(type, stat_name) { \
> +	.name = #stat_name, \
> +	.offset = IONIC_STAT_TO_OFFSET(type, stat_name) \
> +}
> +
> +#define IONIC_LIF_STAT_DESC(stat_name) \
> +	IONIC_STAT_DESC(struct lif_sw_stats, stat_name)
> +
> +#define IONIC_TX_STAT_DESC(stat_name) \
> +	IONIC_STAT_DESC(struct tx_stats, stat_name)
> +
> +#define IONIC_RX_STAT_DESC(stat_name) \
> +	IONIC_STAT_DESC(struct rx_stats, stat_name)
> +
> +#define IONIC_TX_Q_STAT_DESC(stat_name) \
> +	IONIC_STAT_DESC(struct queue, stat_name)
> +
> +#define IONIC_CQ_STAT_DESC(stat_name) \
> +	IONIC_STAT_DESC(struct cq, stat_name)
> +
> +#define IONIC_INTR_STAT_DESC(stat_name) \
> +	IONIC_STAT_DESC(struct intr, stat_name)
> +
> +#define IONIC_NAPI_STAT_DESC(stat_name) \
> +	IONIC_STAT_DESC(struct napi_stats, stat_name)
> +
> +/* Interface structure for a particalar stats group */
> +struct ionic_stats_group_intf {
> +	void (*get_strings)(struct lif *lif, u8 **buf);
> +	void (*get_values)(struct lif *lif, u64 **buf);
> +	u64 (*get_count)(struct lif *lif);
> +};
> +
> +extern const struct ionic_stats_group_intf ionic_stats_groups[];
> +extern const int ionic_num_stats_grps;
> +
> +#define IONIC_READ_STAT64(base_ptr, desc_ptr) \
> +	(*((u64 *)(((u8 *)(base_ptr)) + (desc_ptr)->offset)))
> +
> +struct ionic_stat_desc {
> +	char name[ETH_GSTRING_LEN];
> +	u64 offset;
> +};
> +
> +#endif // _IONIC_STATS_H_

Perhaps worth grepping the driver for C++ style comments?
