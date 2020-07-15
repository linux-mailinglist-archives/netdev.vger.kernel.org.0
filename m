Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C3B22013C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 02:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGOAGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 20:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgGOAGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 20:06:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329A2C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 17:06:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E17915E4595A;
        Tue, 14 Jul 2020 17:06:29 -0700 (PDT)
Date:   Tue, 14 Jul 2020 17:06:27 -0700 (PDT)
Message-Id: <20200714.170627.380704065491369242.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH net-next v3 00/12] udp_tunnel: NIC RX port offload
 infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714191830.694674-1-kuba@kernel.org>
References: <20200714191830.694674-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 17:06:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 14 Jul 2020 12:18:18 -0700

> This set of patches converts further drivers to use the new
> infrastructure to UDP tunnel port offload merged in
> commit 0ea460474d70 ("Merge branch 'udp_tunnel-add-NIC-RX-port-offload-infrastructure'").
> 
> v3:
>  - fix a W=1 build warning in qede.
> v2:
>  - fix a W=1 build warning in xgbe,
>  - expand the size of tables for lio.

Series applied, thanks.
