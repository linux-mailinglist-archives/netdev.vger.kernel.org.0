Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784CF2E025F
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 23:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgLUWMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 17:12:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgLUWMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 17:12:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3815922A85;
        Mon, 21 Dec 2020 22:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608588695;
        bh=DnNgEVjCfrprNJ9RSZxsFZvFFS3e09k0MYPLmOzZhho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IYjo4gN+7De6IfK1dHFK1kt7nvn9kdaSINp3mSvKLeROgVcWOGBHLA18DIpy4n0c6
         ZlHRZ4V4h3xkdK7p1j0NIT5YngfruJqBEwT4fHcMxHbnzvK6kkWIOYjiGfdMOwBmDt
         d35FEDfG2/a+G/LQYaagbYYNr3rNF3T4OjSv/rSnM/JK06Ei0JU6cn3UwsgQZOL8Jn
         7AN4opSg4mLN99Dmnl9ndHYYnG2nX9n0QpIUpe6bm7ZiP1035LIDSMleyavC+Jz/0i
         0P5HHx/y2v2kkllR8j/3ssA8MbSZyDeYkJV8WLvyKtYhPeB8eKxZSDDpv3fm98H1ae
         4LeK3WnlJdXxg==
Date:   Mon, 21 Dec 2020 14:11:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Lowe <nick.lowe@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
Message-ID: <20201221141134.55ad507a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201221191549.4311-1-nick.lowe@gmail.com>
References: <20201221191549.4311-1-nick.lowe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Dec 2020 19:15:49 +0000 Nick Lowe wrote:
> The Intel I211 Ethernet Controller supports 2 Receive Side Scaling (RSS) queues.
> It should not be excluded from having this feature enabled.
> 
> Via commit c883de9fd787b6f49bf825f3de3601aeb78a7114
> E1000_MRQC_ENABLE_RSS_4Q was renamed to E1000_MRQC_ENABLE_RSS_MQ to
> indicate that this is a generic bit flag to enable queues and not
> a flag that is specific to devices that support 4 queues
> 
> The bit flag enables 2, 4 or 8 queues appropriately depending on the part.
> 
> Tested with a multicore CPU and frames were then distributed as expected.
> 
> This issue appears to have been introduced because of confusion caused
> by the prior name.
> 
> Signed-off-by: Nick Lowe <nick.lowe@gmail.com>

Please repost CCing the maintainers.
