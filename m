Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B152CE67
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfE1SU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:20:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbfE1SU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:20:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B63B612DAD572;
        Tue, 28 May 2019 11:20:27 -0700 (PDT)
Date:   Tue, 28 May 2019 11:20:27 -0700 (PDT)
Message-Id: <20190528.112027.1533951620576598756.davem@davemloft.net>
To:     madalin.bucur@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] dpaa_eth: use only online CPU portals
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558959845-30758-1-git-send-email-madalin.bucur@nxp.com>
References: <1558959845-30758-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 11:20:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@nxp.com>
Date: Mon, 27 May 2019 15:24:05 +0300

> Make sure only the portals for the online CPUs are used.
> Without this change, there are issues when someone boots with
> maxcpus=n, with n < actual number of cores available as frames
> either received or corresponding to the transmit confirmation
> path would be offered for dequeue to the offline CPU portals,
> getting lost.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>

Applied.
