Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3DCF36F965
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 13:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhD3Lha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 07:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhD3Lh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 07:37:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366AFC06174A;
        Fri, 30 Apr 2021 04:36:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lcRRg-0023WH-DF; Fri, 30 Apr 2021 13:36:32 +0200
Message-ID: <3a0671bd6a9650fdcdf5cb8414526f6204518774.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Remove redundant assignment to ret
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Fri, 30 Apr 2021 13:36:31 +0200
In-Reply-To: <1619774483-116805-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1619774483-116805-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-04-30 at 17:21 +0800, Yang Li wrote:
> Variable 'ret' is set to -ENODEV but this value is never read as it
> is overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> net/mac80211/debugfs_netdev.c:60:2: warning: Value stored to 'ret' is
> never read [clang-analyzer-deadcode.DeadStores]

Can you just turn that warning off?

It's really quite pointless to churn the tree for effectively nothing.

johannes

