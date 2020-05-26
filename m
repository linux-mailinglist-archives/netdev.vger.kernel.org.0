Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AB51E336D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 01:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392264AbgEZXHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 19:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389565AbgEZXHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 19:07:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96CAC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 16:07:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C584120F5281;
        Tue, 26 May 2020 16:07:38 -0700 (PDT)
Date:   Tue, 26 May 2020 16:07:27 -0700 (PDT)
Message-Id: <20200526.160727.915548443518613182.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH net v2 0/5] nexthops: Fix 2 fundamental flaws with
 nexthop groups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526185618.43748-1-dsahern@kernel.org>
References: <20200526185618.43748-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 16:07:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue, 26 May 2020 12:56:13 -0600

> v2
> - fixed whitespace errors

I was able to catch this in time before I pushed out v1, just FYI.
