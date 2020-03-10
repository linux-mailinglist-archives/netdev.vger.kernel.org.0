Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E24180BFE
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgCJXEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:04:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43876 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJXEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:04:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA33014CCF99A;
        Tue, 10 Mar 2020 16:04:42 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:04:42 -0700 (PDT)
Message-Id: <20200310.160442.827815262817836583.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kuba@kernel.org, saeedm@mellanox.com,
        pablo@netfilter.org, ecree@solarflare.com
Subject: Re: [patch net-next 0/3] flow_offload: follow-ups to HW stats type
 patchset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310154909.3970-1-jiri@resnulli.us>
References: <20200310154909.3970-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:04:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Tue, 10 Mar 2020 16:49:06 +0100

> This patchset includes couple of patches in reaction to the discussions
> to the original HW stats patchset. The first patch is a fix,
> the other two patches are basically cosmetics.

Series applied, thanks Jiri.
