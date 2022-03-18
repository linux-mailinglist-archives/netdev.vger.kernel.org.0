Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3E4DDF25
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiCRQeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiCRQe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A5A22AC7A;
        Fri, 18 Mar 2022 09:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E990B61865;
        Fri, 18 Mar 2022 16:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5B9C340E8;
        Fri, 18 Mar 2022 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647621187;
        bh=xtSwSPaoFLC5ehk1fTDfehgtPHunIjRVtLC4eP8LWBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W7Gzt4NbQxu+sP6dj0hqQISSSRDRMdJwCP3ou48EYo/MvtaHSrTM4SZb9MXxDGbFx
         dm6q+zYgqlkShQY3/+mhhOZMbI6ch0AQol0zoOuGCNx3YtrHBZQBaNJiZq3bWVV7FB
         0yedbH2TNlfCrGavJV61Xk3tzk9vaIlBMHzqibDzHUiW853EPgJbfM+uTiztbT0jcB
         WSbG7g7AqA+Hl+73p+OLQ4Ju5Sq1PmJnBvBWQW10LvDBXHutnxFVzGcxJ3CnCXlO85
         C/04/nMcDY4vigmF8mlpxILy3ar6a3UIK3UYbVj/mfuUqAcf9KiQHi3moyH6PYfLNZ
         AjxuqgSjgRrKQ==
Date:   Fri, 18 Mar 2022 09:33:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guo Zhengkui <guozhengkui@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        zhengkui_guo@outlook.com
Subject: Re: [PATCH linux-next v2] selftests: net: change fprintf format
 specifiers
Message-ID: <20220318093300.2938e068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220318075013.48964-1-guozhengkui@vivo.com>
References: <1d21ee8a-837d-807d-14a4-4ee1af640089@vivo.com>
        <20220318075013.48964-1-guozhengkui@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 15:50:13 +0800 Guo Zhengkui wrote:
> `cur64`, `start64` and `ts_delta` are int64_t. Change
> format specifiers in fprintf from '%lu' to '%ld'.
> 
> It has been tested with gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0
> on x86_64.

No, not like that. Please read up on printing int64_t.
