Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4A721A5
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403941AbfGWVfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:35:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37172 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403905AbfGWVfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:35:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02820153C23C9;
        Tue, 23 Jul 2019 14:35:07 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:35:07 -0700 (PDT)
Message-Id: <20190723.143507.1690183028498872104.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 13/19] ionic: Add initial ethtool support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722214023.9513-14-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
        <20190722214023.9513-14-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:35:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 22 Jul 2019 14:40:17 -0700

> +static int ionic_get_link_ksettings(struct net_device *netdev,
> +				    struct ethtool_link_ksettings *ks)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	int copper_seen = 0;

Reverse christmas tree ordering here please.

> +static int ionic_set_link_ksettings(struct net_device *netdev,
> +				    const struct ethtool_link_ksettings *ks)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic *ionic = lif->ionic;
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	u8 fec_type = PORT_FEC_TYPE_NONE;
> +	u32 req_rs, req_fc;
> +	int err = 0;

Likewise.
> +static void ionic_get_pauseparam(struct net_device *netdev,
> +				 struct ethtool_pauseparam *pause)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	uint8_t pause_type = idev->port_info->config.pause_type;

Likewise.

> +static int ionic_set_pauseparam(struct net_device *netdev,
> +				struct ethtool_pauseparam *pause)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic *ionic = lif->ionic;
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	u32 requested_pause;
> +	int err;

Likewise.
> +static int ionic_get_module_info(struct net_device *netdev,
> +				 struct ethtool_modinfo *modinfo)
> +
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	struct xcvr_status *xcvr;

Likewise.

> +static int ionic_get_module_eeprom(struct net_device *netdev,
> +				   struct ethtool_eeprom *ee,
> +				   u8 *data)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	struct xcvr_status *xcvr;
> +	u32 len;

Likewise.
