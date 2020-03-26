Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE26194676
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgCZS1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:27:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgCZS1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:27:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EE91015CBB870;
        Thu, 26 Mar 2020 11:27:34 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:27:34 -0700 (PDT)
Message-Id: <20200326.112734.1600378423635066696.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@resnulli.us
Subject: Re: [net-next v2 00/11] implement DEVLINK_CMD_REGION_NEW
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:27:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Wed, 25 Mar 2020 20:51:46 -0700

> This is a second revision of the previous series to implement the
> DEVLINK_CMD_REGION_NEW. The series can be viewed on lore.kernel.org at
> 
> https://lore.kernel.org/netdev/20200324223445.2077900-1-jacob.e.keller@intel.com/
> 
> This version includes the suggested cleanups from Jakub and Jiri on the
> list, including the following changes, broken out by the v1 patch title.
 ...

Based upon the review so far I'm expecting one more respin of this.
