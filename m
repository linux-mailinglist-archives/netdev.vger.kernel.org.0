Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849D641FF33
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 04:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhJCCYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 22:24:38 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:34290 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhJCCYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 22:24:37 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id EA2C720274;
        Sun,  3 Oct 2021 10:22:47 +0800 (AWST)
Message-ID: <7e6403c499f2483edeb34dccef5cbd27dec4e47d.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next 1/2] mctp: test: disallow MCTP_TEST when
 building as a module
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, matt@codeconstruct.com.au,
        brendanhiggins@google.com, linux-kselftest@vger.kernel.org
Date:   Sun, 03 Oct 2021 10:22:47 +0800
In-Reply-To: <20211002.140152.1798934215442988990.davem@davemloft.net>
References: <20211002022656.1681956-1-jk@codeconstruct.com.au>
         <20211002.140152.1798934215442988990.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> Jeremy I had to revert your entire series because of this.
> 
> You will need rseubmit the entire series with this build failure
> fixed.

OK, thanks for letting me know, apologies for the breakage. Looks like
my MCTP=m pre-send check didn't end up enabling MCTP_TEST...

v2 coming shortly.

Cheers,


Jeremy

