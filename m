Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04EAEA5DA
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfJ3V7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:59:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47256 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbfJ3V7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:59:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E2A8614D06356;
        Wed, 30 Oct 2019 14:59:17 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:59:17 -0700 (PDT)
Message-Id: <20191030.145917.1263185053715293146.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, laurentiu.tudor@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v3 2/5] bus: fsl-mc: add the
 fsl_mc_get_endpoint function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571998630-17108-3-git-send-email-ioana.ciornei@nxp.com>
References: <1571998630-17108-1-git-send-email-ioana.ciornei@nxp.com>
        <1571998630-17108-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 14:59:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Fri, 25 Oct 2019 13:17:07 +0300

> @@ -712,6 +712,39 @@ void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
>  }
>  EXPORT_SYMBOL_GPL(fsl_mc_device_remove);
>  
> +struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
> +{

Like Andrew, I'd really like to see this returning error pointers.

Even if right now the callers don't really change their actions in any
way for different error types.  It's just so much clearer with error
pointers and opens up propagation of error codes in the future if that
works.

Thank you.
