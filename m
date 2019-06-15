Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE1C46DE8
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfFOCw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:52:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57764 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFOCw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:52:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1209E12D6B4D6;
        Fri, 14 Jun 2019 19:52:28 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:52:27 -0700 (PDT)
Message-Id: <20190614.195227.1067753340429537322.davem@davemloft.net>
To:     timbeale@catalyst.net.nz
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net next 1/2] udp: Remove unused parameter (exact_dif)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
References: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:52:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tim Beale <timbeale@catalyst.net.nz>
Date: Fri, 14 Jun 2019 16:41:26 +1200

> Originally this was used by the VRF logic in compute_score(), but that
> was later replaced by udp_sk_bound_dev_eq() and the parameter became
> unused.
> 
> Note this change adds an 'unused variable' compiler warning that will be
> removed in the next patch (I've split the removal in two to make review
> slightly easier).
> 
> Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>

Applied.
