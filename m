Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF17B287F60
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgJIAHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbgJIAHc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 20:07:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61C9E21D46;
        Fri,  9 Oct 2020 00:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602202051;
        bh=YbT80hsrxwCbTF0rdE6dpScvyQEByaE39uN6fScDSgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cJKk9gUi1Z6IfQIo2nlxn6mNtw9EuzskNYOrG7WmleOs/x2c0dIwUii7z3L2zZY6a
         qAA29DI06sQTSEz36B5FiMtN3MS3Uv9Xhs2rKSFFXfDEFtLV+Hibemfgoz1DMI2V2T
         pBsw9GufZqBL/CmFQJ4jk3GC3JLazy2iH2ygUsdU=
Date:   Thu, 8 Oct 2020 17:07:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] cxgb4: convert tasklets to use new tasklet_setup() API
Message-ID: <20201008170729.7e768447@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006055332.291520-1-allen.lkml@gmail.com>
References: <20201006055332.291520-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 11:23:32 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>

Applied to net-next, thanks!
