Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B720628D47
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237879AbiKNXTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbiKNXS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:18:57 -0500
Received: from ci74p00im-qukt09081902.me.com (ci74p00im-qukt09081902.me.com [17.57.156.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9829D9FF8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1668467410;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:To;
        b=h103k0KHl5TS6E1TxViaJfmaMtfnFG1EH9QC3pJjqqGHvkL0Q5RSV80bnSnNW1gwa
         wYRE/RbHkGwZLI1pBpCt7/ksVOAx2+H2t0wW+Vz1OmUPA6e9gjtbQlxv9SsKZKyg6f
         6n9mmmEI/pHqFC5ZrnBEhvQAwjILOQVQ/ZirB57ygza/1RqiBMG9tcO5FVLRZWJAn7
         lh0k0Br8bvZHIKaeIFxIIEMr5Q6dC9hke9RLKRor13xzwHP8Wa8OYrsRCYFuT3f4a5
         9n8vaDY6KLzVq0eOWQ8CLas+svOaxzCwvXn5C/FuojwtxIXc986pGSkn+UZgaj5IXT
         TPD5UCwMDVckA==
Received: from [10.29.246.1] (ci77p00im-dlb-asmtp-mailmevip.me.com [17.57.156.26])
        by ci74p00im-qukt09081902.me.com (Postfix) with ESMTPSA id 32E8429006D0;
        Mon, 14 Nov 2022 23:10:09 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From:   James Wick <wackooman57@icloud.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/3] uapi: export tc tunnel key file
Date:   Mon, 14 Nov 2022 18:10:07 -0500
Message-Id: <CC6840A3-785D-41DD-BA6C-35B8B1FC274C@icloud.com>
Cc:     davem@davemloft.net, jhs@mojatatu.com, netdev@vger.kernel.org,
        pablo@netfilter.org, stephen@networkplumber.org,
        sthemmin@microsoft.com
To:     James Wick <wackooman57@icloud.com>
X-Mailer: iPhone Mail (17E262)
X-Proofpoint-GUID: TaA5VggxPJcqG9ZmxlmNyz5yp8WNLNnT
X-Proofpoint-ORIG-GUID: TaA5VggxPJcqG9ZmxlmNyz5yp8WNLNnT
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.425,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-01-11=5F01:2022-01-11=5F01,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 clxscore=1011
 suspectscore=0 mlxlogscore=599 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211140163
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


