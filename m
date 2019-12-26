Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDE412AEBB
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfLZVJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:09:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:09:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1465F1510FBA3;
        Thu, 26 Dec 2019 13:09:48 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:09:47 -0800 (PST)
Message-Id: <20191226.130947.1921067020497315902.davem@davemloft.net>
To:     aroulin@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH net-next v2] bonding: rename AD_STATE_* to LACP_STATE_*
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577367717-3971-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1577367717-3971-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 13:09:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Roulin <aroulin@cumulusnetworks.com>
Date: Thu, 26 Dec 2019 05:41:57 -0800

> As the LACP actor/partner state is now part of the uapi, rename the
> 3ad state defines with LACP prefix. The LACP prefix is preferred over
> BOND_3AD as the LACP standard moved to 802.1AX.
> 
> Fixes: 826f66b30c2e3 ("bonding: move 802.3ad port state flags to uapi")
> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> ---
> 
> Notes:
>     v2: use LACP_* prefix instead of BOND_3AD_*

Applied, thank you.
