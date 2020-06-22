Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3351F2042D3
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgFVVpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730556AbgFVVpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 17:45:49 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72E6D2075A;
        Mon, 22 Jun 2020 21:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592862348;
        bh=/iDamTs9vjIgEUlpWcMEymikJ1C267Z2pP/3s/Qz5nU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eysYIJSx90LttU7dgNlebd4Wk8a+HaDDgcpEDdPZTGxaHhZ9sxBAJQ+2qpzwCFxMu
         ZUWv0P5jVeNwEfiWuWNt7P0+JnVoBNy+Cv09/tH8M4fCsrgzmNtMIXBFuHNvA+xWVK
         x6QhczrBiCnlJhHoEuWIYC3oz/UMG3V4qO0QGeSg=
Date:   Mon, 22 Jun 2020 14:45:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com
Subject: Re: [PATCH net-next 3/3] i40e: introduce new dump desc xdp command
Message-ID: <20200622144546.04da25d6@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200622124624.18847-3-ciara.loftus@intel.com>
References: <20200622124624.18847-1-ciara.loftus@intel.com>
        <20200622124624.18847-3-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jun 2020 12:46:24 +0000 Ciara Loftus wrote:
> Interfaces already exist for dumping rx and tx descriptor information.
> Introduce another for doing the same for xdp descriptors.
> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>

Please make sure things build cleanly with W=1 C=1

drivers/net/ethernet/intel/i40e/i40e_debugfs.c:543: warning: Function parameter or member 'type' not described in 'i40e_dbg_dump_desc'
drivers/net/ethernet/intel/i40e/i40e_debugfs.c:543: warning: Excess function parameter 'ring_type' description in 'i40e_dbg_dump_desc'
