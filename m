Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901F7194F27
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgC0Cjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:39:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0Cjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:39:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F15215CE62F9;
        Thu, 26 Mar 2020 19:39:45 -0700 (PDT)
Date:   Thu, 26 Mar 2020 19:39:44 -0700 (PDT)
Message-Id: <20200326.193944.1407114546304446159.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH net-next v3 00/11] implement DEVLINK_CMD_REGION_NEW
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 19:39:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu, 26 Mar 2020 11:37:07 -0700

> This series adds support for the DEVLINK_CMD_REGION_NEW operation, used to
> enable userspace requesting a snapshot of a region on demand.

Series applied, thanks Jacob.
