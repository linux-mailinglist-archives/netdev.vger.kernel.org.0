Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F5610A31
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfEAPip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:38:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34742 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfEAPip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:38:45 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3DA5A1473D330;
        Wed,  1 May 2019 08:38:43 -0700 (PDT)
Date:   Wed, 01 May 2019 11:38:42 -0400 (EDT)
Message-Id: <20190501.113842.2247839627720357369.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        alexei.starovoitov@gmail.com, saeedm@mellanox.com,
        simon.horman@netronome.com
Subject: Re: [PATCH net] net/tls: avoid NULL pointer deref on nskb->sk in
 fallback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429191912.13189-1-jakub.kicinski@netronome.com>
References: <20190429191912.13189-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 08:38:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 29 Apr 2019 12:19:12 -0700

> update_chksum() accesses nskb->sk before it has been set
> by complete_skb(), move the init up.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied and queued up for -stable, thanks.
