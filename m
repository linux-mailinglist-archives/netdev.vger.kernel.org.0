Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28A21C0742
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD3UCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3UCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:02:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3D3C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:02:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F145128A515A;
        Thu, 30 Apr 2020 13:02:54 -0700 (PDT)
Date:   Thu, 30 Apr 2020 13:02:53 -0700 (PDT)
Message-Id: <20200430.130253.176477054285435962.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/9] mlxsw: Prepare SPAN API for upcoming
 changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430170116.4081677-1-idosch@idosch.org>
References: <20200430170116.4081677-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 13:02:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 30 Apr 2020 20:01:07 +0300

> Switched port analyzer (SPAN) is used for packet mirroring. Over mlxsw
> this is achieved by attaching tc-mirred action to either matchall or
> flower classifier.
> 
> The current API used to configure SPAN consists of two functions:
> mlxsw_sp_span_mirror_add() and mlxsw_sp_span_mirror_del().
> 
> These two functions pack a lot of different operations:
> 
> * SPAN agent configuration: Determining the egress port and optional
>   headers that need to encapsulate the mirrored packet (when mirroring
>   to a gretap, for example)
> 
> * Egress mirror buffer configuration: Allocating / freeing a buffer when
>   port is analyzed (inspected) at egress
> 
> * SPAN agent binding: Binding the SPAN agent to a trigger, if any. The
>   current triggers are incoming / outgoing packet and they are only used
>   for matchall-based mirroring
> 
> This non-modular design makes it difficult to extend the API for future
> changes, such as new mirror targets (CPU) and new global triggers (early
> dropped packets, for example).
> 
> Therefore, this patch set gradually adds APIs for above mentioned
> operations and then converts the two existing users to use it instead of
> the old API. No functional changes intended. Tested with existing
> mirroring selftests.
> 
> Patch set overview:
> 
> Patches #1-#5 gradually add the new API
> Patches #6-#8 convert existing users to use the new API
> Patch #9 removes the old API

Looks good, series applied, thanks!
