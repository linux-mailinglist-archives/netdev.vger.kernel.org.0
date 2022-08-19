Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E682959A6BD
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351597AbiHSTrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351227AbiHSTrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:47:15 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E597DAEF5;
        Fri, 19 Aug 2022 12:47:10 -0700 (PDT)
Received: from mail.ispras.ru (unknown [83.149.199.84])
        by mail.ispras.ru (Postfix) with ESMTPSA id 577DF40737CA;
        Fri, 19 Aug 2022 19:47:08 +0000 (UTC)
MIME-Version: 1.0
Date:   Fri, 19 Aug 2022 22:47:08 +0300
From:   goriainov@ispras.ru
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 1/1] qrtr: Convert qrtr_ports from IDR to XArray
In-Reply-To: <Yv+fEteaeS0o2965@kroah.com>
References: <20220818141401.4971-1-goriainov@ispras.ru>
 <20220818141401.4971-2-goriainov@ispras.ru> <Yv9yV9SpKQwm7N3z@kroah.com>
 <Yv+Vvmia1CBnU6Jq@casper.infradead.org> <Yv+fEteaeS0o2965@kroah.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <188b657c5b99de83d8416dd3db43c51f@ispras.ru>
X-Sender: goriainov@ispras.ru
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman писал 2022-08-19 17:32:
> On Fri, Aug 19, 2022 at 02:53:02PM +0100, Matthew Wilcox wrote:
>> On Fri, Aug 19, 2022 at 01:21:59PM +0200, Greg Kroah-Hartman wrote:
>> > On Thu, Aug 18, 2022 at 05:14:01PM +0300, Stanislav Goriainov wrote:
>> > > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> > >
>> > > commit 3403fb9adea5f5d8f9337d77ba1b31e6536ac7f1 upstream.
>> >
>> > This is not a commit id in Linus's tree that I can find anywhere :(
>> 
>> I see it as 3cbf7530a163, fwiw.
> 
> I'll wait for a resend, as obviously something went wrong on the
> sender's side...
Yeah, my bad.. Corrected version follows up.
