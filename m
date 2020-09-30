Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA5B27F185
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgI3SnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgI3SnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:43:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72566C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 11:43:04 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kNh48-00DyWF-LU; Wed, 30 Sep 2020 20:43:00 +0200
Message-ID: <21449c5205a0bf8569842dd86432be46bcff9485.camel@sipsolutions.net>
Subject: Re: Genetlink per cmd policies
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Date:   Wed, 30 Sep 2020 20:42:59 +0200
In-Reply-To: <20200930184210.ojlgmak6slr62aql@lion.mk-sys.cz>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
         <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
         <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
         <20200930184210.ojlgmak6slr62aql@lion.mk-sys.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-30 at 20:42 +0200, Michal Kubecek wrote:
> 
> Not really good either but how about embedding struct genl_ops as first
> member of struct genl_ops_ext like we do with sockets?

That won't work, we need to make an *array* out of these...

johannes

