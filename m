Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E8641FB1B
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 13:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhJBLXM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Oct 2021 07:23:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52284 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbhJBLXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 07:23:11 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 8B1194F7C7764;
        Sat,  2 Oct 2021 04:21:24 -0700 (PDT)
Date:   Sat, 02 Oct 2021 12:21:18 +0100 (BST)
Message-Id: <20211002.122118.350530875086041712.davem@davemloft.net>
To:     saeedm@nvidia.com
Cc:     patchwork-bot+netdevbpf@kernel.org, kuba@kernel.org,
        raeds@nvidia.com, netdev@vger.kernel.org
Subject: Re: [net 01/10] net/mlx5e: IPSEC RX, enable checksum complete
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b8be86319c06c5de4770a9f84b3e7a6847ff217f.camel@nvidia.com>
References: <20210930231501.39062-2-saeed@kernel.org>
        <163309380890.18892.12905958838273991886.git-patchwork-notify@kernel.org>
        <b8be86319c06c5de4770a9f84b3e7a6847ff217f.camel@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sat, 02 Oct 2021 04:21:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>
Date: Fri, 1 Oct 2021 18:27:34 +0000

> On Fri, 2021-10-01 at 13:10 +0000, patchwork-bot+netdevbpf@kernel.org
> wrote:
>> Hello:
>> 
>> This series was applied to netdev/net-next.git (refs/heads/master):
> 
> this was for -net.
> I see it applied to both net and net-next, why the bot says it was
> net-next ?
> 
> Any mistakes on my end ?

I accidently pulled it initially into net-next and puished back out before I could undo that.

So I just pushed it to both trees in the end, not your fault.

Thanks!
