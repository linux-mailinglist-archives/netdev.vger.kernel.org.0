Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC32652B23
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 03:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiLUCEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 21:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLUCEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 21:04:51 -0500
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A31F1DDF3
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 18:04:48 -0800 (PST)
X-QQ-mid: Yeas3t1671588261t623t08474
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20221213063543.2408987-1-jiawenwu@trustnetic.com> <Y6I9lNrBl6Jl2mIw@lunn.ch>
In-Reply-To: <Y6I9lNrBl6Jl2mIw@lunn.ch>
Subject: RE: [PATCH net-next] net: wangxun: Adjust code structure
Date:   Wed, 21 Dec 2022 10:04:20 +0800
Message-ID: <005401d914e0$8a455650$9ed002f0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHeeeY3/zUksUCiGmKjPhlKQULJegHrn96erl1uGVA=
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, December 21, 2022 6:56 AM, Andrew Lunn wrote:
> On Tue, Dec 13, 2022 at 02:35:43PM +0800, Jiawen Wu wrote:
> > From: Mengyuan Lou <mengyuanlou@net-swift.com>
> >
> > Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
> > And move the same codes which sets MAC address between txgbe and ngbe
> > to libwx.
> 
> So this patch appears to do three things. So ideally it should be three patches. I will then but
much easier
> to review.
> 
>       Andrew
> 

I have sent the v2 patch set. Please see
https://lore.kernel.org/all/20221214064133.2424570-1-jiawenwu@trustnetic.com/
Patch set v3 will be sent for "net-next" prefix and more comments, if any, after 6.2-rc1.

