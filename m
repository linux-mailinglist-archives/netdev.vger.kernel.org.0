Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD631B45C8
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgDVND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:03:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52834 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725994AbgDVND1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 09:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587560606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fEHmi9ajdlezL4VA1/XtIrSW1Ks3h0AKTZAGIJKQey4=;
        b=Q8pdOb4Wv+QigrqP4SsdxJHHnDosmnOuSqgR6aPnAiQn4T30qeKtUkiHLn7OgqHA3vZoFZ
        6u/cm+XRxsrTNMvfJ+4rXBKR3c33xdYdWZ61IrZp9y8QWvARajyeV61RF1Go0s/ygvJUUu
        OV07p/lPomT00tiehMMEhebjBa46Gl4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-94pQGZ-xOQu8oO4JBz6_3Q-1; Wed, 22 Apr 2020 09:03:23 -0400
X-MC-Unique: 94pQGZ-xOQu8oO4JBz6_3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8652F8017F5;
        Wed, 22 Apr 2020 13:03:22 +0000 (UTC)
Received: from carbon (unknown [10.40.208.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 414FF3A4;
        Wed, 22 Apr 2020 13:03:17 +0000 (UTC)
Date:   Wed, 22 Apr 2020 15:03:16 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 net-next 1/5] xdp: export the DEV_MAP_BULK_SIZE macro
Message-ID: <20200422150316.0e691547@carbon>
In-Reply-To: <20200422120513.6583-2-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
        <20200422120513.6583-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 15:05:09 +0300
Ioana Ciornei <ioana.ciornei@nxp.com> wrote:

> Export the DEV_MAP_BULK_SIZE macro to the header file so that drivers
> can directly use it as the maximum number of xdp_frames received in the
> .ndo_xdp_xmit() callback.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

