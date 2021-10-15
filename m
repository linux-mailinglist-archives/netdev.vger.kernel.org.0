Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE742FEAD
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 01:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243508AbhJOXcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 19:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243501AbhJOXcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 19:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB9E361151;
        Fri, 15 Oct 2021 23:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634340594;
        bh=1sMO2Ka52k31Xy1/VL7lPoUiapu/Tl8T/BLhtH2Tvao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WndTbQaUs4Z9Uxg3VPDvQ0wJC2bTu6pP6ThzmNQyd0Hl9DkhKUruUP0f2+O7vCt5s
         gKwurn1SAfYP8M/9h0mb2spP21lX7SErRoDs5mrNCjxkYXveghHjMPRHZouC/hgHew
         LQKv3BiHs0IsEWWJDxy9psNuwu0boaOHDOKutr/J71C0AJCYFmJs7GDobkP2OvaiN0
         QaQ3Ct6i3AhaD96LzV6TSIrKYnG/JrmQzfpGTVu4MZDdAZt5dBqqDTJxGZ9NZHpNuh
         g6+3vMvgmIS+vlunM56sNcmSjvh7/zrziWhpZ4JwvcXxC6RW6Y/hIU/GyZ0Ni7O7H1
         2UWr2Ugh20+ZQ==
Date:   Fri, 15 Oct 2021 16:29:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] ipv6: When forwarding count rx stats on the orig
 netdev
Message-ID: <20211015162953.6fefeb4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <372a0b95-7ec4-fcd9-564e-cb898c4fe90a@gmail.com>
References: <20211014130845.410602-1-ssuryaextr@gmail.com>
        <1a83de45-936e-483c-0176-c877d8548d70@gmail.com>
        <20211015022241.GA3405@ICIPI.localdomain>
        <1e07d35a-50f5-349e-3634-b9fd73fca8ea@gmail.com>
        <20211015130141.66db253b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <372a0b95-7ec4-fcd9-564e-cb898c4fe90a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Oct 2021 15:28:00 -0600 David Ahern wrote:
> >> oh right, ipv4 is per net-namespace.  
> > 
> > Is that an ack? :)
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Thanks, applied!
