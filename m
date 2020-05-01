Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806CA1C20C5
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgEAWeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgEAWeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:34:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D883C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:34:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85A1414F64DDF;
        Fri,  1 May 2020 15:34:30 -0700 (PDT)
Date:   Fri, 01 May 2020 15:34:29 -0700 (PDT)
Message-Id: <20200501.153429.2281822366307684985.davem@davemloft.net>
To:     ahochauwaaaaa@gmail.com
Cc:     pablo@netfilter.org, netdev@vger.kernel.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org
Subject: Re: [PATCH net] gtp: set NLM_F_MULTI flag in gtp_genl_dump_pdp()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430050136.1837-1-ahochauwaaaaa@gmail.com>
References: <20200430050136.1837-1-ahochauwaaaaa@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:34:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>
Date: Thu, 30 Apr 2020 14:01:36 +0900

> In drivers/net/gtp.c, gtp_genl_dump_pdp() should set NLM_F_MULTI
> flag since it returns multipart message.
> This patch adds a new arg "flags" in gtp_genl_fill_info() so that
> flags can be set by the callers.
> 
> Signed-off-by: Yoshiyuki Kurauchi <ahochauwaaaaa@gmail.com>

Applied.
