Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0F9DDA8A
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfJSSvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:51:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfJSSvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:51:17 -0400
Received: from localhost (unknown [64.79.112.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 606A9148F63AD;
        Sat, 19 Oct 2019 11:51:15 -0700 (PDT)
Date:   Sat, 19 Oct 2019 11:51:14 -0700 (PDT)
Message-Id: <20191019.115114.563831481451365693.davem@davemloft.net>
To:     jgross@suse.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/netback: fix error path of xenvif_connect_data()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191018074549.4778-1-jgross@suse.com>
References: <20191018074549.4778-1-jgross@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 19 Oct 2019 11:51:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Juergen Gross <jgross@suse.com>
Date: Fri, 18 Oct 2019 09:45:49 +0200

> xenvif_connect_data() calls module_put() in case of error. This is
> wrong as there is no related module_get().
> 
> Remove the superfluous module_put().
> 
> Fixes: 279f438e36c0a7 ("xen-netback: Don't destroy the netdev until the vif is shut down")
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Paul Durrant <paul@xen.org>

Applied and queued up for -stable.
