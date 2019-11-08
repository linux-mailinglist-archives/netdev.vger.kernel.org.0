Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8833EF3CD8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfKHA1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfKHA1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5185E15386608;
        Thu,  7 Nov 2019 16:27:38 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:27:37 -0800 (PST)
Message-Id: <20191107.162737.1165653881854546260.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     david.m.ertman@intel.com, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, andrewx.bowers@intel.com
Subject: Re: [net-next 03/15] ice: Implement DCBNL support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107221438.17994-4-jeffrey.t.kirsher@intel.com>
References: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
        <20191107221438.17994-4-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:27:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu,  7 Nov 2019 14:14:26 -0800

> +static int ice_dcbnl_getpfc(struct net_device *netdev, struct ieee_pfc *pfc)
> +{
> +	struct ice_pf *pf = ice_netdev_to_pf(netdev);
> +	struct ice_dcbx_cfg *dcbxcfg;
> +	struct ice_port_info *pi = pf->hw.port_info;
> +	int i;

Reverse christmas tree here please.
