Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D9DC0952
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 18:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfI0QOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 12:14:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbfI0QOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 12:14:45 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87A46153BD1DB;
        Fri, 27 Sep 2019 09:14:42 -0700 (PDT)
Date:   Fri, 27 Sep 2019 18:14:38 +0200 (CEST)
Message-Id: <20190927.181438.1266274829431178042.davem@davemloft.net>
To:     paul@paul-moore.com
Cc:     Markus.Elfring@web.de, navid.emamdoost@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        emamd001@umn.edu, kjlu@umn.edu, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, smccaman@umn.edu
Subject: Re: genetlink: prevent memory leak in netlbl_unlabel_defconf
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHC9VhRk8Gc_Yexrjz5uif+Vj7d+b=uMUytbrmbm2Yv+zoM05w@mail.gmail.com>
References: <CAHC9VhR+4pZObDz7kG+rxnox2ph4z_wpZdyOL=WmdnRvdQNH9A@mail.gmail.com>
        <c490685a-c7d6-5c95-5bf4-ed71f3c60cb6@web.de>
        <CAHC9VhRk8Gc_Yexrjz5uif+Vj7d+b=uMUytbrmbm2Yv+zoM05w@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 09:14:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>
Date: Fri, 27 Sep 2019 10:48:54 -0400

> From what I've seen the "Fixes" tag is typically used by people who
> are backporting patches, e.g. the -stable folks, to help decide what
> they need to backport.

Fixes: tags say what commit introduced the code being fixed, whether
it manifests in a real problem or not.

It has nothing directly to do with -stable and exists in it's own right
whether a change gets backported to -stable or not.
