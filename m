Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BF8263632
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgIISoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgIISn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:43:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A02C061755;
        Wed,  9 Sep 2020 11:43:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kG54V-0004aL-Ji; Wed, 09 Sep 2020 20:43:55 +0200
Date:   Wed, 9 Sep 2020 20:43:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fabian Frederick <fabf@skynet.be>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/3 nf] selftests: netfilter: add cpu counter check
Message-ID: <20200909184355.GR7319@breakpoint.cc>
References: <20200909182536.23730-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909182536.23730-1-fabf@skynet.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fabian Frederick <fabf@skynet.be> wrote:
> run task on first CPU with netfilter counters reset and check
> cpu meta after another ping

Thanks!

Acked-by: Florian Westphal <fw@strlen.de>
