Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF236DB899
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjDHDYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjDHDYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:24:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A15A2727
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 20:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1401F653B8
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C940C433EF;
        Sat,  8 Apr 2023 03:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680924253;
        bh=qP4WiLxKBsLISuHI5Dc0WlpsorQ/csgvOebhozSr/D8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NdXIQTnkcBQvTgTfiZjPP2TT9sJJihtAPw9MJNlxbGTZerZWRN3IhNT+1Whs2scTu
         Lk3I4VRl1VsWcCiyLSfBXhlXl1XcYmdbkNqcPVUrhJfuHDLoVOs2wYuwSYhh8iW4Hz
         vodTWCRtc1C1qpke7hieYS0xfY1saqSB+1KwrAIhlu7y5lq5nL01eeZpzEebm0fvuy
         P5r8ZjR/crleWUxoUPEvZQUu+YxNaW8m51byeWSsDd9W3fUu6oSwFfoCXdEF0vXdtR
         6/wspgkyBFxkhYPY/FL0U2pLZUh0QrTg88AsZO4vZWN3flFLT2RHm9KC5NsKywJN/c
         o+1C52g76XlSA==
Date:   Fri, 7 Apr 2023 20:24:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shailend Chand <shailend@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] gve: Unify duplicate GQ min pkt desc size
 constants
Message-ID: <20230407202412.6c438a55@kernel.org>
In-Reply-To: <20230407184830.309398-1-shailend@google.com>
References: <20230407184830.309398-1-shailend@google.com>
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

On Fri,  7 Apr 2023 11:48:30 -0700 Shailend Chand wrote:
> The two constants accomplish the same thing.
> 
> Signed-off-by: Shailend Chand <shailend@google.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
