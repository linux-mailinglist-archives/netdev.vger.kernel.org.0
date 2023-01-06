Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2F65FA5C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjAFDhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjAFDhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:37:38 -0500
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AA567BC3
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 19:37:34 -0800 (PST)
X-QQ-mid: Yeas50t1672976243t622t22050
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
In-Reply-To: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
Subject: RE: [PATCH net-next v3 0/7] net: wangxun: Adjust code structure
Date:   Fri, 6 Jan 2023 11:37:20 +0800
Message-ID: <02d701d92180$2ecfef90$8c6fceb0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIX3dKayi0BWJhdsirj3aaMAlvfDq4TRBqA
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this series because of the first patch missing.

> -----Original Message-----
> From: Jiawen Wu <jiawenwu@trustnetic.com>
> Sent: Friday, January 6, 2023 10:12 AM
> To: netdev@vger.kernel.org; mengyuanlou@net-swift.com
> Cc: Jiawen Wu <jiawenwu@trustnetic.com>
> Subject: [PATCH net-next v3 0/7] net: wangxun: Adjust code structure
> 
> Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
> And move the same codes which sets MAC address between txgbe and ngbe to
> libwx. Further more, rename struct 'wx_hw' to 'wx' and move total adapter
> members to wx.
> 
> Changelog:
> v3:
>   - Change function parameters to keep two drivers more similar
>   - Add strucure rename patch
>   - Add adapter remove patch
> v2:
>   - Split patch v1 into separate patches
>   - Fix unreasonable code logic in MAC address operations
> 
> Jiawen Wu (6):
>   net: ngbe: Remove structure ngbe_hw
>   net: txgbe: Move defines into unified file
>   net: ngbe: Move defines into unified file
>   net: wangxun: Move MAC address handling to libwx
>   net: wangxun: Rename private structure in libwx
>   net: txgbe: Remove structure txgbe_adapter
> 
> Mengyuan Lou (1):
>   net: ngbe: Remove structure ngbe_adapter
> 
>  drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 504 +++++++++++-------
>  drivers/net/ethernet/wangxun/libwx/wx_hw.h    |  37 +-
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |  72 ++-
>  drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  79 ---
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  47 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   4 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 300 ++++-------
> drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  68 +--
>  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  23 -
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 112 ++--
>  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +-
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 326 ++++-------
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  26 +-
>  13 files changed, 702 insertions(+), 902 deletions(-)  delete mode 100644
> drivers/net/ethernet/wangxun/ngbe/ngbe.h
>  delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
> 
> --
> 2.27.0
> 

