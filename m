Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93D21458F4
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgAVPpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:45:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgAVPpa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 10:45:30 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BC09217F4;
        Wed, 22 Jan 2020 15:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579707929;
        bh=fiFliyvTvD4+vKGaEmROxrWcVL8c+wPaQxTR+JOqqxw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TrrB8Q/apTjmtijw9B8YJjMMFfc+MFwXwn+v0skUaTVk4soAlpGjGbRiS6m/xZVom
         i0nTnpPxWHgCiuoqQhMTABWS63jEgn9RfL3ZCRSXee2Rt8+hHgrHOrpygoUhnx3/Qj
         1zN9V0WQCF8KFsoy62fZnf+wpr+OWBTwuQ6h81+M=
Date:   Wed, 22 Jan 2020 07:45:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     <ariel.elior@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH net-next 01/14] qed: FW 8.42.2.0 Internal ram offsets
 modifications
Message-ID: <20200122074528.670d3d2a@cakuba>
In-Reply-To: <20200122152627.14903-2-michal.kalderon@marvell.com>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
        <20200122152627.14903-2-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 17:26:14 +0200, Michal Kalderon wrote:
> IRO stands for internal RAM offsets. Updating the FW binary produces
> different iro offsets. This file contains the different values,
> and a new representation of the values.
> 
> Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

If you have different offsets depending on FW build - where is the code
that checks the FW version is the one driver expects? At a quick glance
you're not bumping any numbers in this patch..
