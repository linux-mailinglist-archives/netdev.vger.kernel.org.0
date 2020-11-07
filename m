Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CCA2AA753
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 18:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgKGRzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 12:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKGRzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 12:55:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8D8A20885;
        Sat,  7 Nov 2020 17:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604771742;
        bh=2X+pYmAeqUgWo45AdrivHzYI75Ndi9ovxTDr2Ai1aBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=seWan8beRUqqF0fDQau/dE5NhL2vJid6y/uv9DZL4vmCvuK1uN9cLq3nhq79hLaDE
         pZO0d92KZIOkFNZRUoolz5j3TtFKdfPPK2hBZV53tudz0ngHcKZjp4F0G48yWqFVlU
         Uqt/UPmcCbUEIK+9Rq19wUjxFoKACHR1Y915j/B4=
Date:   Sat, 7 Nov 2020 09:55:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Subject: Re: [PATCH net-next v3 15/15] net/smc: Add support for obtaining
 system information
Message-ID: <20201107095540.0f45b572@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107125958.16384-16-kgraul@linux.ibm.com>
References: <20201107125958.16384-1-kgraul@linux.ibm.com>
        <20201107125958.16384-16-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  7 Nov 2020 13:59:58 +0100 Karsten Graul wrote:
> From: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> Add new netlink command to obtain system information
> of the smc module.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Checkpatch says:

CHECK: Please don't use multiple blank lines
#62: FILE: include/uapi/linux/smc_diag.h:140:
 
+

WARNING: line length of 84 exceeds 80 columns
#172: FILE: net/smc/smc_diag.c:687:
+	smcd_dev = list_first_entry_or_null(&dev_list->list, struct smcd_dev, list);
