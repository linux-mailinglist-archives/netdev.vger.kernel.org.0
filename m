Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF13FD2C1
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKOCKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:10:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfKOCKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:10:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 035C514B79F8F;
        Thu, 14 Nov 2019 18:10:29 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:10:29 -0800 (PST)
Message-Id: <20191114.181029.172632478229743526.davem@davemloft.net>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, sgoutham@marvell.com
Subject: Re: [PATCH v2 00/18] octeontx2-af: Debugfs support and updates to
 parser profile
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 18:10:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sunil.kovvuri@gmail.com
Date: Thu, 14 Nov 2019 10:56:15 +0530

> From: Sunil Goutham <sgoutham@marvell.com>
> 
> This patchset adds debugfs support to dump various HW state machine info
> which helps in debugging issues. Info includes 
> - Current queue context, stats, resource utilization etc
> - MCAM entry utilization, miss and pkt drop counter
> - CGX ingress and egress stats
> - Current RVU block allocation status
> - etc.
> 
> Rest patches has changes wrt
> - Updated packet parsing profile for parsing more protocols.
> - RSS algorithms to include inner protocols while generating hash
> - Handle current version of silicon's limitations wrt shaping, coloring
>   and fixed mapping of transmit limiter queue's configuration.
> - Enable broadcast packet replication to PF and it's VFs.
> - Support for configurable NDC cache waymask
> - etc
> 
> Changes from v1:
>    Removed inline keyword for newly introduced APIs in few patches.
>    - Suggested by David Miller.

Series applied to net-next, thanks.
