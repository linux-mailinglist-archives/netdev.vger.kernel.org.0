Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6297E204301
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgFVVx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730576AbgFVVx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 17:53:27 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E7512073E;
        Mon, 22 Jun 2020 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592862806;
        bh=5vAIr8TWpJY5H6D8PUE0z8CO7YaOX4OBvlSX0veq6uY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r8hsF2xxfGoQWrZiwShUCU6VXIEeR+xPwOAR47rwbinfzYwShjSojvhVi6hCOFoTW
         INyWKY+iY8VDqvZCF9zH/798IevfcnmPr8N0RjNB+pkClcwXuPPrkO3vHBiq8LIuvs
         bMaLgQi4qwVIqGGxFXI6liqoplt7cp1MtVH+vqBo=
Date:   Mon, 22 Jun 2020 14:53:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, jiri@mellanox.com,
        jacob.e.keller@intel.com
Subject: Re: [PATCH v2 net-next 0/2] devlink: Add board.serial_number field
 to info_get cb.
Message-ID: <20200622145324.79906b88@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1592670717-28851-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1592670717-28851-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 22:01:55 +0530 Vasundhara Volam wrote:
> This patchset adds support for board.serial_number to devlink info_get
> cb and also use it in bnxt_en driver.
> 
> Sample output:
> 
> $ devlink dev info pci/0000:af:00.1
> pci/0000:af:00.1:
>   driver bnxt_en
>   serial_number 00-10-18-FF-FE-AD-1A-00
>   board.serial_number 433551F+172300000
>   versions:
>       fixed:
>         board.id 7339763 Rev 0.
>         asic.id 16D7
>         asic.rev 1
>       running:
>         fw 216.1.216.0
>         fw.psid 0.0.0
>         fw.mgmt 216.1.192.0
>         fw.mgmt.api 1.10.1
>         fw.ncsi 0.0.0.0
>         fw.roce 216.1.16.0

LGTM, thank you!

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
