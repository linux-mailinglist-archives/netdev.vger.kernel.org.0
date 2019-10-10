Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290DBD2F96
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfJJRaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:30:18 -0400
Received: from ms.lwn.net ([45.79.88.28]:60756 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfJJRaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 13:30:17 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 382F45A0;
        Thu, 10 Oct 2019 17:30:17 +0000 (UTC)
Date:   Thu, 10 Oct 2019 11:30:16 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?= <j.neuschaefer@gmx.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: networking: devlink-trap: Fix reference to other
 document
Message-ID: <20191010113016.4d2046d4@lwn.net>
In-Reply-To: <20191003190536.32463-1-j.neuschaefer@gmx.net>
References: <20191003190536.32463-1-j.neuschaefer@gmx.net>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Oct 2019 21:05:36 +0200
Jonathan Neuschäfer <j.neuschaefer@gmx.net> wrote:

> This fixes the following Sphinx warning:
> 
> Documentation/networking/devlink-trap.rst:175: WARNING: unknown document: /devlink-trap-netdevsim
> 
> Fixes: 9e0874570488 ("Documentation: Add description of netdevsim traps")
> Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>

Applied, thanks.

jon
