Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D63477648
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 16:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbhLPPrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 10:47:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44954 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbhLPPrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 10:47:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5D6661E74
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 15:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA95C36AE0;
        Thu, 16 Dec 2021 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639669661;
        bh=x2qJMultYb0EWrkj82u15b9av/t2/rtSDjR4mn0u0Uk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tunHtGHWos3bTThh5Ctm7Tnr85bWh2tRT8T3YDY/E3KY1YNVuKmnBI098hBcWxzpu
         JMgwPzZBfgHNWYbZ5hjVfcROCeGPRCvETfoIOkUK3qbERdIqMxtv8zsDNEom0VbkPe
         uniM32V0tVcCwk9g6eLkaYgWch4B4O3WtcrHgYsNWc3jZVO2jcpHzDex+aEeMJlvD9
         7dYxDc5prYcI4O34f+45vfWy9cXcDRG1EH+M1fJoRrIWCkC3//iXmPh/MUX1ylP++i
         SoDobbtvH1oU0j7+4H89NcdyozkJXlABToKPJ8zihX+PEV0aDQW5NzMx6tkIlcbHcD
         +mETeOr/eiGag==
Date:   Thu, 16 Dec 2021 07:47:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Subject: Re: [net-queue PATCH 0/5] i40e: stat counter updates and additions
Message-ID: <20211216074739.7f71a01b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
References: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 14:42:05 -0800 Joe Damato wrote:
> This patch set makes several updates to the i40e driver stats collection
> and reporting code to help users of i40e get a better sense of how the
> driver is performing and interacting with the rest of the kernel.
> 
> These patches include some new stats (like waived and busy) which were
> inspired by other drivers that track stats using the same nomenclature.
> 
> The new stats and an existing stat, rx_reuse, are now accessible with
> ethtool to make harvesting this data more convenient for users.

Looks good overall, thanks.
