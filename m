Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8533B23152D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgG1VuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgG1VuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 17:50:12 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF7582070A;
        Tue, 28 Jul 2020 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595973012;
        bh=1i0XAgYuuitJQpFCLXxss9rSWBjMff3ArKvxJxSYwhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2TTvylBM32zIoClSqAsueK5eONXvMGfHp3fnwDUfeGSPp9v+28/7Le88w4DQwD1Go
         Pyj7FS0LrtU4ya1QhVn53vD6x/aQiotXME/54EQWw0kOxcF70MfsIX1lxbdhRKYVMb
         k983t67TPdQKx++nR5PkTMrqH25WIn8/2JJrLFUw=
Date:   Tue, 28 Jul 2020 14:50:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 0/2] udp_tunnel: convert mlx5 to the new
 udp_tunnel infrastructure
Message-ID: <20200728145010.1902b1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200728214606.303058-1-kuba@kernel.org>
References: <20200728214606.303058-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 14:46:04 -0700 Jakub Kicinski wrote:
> v2: - don't disable the offload on reprs in patch #2.

Oouf, I missed amending the commit, sending v3 with a missing include.
Sorry for the noise :(
