Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8816E9C20
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjDTSzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDTSzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:55:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488A44221
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB42864B52
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1AAC433A8;
        Thu, 20 Apr 2023 18:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682016903;
        bh=NaTkYiztyvoUkrC0zG33CJi2cNo/sAQT6GmoRWyhbaU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gt8VFSkR1Yp68kwPawvf1TbiwxF3ajxCuC05H9jdWliU0NIhwvvtGYWmaCSJpgQGZ
         L5j+ZguTPWWJ3T6P1BNAaU0d8yT1CbdiJX8vPkOuWAj7cqki2TNxhwN1VlXM8qy7/7
         ier+TzcReSpd+9S11Eb3g8oLZvcBHKHJmbCNljatga8vJee0ZO20tUeJMzFwdlahDc
         PWaT8QPlT0vwy7IMesZ8x/DR8tFto/fpQDNNd0aJnHEMZ7lIRRGe9KYgwwIg2w9dIp
         0NTvNGwQgjs9bN7fc5a17xoK1GQO47lOxLe8hKbGNTCEE3C0DbtJD3yFAttQbgj7Tq
         Z8vtURdTyvpsg==
Message-ID: <0097c9fc-2047-fce3-7fc1-b045f58226d8@kernel.org>
Date:   Thu, 20 Apr 2023 12:55:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCHv2 next] ipv6: add icmpv6_error_anycast_as_unicast for
 ICMPv6
Content-Language: en-US
To:     Mahesh Bandewar <maheshb@google.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
References: <20230419013238.2691167-1-maheshb@google.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230419013238.2691167-1-maheshb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/23 7:32 PM, Mahesh Bandewar wrote:
> ICMPv6 error packets are not sent to the anycast destinations and this
> prevents things like traceroute from working. So create a setting similar
> to ECHO when dealing with Anycast sources (icmpv6_echo_ignore_anycast).
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> CC: Maciej Żenczykowski <maze@google.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  7 +++++++
>  include/net/netns/ipv6.h               |  1 +
>  net/ipv6/af_inet6.c                    |  1 +
>  net/ipv6/icmp.c                        | 15 +++++++++++++--
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

