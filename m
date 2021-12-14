Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15D4473A05
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbhLNBGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhLNBGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:06:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02ABC061574;
        Mon, 13 Dec 2021 17:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A38612D4;
        Tue, 14 Dec 2021 01:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EEBC34603;
        Tue, 14 Dec 2021 01:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639444010;
        bh=jWW3Ew1s95+5hirVBdj650xHy3eLw/f6Z7CJNPGI4eQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KV8sdyCZyeY0x3F+w/zG9uIS6FTogfo3EPjJON9ePcQOS2rZ/9rOeaKHtJsOwjqu6
         gk2J0SooRPw/3/srR2qMGGsxWgDlbFNfEIyLsxTP9lG/WZkWC2Sz4xlbFqlBOKpKm1
         Cj/qXCZa9m7z++NceXRPYdI95tXGnalnLm4GCj/4uvDGm1Eacdfnn4jsoPC/x0VlC7
         /wMJ3e6LqWaDClyW04mNiYj58EiHJDcKzoGf16MGxH5tn9LpbQccRtMl1Zmi2hZSxO
         xDdDNe2Z+F73k5veWfHeYTMzRkmYtFiSpV9/6fMDXquqh5ikqUwoEhAPmDD619jLxl
         pcoCxTfCl7kww==
Date:   Mon, 13 Dec 2021 17:06:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <huyd12@chinatelecom.cn>
Cc:     <sunshouxin@chinatelecom.cn>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: =?UTF-8?B?5Zue5aSNOg==?= [PATCH V2] net: bonding: Add support
 for IPV6 ns/na
Message-ID: <20211213170649.5fa82feb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <009101d7f086$3a3e14f0$aeba3ed0$@chinatelecom.cn>
References: <1639141691-3741-1-git-send-email-sunshouxin@chinatelecom.cn>
        <009101d7f086$3a3e14f0$aeba3ed0$@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 09:02:05 +0800 huyd12@chinatelecom.cn wrote:
> Hi=EF=BC=8Call
>=20
> Any comments will be appreciated.
> thanks a lot.

You'll probably need to fix the build failures and repost.
Some reviewers tend to ignore code with build failures.
