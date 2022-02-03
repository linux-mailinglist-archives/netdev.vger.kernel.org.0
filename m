Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A5A4A9014
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbiBCVlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiBCVly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 16:41:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB1AC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 13:41:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C26461667
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 21:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA2EC340E8;
        Thu,  3 Feb 2022 21:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643924512;
        bh=kzuDtzRdpOPRPCbJ5T7Dacpn10lMXnGy9JGJd9xNTGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XwHDcDwW0HWwQ+TaVyi8Bk2t1fkcMTl+Rxu0qxiSG9Ulc408d4nUIfbWInzOBZK6/
         mNSbUpgvQOU9N9l0UKLb7HDwb4m0EKgm8d3ThkFytG3NWH05fJ5lLnoZgkM2o6TJK1
         xN3joaSX3C9GAEokj9O6Cslp3c/Vi4eiHyJafo+TYofC3TY8It+WeOq08rJaETgFtp
         Erfj6yBwVGFPx0o6Lh/ALOYa4zKhXwmN10ezxt8vY0uZafSTNtClTagdF9QNEt+LZI
         4TJNdN0FqmilKSQXuRYQOKd6K6Jt/PmzFx0/NhkNoLDYa7M6fJiYc1synMhRdK4JaS
         MODu+gMJEx88w==
Date:   Thu, 3 Feb 2022 13:41:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     netdev@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH] MAINTAINERS: Update maintainers for chelsio crypto
 drivers
Message-ID: <20220203134151.140ba81d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203101222.57121-1-ayush.sawal@chelsio.com>
References: <20220203101222.57121-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Feb 2022 15:42:22 +0530 Ayush Sawal wrote:
> This updates the maintainer info for chelsio crypto drivers.
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Do you expect us to take this via netdev? You haven't CCed linux-crypto.
