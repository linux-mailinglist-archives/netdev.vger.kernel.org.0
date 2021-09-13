Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E24088E9
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbhIMKYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238490AbhIMKYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631528609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/nzkwe3pr/qPUFlHM8thmADhxRTA4dSRMErI6BImOww=;
        b=I+aDEz/xtCHz/hloUfHFzQo2IPa7fuHbjeXFyfee6j3TcaL/ExRDTzBT0cYsyBCIQBDj+o
        Ri+VtAu5qgPBVti2CKjwinxOJIcWS/RkRrMCmaqyoloKf4pO+D+ZtpKYucnhr9RG7zjDsJ
        0J4DHazHuC/ToGS28PhmkmCby50m/sM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67--V7vw2jsOni4c7SRmCQniw-1; Mon, 13 Sep 2021 06:23:26 -0400
X-MC-Unique: -V7vw2jsOni4c7SRmCQniw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3D07835DE9;
        Mon, 13 Sep 2021 10:23:23 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23C4377F35;
        Mon, 13 Sep 2021 10:23:18 +0000 (UTC)
Date:   Mon, 13 Sep 2021 12:23:16 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Antony Antony <antony.antony@secunet.com>,
        Christian Langrock <christian.langrock@secunet.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        SElinux list <selinux@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>,
        network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Dmitry V. Levin" <ldv@strace.io>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2] include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI
 breakage
Message-ID: <20210913102316.GA30886@asgard.redhat.com>
References: <20210912122234.GA22469@asgard.redhat.com>
 <CAFqZXNtmN9827MQ0aX7ZcUia5amXuZWppb-9-ySxVP0QBy=O8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFqZXNtmN9827MQ0aX7ZcUia5amXuZWppb-9-ySxVP0QBy=O8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 09:16:39AM +0200, Ondrej Mosnacek wrote:
> Perhaps it would be a good idea to put a comment here to make it less
> likely that this repeats in the future. Something like:
> 
> /* IMPORTANT: Only insert new entries right above this line, otherwise
> you break ABI! */

Well, this statement is true for (almost) every UAPI-exposed enum, and
netlink is vast and relies on enums heavily.  I think it is already
mentioned somewhere in the documentation, and in the end it falls on the
shoulders of the maintainers—to pay additional attention to UAPI changes.

