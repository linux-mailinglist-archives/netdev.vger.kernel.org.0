Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4082E2CB22B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgLBBPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgLBBPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:15:53 -0500
Date:   Tue, 1 Dec 2020 17:15:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606871713;
        bh=+gV/WksK6D9OJRf8W8E6Iubi+vr/EFdzLFGIRaN9s3g=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=DwR/lSLRjMQGwEz6gxutrx0xLBcotQhxMJuyYisxiXHQatCMnOlC1RON8Ms90EJPH
         yOO4Iv13FDIClBqLCMac41DdhRxL/n2Yon4PYdK9IYQkVpRw67oNMV653ZSznZ3Fap
         hqlO7L7RRW9Rv3MyRHh917Av4pScLmrJnppkZlxM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 0/2] ionic updates
Message-ID: <20201201171511.0c70e47d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201002546.4123-1-snelson@pensando.io>
References: <20201201002546.4123-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 16:25:44 -0800 Shannon Nelson wrote:
> These are a pair of small code cleanups.

Applied, thanks!
