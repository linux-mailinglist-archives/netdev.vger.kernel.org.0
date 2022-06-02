Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E86E53B111
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiFBAmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiFBAmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E008223688;
        Wed,  1 Jun 2022 17:42:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E188A615A6;
        Thu,  2 Jun 2022 00:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55582C385A5;
        Thu,  2 Jun 2022 00:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654130531;
        bh=0f5eNwYTWKEQ+kw6O47mzElw8E1vw5toPMR6MPu7lI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eFKEFHIw09tusmoYF73aDT88TJdahvU5Gmpc1Meko+R6IdaiJPn4u3qOzOxorQvda
         26StCkMet21f0iq03/KZG/vADpli+7/PxFveWwaNfHgWp85U6xlCKqblsr2LUvS/FU
         LVQifrG9axhwsPehbKcsMEwe3QOQobwB5vnoqTqdDusu+BgzMoHiI+lW6GxIJMDikH
         aK0Eqn7kqDtDKU4bCB/rKI4k+nLQr4oGSjeWgKzZt+CXsGllAWyWjeB8o1sWWb6afn
         jm2GWZt0A9S0kYBwahVPQoHyHhprArn0tmuNeWhBtTz+PqMBrZ2OF2/d0FDwJO0mS9
         X4FTUgRxMIU1A==
Date:   Wed, 1 Jun 2022 17:42:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, nhorman@tuxdriver.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        imagedong@tencent.com, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] net: dropreason: reformat the comment
 fo skb drop reasons
Message-ID: <20220601174209.1afdb123@kernel.org>
In-Reply-To: <20220601065238.1357624-4-imagedong@tencent.com>
References: <20220601065238.1357624-1-imagedong@tencent.com>
        <20220601065238.1357624-4-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patches LGTM now! net-next is closed until -rc1 is released 
so please repost on/after Monday.

> + * en...maybe they should be splited by group?

nit: since we need a repost - I think we can drop this line.
