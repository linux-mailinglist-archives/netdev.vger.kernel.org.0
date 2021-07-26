Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C863D6A7C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 02:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhGZXT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhGZXTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 19:19:55 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798B8C061757;
        Mon, 26 Jul 2021 17:00:23 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id AB434C01F; Tue, 27 Jul 2021 02:00:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1627344017; bh=AqWBIB/P4cglBp3v+EdtFD5gnv4amdJeHzvQ+TsnBuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JlDKAnlU39KnHu8bxfIxaZRWzNJQfxcS0j5Cpgs2W1tAzNLhN7Cy1Ida9gcfAg848
         Pn0w6gXZoPYmJ24Z+B8YI53JCMgaYRoVGqtk8xcEXHGwPxlPILXsEWSPDKhVTzUow8
         90vgG2cRgHIrgte/Os5377+aoHAt8puIOf4asPsPldGH77Qpn4S5Jwxv3JJgQa7Iqd
         dR42VJUX5U2oHLJjBVU43lZNo2FyoYVQEqV5G5STknNkj4i9tBw2RkDo4IxVxtxPlj
         QLtM8qbwcm1alScM2SOuUdIjMePmlIVSX0KXGe63LhXnPqD4kFOIl4s1Fe7A9KGB3n
         vlM6gvXEulfsA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 4FEBEC009;
        Tue, 27 Jul 2021 02:00:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1627344017; bh=AqWBIB/P4cglBp3v+EdtFD5gnv4amdJeHzvQ+TsnBuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JlDKAnlU39KnHu8bxfIxaZRWzNJQfxcS0j5Cpgs2W1tAzNLhN7Cy1Ida9gcfAg848
         Pn0w6gXZoPYmJ24Z+B8YI53JCMgaYRoVGqtk8xcEXHGwPxlPILXsEWSPDKhVTzUow8
         90vgG2cRgHIrgte/Os5377+aoHAt8puIOf4asPsPldGH77Qpn4S5Jwxv3JJgQa7Iqd
         dR42VJUX5U2oHLJjBVU43lZNo2FyoYVQEqV5G5STknNkj4i9tBw2RkDo4IxVxtxPlj
         QLtM8qbwcm1alScM2SOuUdIjMePmlIVSX0KXGe63LhXnPqD4kFOIl4s1Fe7A9KGB3n
         vlM6gvXEulfsA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 7ce8ee03;
        Tue, 27 Jul 2021 00:00:08 +0000 (UTC)
Date:   Tue, 27 Jul 2021 08:59:53 +0900
From:   asmadeus@codewreck.org
To:     Stefano Stabellini <sstabellini@kernel.org>
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [External] : Re: [PATCH] 9p/xen: Fix end of loop tests for
 list_for_each_entry
Message-ID: <YP9MeeqOKcyYRxjK@codewreck.org>
References: <20210725175103.56731-1-harshvardhan.jha@oracle.com>
 <YP3NqQ5NGF7phCQh@codewreck.org>
 <alpine.DEB.2.21.2107261357210.10122@sstabellini-ThinkPad-T480s>
 <d956e0f2-546e-ddfd-86eb-9afb8549b40d@oracle.com>
 <alpine.DEB.2.21.2107261654130.10122@sstabellini-ThinkPad-T480s>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2107261654130.10122@sstabellini-ThinkPad-T480s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stefano Stabellini wrote on Mon, Jul 26, 2021 at 04:54:29PM -0700:
> > > Yes, I did test it successfully. Aside from the commit messaged to be
> > > reworded:
> > How's this?
> > ===========================BEGIN========================================
> > 9p/xen: Fix end of loop tests for list_for_each_entry
> > 
> > This patch addresses the following problems:
> >  - priv can never be NULL, so this part of the check is useless
> >  - if the loop ran through the whole list, priv->client is invalid and
> > it is more appropriate and sufficient to check for the end of
> > list_for_each_entry loop condition.
> > 
> > Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>

Will take the patch with this text as commit message later tonight


> > > Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
> > > Tested-by: Stefano Stabellini <sstabellini@kernel.org>

Thanks for the test!

-- 
Dominique
