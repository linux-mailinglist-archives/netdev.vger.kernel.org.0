Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86FA2C9CC2
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388361AbgLAJAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:00:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388305AbgLAJAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606813149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSsGRBUOWAETZ5Sd8nvg/sErSOqJ3PR8KtVDoY0Iy7E=;
        b=P7Axfj+dbAZYyBINPb/L+4ZwmHvWNjB7CbIjC0GGCuRUXZIVi5A6Tyb2aHN8P0mf56CKYF
        CFPRGpAKluG2OVz0WCDongZlbFUJmGupO4jrXjwIUFwtjJDdz4lD0jZ703XnedGd6O+uxQ
        O+bNqZtKb8agDidAEmn5LzQt5r1+yYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-XQC94cYxOpGWW0bpr6vFOQ-1; Tue, 01 Dec 2020 03:59:05 -0500
X-MC-Unique: XQC94cYxOpGWW0bpr6vFOQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91A15817B83;
        Tue,  1 Dec 2020 08:59:02 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 517495D9DC;
        Tue,  1 Dec 2020 08:58:53 +0000 (UTC)
Date:   Tue, 1 Dec 2020 09:58:52 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Penigalapati, Sandeep" <sandeep.penigalapati@intel.com>
Cc:     "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, brouer@redhat.com
Subject: Re: [PATCH v4 2/6] igb: take vlan double header into account
Message-ID: <20201201095852.2dc1e8f8@carbon>
In-Reply-To: <DM6PR11MB454615FDFC4E7B71D9B82FA29CF40@DM6PR11MB4546.namprd11.prod.outlook.com>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
        <20201111170453.32693-3-sven.auhagen@voleatech.de>
        <DM6PR11MB454615FDFC4E7B71D9B82FA29CF40@DM6PR11MB4546.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 08:23:23 +0000
"Penigalapati, Sandeep" <sandeep.penigalapati@intel.com> wrote:

> Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>

Very happy that you are testing this.

Have you also tested that samples/bpf/ xdp_redirect_cpu program works?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

