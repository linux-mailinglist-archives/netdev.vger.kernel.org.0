Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4AF22892E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgGUTcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728577AbgGUTcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 15:32:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B9620717;
        Tue, 21 Jul 2020 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595359967;
        bh=H9Jiq/6Pv5OO0Gp+4tWgz8sj+vHZ52XA/lBciE9LxiY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0UKyeVk0PAO/r+kiASFp3puUHZWFRupW4wSBfboeQPspnxMPHrpBuIl8uZnLxW8KM
         OcFCd36evGL2btx1D9y1kjm/ZdKXD4+7NIlYYotMVwtChdinpTYBYEcgXRIaWmA0/z
         XOZ6KyApMsoXFLt/MreSMViwIcS0YSPVhHQM5diA=
Date:   Tue, 21 Jul 2020 12:32:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com
Subject: Re: [PATCH net-next 0/4] devlink small improvements
Message-ID: <20200721123245.4e8082cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721165354.5244-1-parav@mellanox.com>
References: <20200721165354.5244-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jul 2020 19:53:50 +0300 Parav Pandit wrote:
> Hi Jakub, Dave,
> 
> This short series improves the devlink code for lock commment,
> simplifying checks and keeping the scope of mutex lock for necessary
> fields.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
