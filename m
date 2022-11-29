Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBD763B896
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbiK2DKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235461AbiK2DJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E07391CC
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 19:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D3D56155A
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDECC433C1;
        Tue, 29 Nov 2022 03:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669691393;
        bh=PRPILDn1fBUKUSXfDfIXCj1RD2FUWQIFDf4JM0YZ+tA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=Um8vnSOAv3RmZ7XpN1D5Nv8zlTXSN1oA5qIyB3TVYglg1H6c1e4u34o5vXARChxnO
         uPyOzyk0EyQZrS6Osk9Q6qY1y/LOoQp/5ENrvDDNprf4C28b3iL/C+ln6wVCe8IUEu
         5S/rZyg/ciDY+LPmvaUsDCtuZjeavUOMlb2mNcVdEambG1yy/hBA8QPCcJPvgsBz3s
         fpTxMvPc+vN0mLaLTo+73Y2buaOTogwyZ+Fo3YrbOIksfJufCrBeCPpGG2pgrf1phi
         FiuFQla3nuENwj5fSvgOTO9ugmpowZTQz/nq4CiP/jiWCtotvjWJXcPqPQmr9Hi1t9
         Ev6sI/x5XMxlQ==
Message-ID: <df265cdb-7af7-a881-63ed-4250951c6576@kernel.org>
Date:   Mon, 28 Nov 2022 20:09:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2] udp_tunnel: Add checks for nla_nest_start() in
 __udp_tunnel_nic_dump_write()
Content-Language: en-US
To:     Yuan Can <yuancan@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20221129013934.55184-1-yuancan@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221129013934.55184-1-yuancan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 6:39 PM, Yuan Can wrote:
> As the nla_nest_start() may fail with NULL returned, the return value needs
> to be checked.
> 
> Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
> Changes in v2:
> - return directly without calling nla_nest_cancel if nest_start fails
> 
>  net/ipv4/udp_tunnel_nic.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


