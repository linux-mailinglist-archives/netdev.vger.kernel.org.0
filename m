Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49FE10F324
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 00:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfLBXJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 18:09:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfLBXJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 18:09:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A69F014DAF87D;
        Mon,  2 Dec 2019 15:09:08 -0800 (PST)
Date:   Mon, 02 Dec 2019 15:09:08 -0800 (PST)
Message-Id: <20191202.150908.2038427090014426460.davem@davemloft.net>
To:     leoyang.li@nxp.com
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        oss@buserror.net, timur@kernel.org, netdev@vger.kernel.org,
        linux@rasmusvillemoes.dk, qiang.zhao@nxp.com,
        christophe.leroy@c-s.fr
Subject: Re: [PATCH v6 44/49] net/wan/fsl_ucc_hdlc: avoid use of
 IS_ERR_VALUE()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <VE1PR04MB6687B5428E3E4FA0F8F77DF08F430@VE1PR04MB6687.eurprd04.prod.outlook.com>
References: <20191128145554.1297-1-linux@rasmusvillemoes.dk>
        <20191128145554.1297-45-linux@rasmusvillemoes.dk>
        <VE1PR04MB6687B5428E3E4FA0F8F77DF08F430@VE1PR04MB6687.eurprd04.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Dec 2019 15:09:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leo Li <leoyang.li@nxp.com>
Date: Mon, 2 Dec 2019 22:51:57 +0000

> 
> 
>> -----Original Message-----
>> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Sent: Thursday, November 28, 2019 8:56 AM
>> To: Qiang Zhao <qiang.zhao@nxp.com>; Leo Li <leoyang.li@nxp.com>;
>> Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; Scott Wood <oss@buserror.net>; Timur Tabi
>> <timur@kernel.org>; Rasmus Villemoes <linux@rasmusvillemoes.dk>;
>> netdev@vger.kernel.org
>> Subject: [PATCH v6 44/49] net/wan/fsl_ucc_hdlc: avoid use of
>> IS_ERR_VALUE()
> 
> Hi David,
> 
> Would you help to review patch 44-47 in the series?  If it is fine with you, I can take these 4 patches with the whole series though soc tree to enable the QE drivers on ARM and PPC64 with your ACK.

Please take it via your tree, that's fine.
