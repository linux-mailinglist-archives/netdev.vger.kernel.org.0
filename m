Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 036CC191D98
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgCXXgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:36:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37948 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgCXXgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:36:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC6DA159F5F6C;
        Tue, 24 Mar 2020 16:36:06 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:36:05 -0700 (PDT)
Message-Id: <20200324.163605.1988277256387167758.davem@davemloft.net>
To:     ybason@marvell.com
Cc:     netdev@vger.kernel.org, dbolotin@marvell.com
Subject: Re: [PATCH net-next 1/3] qed: Replace wq_active Boolean with an
 atomic QED_SLOWPATH_ACTIVE flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324141348.7897-2-ybason@marvell.com>
References: <20200324141348.7897-1-ybason@marvell.com>
        <20200324141348.7897-2-ybason@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:36:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>
Date: Tue, 24 Mar 2020 16:13:46 +0200

> The atomic opertaion might prevent a potential race condition.
> 
> Signed-off-by: Yuval Basson <ybason@marvell.com>
> Signed-off-by: Denis Bolotin <dbolotin@marvell.com>

There is no basis in fact behind this change.

Either explain clearly and precisely what race is fixed by this
change or remove this change.

Thank you.
