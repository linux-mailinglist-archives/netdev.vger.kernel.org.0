Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB88A73663
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfGXSOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:14:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfGXSOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:14:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F0DF3154086E4;
        Wed, 24 Jul 2019 11:14:35 -0700 (PDT)
Date:   Wed, 24 Jul 2019 11:14:35 -0700 (PDT)
Message-Id: <20190724.111435.1790922345411569346.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     klassert@kernel.org, jcliburn@gmail.com, chris.snook@gmail.com,
        rmody@marvell.com, michael.chan@broadcom.com,
        siva.kallam@broadcom.com, prashant@broadcom.com,
        GR-Linux-NIC-Dev@marvell.com, jeffrey.t.kirsher@intel.com,
        cooldavid@cooldavid.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/8] Use dev_get_drvdata where possible
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724060512.23899-1-hslester96@gmail.com>
References: <20190724060512.23899-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 11:14:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Wed, 24 Jul 2019 14:05:12 +0800

> These patches use dev_get_drvdata instead of
> using to_pci_dev + pci_get_drvdata to make
> code simpler where possible.
> 
> Changelog:
> 
> v1 -> v2:
> - Change pci_set_drvdata to dev_set_drvdata
>   to keep consistency.

Some of these patches were applied yesterday, weren't they?

Please take that into consideration when you repost, especially
when the maintainer(s) explicitly reply to your patches saying
"Applied." or similar like I always do.

Thanks.
