Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD66EC384
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 03:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjDXB7N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 23 Apr 2023 21:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDXB7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 21:59:12 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F0A19B0;
        Sun, 23 Apr 2023 18:59:07 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33O1wY8h9006101, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33O1wY8h9006101
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 24 Apr 2023 09:58:34 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 24 Apr 2023 09:58:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 24 Apr 2023 09:58:35 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Mon, 24 Apr 2023 09:58:35 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Zhang Shurong <zhang_shurong@foxmail.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 01/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_write_reg
Thread-Topic: [PATCH 01/10] wifi: rtw88: fix incorrect error codes in
 rtw_debugfs_set_write_reg
Thread-Index: AQHZdQLZEwGgnP9KBkK9dZfWruowpK85tNhw
Date:   Mon, 24 Apr 2023 01:58:35 +0000
Message-ID: <a3450e1f9ee740478f8215feea6127e4@realtek.com>
References: <cover.1682156784.git.zhang_shurong@foxmail.com>
 <tencent_6E21370EB57D5B7060611EB60A96A88B1208@qq.com>
In-Reply-To: <tencent_6E21370EB57D5B7060611EB60A96A88B1208@qq.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Zhang Shurong <zhang_shurong@foxmail.com>
> Sent: Saturday, April 22, 2023 6:05 PM
> To: tony0620emma@gmail.com
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Zhang Shurong
> <zhang_shurong@foxmail.com>
> Subject: [PATCH 01/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_write_reg
> 
> If there is a failure during copy_from_user or user-provided data
> buffer is invalid, rtw_debugfs_set_write_reg should return negative
> error code instead of a positive value count.
> 
> Fix this bug by returning correct error code. Moreover, the check
> of buffer against null is removed since it will be handled by
> copy_from_user.
> 
> Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/debug.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
> index fa3d73b333ba..bc41c5a7acaf 100644
> --- a/drivers/net/wireless/realtek/rtw88/debug.c
> +++ b/drivers/net/wireless/realtek/rtw88/debug.c
> @@ -183,8 +183,8 @@ static int rtw_debugfs_copy_from_user(char tmp[], int size,
> 
>         tmp_len = (count > size - 1 ? size - 1 : count);
> 
> -       if (!buffer || copy_from_user(tmp, buffer, tmp_len))
> -               return count;
> +       if (copy_from_user(tmp, buffer, tmp_len))
> +               return -EFAULT;

This patchset is fine to me. The only thing is this chunk can be first patch,
and squash other patches to second patch because they do the same thing
in the same driver.


> 
>         tmp[tmp_len] = '\0';
> 
> @@ -338,14 +338,17 @@ static ssize_t rtw_debugfs_set_write_reg(struct file *filp,
>         char tmp[32 + 1];
>         u32 addr, val, len;
>         int num;
> +       int ret;
> 
> -       rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
> +       ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
> +       if (ret < 0)
> +               return ret;
> 
>         /* write BB/MAC register */
>         num = sscanf(tmp, "%x %x %x", &addr, &val, &len);
> 
>         if (num !=  3)
> -               return count;
> +               return -EINVAL;
> 
>         switch (len) {
>         case 1:
> --
> 2.40.0

