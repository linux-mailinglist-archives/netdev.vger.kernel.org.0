Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1504E6AFB
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355596AbiCXXFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346914AbiCXXFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:05:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7FC1CB2A;
        Thu, 24 Mar 2022 16:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A089561679;
        Thu, 24 Mar 2022 23:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF66EC340EC;
        Thu, 24 Mar 2022 23:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648163041;
        bh=TU26cq1OfZeGc7sMNsqoZvVuxIL8l02NH5svgPEtQII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oUR4c1bEzAGEay1rJpZUVunyvYPejXi3X7f2SBF7OiuVle/PdIOrYHI+60uQAXrgB
         HqL3Wxt1xtEt4kpxBngBuEfLeidSCLo6aGOHD+nNumu7gM3JA0KMiMBWnzgUzAlZYY
         BC6pXC5doUVKq7nizoWNgNgEVK7aqvjxNrtg6gK7fNNMrj8X/qVUKhPIQIDaJVZW+g
         R5gGHfIjEpCWp4e580IpsRN6aG9MNaxRPHzVGU9UPyA6jtvDTfgEvmDQNI0RmGfYa3
         byta2kA9C7wtD2AKyAViZ7k8FecTS/gA9OjgwxvVG/DTG0ZMbfAEjFHniRfy5TSRip
         cHNY2keZ6Z16g==
Date:   Thu, 24 Mar 2022 16:03:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Long Xin <lxin@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bond: add mac filter option for balance-xor
Message-ID: <20220324160359.667e13d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b03f0896e1a0b65cc1b278aecc9d080b2ec9d8a6.1648136359.git.jtoppins@redhat.com>
References: <b03f0896e1a0b65cc1b278aecc9d080b2ec9d8a6.1648136359.git.jtoppins@redhat.com>
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

On Thu, 24 Mar 2022 11:54:41 -0400 Jonathan Toppins wrote:
> Attempt to replicate the OvS SLB Bonding[1] feature by preventing
> duplicate frame delivery on a bond whos members are connected to
> physically different switches.
> 
> Combining this feature with vlan+srcmac hash policy allows a user to
> create an access network without the need to use expensive switches that
> support features like Cisco's VCP.

# Form letter - net-next is closed

We have already sent the networking pull request for 5.18
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.18-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
