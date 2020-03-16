Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D167186761
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 10:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgCPJFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 05:05:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730075AbgCPJE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 05:04:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C50C146F7ECC;
        Mon, 16 Mar 2020 02:04:59 -0700 (PDT)
Date:   Mon, 16 Mar 2020 02:04:58 -0700 (PDT)
Message-Id: <20200316.020458.1470957653235116686.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] ethtool: fail with error if request has
 unknown flags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1584292182.git.mkubecek@suse.cz>
References: <cover.1584292182.git.mkubecek@suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 02:04:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Sun, 15 Mar 2020 18:17:38 +0100 (CET)

> Jakub Kicinski pointed out that if unrecognized flags are set in netlink
> header request, kernel shoud fail with an error rather than silently
> ignore them so that we have more freedom in future flags semantics.
> 
> To help userspace with handling such errors, inform the client which
> flags are supported by kernel. For that purpose, we need to allow
> passing cookies as part of extack also in case of error (they can be
> only passed on success now).

Series applied, thanks Michal.
