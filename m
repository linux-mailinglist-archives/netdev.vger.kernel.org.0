Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8336B4DF04
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 04:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfFUCJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 22:09:28 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:46664 "EHLO
        cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFUCJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 22:09:27 -0400
Received: (from localhost user: 'macro', uid#1010) by eddie.linux-mips.org
        with ESMTP id S23990396AbfFUCJX1JN01 (ORCPT
        <rfc822;linux-kernel@vger.kernel.org> + 2 others);
        Fri, 21 Jun 2019 04:09:23 +0200
Date:   Fri, 21 Jun 2019 03:09:23 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@linux-mips.org>
To:     Paul Burton <paul.burton@mips.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Burton <pburton@wavecomp.com>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] FDDI: defza: Include linux/io-64-nonatomic-lo-hi.h
In-Reply-To: <20190620221224.27352-1-paul.burton@mips.com>
Message-ID: <alpine.LFD.2.21.1906210307020.21654@eddie.linux-mips.org>
References: <20190620221224.27352-1-paul.burton@mips.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019, Paul Burton wrote:

> Maciej, David, if you'd be happy to provide an Ack so that I can take
> this through the mips-next branch that would be great; that'll let me
> apply it prior to the asm/io.h change.

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Sure, thanks for doing this work.

  Maciej
