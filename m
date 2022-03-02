Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DEB4CAD08
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 19:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbiCBSMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236621AbiCBSL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:11:59 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4FE675221
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 10:11:15 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-014-155-020.89.14.pool.telefonica.de [89.14.155.20])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8922020B7178;
        Wed,  2 Mar 2022 10:11:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8922020B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646244675;
        bh=wnNxxKJhkbCQZA6MR48J0yJP1hDi/gPWM9pPHYM7Il0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=RKPY8/WLcodYi6GvwmfAozvyUyE7gVN2ld7er/uPxYunMgMKN0oGFO4huvk1IY5js
         D/ZZbN9B4M2DxouX06NulIU2xryaSI1PH4JZq/FqvawQIetZ/4U5i50ZV76wH175TQ
         +CcRFCuylSMf60HqzBSSpi60jFd58om7vo8hwJuA=
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
To:     Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>, netdev@vger.kernel.org
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
 <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
 <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
 <20220301150930.GA56710@Mem>
 <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
 <20220301161001.GV1223722@gauss3.secunet.de>
 <20220302080439.2324c5d0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Kai Lueke <kailueke@linux.microsoft.com>
Message-ID: <6c2d3e6b-23f8-d4a4-4701-ff9288c18a5c@linux.microsoft.com>
Date:   Wed, 2 Mar 2022 19:11:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20220302080439.2324c5d0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
> Agreed. FWIW would be great if patch #2 started flowing towards Linus'es
> tree separately if the discussion on #1 is taking longer.

to preserve the initial goal of helping to uncover id 0 usage I think it
would be best to have the revert be accompanied by a patch that instead
creates a kernel log warning (or whatever).

Since I never did that I suggest to not wait for me.
Also, feel free to do the revert yourself with a different commit
message if mine didn't capture the things appropriately.

Regards,
Kai

