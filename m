Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C476EDA03
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbjDYBr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbjDYBre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:47:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1701C7A80
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:47:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A919E61E24
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46BAC433D2;
        Tue, 25 Apr 2023 01:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682387252;
        bh=WhJRoNOv06TNk/L/HsiiUAY8lXLH9tWgKSGf9BXesVQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=o8Ub58+rgO6BFP+p4iGfDId6bXmgg/aEdRZXfo00LYBfCWTatTuo+sYvSvR/wvv6I
         7oEjXPzIo+hd0K08DWQExOpEHXCPM8ZE/oBBlor6GNaA0lzRhLuT85thc+ur8oK88/
         q32GJcMLcKq+omqTA51J+K2XFecgA9MLIGHa5KBjAe/b7y4wW9aqO2EVDsKQ97ceIb
         tWbgTxzD4kCDs5UAwIAwtW3Qq7Ak9WQhpqrlLLVuKVS0aEo+EMy91kl5tA1urCS+1C
         4XTfgt2a8OmG8Uk5UIiT5EnhRoLqsitxOu8hUKLUElGn06eAcnpCzKujqNwV1ultTV
         HavPXfdpZOc+w==
Message-ID: <5575810d-ceee-7b7b-fba4-e14e5ca6e412@kernel.org>
Date:   Mon, 24 Apr 2023 19:47:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2 iproute2-next 00/10] Add tc-mqprio and tc-taprio
 support for preemptible traffic classes
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
 <535c37f2-df90-ae4b-5b5a-8bf75916ad22@kernel.org>
 <20230422165945.7df2xbpeg3llgt7x@skbuf>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230422165945.7df2xbpeg3llgt7x@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/23 10:59 AM, Vladimir Oltean wrote:
> Unless there are changes I need to make to the contents of the patches,
> could you take these from the lists, or is that a no-no?

iproute2 follows the netdev dev model with a main tree for bug fixes and
-next tree for features. In the future please separate out the patches
and send with proper targets. If a merge is needed you can state that in
the cover letter of the set for -next.
