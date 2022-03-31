Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EC74EDA45
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbiCaNND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiCaNNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:13:02 -0400
X-Greylist: delayed 757 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 06:11:14 PDT
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318DB20DB09
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:11:13 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9f:8600:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 22VCwErm206850
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 13:58:16 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 22VCwC1b3975823
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 14:58:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1648731494; bh=3qad0vu847N501JVj+B9zfqjiTiuw/ACV2x6SxDvb2M=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Z3DvLyPGhXpJCOh58KXP7rFdbDdw8HiozWFs+fYFn8M1SYJG4TV2gRAl5a4JH3Hvc
         wNiZBwjXwjqUdnf8vvvB0pLSh8ECgbd0QDLLmJF1xZppE0ovaJ0uvEq+bk/rucMnIF
         OrkQrrBCVPXZWHdS5pm8OwWCxXFXNNLbasYwjtHs=
Received: (nullmailer pid 178357 invoked by uid 1000);
        Thu, 31 Mar 2022 12:58:12 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Qing Wang <wangqing@vivo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: remove duplicate assignment
Organization: m
References: <1648728494-37344-1-git-send-email-wangqing@vivo.com>
Date:   Thu, 31 Mar 2022 14:58:12 +0200
In-Reply-To: <1648728494-37344-1-git-send-email-wangqing@vivo.com> (Qing
        Wang's message of "Thu, 31 Mar 2022 05:08:14 -0700")
Message-ID: <87sfqygty3.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qing Wang <wangqing@vivo.com> writes:

> netdev_alloc_skb() has assigned ssi->netdev to skb->dev if successed,
> no need to repeat assignment.

Thanks.

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
