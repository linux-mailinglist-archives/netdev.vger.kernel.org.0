Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C038EFFF69
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfKRHQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:16:41 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:40526 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfKRHQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 02:16:40 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D2FF020460;
        Mon, 18 Nov 2019 08:16:39 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RkiwNY-Stmzm; Mon, 18 Nov 2019 08:16:39 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 79B22201E5;
        Mon, 18 Nov 2019 08:16:39 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 18 Nov 2019
 08:16:39 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 10AFF318275C;
 Mon, 18 Nov 2019 08:16:39 +0100 (CET)
Date:   Mon, 18 Nov 2019 08:16:39 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Vakul Garg <vakul.garg@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Required guidance to debug ipsec memory leak
Message-ID: <20191118071638.GQ14361@gauss3.secunet.de>
References: <DB7PR04MB4620A7723FAC95C7767573208B4D0@DB7PR04MB4620.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DB7PR04MB4620A7723FAC95C7767573208B4D0@DB7PR04MB4620.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 06:35:24AM +0000, Vakul Garg wrote:
> Hi
> 
> I need help to debug a suspected memory leak problem while running kernel ipsec with rekeying enabled.

Did you try with the current net tree? There is a fix for
such a leak:

commit 86c6739eda7d ("xfrm: Fix memleak on xfrm state destroy")

