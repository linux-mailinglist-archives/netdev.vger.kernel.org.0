Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32D663C399
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 16:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiK2PWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 10:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiK2PWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 10:22:20 -0500
Received: from pv50p00im-ztdg10021901.me.com (pv50p00im-ztdg10021901.me.com [17.58.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2305F54
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669735339;
        bh=gc+MM0N94WxAhdaa5hRT0yOMkZKFIlgChNYaRtyDec8=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=nA1dycx+bIMw5zmVS5zEO9ie8igF7UmWxUPDQlP6JYK7kIcz4xxyBvGj/RvMiGkUJ
         XUmKsWucJpfh+M8R5dHmfNRDTH9JywwI+y9xJVQTCIp2d5QPa/6lWiKQeXGjZyX6hc
         05CxrhKLFByVvxl5+Trm5X/JVgwYlUaW94fw1lcGRdx6wd6qtxNXsUDPwkD0bluL8v
         KCFPWyMGYF5FkK7etRCSir1UdO4lGosuERr7/H4FJp6cJ9RofadMCGgedms8+WGjHv
         eV8UKnTcY/uePyCCauIfIaUYlsVHHQl6VeqANpLlG+tKYRmv3eGX23hENDnkEiLZXu
         6hdeR36UJbCCw==
Received: from vanilla.lan (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021901.me.com (Postfix) with ESMTPSA id 43E7581D8C;
        Tue, 29 Nov 2022 15:22:15 +0000 (UTC)
From:   JunASAKA <JunASAKA@zzy040330.moe>
To:     rtl8821cerfe2@gmail.com, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: reply to Bitterblue Smith
Date:   Tue, 29 Nov 2022 23:22:12 +0800
Message-Id: <20221129152212.382062-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: SLyiBI9WleRtlrLsT-sio-4kkuKuBm0P
X-Proofpoint-GUID: SLyiBI9WleRtlrLsT-sio-4kkuKuBm0P
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=probablespam policy=default score=89 malwarescore=0 mlxlogscore=-89
 bulkscore=0 phishscore=0 mlxscore=89 spamscore=89 clxscore=1030
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2211290086
X-Suspected-Spam: true
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	I think you're right and I am comparing those sorces. But the realtek official driver 
is far different from the one in rtl8xxxu module. I think it's difficult for me to do it, but
I am trying my best.

Jun ASAKA.

