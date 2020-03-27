Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF844194F21
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgC0Ch2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:37:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57570 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0Ch2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:37:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6486215CE62EB;
        Thu, 26 Mar 2020 19:37:27 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:37:26 -0700 (PDT)
Message-Id: <20200326.193726.945892559006461550.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     jiri@resnulli.us, netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next v3 11/11] ice: add a devlink region for
 dumping NVM contents
From:   David Miller <davem@davemloft.net>
In-Reply-To: <83be9fef-c15e-c32b-7d0f-70c563318fb9@intel.com>
References: <20200326183718.2384349-12-jacob.e.keller@intel.com>
        <20200326211908.GG11304@nanopsycho.orion>
        <83be9fef-c15e-c32b-7d0f-70c563318fb9@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:37:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu, 26 Mar 2020 15:35:15 -0700

> I'm happy to send a v4 with this fix in, or to send a separate follow-up
> patch which cleans up all of the devlink documents to avoid this.
> 
> Dave, which would you prefer?

I'm going to apply this series as-is, so please do a follow-up.

Thanks.
