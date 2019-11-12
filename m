Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1423F99AD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 20:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfKLT0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 14:26:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48270 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbfKLT0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 14:26:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91366154CEC52;
        Tue, 12 Nov 2019 11:26:04 -0800 (PST)
Date:   Tue, 12 Nov 2019 11:26:03 -0800 (PST)
Message-Id: <20191112.112603.40446033659590804.davem@davemloft.net>
To:     ayal@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] Update devlink binary output
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
References: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 11:26:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>
Date: Tue, 12 Nov 2019 14:07:48 +0200

> This series changes the devlink binary interface:
> -The first patch forces binary values to be enclosed in an array. In
>  addition, devlink_fmsg_binary_pair_put breaks the binary value into
>  chunks to comply with devlink's restriction for value length.
> -The second patch removes redundant code and uses the fixed devlink
>  interface (devlink_fmsg_binary_pair_put).
> -The third patch make self test to use the updated devlink
>  interface.
> -The fourth, adds a verification of dumping a very large binary
>  content. This test verifies breaking the data into chunks in a valid
>  JSON output.
> 
> Series was generated against net-next commit:
> ca22d6977b9b Merge branch 'stmmac-next'

Series applied, thank you.
