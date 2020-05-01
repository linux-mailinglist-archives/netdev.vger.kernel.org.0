Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779871C0CBC
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgEADmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgEADmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:42:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E24CC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:42:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2788C12774D47;
        Thu, 30 Apr 2020 20:42:06 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:42:05 -0700 (PDT)
Message-Id: <20200430.204205.1991520353622189464.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_acl_tcam: Position vchunk in a
 vregion list properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427150547.3949211-1-idosch@idosch.org>
References: <20200427150547.3949211-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:42:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 27 Apr 2020 18:05:47 +0300

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Vregion helpers to get min and max priority depend on the correct
> ordering of vchunks in the vregion list. However, the current code
> always adds new chunk to the end of the list, no matter what the
> priority is. Fix this by finding the correct place in the list and put
> vchunk there.
> 
> Fixes: 22a677661f56 ("mlxsw: spectrum: Introduce ACL core with simple TCAM implementation")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied and queued up for -stable, thanks.
