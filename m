Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6D42C87
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbfFLQnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:43:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730601AbfFLQmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:42:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB81715224139;
        Wed, 12 Jun 2019 09:42:50 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:42:50 -0700 (PDT)
Message-Id: <20190612.094250.1851652194156222564.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        rdunlap@infradead.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies for real
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612095037.6472-1-mcroce@redhat.com>
References: <20190612095037.6472-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 09:42:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Wed, 12 Jun 2019 11:50:37 +0200

> Randy reported that selecting MPLS_ROUTING without PROC_FS breaks
> the build, because since commit c1a9d65954c6 ("mpls: fix af_mpls
> dependencies"), MPLS_ROUTING selects PROC_SYSCTL, but Kconfig's select
> doesn't recursively handle dependencies.
> Change the select into a dependency.
> 
> Fixes: c1a9d65954c6 ("mpls: fix af_mpls dependencies")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied.
