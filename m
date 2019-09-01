Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A53A46BA
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 03:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfIABqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 21:46:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59202 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfIABqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 21:46:13 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B2CA14C5E6D5;
        Sat, 31 Aug 2019 18:46:12 -0700 (PDT)
Date:   Sat, 31 Aug 2019 18:46:08 -0700 (PDT)
Message-Id: <20190831.184608.1630341870469551407.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net 0/3] Fix issues in tc-taprio and tc-cbs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830010723.32096-1-olteanv@gmail.com>
References: <20190830010723.32096-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 18:46:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 30 Aug 2019 04:07:20 +0300

> This series fixes one panic and one WARN_ON found in the tc-taprio
> qdisc, while trying to apply it:
> 
> - On an interface which is not multi-queue
> - On an interface which has no carrier
> 
> The tc-cbs was also visually found to suffer of the same issue as
> tc-taprio, and the fix was only compile-tested in that case.

Series applied, thanks.
