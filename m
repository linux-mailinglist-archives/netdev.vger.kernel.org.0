Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76EB1973AC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgC3FJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:09:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33272 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgC3FJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 01:09:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C0D715C60D29;
        Sun, 29 Mar 2020 22:09:23 -0700 (PDT)
Date:   Sun, 29 Mar 2020 22:09:22 -0700 (PDT)
Message-Id: <20200329.220922.2145807458548324030.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net-next] devlink: don't wrap commands in rST shell
 blocks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200327205536.2527859-1-jacob.e.keller@intel.com>
References: <20200327205536.2527859-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 22:09:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Fri, 27 Mar 2020 13:55:36 -0700

> The devlink-region.rst and ice-region.rst documentation files wrapped
> some lines within shell code blocks due to being longer than 80 lines.
> 
> It was pointed out during review that wrapping these lines shouldn't be
> done. Fix these two rST files and remove the line wrapping on these
> shell command examples.
> 
> Reported-by: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied.
