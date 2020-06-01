Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80E1EAD62
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbgFASJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730914AbgFASJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:09:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF003C05BD43
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:09:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5C5411D53F8B;
        Mon,  1 Jun 2020 11:09:41 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:09:41 -0700 (PDT)
Message-Id: <20200601.110941.803066444820067254.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        kuba@kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, dlstevens@us.ibm.com,
        allas@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/2] Fix infinite loop in bridge and vxlan modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200601125855.1751343-1-idosch@idosch.org>
References: <20200601125855.1751343-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:09:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon,  1 Jun 2020 15:58:53 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> When suppressing invalid IPv6 Neighbour Solicitation messages, it is
> possible for the bridge and vxlan modules to get stuck in an infinite
> loop. See the individual changelogs for detailed explanation of the
> problem and solution.
> 
> The bug was originally reported against the bridge module, but after
> auditing the code base I found that the buggy code was copied from the
> vxlan module. This patch set fixes both modules. Could not find more
> instances of the problem.
> 
> Please consider both patches for stable releases.

Series applied and queued up for -stable, thank you.
