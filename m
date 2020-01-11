Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA29E137AD9
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 02:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgAKBHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 20:07:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbgAKBHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 20:07:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A64715859B5B;
        Fri, 10 Jan 2020 17:07:17 -0800 (PST)
Date:   Fri, 10 Jan 2020 17:07:16 -0800 (PST)
Message-Id: <20200110.170716.819771465192664636.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH 00/17] devlink documentation refactor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 17:07:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu,  9 Jan 2020 14:46:08 -0800

> This series updates the devlink documentation, with a few primary goals
> 
>  * move all of the devlink documentation into a dedicated subfolder
>  * convert that documentation to the reStructuredText format
>  * merge driver-specific documentations into a single file per driver
>  * add missing documentation, including per-driver and devlink generally
> 
> For each driver, I took the time to review the code and add further
> documentation on the various features it currently supports. Additionally, I
> added new documentation files for some of the features such as
> devlink-dpipe, devlink-resource, and devlink-regions.
> 
> Note for the region snapshot triggering, I kept that as a separate patch as
> that is based on work that has not yet been merged to net-next, and may
> change.
> 
> I also improved the existing documentation for devlink-info and
> devlink-param by adding a bit more of an introduction when converting it to
> the rst format.

Series applied, thanks Jacob.
