Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6CF1D5861
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgEORzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgEORzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:55:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359AEC061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 10:55:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF50214EB3891;
        Fri, 15 May 2020 10:54:59 -0700 (PDT)
Date:   Fri, 15 May 2020 10:54:59 -0700 (PDT)
Message-Id: <20200515.105459.159440318464405050.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next 0/3] cxgb4: improve and tune TC-MQPRIO offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
References: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 10:55:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Fri, 15 May 2020 22:41:02 +0530

> Patch 1 improves the Tx path's credit request and recovery mechanism
> when running under heavy load.
> 
> Patch 2 adds ability to tune the burst buffer sizes of all traffic
> classes to improve performance for <= 1500 MTU, under heavy load.
> 
> Patch 3 adds support to track EOTIDs and dump software queue
> contexts used by TC-MQPRIO offload.

Series applied, thank you.
