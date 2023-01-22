Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD95A677072
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 17:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjAVQWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 11:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjAVQWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 11:22:07 -0500
X-Greylist: delayed 567 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 22 Jan 2023 08:22:06 PST
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0004D1E28E;
        Sun, 22 Jan 2023 08:22:06 -0800 (PST)
Received: from madeliefje.horms.nl (86-88-72-229.fixed.kpn.net [86.88.72.229])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 811E720095;
        Sun, 22 Jan 2023 16:12:07 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id 121EB4899; Sun, 22 Jan 2023 17:12:07 +0100 (CET)
Date:   Sun, 22 Jan 2023 17:12:07 +0100
From:   Simon Horman <horms@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ffmancera@riseup.net
Subject: Re: [PATCH net-next] netfilter: nf_tables: fix wrong pointer passed
 to PTR_ERR()
Message-ID: <Y81gVzRgIHTc6erY@vergenet.net>
References: <20230119075125.3598627-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119075125.3598627-1-yangyingliang@huawei.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.7 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 03:51:25PM +0800, Yang Yingliang wrote:
> It should be 'chain' passed to PTR_ERR() in the error path
> after calling nft_chain_lookup() in nf_tables_delrule().
> 
> Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
