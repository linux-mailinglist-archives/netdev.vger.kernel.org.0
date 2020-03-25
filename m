Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C317193073
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgCYSdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgCYSdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 14:33:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8C9F20774;
        Wed, 25 Mar 2020 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585161218;
        bh=pWx+dVHt6T8+QCNHGIOFupFdgY3yMzPpddxo+5DCMSI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xrLTfpm6t+Dz027DIMucE7RxL1T0hCZ+3P+zxBWWRWnjpG9Oym478qdLb/8Pg2MwB
         t3VGteqdsUzpoKipRXxQz9qVuNfzA8ubbZtr+x/+xb7roqnS5dS0vCldE/27B6txbR
         7DmbGPDD7tnr1b8zli/Z4GM+eL7VMqAjPy3IbEHA=
Date:   Wed, 25 Mar 2020 11:33:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@mellanox.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 1/2] devlink: Implicitly set auto recover flag
 when registering health reporter
Message-ID: <20200325113336.567223e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1585142784-10517-2-git-send-email-eranbe@mellanox.com>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
        <1585142784-10517-2-git-send-email-eranbe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 15:26:23 +0200 Eran Ben Elisha wrote:
> When health reporter is registered to devlink, devlink will implicitly set
> auto recover if and only if the reporter has a recover method. No reason
> to explicitly get the auto recover flag from the driver.
> 
> Remove this flag from all drivers that called
> devlink_health_reporter_create.
> 
> Yet, administrator can unset auto recover via netlink command as prior to
> this patch.
> 
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

It would have been useful to say that all the cases where auto-recovery
was disabled don't have the recover method.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
