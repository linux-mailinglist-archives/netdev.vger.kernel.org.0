Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F21833A5E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfFCV5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:57:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35866 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFCV5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:57:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB526133E97CE;
        Mon,  3 Jun 2019 14:57:14 -0700 (PDT)
Date:   Mon, 03 Jun 2019 14:57:14 -0700 (PDT)
Message-Id: <20190603.145714.586469768418251982.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     jhs@mojatatu.com, jiri@resnulli.us, pablo@netfilter.org,
        netdev@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH net-next] flow_offload: include linux/kernel.h from
 flow_offload.h
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c7da964b-72ba-964a-5adf-c7b33b32c737@solarflare.com>
References: <c7da964b-72ba-964a-5adf-c7b33b32c737@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Jun 2019 14:57:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Fri, 31 May 2019 22:47:21 +0100

> flow_stats_update() uses max_t, so ensure we have that defined.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Applied.
