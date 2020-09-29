Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D6A27B925
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgI2A66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgI2A66 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 20:58:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 990C8207C4;
        Tue, 29 Sep 2020 00:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601341137;
        bh=YTWYVSHeW74nejX1frBcAqnFBvCikqbvRyCPWW9X5u8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tvq1n5iEyfbGAoNLvfzP6S99kfgjToZUm9mGvjG7SHHhfDfqexkhksXB6gcL/2pmj
         q4kvP8z7EfE7covqinm8qJvO2W8WBJ9/nn3uqwKCAZT8TIIurx4qchLxIrqbNxRlGV
         O+6ezT1yCRdWOcsyI6Fa+UgUzXDmv71Qk1MOg+SU=
Date:   Mon, 28 Sep 2020 17:58:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net] ethtool: mark netlink policy as __ro_after_init
Message-ID: <20200928175856.4a43fe30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929005718.3640588-1-kuba@kernel.org>
References: <20200929005718.3640588-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Sep 2020 17:57:18 -0700 Jakub Kicinski wrote:
> Like all genl families ethtool_genl_family needs to not
> be a straight up constant, because it's modified/initialized
> by genl_register_family(). After init, however, it's only
> passed to genlmsg_put() & co. therefore we can mark it
> as __ro_after_init.

Sorry I just realized the subject is off.
