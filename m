Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B3F24800D
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHRH5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:57:44 -0400
Received: from mail.intenta.de ([178.249.25.132]:42591 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRH5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 03:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=2lNUKZLYV75UG79GoiRAn2THVdEF4AtQF1ysM4RMjMY=;
        b=M8F6rzg6mEYa9mrn9fiWHiv06CkNSJn4IO0BCPzml2hXLIX5jyoov82sBzsgQrCwxDK4XLC4JRZEBfQsoziWM8TwLG9GrAuOcvk4UGq6/ZMVdi/wNMfKPpLAz69glJQu87zCf/sZPXJre9TtsNUy3Im7dRSVLWVOBzKlzbKX88BmJk5zAwd0ZjkyNWzmKDYRrEkJQM+z7UKAIEhnyFTCE2/vDXUtwrqDSrSuPIykZ7M/ptVpHT7lNppouVnoq04Ikv2EfExUkVzwxtwgaf8YV0VzYx30Zbq4lmw48Kxk37AtyMYl3Tby9yFOqKiL+gmcpRH6m+pddfIqTzcK7fU/Hw==;
Date:   Tue, 18 Aug 2020 09:57:36 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] net: dsa: microchip: delete dead code
Message-ID: <20200818075736.GA1698@laureti-dev>
References: <20200725174130.GL1472201@lunn.ch>
 <cover.1597675604.git.helmut.grohne@intenta.de>
 <73ba5a2a-786d-e847-598a-20cdeef2e1c0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <73ba5a2a-786d-e847-598a-20cdeef2e1c0@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, Aug 17, 2020 at 08:18:41AM -0700, Florian Fainelli wrote:
> net-next is currently closed at the moment, and these patches are clearly
> targeted at that tree:

I agree that these are clearly net-next material.

> http://vger.kernel.org/~davem/net-next.html

It says "Come in we're open" for me. Maybe that changed over night and I
was just a day early? I'll check this for future submissions.

> Also, please provide a commit message, even if it is only paraphrasing what
> the subject does. The changes do look good, so once you fix that, we should
> be good.

I'm all for writing good commit messages and if you look into the few
commits I've authored thus far, you see that I usually do explain them
in detail. In these cases however, I'm left wondering what value any
further explanation would add. Repeating the subject does not make sense
to me.

I feel that we're overdoing it here and that there are more important
aspects to be improved about the driver. I'll be focusing on those.

Helmut
