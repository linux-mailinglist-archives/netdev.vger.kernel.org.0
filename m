Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6999837BB6F
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 13:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhELLHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 07:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhELLHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 07:07:10 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0791EC061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 04:06:01 -0700 (PDT)
Received: from miraculix.mork.no (fwa185.mork.no [192.168.9.185])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 14CB5fWW006179
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 12 May 2021 13:05:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1620817541; bh=WT9IlVcU8W6uU/8XrkMKnsZd/CQKCOOeo6vuIONjm90=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=UZQ8bFZ0qvE4pLT2imJTlT52aUtIeozGqC1JLMpFf0NESdPTlyZswauLs54dIlDUD
         b7Zrp60EKu0sMnIlxVR71uNRlYqeQnWpS4wCP4GSYVv+EunjTb+Hgh+JgdIp8Ql0ag
         TvD3P8TJ3XXi4gKMXd6et8FxoaErnnslzilIvi+M=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1lgmgO-000aan-BW; Wed, 12 May 2021 13:05:40 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        dcbw@gapps.redhat.com
Subject: Re: [PATCH net-next v2 2/2] usb: class: cdc-wdm: WWAN framework
 integration
Organization: m
References: <1620744143-26075-1-git-send-email-loic.poulain@linaro.org>
        <1620744143-26075-2-git-send-email-loic.poulain@linaro.org>
        <CAAP7ucJah5qJXpjyP9gYmnYDyBWS7Qe3ck2SCBonJhJB2NgS5A@mail.gmail.com>
        <CAMZdPi_2PdM9+_RQi0hL=eQauXfN3wFJVyHwSWGsfnK2QBaHbw@mail.gmail.com>
        <CAAP7ucLb=e-mV6YM3LEh_OvttJVnAN+awRpEQGNt9y_grw+Hqw@mail.gmail.com>
        <CAMZdPi9zABtXoKiUuE9mmbnYsSmZoVWR+nLAdq0O5b7=Ghh-rg@mail.gmail.com>
Date:   Wed, 12 May 2021 13:05:40 +0200
In-Reply-To: <CAMZdPi9zABtXoKiUuE9mmbnYsSmZoVWR+nLAdq0O5b7=Ghh-rg@mail.gmail.com>
        (Loic Poulain's message of "Wed, 12 May 2021 13:01:55 +0200")
Message-ID: <878s4kxldn.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loic Poulain <loic.poulain@linaro.org> writes:

> I'm however open discussing other strategies:
> - Do not change anything, keep USB WWAN devices out of the WWAN subsystem.
> - Migrate cdc-wdm completely to WWAN and get rid of the cdc-wdm chardev
> - Build time choice, if CONFIG_WWAN, registered to WWAN, otherwise
> exposed through cdc-wdm chardev.
> - Run time choice, use either the new WWAN chardev or the legacy
> cdc-wdm chardev (this patch)
> - ...
>
> I would be interested in getting input from others/maintainers on this.

I appreciate the work you do.  When I am silent on the issue, it's
because I don't know the best solution (this is a well proven fact :-)
and don't want to affect the results by arbitrary comments.

There is one thing I can say though:  No build time options, please.


Bj=C3=B8rn
