Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE49150BA83
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448860AbiDVOrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 10:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448847AbiDVOrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 10:47:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB70F5C348;
        Fri, 22 Apr 2022 07:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qm/VzgM1YV+toreS1622ZysIy2YqAAfNXvFrk/+uF+E=; b=gFLosF+dGwCLU1geoEIXz26n7v
        8WbrQmAtMUl67UVqPerNr7ENxc20ctUFiN4yjbcS7FaezlE2izax7Hkxn/HObMNuO34QB3mfH0MtG
        /qKiPzbLwISlsX+KxB7JWlyafP3Y6H0GEIAXqDl8kLRIE/s4Eby/pUOVzOKkdt6iezrIssG4gKtSt
        aN5qBqLPkutVd+6wjo+9hcmPmdWNDW+lIArWoD126pqd3NB3TRNM/idDF5pPLJrWJ7e8R5/wlvexj
        NHT1sByiZuFju8fCEeDrAxwUU/t1z8ZT3mqCTySxXPUkZDJTQHsVP3vemKHAbaTVfYFHrST6IWRl7
        ANh74N4g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nhuW4-000sQV-Ji; Fri, 22 Apr 2022 14:44:12 +0000
Date:   Fri, 22 Apr 2022 07:44:12 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next v4 0/3] use standard sysctl macro
Message-ID: <YmK/PM2x5PTG2b+c@bombadil.infradead.org>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 03:01:38PM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> This patchset introduce sysctl macro or replace var
> with macro.
> 
> Tonghao Zhang (3):
>   net: sysctl: use shared sysctl macro
>   net: sysctl: introduce sysctl SYSCTL_THREE
>   selftests/sysctl: add sysctl macro test

I see these are based on net-next, to avoid conflicts with
sysctl development this may be best based on sysctl-next
though. Jakub?

  Luis
