Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16A79195D
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 21:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfHRTqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 15:46:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfHRTqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 15:46:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B71A142395C7;
        Sun, 18 Aug 2019 12:45:58 -0700 (PDT)
Date:   Sun, 18 Aug 2019 12:45:57 -0700 (PDT)
Message-Id: <20190818.124557.401382074697068581.davem@davemloft.net>
To:     manishc@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com
Subject: Re: [PATCH net 1/1] bnx2x: Fix VF's VLAN reconfiguration in reload.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190818142548.22365-1-manishc@marvell.com>
References: <20190818142548.22365-1-manishc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 Aug 2019 12:45:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manish Chopra <manishc@marvell.com>
Date: Sun, 18 Aug 2019 07:25:48 -0700

> Commit 04f05230c5c13 ("bnx2x: Remove configured vlans as
> part of unload sequence."), introduced a regression in driver
> that as a part of VF's reload flow, VLANs created on the VF
> doesn't get re-configured in hardware as vlan metadata/info
> was not getting cleared for the VFs which causes vlan PING to stop.
> 
> This patch clears the vlan metadata/info so that VLANs gets
> re-configured back in the hardware in VF's reload flow and
> PING/traffic continues for VLANs created over the VFs.
> 
> Fixes: 04f05230c5c13 ("bnx2x: Remove configured vlans as part of unload sequence.")
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
> Signed-off-by: Shahed Shaikh <shshaikh@marvell.com>

Applied and queued up for -stable.
