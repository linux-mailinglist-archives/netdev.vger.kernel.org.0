Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670DF86F07
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405210AbfHIA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:59:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53902 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405098AbfHIA7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:59:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95C5F1424972E;
        Thu,  8 Aug 2019 17:59:04 -0700 (PDT)
Date:   Thu, 08 Aug 2019 17:59:02 -0700 (PDT)
Message-Id: <20190808.175902.932211761024300821.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     madalin.bucur@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dpaa_eth: Use refcount_t for refcount
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190802164759.20135-1-hslester96@gmail.com>
References: <20190802164759.20135-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 17:59:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Sat,  3 Aug 2019 00:47:59 +0800

> refcount_t is better for reference counters since its
> implementation can prevent overflows.
> So convert atomic_t ref counters to refcount_t.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
> Changes in v2:
>   - Add #include in dpaa_eth.h.

Applied to net-next.
