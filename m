Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D35E5EAD
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfJZSgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:36:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfJZSgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:36:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DA9714DECD47;
        Sat, 26 Oct 2019 11:36:08 -0700 (PDT)
Date:   Sat, 26 Oct 2019 11:36:06 -0700 (PDT)
Message-Id: <20191026.113606.2071884675063818343.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/31] Netfilter/IPVS updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 11:36:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 26 Oct 2019 13:47:02 +0200

> The following patchset contains Netfilter/IPVS updates for net-next,
> more specifically:
 ...
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks Pablo.
