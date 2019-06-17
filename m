Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66EEE47E2B
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfFQJVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:21:03 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55848 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfFQJVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 05:21:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 181822024F;
        Mon, 17 Jun 2019 11:21:02 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uBtEXELGW6hi; Mon, 17 Jun 2019 11:21:01 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D83B32025D;
        Mon, 17 Jun 2019 11:21:00 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 17 Jun 2019
 11:20:59 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2115B31805E2;
 Mon, 17 Jun 2019 11:21:00 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:21:00 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Li RongQing <lirongqing@baidu.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: remove empty xfrmi_init_net
Message-ID: <20190617092100.GT17989@gauss3.secunet.de>
References: <1560426324-5824-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1560426324-5824-1-git-send-email-lirongqing@baidu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 07:45:24PM +0800, Li RongQing wrote:
> Pointer members of an object with static storage duration, if not
> explicitly initialized, will be initialized to a NULL pointer. The
> net namespace API checks if this pointer is not NULL before using it,
> it are safe to remove the function.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Patch applied, thanks a lot!
