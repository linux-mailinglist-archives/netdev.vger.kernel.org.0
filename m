Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7C5497981
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 08:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241870AbiAXHds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 02:33:48 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235991AbiAXHdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 02:33:47 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20O5tjrY008022;
        Sun, 23 Jan 2022 23:33:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=L6nx2R5aYAI03xiBq9N133nzcqVFlDhBMOV25SNCBGY=;
 b=VDdKLQ3mHAie2o0DgRHHJ/Dy/dLcvkaUZkIwTtbfeA3F4bvw35hw6AUF4fPmEQ7AEfBH
 XWOdg+5r0T9HUFc2Fl58cjRrvKBmWn1qJ4H1JP0nkz3Z/4Sv0WTKaq1XWbwxNPqOWynR
 iNVVYVfcgJ/ruiUYezGQxpZzpt0SOZ12qp9ELDetfxtjfcxGcrLQceLz8OXY/pdnY0TD
 ORkUdYEFGlkDf50/U/rprZ1tQnOPA+bxWtrhn151ODfMfHkDGb9ljHoY3bQhoh1k+wkO
 7uGs9Jlt05BdejwZkMpobiLonf6sYajX28jM9oLIfSQt0a3kX3fSLUJOyPAZ4TrWvMmf nQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dspd207b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Jan 2022 23:33:37 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Jan
 2022 23:33:35 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 23 Jan 2022 23:33:35 -0800
Received: from [10.193.32.121] (unknown [10.193.32.121])
        by maili.marvell.com (Postfix) with ESMTP id D217E3F7058;
        Sun, 23 Jan 2022 23:33:33 -0800 (PST)
Message-ID: <7c74bd66-ee40-b636-8a06-0fc02d681f63@marvell.com>
Date:   Mon, 24 Jan 2022 08:33:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [EXT] [PATCH] net: atlantic: Use the bitmap API instead of
 hand-writing it
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <27b498801eb6d9d9876b35165c57b7f8606f4da8.1642920729.git.christophe.jaillet@wanadoo.fr>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <27b498801eb6d9d9876b35165c57b7f8606f4da8.1642920729.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: bjXx8z6ilBfwrx7c8lr0koPGDqMWLj5L
X-Proofpoint-ORIG-GUID: bjXx8z6ilBfwrx7c8lr0koPGDqMWLj5L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_05,2022-01-21_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thanks, Christophe,

> Simplify code by using bitmap_weight() and bitmap_zero() instead of
> hand-writing these functions.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
