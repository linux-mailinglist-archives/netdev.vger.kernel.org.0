Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4D247BA72
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhLUHJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:09:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40378 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbhLUHJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 02:09:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B420661463;
        Tue, 21 Dec 2021 07:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D526C36AE9;
        Tue, 21 Dec 2021 07:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640070576;
        bh=Pvvhgzw4Bg7THafEjDQkprLbY/TI8E6lWZ5l34UMp2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J5nPdGiF6OxtfnvPVTtM24vPraqu6b2zOscCic9VIKoXeAHp1TVKWlaMayXLRJ1On
         k+iUNWxZjblS2RGy+JqVV3oqDTJgjwCkc7Ptt+ufVRGxqoxcIOkA6RMqbyONTvBB9d
         7DYiLxuRKGrwu3+2WhnMQfXtEMatOGMlOfiGYxrc=
Date:   Tue, 21 Dec 2021 08:09:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC PATCH v12 00/17] dlb: introduce DLB device driver
Message-ID: <YcF9rRTVzrbCyOtq@kroah.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 12:50:30AM -0600, Mike Ximing Chen wrote:
> v12:

<snip>

How is a "RFC" series on version 12?  "RFC" means "I do not think this
should be merged, please give me some comments on how this is all
structured" which I think is not the case here.

> - The following coding style changes suggested by Dan will be implemented
>   in the next revision
> -- Replace DLB_CSR_RD() and DLB_CSR_WR() with direct ioread32() and
>    iowrite32() call.
> -- Remove bitmap wrappers and use linux bitmap functions directly.
> -- Use trace_event in configfs attribute file update.

Why submit a patch series that you know will be changed?  Just do the
work, don't ask anyone to review stuff you know is incorrect, that just
wastes our time and ensures that we never want to review it again.

greg k-h
