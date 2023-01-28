Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16B367FAC4
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 21:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbjA1UZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 15:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjA1UZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 15:25:32 -0500
X-Greylist: delayed 408 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 28 Jan 2023 12:25:32 PST
Received: from st43p00im-ztdg10071801.me.com (st43p00im-ztdg10071801.me.com [17.58.63.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35578974E
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 12:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1674937123;
        bh=TFBvmJtiFSXdwZwqHZ0w4IYBxEDcVmyojxXWT3p+p6k=;
        h=Content-Type:From:Mime-Version:Date:Subject:Message-Id:To;
        b=kqOvJhry798NKtwBSgDT3ukCLPwYgGNLRYO8ZhTVOCKZI0OwuxKNa+zydQQdElvwr
         b0by7s7Z0zHzQzn8D2cBT6CvATTY23Qb9xyKpknB+mJBegbyPRo59H+G+ZWsxDQCKp
         brdnytftEwky8YQxgUQAxzDvnlDyGbLHpO8AH9rm6scf9NaIAVBD62us2QzuvSBf0N
         YMsQMEEY0K5cblQe2a26iDkT1p+U+fzBOZAfJQLSiGPw4MOiMd5exRUJiS3u001lnF
         k5fy0NCANy+A3obDnShWh+FyieClU9Ba4jcNeLt2R07oflOAjO26rZS7a9OlOa0+S/
         aofxkFf68ohcQ==
Received: from smtpclient.apple (st43p00im-dlb-asmtp-mailmevip.me.com [17.42.251.41])
        by st43p00im-ztdg10071801.me.com (Postfix) with ESMTPSA id D24AF3C0E3A;
        Sat, 28 Jan 2023 20:18:42 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From:   Mostafa Shahdadi <mostafa.shahdadi@icloud.com>
Mime-Version: 1.0 (1.0)
Date:   Sat, 28 Jan 2023 23:48:37 +0330
Subject: Re: [PATCH net 0/5] wireguard fixes for 5.6-rc7
Message-Id: <B10B5437-DA70-4AF1-8135-6E15A2AB30C0@icloud.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
To:     jason@zx2c4.com
X-Mailer: iPad Mail (19H307)
X-Proofpoint-ORIG-GUID: uPHbRk4KkR5nNIX9fBzlLpIsqQj2Jq4p
X-Proofpoint-GUID: uPHbRk4KkR5nNIX9fBzlLpIsqQj2Jq4p
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F01:2022-06-21=5F01,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 mlxlogscore=515
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2301280198
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Sent from my iPad 15.7

