Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877151BACDA
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgD0Sez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726213AbgD0Sey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:34:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75216C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:34:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 025BC15D54AD8;
        Mon, 27 Apr 2020 11:34:53 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:34:53 -0700 (PDT)
Message-Id: <20200427.113453.1404536144150891450.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v2 net] fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE
 sanity checks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200425194025.70351-1-edumazet@google.com>
References: <20200425194025.70351-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:34:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sat, 25 Apr 2020 12:40:25 -0700

> My intent was to not let users set a zero drop_batch_size,
> it seems I once again messed with min()/max().
> 
> Fixes: 9d18562a2278 ("fq_codel: add batch ability to fq_codel_drop()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks.
