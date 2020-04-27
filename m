Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3F31BAE46
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 21:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgD0Tn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 15:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgD0Tnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 15:43:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AF4C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 12:43:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED6EF15D6389C;
        Mon, 27 Apr 2020 12:43:53 -0700 (PDT)
Date:   Mon, 27 Apr 2020 12:43:50 -0700 (PDT)
Message-Id: <20200427.124350.787548116668309902.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 00/13] mlxsw: Rework matchall offloading
 plumbing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 12:43:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 27 Apr 2020 18:12:57 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jiri says:
> 
> Currently the matchall and flower are handled by registering separate
> callbacks in mlxsw. That leads to faulty indication "in_hw_count 2" in
> filter show command for every inserted flower filter. That happens
> because matchall callback just blindly returns 0 for it and it is
> wrongly accounted for as "the offloader".
> 
> I inspected different ways to fix this problem. The only clean solution
> is to rework handling of matchall in mlxsw a bit. The driver newely
> registers one callback for bound block which is called for both matchall
> and flower filter insertions.
> 
> On the way, iron out the matchall code a bit, push it into a separate
> file etc.

Series applied, thanks.
