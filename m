Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F924E7C30
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiCYXtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 19:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiCYXth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 19:49:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B52532ED5;
        Fri, 25 Mar 2022 16:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7B861301;
        Fri, 25 Mar 2022 23:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683BEC004DD;
        Fri, 25 Mar 2022 23:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648252082;
        bh=bVEYqWWkC9PUJo4OJT2wRbEodCot5lPTmYZu9YU7slA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yd83BjBbgktdVSBUEbRBbyN2eOw+1tRty3i4i3FzoeKokmvmLqiTKPtyP2e3EbxDB
         FUyWG09HtVB/GeZikT7q2ipGpztQqMssQKRJF4DO8ulZjqLyx8Um6aXo4ZdPobv88E
         +OenpS4Ay28G8qLHT8wcpGVCJeJrK6uYbYoCYTQz4dnDQeCLQo6F5/HnPLaKDbAhj9
         BHsv+XCrwk8aQjId0IKIKRHJw0MzAPLgLT1Ycllt4XDW+kBqVMUXfZt1coPagb4zhO
         VB2/HVqKQCUxpkjz2A6DQLC3fH7/313wV0hzoYjROVHrPyHg98w/xVHs+0cvP0iYSH
         +v9TgvTOVtHsw==
Date:   Fri, 25 Mar 2022 16:48:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mukesh Savaliya <msavaliy@codeaurora.org>,
        Akash Asthana <akashast@codeaurora.org>,
        Bayi Cheng <bayi.cheng@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Min Guo <min.guo@mediatek.com>, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix missing '/schemas' in $ref paths
Message-ID: <20220325164800.3c7f1c71@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220325215652.525383-1-robh@kernel.org>
References: <20220325215652.525383-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 16:56:52 -0500 Rob Herring wrote:
> Absolute paths in $ref should always begin with '/schemas'. The tools
> mostly work with it omitted, but for correctness the path should be
> everything except the hostname as that is taken from the schema's $id
> value. This scheme is defined in the json-schema spec.
> 
> Cc: Hector Martin <marcan@marcan.st>
> Cc: Sven Peter <sven@svenpeter.dev>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
