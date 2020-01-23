Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B64146F54
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgAWRQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgAWRQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jan 2020 12:16:30 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD0A020704;
        Thu, 23 Jan 2020 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579799790;
        bh=f5G/hFPUrKbySScrvBUwJSRmogzaDs+Na2LQsdmY9DQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NlU6gOAsNX2tsLmj9HKIL1iiRxvGlAzFc5GDSJRotwWW4c0jYYtDPIFM1ebLUP9As
         jm2jb8lZc6EkzQqaNwheYdRK0e12XO+dCKhnMHitjSy6yo4zX7JC5Wd/vaPLp8tvmm
         v50kPxhk+2jPF6Q6nMyVUsPWGput1TmfcFQUHxII=
Date:   Thu, 23 Jan 2020 09:16:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     <ariel.elior@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 00/13] qed*: Utilize FW 8.42.2.0
Message-ID: <20200123091629.0291bbaf@cakuba>
In-Reply-To: <20200123105836.15090-1-michal.kalderon@marvell.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 12:58:23 +0200, Michal Kalderon wrote:
> Changes from V1
> ---------------
> - Remove epoch + kernel version from device debug dump
> - don't bump driver version

But you haven't fixed the fact that in patch 1 you already strat
changing defines for the new FW version, even though the version 
is only enforced (reportedly) in patch 9?
