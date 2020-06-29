Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D7220D6C5
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbgF2TXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731733AbgF2TXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:23:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54149C061755;
        Mon, 29 Jun 2020 12:23:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4CB7121110A7;
        Mon, 29 Jun 2020 12:23:41 -0700 (PDT)
Date:   Mon, 29 Jun 2020 12:23:37 -0700 (PDT)
Message-Id: <20200629.122337.481071276474268044.davem@davemloft.net>
To:     rao.shoaib@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        ka-cheong.poon@oracle.com, david.edmondson@oracle.com
Subject: Re: [PATCH v1] rds: If one path needs re-connection, check all and
 re-connect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ba7da46b-a84d-142f-90e2-6b0be6899fbf@oracle.com>
References: <20200626183438.20188-1-rao.shoaib@oracle.com>
        <20200626.163100.603726050168307590.davem@davemloft.net>
        <ba7da46b-a84d-142f-90e2-6b0be6899fbf@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 12:23:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>
Date: Mon, 29 Jun 2020 10:55:28 -0700

> This was coded in this unusual way because the code is agnostic to the
> underlying transport. Unfortunately, IB transport does not
> initialize/use this field where as TCP does and counts starting from
> one.

Ok, please resubmit, I didn't understand that the conn->c_npaths
could be zero.

Thank you.
