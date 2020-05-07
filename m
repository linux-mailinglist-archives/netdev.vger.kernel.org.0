Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03A21C9B81
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgEGUAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726320AbgEGUAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:00:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5A5C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 13:00:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 071F211950773;
        Thu,  7 May 2020 13:00:43 -0700 (PDT)
Date:   Thu, 07 May 2020 13:00:43 -0700 (PDT)
Message-Id: <20200507.130043.1453341586543577224.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     johan@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] usb: hso: correct debug message
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507094949.11121-1-oneukum@suse.com>
References: <20200507094949.11121-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:00:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu,  7 May 2020 11:49:49 +0200

> If you do not find the OUT endpoint, you should say so,
> rather than copy the error message for the IN endpoint.
> Presumably a copy and paste error.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Applied, thank you.
