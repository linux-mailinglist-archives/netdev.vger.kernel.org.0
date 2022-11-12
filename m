Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB6A626703
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiKLErP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiKLErO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:47:14 -0500
X-Greylist: delayed 519 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Nov 2022 20:47:13 PST
Received: from ci74p00im-qukt09081901.me.com (ci74p00im-qukt09081901.me.com [17.57.156.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C8F10B72
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 20:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1668227913;
        bh=4ht9G50SlYlr7BPTCuy+KjNotHQlLEXbSKghIYlF3TI=;
        h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To;
        b=Marb1YmnZicYGgNQKLfFg2N+zNt9EVYhYKnvVebdgfjZU9/fwwaOU18yDbHfOmNmU
         c3M2y8JIzES/kAwFs3P9YkMSelDAl3ys7Dl9cQsGJu0r5pfjkifSJjIdnyS/fVO5Xh
         NnMmQANfzh8JhfRgjHHzqS9lJqc4EfBy4MfBlUvPwj+cKfta/blpq/dwg8Va4VH+vk
         tW4MmYSjNDIwi+gzJCGDeCdy9MKMASGhkqDmYxm0oX6m08hNbzbmIR+WQhnw+IpfO5
         GbI3cPvMtw1ytkVbQ/57ZAZPnkC9y24vn5SUNsmDly/vPPheQ4WRUaVnlpNojaGPh+
         uJcD43ASPF0OQ==
Received: from smtpclient.apple (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
        by ci74p00im-qukt09081901.me.com (Postfix) with ESMTPSA id 5CA6D5AC0424;
        Sat, 12 Nov 2022 04:38:32 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From:   Ernest Ugwu <ernestugwu08@icloud.com>
Mime-Version: 1.0 (1.0)
Date:   Fri, 11 Nov 2022 22:37:26 -0800
Subject: Re: [PATCH net-next 4/6] ixp4xx_eth: Stop referring to GPIOs
Message-Id: <349FCFFE-BFDE-4FD7-A023-338452887EF5@icloud.com>
Cc:     arnd@arndb.de, davem@davemloft.net, kaloz@openwrt.org,
        khalasa@piap.pl, kuba@kernel.org, netdev@vger.kernel.org
To:     linus.walleij@linaro.org
X-Mailer: iPhone Mail (18H107)
X-Proofpoint-GUID: 69v8JPlESJQvIZiXkoZjZDdbgYmn_FZJ
X-Proofpoint-ORIG-GUID: 69v8JPlESJQvIZiXkoZjZDdbgYmn_FZJ
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=376
 clxscore=1011 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211120031
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Sent from my iPhone
