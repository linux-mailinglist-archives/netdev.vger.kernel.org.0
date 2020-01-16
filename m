Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A4513DAFD
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgAPNAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:00:39 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:33798 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgAPNAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:00:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7E7562006F;
        Thu, 16 Jan 2020 14:00:37 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id B6lqxDFMhCzr; Thu, 16 Jan 2020 14:00:37 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5CEBB2027C;
        Thu, 16 Jan 2020 14:00:34 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 14:00:34 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E562531801A4;
 Thu, 16 Jan 2020 14:00:33 +0100 (CET)
Date:   Thu, 16 Jan 2020 14:00:33 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Ulrich Weber <ulrich.weber@gmail.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: support output_mark for offload ESP packets
Message-ID: <20200116130033.GD23018@gauss3.secunet.de>
References: <20200115095358.GQ8621@gauss3.secunet.de>
 <20200115111128.8671-1-ulrich.weber@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200115111128.8671-1-ulrich.weber@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 12:11:29PM +0100, Ulrich Weber wrote:
> Commit 9b42c1f179a6 ("xfrm: Extend the output_mark") added output_mark
> support but missed ESP offload support.
> 
> xfrm_smark_get() is not called within xfrm_input() for packets coming
> from esp4_gro_receive() or esp6_gro_receive(). Therefore call
> xfrm_smark_get() directly within these functions.
> 
> Fixes: 9b42c1f179a6 ("xfrm: Extend the output_mark to support input direction and masking.")
> Signed-off-by: Ulrich Weber <ulrich.weber@gmail.com>

Applied, thanks Ulrich!
