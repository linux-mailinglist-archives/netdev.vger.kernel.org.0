Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0DBFE01B
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 15:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfKOObq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 09:31:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfKOObq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 09:31:46 -0500
Received: from [192.168.1.20] (cpe-24-28-70-126.austin.res.rr.com [24.28.70.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABC7D2072D;
        Fri, 15 Nov 2019 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573828305;
        bh=z4t0QNOpMSUfT6xxNqEGeyK4kvswHzvxvuh4u4MxWE4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tMCfohkEdQO5MZtypr3lSf1IVaJNmcuvM+seUixNNfXHYT1wU3BcK1Cfe+diLM0eV
         fyzg3L/GNsHDQ+PhCDP+S6JRz0JMtKXb/fISpdS5IYkDXiRF5RBdamtlBk10zLLTLj
         TmouuZ3KKjaXi3Y2CWdFcKM2A7/uTmgAkKcO5vH8=
Subject: Re: [PATCH v4 46/47] net: ethernet: freescale: make UCC_GETH
 explicitly depend on PPC32
To:     Li Yang <leoyang.li@nxp.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Qiang Zhao <qiang.zhao@nxp.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Scott Wood <oss@buserror.net>, netdev <netdev@vger.kernel.org>
References: <20191108130123.6839-1-linux@rasmusvillemoes.dk>
 <20191108130123.6839-47-linux@rasmusvillemoes.dk>
 <CAOZdJXUX2cZfaQTkBdNrwD=jT2399rZzRFtDj6vNa==9Bmkh5A@mail.gmail.com>
 <CADRPPNS00uU+f6ap9D-pYQUFo_T-o2bgtnYaE9qAXOwck86-OQ@mail.gmail.com>
From:   Timur Tabi <timur@kernel.org>
Message-ID: <52639dfc-d558-8a92-5e2e-8ec18f39b383@kernel.org>
Date:   Fri, 15 Nov 2019 08:31:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CADRPPNS00uU+f6ap9D-pYQUFo_T-o2bgtnYaE9qAXOwck86-OQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 11:44 PM, Li Yang wrote:
>> Can you add an explanation why we don't want ucc_geth on non-PowerPC platforms?
> I think it is because the QE Ethernet was never integrated in any
> non-PowerPC SoC and most likely will not be in the future.  We
> probably can make it compile for other architectures for general code
> quality but it is not a priority.

This explanation belongs in the commit message.
