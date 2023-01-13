Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E6A668F17
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240976AbjAMHWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239960AbjAMHWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:22:21 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8545BA2B;
        Thu, 12 Jan 2023 23:13:31 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NtXh75fQdz8RTZF;
        Fri, 13 Jan 2023 15:13:27 +0800 (CST)
Received: from szxlzmapp05.zte.com.cn ([10.5.230.85])
        by mse-fl1.zte.com.cn with SMTP id 30D7DA6U049679;
        Fri, 13 Jan 2023 15:13:10 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp01[null])
        by mapi (Zmail) with MAPI id mid14;
        Fri, 13 Jan 2023 15:13:12 +0800 (CST)
Date:   Fri, 13 Jan 2023 15:13:12 +0800 (CST)
X-Zmail-TransId: 2b0363c10488ffffffff9d335c5f
X-Mailer: Zmail v1.0
Message-ID: <202301131513124870047@zte.com.cn>
In-Reply-To: <20230112211707.2abb31ad@kernel.org>
References: 202301111425483027624@zte.com.cn,20230112211707.2abb31ad@kernel.org
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <kuba@kernel.org>
Cc:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBuZXQtbmV4dCB2Ml0gbmV0L3JkczogdXNlIHN0cnNjcHkoKSB0byBpbnN0ZWFkIG9mIHN0cm5jcHkoKQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 30D7DA6U049679
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 63C10497.000 by FangMail milter!
X-FangMail-Envelope: 1673594007/4NtXh75fQdz8RTZF/63C10497.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63C10497.000/4NtXh75fQdz8RTZF
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What are the differences in behavior between strncpy() and strscpy()?

Strscpy() makes the dest string NUL-terminated, and returns more
useful value. While strncpy() can initialize the dest string.

Here we use strscpy() to make dest string NUL-terminated, and use
return value to check src string size and dest string size. This make
the code simpler.
