Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224A963CBAC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 00:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiK2XUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 18:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbiK2XUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 18:20:09 -0500
X-Greylist: delayed 496 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Nov 2022 15:20:07 PST
Received: from ms11p00im-qufo17281501.me.com (ms11p00im-qufo17281501.me.com [17.58.38.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7B53054E
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 15:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669763510;
        bh=bDVPnjP7mjPXDaFoBo3SoljB9WhJu/n4uw9Ly0kVEtU=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=Wi0SExB7cuLKfOonD+An46v0F3xQuLUn/oS32MZHR847ObgEwUlIDdim1SXYiT1nF
         pwcd98Hj/anf8fvkETQISnhfY1Hm4KJfSAOC2SceYxA7iFskJ8/HJJp+pNqJJxyc6r
         T4xUsMUqVPdMxKRXdDF+sRUTFHigM4bxGwNSgSLSdFrSQuMQWaHQWmSj+2mvstR5eZ
         CgG3mYCisCeeg1zHsdmeMpb1nEhNK12AER4tJTmIj6wfq1laPVmcCOJx4hCcMi79Xb
         p4z7nIWFaXVgPhV1A0XG2MWw6E/hi+gk64VkdDbXy4yXtD8R1p3+J4bl9IpH6jSVL4
         +NH2GL6nMWgiA==
Received: from vanilla.lan (ms11p00im-dlb-asmtpmailmevip.me.com [17.57.154.19])
        by ms11p00im-qufo17281501.me.com (Postfix) with ESMTPSA id 78E88B61D2E;
        Tue, 29 Nov 2022 23:11:48 +0000 (UTC)
From:   JunASAKA <JunASAKA@zzy040330.moe>
To:     w@1wt.eu, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: rewrite and remove a superfluous parameter.
Date:   Wed, 30 Nov 2022 07:11:44 +0800
Message-Id: <20221129231144.416668-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: sl2gg6b7_mkxDy_nmgFk31M2hs6XfKo0
X-Proofpoint-ORIG-GUID: sl2gg6b7_mkxDy_nmgFk31M2hs6XfKo0
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=probablespam policy=default score=59 spamscore=59 malwarescore=0
 adultscore=0 clxscore=1030 bulkscore=0 suspectscore=0 mlxlogscore=-15
 phishscore=0 mlxscore=59 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211290139
X-Suspected-Spam: true
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I see. Sorry for that.

Jun ASAKA.

