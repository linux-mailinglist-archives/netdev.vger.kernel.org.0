Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCD214F1D4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgAaSHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:38 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F380B20CC7;
        Fri, 31 Jan 2020 18:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494058;
        bh=P04dmKf3OT4D1hSsCAL27hf8NQtQTt7Ymo69pvNsmEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IF1kyBuAz2aBw4WixsVL/9lALEVgJsAaWv0Wm+AEzpWHE8zG5xr5Zfrs9tXINcmR1
         rK+lsEkOp2wFTzgpamMJWUOAEHF2KngenJZM7b+mLpkvNf1Ul/RMzZVBEmhluIfqIN
         8YNLy8nJ21vMTPfu6PYUUL+jHQJecbKQONEeIwf0=
Date:   Fri, 31 Jan 2020 10:07:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 03/15] devlink: add operation to take an immediate
 snapshot
Message-ID: <20200131100736.54a7deb7@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-4-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:58:58 -0800, Jacob Keller wrote:
> Add a new devlink command, DEVLINK_CMD_REGION_TAKE_SNAPSHOT. This
> command is intended to enable userspace to request an immediate snapshot
> of a region.
> 
> Regions can enable support for requestable snapshots by implementing the
> snapshot callback function in the region's devlink_region_ops structure.
> 
> Implementations of this function callback should capture an immediate
> copy of the data and return it and its destructor in the function
> parameters. The core devlink code will generate a snapshot ID and create
> the new snapshot while holding the devlink instance lock.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
