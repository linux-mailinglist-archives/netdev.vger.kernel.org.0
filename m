Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449AA2AFC20
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgKLBc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:32:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbgKLAhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 19:37:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC532068E;
        Thu, 12 Nov 2020 00:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605141454;
        bh=Kxdz/475olV2eZAJqK0eMNh5DAsBrO8alQP2v2+p+6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tMlDlwgII+/vq2032Rz7369OG9yf2U8KlZscm3022ogK+96cCFR6yXCI2ntvcxFSE
         mL++m9A/axSP6y6XvvX4ubFNzjfdgNM0cLLr6bAy9ShubhkhvKz+hvYwzBqtMZ1o3g
         ZMDU74DV5IHTsAxLL2seLT8HKwl0qr9SqYNv6u+0=
Date:   Wed, 11 Nov 2020 16:37:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net v6 00/12] cxgb4/ch_ktls: Fixes in nic tls code
Message-ID: <20201111163733.580c91ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109105142.15398-1-rohitm@chelsio.com>
References: <20201109105142.15398-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 16:21:30 +0530 Rohit Maheshwari wrote:
> This series helps in fixing multiple nic ktls issues. Series is broken
> into 12 patches.

Applied.
