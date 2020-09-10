Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2770A2639BC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgIJCBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730022AbgIJBrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:47:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C8D22228;
        Thu, 10 Sep 2020 01:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599699995;
        bh=CzMd3+AlFNeYD+Bux2LR7/YLJ8/R470RJG+xSF0bZ60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iSMyjljf8LR0kNWuMslKPU15MZp5CcSD+LxuEKMuKVql+6gMo91lGFDkP3F0fsVis
         +I2ULlGYWcZ6yPHU5L6okj8VzLUqmzzc45GYA64CBDPKad+EuqyxiasMxhBcQcwBsR
         awAYGPAzs0SZGrqX1AXnuZLJPNv63mcG4I/Emxxc=
Date:   Wed, 9 Sep 2020 18:06:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v4 5/5] ice: add support for flash update overwrite
 mask
Message-ID: <20200909180633.42cfc05c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909222653.32994-6-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
        <20200909222653.32994-6-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 15:26:53 -0700 Jacob Keller wrote:
> Support the recently added DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK
> parameter in the ice flash update handler. Convert the overwrite mask
> bitfield into the appropriate preservation level used by the firmware
> when updating.
> 
> Because there is no equivalent preservation level for overwriting only
> identifiers, this combination is rejected by the driver as not supported
> with an appropriate extended ACK message.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
