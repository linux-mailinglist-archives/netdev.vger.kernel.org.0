Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEE96221D6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKICQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKICQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:16:53 -0500
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B8F68C68
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:16:50 -0800 (PST)
X-QQ-mid: Yeas48t1667960193t538t04897
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Mengyuan Lou'" <mengyuanlou@net-swift.com>
Cc:     <netdev@vger.kernel.org>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>  <20221108111907.48599-3-mengyuanlou@net-swift.com> <20221108155545.79373df2@kernel.org>
In-Reply-To: <20221108155545.79373df2@kernel.org>
Subject: RE: [PATCH net-next 2/5] net: txgbe: Initialize service task
Date:   Wed, 9 Nov 2022 10:16:32 +0800
Message-ID: <028801d8f3e1$492f08c0$db8d1a40$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEDYkxFLCrX910mDyZZwuk/z1QniAJSzitJAxQO1eCvtcYxoA==
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

On Wednesday, November 9, 2022 7:56 AM, Jakub wrote:
> On Tue,  8 Nov 2022 19:19:04 +0800 Mengyuan Lou wrote:
> > +	__TXGBE_TESTING,
> > +	__TXGBE_RESETTING,
> > +	__TXGBE_DOWN,
> > +	__TXGBE_HANGING,
> > +	__TXGBE_DISABLED,
> > +	__TXGBE_REMOVING,
> > +	__TXGBE_SERVICE_SCHED,
> > +	__TXGBE_SERVICE_INITED,
> 
> Please don't try to implement a state machine in the driver.
> Protect data structures with locks, like a normal piece of SW.
> 

The state machine will be used in interrupt events, locks don't seem to fit it.

