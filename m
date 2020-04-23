Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4C01B5188
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 02:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDWAxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 20:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgDWAxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 20:53:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587AB2075A;
        Thu, 23 Apr 2020 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587603212;
        bh=6yLmeFDKVLFdNtJWamWFLjt/Hw95onywxeZS7TWv0hQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=w+G//GP762mwk+M1OPwqZEYw4PodL/qCIGb5nDaZAaUAQWFsrESeANq80+AoJB2gO
         0hkRLoR0V2okKp1PYKE0qmGnV4n8O/pkL9OsSFWb5QkBQdbDdQiD8JAPgZMCZoVqXa
         GvdPdheDDpjzJoV4Swip8POl2EfcC9yxRISWdmHU=
Date:   Wed, 22 Apr 2020 17:53:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <aelior@marvell.com>, <irusskikh@marvell.com>,
        <mkalderon@marvell.com>
Subject: Re: [PATCH net-next v2 2/2] qede: Add support for handling the pcie
 errors.
Message-ID: <20200422175330.448cb5f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422131607.7262-3-skalluru@marvell.com>
References: <20200422131607.7262-1-skalluru@marvell.com>
        <20200422131607.7262-3-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 06:16:07 -0700 Sudarsana Reddy Kalluru wrote:
> The error recovery is handled by management firmware (MFW) with the help of
> qed/qede drivers. Upon detecting the errors, driver informs MFW about this
> event which in turn starts a recovery process. MFW sends ERROR_RECOVERY
> notification to the driver which performs the required cleanup/recovery
> from the driver side.
> 
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
