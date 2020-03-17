Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44756188C90
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgCQRwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:52:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgCQRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 13:52:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EADC020714;
        Tue, 17 Mar 2020 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584467542;
        bh=OWHfxMncdeelzCj+fHHy7yIJhg9mrAB8/Rr2nsGdRwk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=owaQNJslKZQ8oJw8QgoHTJjZd4NKkLct2RojX6KQlVxDje6YoZ0sy/jKO4EDM/Ewa
         CJWOoJzHrLSMgzpMDYVzyQTaIDYLdWnsyxU1f6xX2THlsrJUMcRIkNgeB4apVw4nj/
         IbqAwzzjZeAnpa79gcHaILWkHtvniFbFPtwTh/Gk=
Date:   Tue, 17 Mar 2020 10:52:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 09/11] devlink: Add new enable_ecn generic
 device param
Message-ID: <20200317105220.3ae07cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1584458246-29370-3-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458246-29370-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1584458246-29370-3-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 20:47:24 +0530 Vasundhara Volam wrote:
> From: Pavan Chebbi <pavan.chebbi@broadcom.com>
> 
> Add new device parameter to enable/disable handling of Explicit
> Congestion Notification(ECN) in the device.
> 
> This patch also addresses comments from Jiri Pirko, to update the
> devlink-info.rst documentation.
> 
> Cc: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Nacked-by: Jakub Kicinski <kuba@kernel.org>

We've been over this multiple times. Devlink is not for configuring
forwarding features. Use qdisc offload.
