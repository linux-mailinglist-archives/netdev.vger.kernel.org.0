Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA00A62CE13
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiKPWwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiKPWwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:52:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436BB1E703;
        Wed, 16 Nov 2022 14:52:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D554961FF2;
        Wed, 16 Nov 2022 22:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35169C433D6;
        Wed, 16 Nov 2022 22:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668639138;
        bh=GBrrKIhYH0x/WpZZSIEwufRVUqozplMU5SE9ZHpKSgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NyV4tD/iZKp+P1sXXMKJkh2In5PXOIe4r3VFUEzwa/G+ej6LIGLDgCLJKQWDU4PT6
         9Lc4z2t4zl/X0XO2N/WfCv/NjtJzjtncjO3bPk1ylqTp/E8C3jZKMqoKgpRp/D+Z3b
         xNb661X5X2p2moje+49tsYGfzDzonIJMSq4GWmkI89NmDWSvTi8kasFUBFjpWhHOFI
         ylVfjgKoCIDQdtZOgqEEiWIE48UOSX4DfuYW6MKd6UBjIm+QX1BzZnQZsz0t4AsUfE
         HzO+0wN0/d4F0jtE3izfNao07PnMS7LdvEfDl7NK3X3j5MYfjMle8YxL9iRW6RnTDE
         7iVnuLISMaP5A==
Date:   Wed, 16 Nov 2022 14:52:17 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net-next] sctp: move SCTP_PAD4 and SCTP_TRUNC4 to
 linux/sctp.h
Message-ID: <Y3VpoUDGlNiE7lD7@x130.lan>
References: <ef6468a687f36da06f575c2131cd4612f6b7be88.1668526821.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ef6468a687f36da06f575c2131cd4612f6b7be88.1668526821.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Nov 10:40, Xin Long wrote:
>Move these two macros from net/sctp/sctp.h to linux/sctp.h, so that
>it will be enough to include only linux/sctp.h in nft_exthdr.c and
>xt_sctp.c. It should not include "net/sctp/sctp.h" if a module does
>not have a dependence on SCTP module.
>
>Signed-off-by: Xin Long <lucien.xin@gmail.com>

LGTM as long as it builds:
Reviewed-by: Saeed Mahameed <saeed@kernel.org>

