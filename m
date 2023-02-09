Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4032C6911AE
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 21:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjBIUDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 15:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjBIUDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 15:03:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0127660D5D
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 12:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C7561AB3
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 20:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A84CC433D2;
        Thu,  9 Feb 2023 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675972989;
        bh=nc1DWPaJEGwYrhAtz67ggxlrO2ovQDMV52TdnLYcYJQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mBIY15BZEhh6V2SZxyKC3Xeg7/r4NKneZIrmoVPGWixcvtEvtK7H6yWIBd6iklzih
         YFZ8TOF9ZISQKcrFX6dref4UuPEM8KzaXSqZQhOK0sBkolD40Gz1/oqP4/O4VXkLIv
         eVkMKpNKFdCLZoPFHQzMa/7MFqOm0mALEQnNmnskpDxohdWuMrq4WTzijvl0o76qoh
         Wa+UsWXHL1sZNMk0BM0aqDTPNZ0es73rqajxFiTZCXyJxxXJNLO7X92Ywd7j9IdAVw
         q6P14hWqkm5bTZ1Mh3zNLqMuDL7iduoeEKZnmd0VRZR53SjyBjVXaFZsojfa5p5nJV
         ACk2u5NuLaDiQ==
Message-ID: <6e4e9126-f2a7-8d3f-9fa2-264745d3364e@kernel.org>
Date:   Thu, 9 Feb 2023 13:03:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: ipv6:ping ipv6 address on the same host from the loopback
Content-Language: en-US
To:     gaoxingwang <gaoxingwang1@huawei.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        chenzhen126@huawei.com, liaichun@huawei.com, yanan@huawei.com
References: <20230209134244.3953539-1-gaoxingwang1@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230209134244.3953539-1-gaoxingwang1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/23 6:42 AM, gaoxingwang wrote:
> When I ping another ipv6 address on the same host from the loopback interface, it fails.
> Is this what was expected? Or should it work successfully like ipv4?

IMHO, ipv4 should not work; I do not recall the origins of why it does -
meaning intentional or byproduct of using the loopback device to
"transmit" packets locally.
