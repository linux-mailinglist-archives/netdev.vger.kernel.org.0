Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C42DF97C
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 08:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgLUHdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 02:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgLUHdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 02:33:00 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A75FC0613D3
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 23:32:17 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id w17so1416369ilj.8
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 23:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VKKGthXLCQvXQ4nd0aqRaFO96rU0BPEkkbKVkg7CCWE=;
        b=NGd5yj17q/p9NDxBGxCPBJIPJtREvI5mLAxlhZC57Ox1yD7+Pa6DpR/H7jYFV1nHaz
         QoCUnx8BgClp+J4bSXjo+PpGrVmwJiUnE36DcEzj0bsCU3KV46yO8DwGK5YQReUe2Qfc
         L7gk4FOzdIIKxw+8/g+L0KewWlQ6Ew45WJQINMFRTaGQuAAFv1VuJ9+N11kA3PXDOp3j
         9oZXHosbPnB0RJzGwBW2rBTvaiSygZPIO514cTLKpkk+EoyciAv8X18SN5QJmgYWLMhm
         EeP+wplEwkGGjIRvDiS8mOcNICy0BctOUgjBv3E6WE6SRUh7UBlPzje6lPKvV+j6T/5w
         Cslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VKKGthXLCQvXQ4nd0aqRaFO96rU0BPEkkbKVkg7CCWE=;
        b=ix4kNh7fEjmrNBUrV89QSFsVMLi6efUAPKnq+IBEehpgErwccSdqxDZioMX5v3QpJw
         oEQhkHsAfWs1WsSPYHJ9IBuRzrwMZKxzEglzu5JLxL3cfHzFwj/RCEgoBh3jgTMm0BTu
         F1bGCbuY9GTx2DbYifY4jGSbQABt1mC3wc3I2eXobEsYZebH5KYvnZsv6Wt9NHWjRO4S
         JQB5RNDczEZBRy//LflII9lAapczQ0inTH7Q5XLH5MJ7wejbIyVuGdcHmYTqIyRcsoiZ
         Kb+dLzyLbn+nXDtzIbajmUf9NnVs3ilvaTiMQp+mKSanoGp4kJ6lRmhiyAsl/1ItM3h+
         6bFg==
X-Gm-Message-State: AOAM530+0PVwJ0D1MubQ0LMuKIsP1yZmNSYMqt3EfZqhfL/p3qDShwnq
        RX2+rw3rS4hpaNSeGQQ/rsdRqs8FdFSvcZYrY6A=
X-Google-Smtp-Source: ABdhPJx4keJVyXc4qHV+zlp63dRbuvDHMLpTtWIMjpMIANsDt8mwlu8WI3lqUORsVTKCSOOEjuu+0e1oforVxdtlFlI=
X-Received: by 2002:a92:dc8c:: with SMTP id c12mr15667093iln.274.1608535936833;
 Sun, 20 Dec 2020 23:32:16 -0800 (PST)
MIME-Version: 1.0
References: <20201219162153.23126-1-dqfext@gmail.com> <20201219162601.GE3008889@lunn.ch>
 <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com>
In-Reply-To: <47673b0d-1da8-d93e-8b56-995a651aa7fd@gmail.com>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Mon, 21 Dec 2020 15:32:05 +0800
Message-ID: <CAJsYDVJW+rA6N87DjBhkb_y5jJ0T7GMnUKUeBnq-uEnyYBQ3fw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, DENG Qingfang <dqfext@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Sun, Dec 20, 2020 at 1:10 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 12/19/2020 8:26 AM, Andrew Lunn wrote:
> >> --- a/drivers/net/dsa/mt7530.c
> >> +++ b/drivers/net/dsa/mt7530.c
> >> @@ -2688,7 +2688,7 @@ static const struct mt753x_info mt753x_table[] = {
> >>  };
> >>
> >>  static const struct of_device_id mt7530_of_match[] = {
> >> -    { .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
> >> +    { .compatible = "mediatek,mt7621-gsw", .data = &mt753x_table[ID_MT7621], },
> >>      { .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
> >>      { .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
> >>      { /* sentinel */ },
> >
> > This will break backwards compatibility with existing DT blobs. You
> > need to keep the old "mediatek,mt7621", but please add a comment that
> > it is deprecated.
>
> Besides, adding -gsw would make it inconsistent with the existing
> matching compatible strings. While it's not ideal to have the same
> top-level SoC compatible and having another sub-node within that SoC's
> DTS have the same compatible, given this would be break backwards
> compatibility, cannot you stay with what is defined today?

U-boot for MT7621 doesn't support device tree, and the kernel image
is always packaged with dt. Do we need to maintain backward
compatibility at all in this situation?

-- 
Regards,
Chuanhong Guo
