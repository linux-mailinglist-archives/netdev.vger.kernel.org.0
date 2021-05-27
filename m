Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC85B39253E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 05:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhE0DND convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 May 2021 23:13:03 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:27910 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232725AbhE0DNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 23:13:02 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-gHPaEQ38Pxqjp6QldB-D_A-1; Wed, 26 May 2021 23:11:23 -0400
X-MC-Unique: gHPaEQ38Pxqjp6QldB-D_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EAE8107ACC7;
        Thu, 27 May 2021 03:11:22 +0000 (UTC)
Received: from Leo-laptop-t470s (unknown [10.64.242.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC65F61156;
        Thu, 27 May 2021 03:11:20 +0000 (UTC)
Date:   Thu, 27 May 2021 11:11:15 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] selftests/wireguard: make sure rp_filter disabled on
 vethc
Message-ID: <YK8N0+2Zvn0PME/y@Leo-laptop-t470s>
References: <20210525121507.6602-1-liuhangbin@gmail.com>
 <CAHmME9qHbTWB=V3Yw6FNLa1ZgP2gxb29Pt=Nw3=+QADDXArQuA@mail.gmail.com>
 <CAPwn2JTkdXRkT=azv+hPSUvcb-Gq51T11Z2MBFBsNCRG_8=Gsg@mail.gmail.com>
 <CAHmME9q+_9TBv0kS4_B9WihtadT+6uDZ8Pn1yJBgrvj8c-nzzg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHmME9q+_9TBv0kS4_B9WihtadT+6uDZ8Pn1yJBgrvj8c-nzzg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 04:38:09PM +0200, Jason A. Donenfeld wrote:
> Hi Hangbin,
> 
> fc00::1 lives inside of fc00::9/96.

Yes, I know fc00::1 belongs to fc00::9/96 subnet. I just don't understand
why we need to add a default v6 route for vethc, while the default route
address fc00::1 is not configured on any device.

This step looks useless for me.

Thanks
Hangbin

