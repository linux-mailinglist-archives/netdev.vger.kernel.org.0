Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D049228A3FB
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389326AbgJJWzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbgJJTh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:37:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49131221FE;
        Sat, 10 Oct 2020 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602349428;
        bh=d0LFuyXXJbRxphXVoTE7xJapgi4yM0kVr93JTctrCqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nif7FEXAZPFBPMgF+HoD/XN8C3N3jzWD+luDeDHzdcoHuFElMVxv2+DtBRzbsp+Hi
         ff7M7YsK8mSPltbzzjTZ5G10WFGrbxs7vIx2TqN6xsiks5aA6gHgh4wmB2XP+dqrSw
         5lD2YnIGYc6KQzz0Z8t05rBRMn5gCTxmMMpEnaXI=
Date:   Sat, 10 Oct 2020 10:03:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: usbnet: update  __usbnet_{read|write}_cmd()
 to use new API
Message-ID: <20201010100346.158cbf62@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
References: <20201010065623.10189-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 12:26:23 +0530 Anant Thazhemadam wrote:
> GPF_KERNEL

You haven't even built this, let alone tested :/
