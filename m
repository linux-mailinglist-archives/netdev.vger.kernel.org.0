Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8BC135017
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgAHXsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:48:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49542 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAHXsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:48:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C665314C76F80;
        Wed,  8 Jan 2020 15:48:05 -0800 (PST)
Date:   Wed, 08 Jan 2020 15:48:05 -0800 (PST)
Message-Id: <20200108.154805.1094700915467259339.davem@davemloft.net>
To:     vikas.gupta@broadcom.com
Cc:     michael.chan@broadcom.com, jiri@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vasundhara-v.volam@broadcom.com, vikram.prakash@broadcom.com
Subject: Re: [PATCH INTERNAL v1 0/3] Devlink notification after recovery
 complete by bnxt_en driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
References: <1577980091-25118-1-git-send-email-vikas.gupta@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 15:48:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vikas Gupta <vikas.gupta@broadcom.com>
Date: Thu,  2 Jan 2020 21:18:08 +0530

>  This patchset adds following feature in devlink 
>   1) Recovery complete direct call API to be used by drivers when it
>      successfully completes. It is required as recovery triggered by
>      devlink may return with EINPROGRESS and eventually recovery 
>      completes in different context.
>   2) A notification when health status is updated by reporter.
> 
>  Patchset also contains required changes in bnxt_en driver to 
>  mark recovery in progress when recovery is triggered from kernel 
>  devlink.

Series applied to net-next, thanks.
