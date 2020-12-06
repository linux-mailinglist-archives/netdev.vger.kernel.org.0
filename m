Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529C92D0733
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 21:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgLFU5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 15:57:54 -0500
Received: from m13117.mail.163.com ([220.181.13.117]:49885 "EHLO
        m13117.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgLFU5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 15:57:54 -0500
X-Greylist: delayed 42418 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2020 15:57:53 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=/Gq/5
        7x/JhjQ4trt87R2Uu6xac5xH1imKRKM4ZhonVw=; b=diD7FB6L4VbPdfofqC74W
        oT0SpsEDT+O7+/DyeOmVRgOdiNs0h+1kbMnhqEEGad8icqfCH7UOcdIMddkuhxVR
        lsqC0dcHpxqj4HQ87UCOcI9gBC/0UEQUaTeuPy8sc0mPEESBuGkInW1QGTcvjFop
        M6WeHGmjyQEPTP+p3Ar1fc=
Received: from sh_def$163.com ( [139.162.53.180] ) by ajax-webmail-wmsvr117
 (Coremail) ; Sun, 6 Dec 2020 16:33:43 +0800 (CST)
X-Originating-IP: [139.162.53.180]
Date:   Sun, 6 Dec 2020 16:33:43 +0800 (CST)
From:   =?UTF-8?B?6IuP6L6J?= <sh_def@163.com>
To:     =?UTF-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn.topel@intel.com>
Cc:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re:Re: linux-next: ERROR: build error for arm64
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10 build 20190724(ac680a23)
 Copyright (c) 2002-2020 www.mailtech.cn 163com
In-Reply-To: <a6899dcd-eee7-3559-6f4e-584f5f5973ce@intel.com>
References: <20201206073231.GA3805@rlk>
 <a6899dcd-eee7-3559-6f4e-584f5f5973ce@intel.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <ea58b17.d87.176372f6ac3.Coremail.sh_def@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: dcGowAB3f1Nnl8xfkPESAA--.57582W
X-CM-SenderInfo: xvkbvvri6rljoofrz/1tbipB3yX1r7rvHG3QABsw
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjAtMTItMDYgMTY6MjU6MTksICJCasO2cm4gVMO2cGVsIiA8
Ympvcm4udG9wZWxAaW50ZWwuY29tPiB3cm90ZToKCk9rLCB0aGFua3Mu
