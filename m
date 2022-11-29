Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7172B63C294
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiK2Ocl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiK2Ocg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:32:36 -0500
Received: from pv50p00im-ztdg10021101.me.com (pv50p00im-ztdg10021101.me.com [17.58.6.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D443B8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669732352;
        bh=D1sY42WHcDsVJr/mrozXVUG4CSOOZzLkdsx1x7wE2EE=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=KxufnIFv9bXmj8ZCvfCCyitPxBDIUFz/5qNlapdNvzeQA2U7/O7LW62pe3pjncdIu
         5k+MK34sigv3mlZ9cnSJsSHUNS6BbrdKEQ+wXt//oAHHtH4Z10USA+A2D7gif67Z8g
         0VsfSiD384hBq7gcVaWtw7xMP5EwvMQR0jv0PRwkKwl0avwmWeU8z+dxO8nNtXzlXt
         CuKY9VYv11pHPfhHEejjMY+L4DmJE6TwtMYC1WAFVdY4mv1Lj3hd+MVae7D2abKr68
         Zhycb9Ubk+Qg2OmQc+8/E2Yfve/pDDbcZQ22pHM+fhyyMO1vJWxBMAeak+eZXPbbym
         I3gEcG5icBzJQ==
Received: from vanilla.lan (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021101.me.com (Postfix) with ESMTPSA id B8D7AD00A38;
        Tue, 29 Nov 2022 14:32:28 +0000 (UTC)
From:   JunASAKA <JunASAKA@zzy040330.moe>
To:     rtl8821cerfe2@gmail.com, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: reply to Bitterblue Smith
Date:   Tue, 29 Nov 2022 22:32:25 +0800
Message-Id: <20221129143225.376856-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: XqlrtoIyYeu0Ldd9Oh_7RY6MzhcB1tnE
X-Proofpoint-GUID: XqlrtoIyYeu0Ldd9Oh_7RY6MzhcB1tnE
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=43 malwarescore=0 clxscore=1030
 mlxlogscore=12 bulkscore=0 suspectscore=0 spamscore=43 adultscore=0
 mlxscore=43 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211290083
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bitterblue Smith,

Thanks for your reply. I've seen the discussion.
As for the bugs of the module, my Tenda U1 wifi module which is using the rtl8192eu chip running into problems with the rtl8xxxu module, more information can be found here: https://bugzilla.kernel.org/show_bug.cgi?id=216746. I want to solve this problem but I haven't got enough experience upon it. I'll appreciate it if you could do me a favour on it. Thanks again.

Jun ASAKA.
