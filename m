Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40273627DF
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244926AbhDPSoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235192AbhDPSoC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:44:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881056137D;
        Fri, 16 Apr 2021 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618598617;
        bh=eERb2oIzvyw5mgVwHPGPZN8LJRNHcHdySBdmdFB48YM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JUzxt9l+ogD7mNdpRSJSD3l/mxt94GraDQOb2D5vmo9/iv6yFXEmYjLCEom8Hwujp
         ZhtS5Xcd/6QJyMOneA5oQsI0dqUDk9ooBauJ7q3yyZBtB9Q5HLXFZc/Vah55OV42+U
         y6vgJmt52RujW9Q0JIBxzjWP7B550pD9ou8tBAKi7M8ayprPgsPDHvYZ4qYUxy3psw
         haJQeKiEHOm0cmSrsYG5yE/hYgQTI/sVvsx4RDThunsJuQDXeY52ulITdIvQELnNl4
         z45qiLxGRjt3d1YA83RNDiZrzSsfX4JLGW/GYNGE6JGU9o/yQ9M/NcBbrXZSOMd/Be
         ayDE7yHP8SA2Q==
Date:   Fri, 16 Apr 2021 11:43:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] scm: fix a typo in put_cmsg()
Message-ID: <20210416114336.4ec334e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416183538.1194197-1-eric.dumazet@gmail.com>
References: <20210416183538.1194197-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Apr 2021 11:35:38 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We need to store cmlen instead of len in cm->cmsg_len.
> 
> Fixes: 38ebcf5096a8 ("scm: optimize put_cmsg()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jakub Kicinski <kuba@kernel.org>

FWIW can confirm it fixes the issue:

Tested-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
