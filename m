Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16555E8FB1
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732231AbfJ2TIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:08:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58436 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728522AbfJ2TIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 15:08:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35DFD14D69E2D;
        Tue, 29 Oct 2019 12:08:13 -0700 (PDT)
Date:   Tue, 29 Oct 2019 12:08:09 -0700 (PDT)
Message-Id: <20191029.120809.331773295638073169.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: return directly from dsa_to_port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025184853.1375840-1-vivien.didelot@gmail.com>
References: <20191025184853.1375840-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 12:08:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Fri, 25 Oct 2019 14:48:53 -0400

> Return directly from within the loop as soon as the port is found,
> otherwise we won't return NULL if the end of the list is reached.
> 
> Fixes: b96ddf254b09 ("net: dsa: use ports list in dsa_to_port")
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied, thanks.
