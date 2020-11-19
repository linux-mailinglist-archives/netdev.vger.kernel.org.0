Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA2F2B8928
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgKSAp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgKSAp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:45:56 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E4AF2467A;
        Thu, 19 Nov 2020 00:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605746755;
        bh=7iwE2nJhJPLK2m97X/tQFFY7Zib/UNMs7j8PdP7D/dU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TlEdzrHmmexDXrICBv9rG+Qu4jBcqkwsMPATOaA9cfhgLxgjhsh7zno+xoWWhgkL8
         h0ay/v0zc7rmNhQYwbZx+gByus41JtcVGdshCNK+ObZZByAUNNa6V4qDAd7359tpMl
         VQa16GUenbzUZmuaXtWA5uZPrqmDZteG6+fYcvNc=
Date:   Wed, 18 Nov 2020 16:45:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-atm-general@lists.sourceforge.net,
        Chas Williams <3chas3@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] atm: Replace in_interrupt usage
Message-ID: <20201118164554.08ff796e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201116162117.387191-1-bigeasy@linutronix.de>
References: <20201116162117.387191-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 17:21:13 +0100 Sebastian Andrzej Siewior wrote:
> Folks,
> 
> this mini series contains the removal of in_interrupt() in drivers/atm
> and a tiny bugfix while staring into code.

Applied, thanks.
