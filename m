Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D45157F820
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 04:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiGYCD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 22:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGYCD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 22:03:58 -0400
X-Greylist: delayed 614 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 24 Jul 2022 19:03:53 PDT
Received: from m13114.mail.163.com (m13114.mail.163.com [220.181.13.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69C1655AE;
        Sun, 24 Jul 2022 19:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=hVWFC
        12o7gBcl52Q0cY8D8npn8wKH4MrJil30NXenNI=; b=OiLyIYeB9CAoxx6svBm6J
        wqJ0ci/Eg/a7FnmcILjIHshP8YoH7STOzJI+IVuY609O6HIMyKxM39ztOT+mu/3k
        82clGeUAU1HFMvepKUAwhFIH6NefbFrNdfHp+XsUU23+ibjhy9z6ftHpRIJF86N5
        1rzrdTO9apSozzuykoJrI0=
Received: from slark_xiao$163.com ( [112.97.48.126] ) by
 ajax-webmail-wmsvr114 (Coremail) ; Mon, 25 Jul 2022 10:02:34 +0800 (CST)
X-Originating-IP: [112.97.48.126]
Date:   Mon, 25 Jul 2022 10:02:34 +0800 (CST)
From:   "Slark Xiao" <slark_xiao@163.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     tglx@linutronix.de, mingo@redhat.com, shuah@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        peterz@infradead.org, dvhart@infradead.org, dave@stgolabs.net,
        andrealmeid@igalia.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] selftests: Fix typo 'the the' in comment
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <20220722115227.624aa650@kernel.org>
References: <20220722104259.83599-1-slark_xiao@163.com>
 <20220722115227.624aa650@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <2b780c4f.be2.18233177ffa.Coremail.slark_xiao@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: csGowAD3L9O6+d1iwhElAA--.65124W
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/xtbBAwhJZGB0LqTJ+wABsL
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjItMDctMjMgMDI6NTI6MjcsICJKYWt1YiBLaWNpbnNraSIg
PGt1YmFAa2VybmVsLm9yZz4gd3JvdGU6Cj5PbiBGcmksIDIyIEp1bCAyMDIyIDE4OjQyOjU5ICsw
ODAwIFNsYXJrIFhpYW8gd3JvdGU6Cj4+IFJlcGxhY2UgJ3RoZSB0aGUnIHdpdGggJ3RoZScgaW4g
dGhlIGNvbW1lbnQuCj4+IAo+PiBTaWduZWQtb2ZmLWJ5OiBTbGFyayBYaWFvIDxzbGFya194aWFv
QDE2My5jb20+Cj4+IC0tLQo+PiAgLi4uL2Z1dGV4L2Z1bmN0aW9uYWwvZnV0ZXhfcmVxdWV1ZV9w
aV9zaWduYWxfcmVzdGFydC5jICAgICAgICAgIHwgMiArLQo+PiAgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvbmV0L2ZvcndhcmRpbmcvdnhsYW5fYXN5bW1ldHJpYy5zaCAgICAgIHwgMiArLQo+Cj5Z
b3UgbmVlZCB0byBzcGxpdCB0aGlzIGJ5IHRoZSBzdWJzeXN0ZW0uCkhpICwKICBBbHJlYWR5IHNw
bGl0dGluZyAgaXQgdG8gMiBwYXJ0cy4gUGxlYXNlIGNoZWNrIHRoZSBuZXcgcGF0Y2guCgpUaGFu
a3MK
