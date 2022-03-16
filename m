Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CB04DB926
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352561AbiCPUG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241944AbiCPUG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:06:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBDB6E2B6;
        Wed, 16 Mar 2022 13:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6054AB81CCF;
        Wed, 16 Mar 2022 20:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EF8C340E9;
        Wed, 16 Mar 2022 20:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647461140;
        bh=jUzwjh3mWnd4XiAMgVaql4abbZ0+nKiGDcP6zwjeN7M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n/9DmroDqbcKeuNI+dbGCSSFkCP3kyepRfPV9G+cufPNplufi97HkosJ0P3W3X8nl
         J3wn1dTw5f6vbHKXKAJh0o83WBn5VumWGwtZwZTm74ZhGWQ5FGE9YEZ3TvQQ8QsnV4
         Qmlbg6sorRHTIBbqf+MAP79Ls1ekwAz6O+hDIPJZMmMrQ3NfWGZSVLJAMB318fU0og
         NDsEwwRGsdAFZZNCbwMzRj1iCRgdCa9vk+UxRMoPxWhRnCL0ZW93k44v8KsMxN8d9u
         G5SmPpu52Y777fPfOuGo1jR2ZmqtCvZhbjXSsvFhkFWTP8GKITKp5d+RmKDs3Wfh5w
         t7zxarC2WdUGQ==
Date:   Wed, 16 Mar 2022 13:05:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        oliver@neukum.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v3 0/4] net:bonding:Add support for IPV6 RLB to
 balance-alb mode
Message-ID: <20220316130537.3f43d467@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316084958.21169-1-sunshouxin@chinatelecom.cn>
References: <20220316084958.21169-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 04:49:54 -0400 Sun Shouxin wrote:
> This patch is implementing IPV6 RLB for balance-alb mode.

Patches 1, 2 and 3 do no build individually. Please build test each
patch to avoid breaking bisection.
