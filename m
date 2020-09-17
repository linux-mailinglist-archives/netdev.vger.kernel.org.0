Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E690726E5FE
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgIQUAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgIQUAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:00:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7A2235F7;
        Thu, 17 Sep 2020 19:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600372348;
        bh=VonLcGC9WYLHniE2w/czvnaUZa99NGgt6rFtYOzl/IU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=paC8HuavIJ4e/1Yxhyqo0rgTm2Fvu3K8pBHzQ5iia/FpF06COY/57VQFEmrHu4BIa
         irl++yVs0VomByRh/z1JP+ACHrrmCjLpPIaO4ramLlDOLwBA7tFUq2E2LH5hRC0ibn
         hvh0X/HHKXkz8JfZ5OjJjf0f0KG09ivkwOxuYsL0=
Date:   Thu, 17 Sep 2020 12:52:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 5/5] ionic: add devlink firmware update
Message-ID: <20200917125227.52d58738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200917030204.50098-6-snelson@pensando.io>
References: <20200917030204.50098-1-snelson@pensando.io>
        <20200917030204.50098-6-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Sep 2020 20:02:04 -0700 Shannon Nelson wrote:
> Add support for firmware update through the devlink interface.
> This update copies the firmware object into the device, asks
> the current firmware to install it, then asks the firmware to
> select the new firmware for the next boot-up.
> 
> The install and select steps are launched as asynchronous
> requests, which are then followed up with status request
> commands.  These status request commands will be answered with
> an EAGAIN return value and will try again until the request
> has completed or reached the timeout specified.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Acked-by: Jakub Kicinski <kuba@kernel.org>
