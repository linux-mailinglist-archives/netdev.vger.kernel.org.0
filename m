Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2D312A4B6
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 00:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLXXm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 18:42:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57624 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfLXXm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 18:42:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65490154CBDE1;
        Tue, 24 Dec 2019 15:42:56 -0800 (PST)
Date:   Tue, 24 Dec 2019 15:42:54 -0800 (PST)
Message-Id: <20191224.154254.1245558924785049224.davem@davemloft.net>
To:     aroulin@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH net-next] bonding: rename AD_STATE_* to BOND_3AD_STATE_*
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576798379-5061-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1576798379-5061-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 15:42:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Roulin <aroulin@cumulusnetworks.com>
Date: Thu, 19 Dec 2019 15:32:59 -0800

> As the LACP states are now part of the uapi, rename the
> 3ad state defines with BOND_3AD prefix. This way, the naming
> is consistent with the the rest of the bonding uapi.
> 
> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>

When the next version of this is posted please provide an appropriate
Fixes: tag.

My understanding of this situaion is that we only started putting this in
the UAPI header in the current merge window, which is why it is valid to
change UAPI like this.

If you provided an appropriate Fixes: tag, it would have been very clear
to me that this is in fact the case.
