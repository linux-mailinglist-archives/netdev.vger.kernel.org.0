Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC814F8CD3
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiDHCkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 22:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiDHCkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 22:40:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA0F102424;
        Thu,  7 Apr 2022 19:38:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62EF4CE29DA;
        Fri,  8 Apr 2022 02:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AAFC385A0;
        Fri,  8 Apr 2022 02:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649385509;
        bh=s5ixvDNITfgSHahK5E+OM7MgUQMNYPFTNm1hieAfez0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j1nYvznKzvHmSTATQgK62im9zqf20J5QddcqysoyaoLleFQd/u4QuQjb1Rr3iXdBc
         NnyZP4l3MUBgQ7wSbUdqohZuHAi0PIcP6bUpNKe7au4iGkOjPw+tPAN62fQzXYfl3X
         tMeviCT7JFwXICj0oT2r/DE4tUsKtVQexET190b84IZCBptY9u03HgjWoB7b3wqjhy
         DU+H4/I0phC860SXS1er+U9R6rZ5grZaWN5YnIMwtcbsMT1rgR9ML8KZT1B+YKV/bJ
         g/KhsxBD2xRBVncm+2w7FgNrzUN0BFMW+BRtHYSgEnRssGM+A+IR9ebE+ZaOpquAYX
         iFlOCTJ5sV5uA==
Date:   Thu, 7 Apr 2022 19:38:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ethernet: Fix some formatting issues
Message-ID: <20220407193828.6c95928c@kernel.org>
In-Reply-To: <1649327764-29869-1-git-send-email-baihaowen@meizu.com>
References: <1649327764-29869-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022 18:36:04 +0800 Haowen Bai wrote:
> reported by checkpatch.pl

Please don't send "checkpatch fixes" for networking.

> WARNING: suspect code indent for conditional statements (16, 16)
> #732: FILE: drivers/net/ethernet/3com/3c589_cs.c:732:
> CHECK: Alignment should match open parenthesis
> #733: FILE: drivers/net/ethernet/3com/3c589_cs.c:733:
> CHECK: Alignment should match open parenthesis
> #735: FILE: drivers/net/ethernet/3com/3c589_cs.c:735:
> WARNING: suspect code indent for conditional statements (16, 16)
> #736: FILE: drivers/net/ethernet/3com/3c589_cs.c:736:
> CHECK: Alignment should match open parenthesis
> #737: FILE: drivers/net/ethernet/3com/3c589_cs.c:737:
> CHECK: Alignment should match open parenthesis
> #739: FILE: drivers/net/ethernet/3com/3c589_cs.c:739:
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
