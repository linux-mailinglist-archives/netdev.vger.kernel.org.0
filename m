Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBFC6C8AB3
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjCYDio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjCYDim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:38:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94DEE3B8;
        Fri, 24 Mar 2023 20:38:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EC0DB82664;
        Sat, 25 Mar 2023 03:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA526C433D2;
        Sat, 25 Mar 2023 03:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679715519;
        bh=1cvkHaeQw5tJnRj+hoz3XCfohdWbeMpmRiA/JXaPdBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rXxmpDvE+vygNAhE7dUq2x5EQpYEZYSUIra0TNRt3sRqgkN8n1eA908vkp8dEWzUz
         HrmNtwBWQgGJ20PAAJggAvN7BQqCIgg6WF0IDX+BjCk2z37wK5vbfTIir6/XZ4jcTI
         OVxwl23NXq8tLDVQQ6vnygABv7/mb8L2XmvSQTGvi4uSRn5EqoWIspOZLRjFYzdHJH
         tM4qm1yLH43OBWlqjn3e7KBck/M5brjcMJC8PHxNaHiX0MHOiAemhiJKnj8borgcK2
         w62gVFshvvDGCwSt5ZrG54jxwnaeToZ3LKwz2lcnF9L97tt8DiW2bMKT4rZiBq9Pae
         Nq7aN/nVDNrhQ==
Date:   Fri, 24 Mar 2023 20:38:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 2/7] tools: ynl: Add C array attribute
 decoding to ynl
Message-ID: <20230324203837.1e12be44@kernel.org>
In-Reply-To: <20230324191900.21828-3-donald.hunter@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-3-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 19:18:55 +0000 Donald Hunter wrote:
> Add support for decoding C arrays from binay blobs in genetlink-legacy
> messages.
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>

If Stan's byte-order support gets in first consider supporting
byte-order in arrays as well:
https://lore.kernel.org/r/20230324225656.3999785-2-sdf@google.com/

Otherwise LGTM:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
