Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25F647BC3F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 09:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhLUI5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 03:57:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54082 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhLUI5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 03:57:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15B716132D;
        Tue, 21 Dec 2021 08:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0646C36AE7;
        Tue, 21 Dec 2021 08:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640077022;
        bh=HfISWOm/KTR0zaBU9ujisT2ybpuP78TvRi7qXjxgM0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5dlQCkZ07Krazl+1InZZtjAsOpzJPhd098PdnrUoaoLIxNtA3eNResW+dTxEVYBV
         4SEZrwf2oK8EyeLk+R90+NyrfMBmFdCAmNetfCm3H/tBVlTbWqH5FsTfpY7AqrSufk
         pTS+BbfBZAYscC+dR5Sqddo17OshT1Dv1HCGT2wg=
Date:   Tue, 21 Dec 2021 09:56:59 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Message-ID: <YcGW26h6wf3f3hDl@kroah.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-18-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221065047.290182-18-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 12:50:47AM -0600, Mike Ximing Chen wrote:
> +Date:		Oct 15, 2021
> +KernelVersion:	5.15

5.15 and that date was  long time ago :(
