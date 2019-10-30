Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AD8E943E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfJ3Axe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:53:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJ3Axe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:53:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0EE0140C058E;
        Tue, 29 Oct 2019 17:53:33 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:53:33 -0700 (PDT)
Message-Id: <20191029.175333.1750623293752512030.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        simon.horman@netronome.com
Subject: Re: [PATCH net] MAINTAINERS: remove Dave Watson as TLS maintainer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191028221131.2315-1-jakub.kicinski@netronome.com>
References: <20191028221131.2315-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:53:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 28 Oct 2019 15:11:31 -0700

> Dave's Facebook email address is not working, and my attempts
> to contact him are failing. Let's remove it to trim down the
> list of TLS maintainers.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Applied.
