Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A14F2AA80B
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 22:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgKGVMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 16:12:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGVMq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 16:12:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2370A208FE;
        Sat,  7 Nov 2020 21:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604783566;
        bh=SR6fR0mt62umQNHQmvNUUFXuKU+qNpjw2/X9a5XthRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LmehF8jQhMJDtS6aaG5u79SuHBujmUkilacT9b88M8xVkEE/FENXVVzQ7qAZwteWm
         YKIq2S8BD1rlr68HT17zxYP143zkARCTpTDtm90ptJJpu00rF8/Bq8jNq/LjViMwXQ
         eNJhAzx2jCY0jMq8yCCDOsEUtRletp7IMYJPkZZg=
Date:   Sat, 7 Nov 2020 13:12:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 1/3] ptp: idt82p33: add adjphase support
Message-ID: <20201107131245.686413bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604634729-24960-1-git-send-email-min.li.xe@renesas.com>
References: <1604634729-24960-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 22:52:07 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjphase() to support PHC write phase mode.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied all 3, thanks.
