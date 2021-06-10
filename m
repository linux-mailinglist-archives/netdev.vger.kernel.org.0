Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2943A369D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFJVtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhFJVtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:49:03 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481C2C0617A6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 14:46:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1B55A4F7E3845;
        Thu, 10 Jun 2021 14:46:49 -0700 (PDT)
Date:   Thu, 10 Jun 2021 14:46:45 -0700 (PDT)
Message-Id: <20210610.144645.1169461277377813265.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, richardcochran@gmail.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 00/10] DSA tagging driver for NXP SJA1110
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Jun 2021 14:46:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please fix this and resubmit, thanks:

ERROR: modpost: "dsa_8021q_rcv" [net/dsa/tag_sja1105.ko] undefined!
ERROR: modpost: "sja1110_process_meta_tstamp" [net/dsa/tag_sja1105.ko] undefined!
ERROR: modpost: "dsa_8021q_rcv" [net/dsa/tag_ocelot_8021q.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:150: modules-only.symvers] Error 1
make[1]: *** Deleting file 'modules-only.symvers'
make: *** [Makefile:1754: modules] Error 2
make: *** Waiting for unfinished jobs....

