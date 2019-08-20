Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C00D295368
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbfHTBb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:31:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39344 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbfHTBb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:31:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91BBB14B98288;
        Mon, 19 Aug 2019 18:31:58 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:31:58 -0700 (PDT)
Message-Id: <20190819.183158.1151163538921922149.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     paul.greenwalt@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, andrewx.bowers@intel.com
Subject: Re: [net-next v2 04/14] ice: fix set pause param autoneg check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190819161708.3763-5-jeffrey.t.kirsher@intel.com>
References: <20190819161708.3763-1-jeffrey.t.kirsher@intel.com>
        <20190819161708.3763-5-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:31:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 19 Aug 2019 09:16:58 -0700

> +	/* Get pause param reports configured and negotiated flow control pause
> +	 * when ETHTOOL_GLINKSETTINGS is defined. Since ETHTOOL_GLINKSETTINGS is
> +	 * defined get pause param pause->autoneg reports SW configured setting,
> +	 * so compare pause->autoneg with SW configured to prevent the user from
> +	 * using set pause param to chance autoneg.
> +	 */
> +	pcaps = devm_kzalloc(&vsi->back->pdev->dev, sizeof(*pcaps),
> +			     GFP_KERNEL);

Just in case it isn't clear, please use plain kzalloc/kfree in this code.

Thank you.
