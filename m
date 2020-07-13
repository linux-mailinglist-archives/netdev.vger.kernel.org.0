Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DED21E35D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 01:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGMXCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 19:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgGMXCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 19:02:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF0A42145D;
        Mon, 13 Jul 2020 23:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594681322;
        bh=P6s0vSnmFTH066+S9zKbYZtViHwlzCDyeAkKsuLnRCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DV+tbh9pmAOnpkZMYFW10TdVlics/zUGAJhIR6Mjoidw5JiA6bQzNDVBdGojWJC9+
         Y89DkllHv80hPhp0hUJ2vRsy4vkQR8FfH9uCnUk5ka/x4l28Yc7qINdGfAf1xRD16n
         daLAKtlDgLd3MSuRoUyd/jnLrVtjM+Xcyxn9oi6M=
Date:   Mon, 13 Jul 2020 16:02:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 04/16] sfc_ef100: skeleton EF100 PF driver
Message-ID: <20200713160200.681db7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
        <14ffb6fc-d5a2-ce62-c8e7-6cf6e164bf16@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 12:32:16 +0100 Edward Cree wrote:
> +MODULE_VERSION(EFX_DRIVER_VERSION);

We got rid of driver versions upstream, no?
