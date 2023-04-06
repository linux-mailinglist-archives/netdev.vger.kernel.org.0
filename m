Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804406DA0A5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 21:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjDFTEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 15:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjDFTEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 15:04:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DAE19A7;
        Thu,  6 Apr 2023 12:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6BEE60DF8;
        Thu,  6 Apr 2023 19:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE8C433D2;
        Thu,  6 Apr 2023 19:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680807883;
        bh=tVz3pfAgRzXmBCfyoMy3hUHT9yhsPNfrkqbnp5q3t1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VoYtCarYUn4cyi/71H9NmLbViyEmW6a8kZwUzytx/kzfteaQSyeQQHVyxSCw5EPKp
         ptNPWAQBSvKohjS/N7tdE2PB/FQtMmzmWyeFKUU4SoJqdVrFe6S1R7lZVmhu22b9nS
         m4DFMbF/NiP3wi6q7H5ZwbHNqI41wbtcDN7go9xwRlSSP1Mt0ooaRhmAKgvfU2dJZ+
         ibpVC5Z9/R/FJS0zBVPUCOIvoQfVd1T0l7BuFKN4RGjxkhptLWRs/f+5cbhsSWIN2q
         ivSIGwyikcxHZZTVua2ZEuX+DmUOR9WxHPpCTVAjEiSC9Wzjav7EyRTT2BhLxejsVR
         3yp++bk/E8ZyA==
Date:   Thu, 6 Apr 2023 12:04:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Praveen Kaligineedi <pkaligineedi@google.com>,
        Shailend Chand <shailend@google.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230406120441.1276ef49@kernel.org>
In-Reply-To: <20230406104927.45d176f5@canb.auug.org.au>
References: <20230406104927.45d176f5@canb.auug.org.au>
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

On Thu, 6 Apr 2023 10:49:27 +1000 Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/net/ethernet/google/gve/gve.h
> 
> between commit:
> 
>   3ce934558097 ("gve: Secure enough bytes in the first TX desc for all TCP pkts")
> 
> from the net tree and commit:
> 
>   75eaae158b1b ("gve: Add XDP DROP and TX support for GQI-QPL format")
> 
> from the net-next tree.

I fixed the conflict in net-next but Praveen, Shailend - one of you
called the constant MIN and the other one MAX. So which one is it?
Please send a patch to net-next which removes one of them and uses
the other consistently, they seem to serve the same purpose.
