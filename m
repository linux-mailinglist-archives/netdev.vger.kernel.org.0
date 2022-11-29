Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C9163C337
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiK2Ozj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiK2Ozi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:55:38 -0500
Received: from pv50p00im-ztdg10011901.me.com (pv50p00im-ztdg10011901.me.com [17.58.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6A9B5C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669733735;
        bh=7VHgYyrts87O0uqb1nQ28K/+qcn3F8Gj517nlgJXqpk=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=Rm7Ax+eVh9lfS8kpvuuyYRlhN/frni+KjidqvZMcxViExaL5qGlE401G5AAZTOzEM
         UUzS5Xq7bhKedTJR0gE2wJu61+dRco67dat+1kYqlOgYKN1dPEvyluzbKCpgBg7sTV
         keXVRHq8cicNur+BsIcETo8jKU6hthbT1Al0oGG6zIIWU/nDr8D6fdAhO9xqQc3YCD
         aeYzsUUfFsCRXWh4atvDGGiX39dz7wLUVc2IfUlAh18qOXnMQ/MgIAdRxidFgf/HoF
         O12E7jflHUci6/Zn2T6A4+jOSLrA2vb5Jkdzunk+efhlGEIr1YTlV+6vEGCFT+gba9
         QEPZLMm8/EIgA==
Received: from vanilla.lan (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10011901.me.com (Postfix) with ESMTPSA id 6EA163A06A5;
        Tue, 29 Nov 2022 14:55:32 +0000 (UTC)
From:   JunASAKA <JunASAKA@zzy040330.moe>
To:     rtl8821cerfe2@gmail.com, Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: reply to Bitterblue Smith
Date:   Tue, 29 Nov 2022 22:55:28 +0800
Message-Id: <20221129145528.377371-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: cljaZqDiDt2T0ayp4P5SmdB21H1zrx5-
X-Proofpoint-ORIG-GUID: cljaZqDiDt2T0ayp4P5SmdB21H1zrx5-
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.883,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F08:2022-06-21=5F01,2022-06-21=5F08,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=4 malwarescore=0 clxscore=1030
 adultscore=0 spamscore=4 mlxlogscore=134 suspectscore=0 phishscore=0
 bulkscore=0 mlxscore=4 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2211290084
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bitterblue Smith,

 	I have seen the patch you've mentioned. Actually, when I was trying to address the rtl8192eu problem, I saw that patch and
considered it would tackle my problem, but it turns out that it doesn't work for me. And I found this rtl8xxxu_queue_select() 
function which has a *hdr parameter that can be gained from skb since skb is indeed neccessary for this function to work.
	What do you think of these? And please take a look of my problem above on your convenience, thanks a lot.

Thanks and Regards,
Jun ASAKA.

