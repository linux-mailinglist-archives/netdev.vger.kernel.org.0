Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AACD536998
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 03:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355333AbiE1BIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 21:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiE1BIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 21:08:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99540ED79F;
        Fri, 27 May 2022 18:08:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F54FB82658;
        Sat, 28 May 2022 01:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26968C34113;
        Sat, 28 May 2022 01:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653700131;
        bh=BHdO//WFdywzaAtxnWELfFNsd3t16H2AK+RSIjth62Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N3A+ayqXSJHBK0dACaRK4ZQqVBALscjvXc3z6cXfLcf0PBn+Y7+u6g4xSSxT1EWJC
         53lA6Ztd62uJ958r9EOLk/8farpnXsiUTKW7zt5a9d46vTD5OqcpfzkOMNKhUU+HuU
         AvuyeoXVaY+cQzhkeCSPfgpQZup9jc7wc44jfWYqCl3xlqUL01zfYvyu1+asF7P/h+
         O2toKSTUCAGv6oByLuR6Q9cEufrTNqY0UFyQVEb2Ae7+Lu5WMDwHP1REq065fT/Q4f
         5yP8OgVPSDIaEy9RVCyvb+Q4UhYkcc8bmP1vHk5BLJAqV5mfbq3PNJZnLV8eBOcoWz
         9PzhVKo+v3ASA==
Date:   Fri, 27 May 2022 18:08:48 -0700
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
Subject: Re: [PATCH net-next 1/3] net: skb: move enum skb_drop_reason to
 standalone header file
Message-ID: <20220527180848.25f9e199@kernel.org>
In-Reply-To: <20220527071522.116422-2-imagedong@tencent.com>
References: <20220527071522.116422-1-imagedong@tencent.com>
        <20220527071522.116422-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 May 2022 15:15:20 +0800 menglong8.dong@gmail.com wrote:
> +++ b/include/linux/dropreason.h

include/net is probably a better location for it
