Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2E5FE699
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfKOUte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:49:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfKOUtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:49:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E85E514E20F60;
        Fri, 15 Nov 2019 12:49:32 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:49:32 -0800 (PST)
Message-Id: <20191115.124932.339187560742442216.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        brandon.streiff@ni.com, christopher.s.hall@intel.com,
        eugenia@mellanox.com, felipe.balbi@linux.intel.com,
        ferasda@mellanox.com, jacob.e.keller@intel.com,
        jeffrey.t.kirsher@intel.com, sergei.shtylyov@cogentembedded.com,
        stefan.sorensen@spectralink.com
Subject: Re: [PATCH net 00/13] ptp: Validate the ancillary ioctl flags more
 carefully.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114184507.18937-1-richardcochran@gmail.com>
References: <20191114184507.18937-1-richardcochran@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:49:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Thu, 14 Nov 2019 10:44:54 -0800

> The flags passed to the ioctls for periodic output signals and
> time stamping of external signals were never checked, and thus formed
> a useless ABI inadvertently.  More recently, a version 2 of the ioctls
> was introduced in order make the flags meaningful.  This series
> tightens up the checks on the new ioctl flags.
> 
> - Patch 1 ensures at least one edge flag is set for the new ioctl.
> - Patches 2-7 are Jacob's recent checks, picking up the tags.
> - Patch 8 introduces a "strict" flag for passing to the drivers when the
>   new ioctl is used.
> - Patches 9-12 implement the "strict" checking in the drivers.
> - Patch 13 extends the test program to exercise combinations of flags.

Series applied, thanks Richard.
