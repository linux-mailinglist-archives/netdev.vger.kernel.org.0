Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2BE191DA8
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCXXtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:49:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38024 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgCXXtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:49:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31058159F798D;
        Tue, 24 Mar 2020 16:49:07 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:49:06 -0700 (PDT)
Message-Id: <20200324.164906.998922318294541493.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, eugenem@fb.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        michael.chan@broadcom.com, snelson@pensando.io,
        jesse.brandeburg@intel.com, rdunlap@infradead.org,
        vasundhara-v.volam@broadcom.com
Subject: Re: [PATCH net-next v3] devlink: expand the devlink-info
 documentation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324173016.135105-1-kuba@kernel.org>
References: <20200324173016.135105-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:49:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 24 Mar 2020 10:30:16 -0700

> We are having multiple review cycles with all vendors trying
> to implement devlink-info. Let's expand the documentation with
> more information about what's implemented and motivation behind
> this interface in an attempt to make the implementations easier.
> 
> Describe what each info section is supposed to contain, and make
> some references to other HW interfaces (PCI caps).
> 
> Document how firmware management is expected to look, to make
> it clear how devlink-info and devlink-flash work in concert.
> 
> Name some future work.
> 
> v2: - improve wording
> v3: - improve wording
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks.
