Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1284F2827A9
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgJDAe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgJDAe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:34:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65CDC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 17:34:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0751311E3E4CB;
        Sat,  3 Oct 2020 17:18:09 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:34:57 -0700 (PDT)
Message-Id: <20201003.173457.1086868343990640432.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: remove duplicate prefix
 for VL Lookup dynamic config
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201003081836.4052912-1-vladimir.oltean@nxp.com>
References: <20201003081836.4052912-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 17:18:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sat,  3 Oct 2020 11:18:36 +0300

> This is a strictly cosmetic change that renames some macros in
> sja1105_dynamic_config.c. They were copy-pasted in haste and this has
> resulted in them having the driver prefix twice.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
