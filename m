Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32184E602C
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 02:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfJ0Bbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 21:31:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50796 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfJ0Bbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 21:31:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4642314EC2C84;
        Sat, 26 Oct 2019 18:31:45 -0700 (PDT)
Date:   Sat, 26 Oct 2019 18:31:44 -0700 (PDT)
Message-Id: <20191026.183144.1686578062519734985.davem@davemloft.net>
To:     aroulin@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH iproute2-net-next 0/3] pretty-print 802.3ad slave state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 26 Oct 2019 18:31:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nope, this is not how you do this.

Kernel changes and iproute2 changes must be submitted separately.

I'm tossing all of this, sorry.
