Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30AFBE9427
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfJ3Aka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:40:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33642 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfJ3Aka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:40:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB62F126514D2;
        Tue, 29 Oct 2019 17:40:29 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:40:29 -0700 (PDT)
Message-Id: <20191029.174029.1911221179052316857.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, tgraf@suug.ch
Subject: Re: [PATCH net] vxlan: check tun_info options_len properly
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7cd6d34cc1a13810805b08da771848cfff315d5c.1572283472.git.lucien.xin@gmail.com>
References: <7cd6d34cc1a13810805b08da771848cfff315d5c.1572283472.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:40:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 29 Oct 2019 01:24:32 +0800

> This patch is to improve the tun_info options_len by dropping
> the skb when TUNNEL_VXLAN_OPT is set but options_len is less
> than vxlan_metadata. This can void a potential out-of-bounds
> access on ip_tun_info.
> 
> Fixes: ee122c79d422 ("vxlan: Flow based tunneling")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks Xin.
