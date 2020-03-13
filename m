Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E103185292
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgCMXyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbgCMXyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 19:54:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2B7D2074E;
        Fri, 13 Mar 2020 23:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584143673;
        bh=0P9xgH7QzMeqwIkpaOz8z3Oty6VKgtDzU10MFU8QqIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SEsD46NmZwwJSYW3lqbSIEGUWlW+cPCbVN/mwhr4gXYDDrvenNCKGLNmumcSR5hYN
         2J474AqFGzxoB1ZlpJUGuMyzxJDjQdxni7ScdTgUKCFVNVwNSaS5n1fVxLnn99hhJy
         KjUDneamQhmJc5it1COWuIwk5FT0RXYsgOrGvw5o=
Date:   Fri, 13 Mar 2020 16:54:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     shuah@kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 3/5] kselftest: run tests by fixture
Message-ID: <20200313165430.7f7e35b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <202003131626.8EF371151@keescook>
References: <20200313031752.2332565-1-kuba@kernel.org>
        <20200313031752.2332565-4-kuba@kernel.org>
        <202003131626.8EF371151@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 16:27:54 -0700 Kees Cook wrote:
> On Thu, Mar 12, 2020 at 08:17:50PM -0700, Jakub Kicinski wrote:
> > Now that all tests have a fixture object move from a global
> > list of tests to a list of tests per fixture.
> > 
> > Order of tests may change as we will now group and run test
> > fixture by fixture, rather than in declaration order.  
> 
> I'm not convinced about this change. Declaration order is a pretty
> intuitive result that I'd like to keep for the harness.
> 
> Can this change be avoided and still keep the final results of a
> "mutable" fixture?

Sure! I will abandon the reorg of the lists then, keep just the list of
tests, and have each test point to its fixture. Which then may contain
param sets.
