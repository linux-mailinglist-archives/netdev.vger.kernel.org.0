Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686FE1903FD
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 04:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgCXDyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 23:54:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCXDyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 23:54:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 000CE154A1DDC;
        Mon, 23 Mar 2020 20:54:34 -0700 (PDT)
Date:   Mon, 23 Mar 2020 20:54:34 -0700 (PDT)
Message-Id: <20200323.205434.1296492673341017869.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net-next] net: sched: rename more stats_types
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319232623.102700-1-kuba@kernel.org>
References: <20200319232623.102700-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 20:54:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 19 Mar 2020 16:26:23 -0700

> Commit 53eca1f3479f ("net: rename flow_action_hw_stats_types* ->
> flow_action_hw_stats*") renamed just the flow action types and
> helpers. For consistency rename variables, enums, struct members
> and UAPI too (note that this UAPI was not in any official release,
> yet).
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied.
