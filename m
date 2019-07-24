Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7787416E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfGXWaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:30:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfGXWaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:30:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5BEA1543BD22;
        Wed, 24 Jul 2019 15:30:13 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:30:13 -0700 (PDT)
Message-Id: <20190724.153013.980401136476976734.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com, simon.horman@netronome.com,
        ast@kernel.org
Subject: Re: [PATCH net-next] net/tls: add myself as a co-maintainer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724180248.6480-1-jakub.kicinski@netronome.com>
References: <20190724180248.6480-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:30:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 24 Jul 2019 11:02:48 -0700

> I've been spending quite a bit of time fixing and
> preventing bit rot in the core TLS code. TLS seems
> to only be growing in importance, I'd like to help
> ensuring the quality of our implementation.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Simon Horman <simon.horman@netronome.com>

I'll aplly this to 'net', thanks.
