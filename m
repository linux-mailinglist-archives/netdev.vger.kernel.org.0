Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335245F3253
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 17:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiJCPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 11:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiJCPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 11:08:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC4F1BEBE;
        Mon,  3 Oct 2022 08:08:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 154C06112C;
        Mon,  3 Oct 2022 15:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47829C433D6;
        Mon,  3 Oct 2022 15:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664809698;
        bh=C+CZk1YQmG4Nl0fE3khgE4JYTLKeLdL8INghkpzax3A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m7uXDxfNuxFKs9e2UyNFN5u1L/Al+OoxCkNyASddpHREo9TiyPCFCF8a0f4MGrgCc
         71+ZNFOLnJdypbq0GitYSv8aGQlRbc4129k+0o+VAkFQP4VMByebpDUAttf/mgZLD6
         3ZHOMBPMwYDfTgRUSby1YIuChYm57QjZpMzM/e23JIY5O5a2mxEszVrKrStGFrtp44
         sRjaAROkYuuHYV8ACBPurC2VCBalrsE7JdBbsBW6kb5G7a/LXP47R/FXPEotbGh/eq
         TKnbH7+3G7drhNYxCw3G6oJDF9n83872QMrOFaGESoyq+Gjc1wo/FtrV14cUs/i++7
         E7A+nh8/rNw9g==
Date:   Mon, 3 Oct 2022 08:08:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jianghaoran <jianghaoran@kylinos.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2] taprio: Set the value of picos_per_byte before fill
 sched_entry
Message-ID: <20221003080817.27dfd103@kernel.org>
In-Reply-To: <20221001080626.464349-1-jianghaoran@kylinos.cn>
References: <20220928065830.1544954-1-jianghaoran@kylinos.cn>
        <20221001080626.464349-1-jianghaoran@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  1 Oct 2022 16:06:26 +0800 jianghaoran wrote:
> Fixes: b5b73b26b3ca ("taprio: Fix allowing too small intervals")

Please note that whenever you put a Fixes tag in a patch you should CC
the authors of the commit in question. get_maintainer will point them
out to you (when run on the patch).
