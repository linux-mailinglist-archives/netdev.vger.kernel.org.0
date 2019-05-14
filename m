Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE311E56F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 01:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfENXDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 19:03:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfENXDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 19:03:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DF5E14C12428;
        Tue, 14 May 2019 16:03:40 -0700 (PDT)
Date:   Tue, 14 May 2019 16:03:39 -0700 (PDT)
Message-Id: <20190514.160339.393345500614325.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        pieter.jansenvanvuuren@netronome.com, john.hurley@netronome.com
Subject: Re: [PATCH net] nfp: flower: add rcu locks when accessing netdev
 for tunnels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190514212819.7789-1-jakub.kicinski@netronome.com>
References: <20190514212819.7789-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 May 2019 16:03:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 14 May 2019 14:28:19 -0700

> From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> 
> Add rcu locks when accessing netdev when processing route request
> and tunnel keep alive messages received from hardware.
> 
> Fixes: 8e6a9046b66a ("nfp: flower vxlan neighbour offload")
> Fixes: 856f5b135758 ("nfp: flower vxlan neighbour keep-alive")
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: John Hurley <john.hurley@netronome.com>

Applied and queued up for -stable.
