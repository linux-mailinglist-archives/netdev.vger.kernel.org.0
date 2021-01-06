Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42092EB6F9
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbhAFAnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbhAFAnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:43:20 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B177C061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 16:42:40 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 506FB4CBCE1FB;
        Tue,  5 Jan 2021 16:42:39 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:42:38 -0800 (PST)
Message-Id: <20210105.164238.974008569350313242.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, olteanv@gmail.com
Subject: Re: [PATCH net v2] docs: net: fix documentation on .ndo_get_stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210105012224.1681573-1-kuba@kernel.org>
References: <20210105012224.1681573-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:42:39 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon,  4 Jan 2021 17:22:24 -0800

> Fix calling context.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied, thanks.
