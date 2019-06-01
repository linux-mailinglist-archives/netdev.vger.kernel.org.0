Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96845320AF
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 22:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfFAUa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 16:30:29 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34862 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfFAUa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 16:30:28 -0400
Received: by mail-ed1-f67.google.com with SMTP id p26so20457616edr.2
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 13:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t5szP295+NWZz8uU+DdJv27LUpzZfoAdzMomr0CA/oY=;
        b=dVsrwHMOSozVDeXCzo8XyeXXaoUORB9nM55/eE3gqe0psp32fA0Bu5cZHhoWtmk/C8
         z+I1wlSwCqVflVc3McNR6WsDYsJSJdRNe7hz0lKN/9tbXE7ngOt0Elqv1MoQjdlsR0Qg
         eWV2likHeIBB9DYZU8jLNkTRXXcq3nbU/AYv6DEMz5JdGs6P+/mv1QVsfggQCNhBpQpa
         zKAZ6duIEXLFuFJa2UynFHy7XuqZfkUxPLnT3LyHdm0w1f5kcLJca4eXqBj8k3xrimhS
         rN1LtMJElmwOx5GbzFC6N1jF/cZPHZso2O7IXJ7Hf63H/3ciojggHB5/FHRT4Wl1TtJs
         QxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t5szP295+NWZz8uU+DdJv27LUpzZfoAdzMomr0CA/oY=;
        b=Z1AmAuUN6Wtlw1kZKZvPBvsvOvQXNji+yEVC7xYOViPq0hS2o1iTMYRwIpQNvrojaK
         BzRn3SLff6TauMUJ62icTI93yPGyl/b2mt9/1VTYt4VgLG9DWG7MeFOVEF34YdvNIfgP
         CK+qPmXerVXhM3n1vVC+COvziJp11pW0tdZXb6O5uyS/jTA0djXlZHWnOCWM3MTB0Yup
         6RqlVGbAgIWB2mwZ4rXEEOh1rXrnEzgYBGd3zu4TXSENFjttlmKVl2PgyXzRbfAA/Zv5
         VylB2wKc3ngv/cYf7+R6Wg1HmhkeOPwUUswybLr/QM04TaQGvCy9RX8zkVqT/1RVN1T0
         q2Uw==
X-Gm-Message-State: APjAAAVyE1FBWiIcHrqPSmY+5RczSmGMQd1zqdB0LXN7c+bU6HSnusDs
        Z3+YqRS1/YYSvLpHlihJAUWxWkmngN18wf4SmfQ=
X-Google-Smtp-Source: APXvYqwK9CcDhr7eWFzQLn8+od0/Pnm5fff4X8cwFTQ2MRmdMDTKeRwixM2p6YStuXW2IenbXMZxp6Gwwahd4Mpwn1s=
X-Received: by 2002:a17:906:259a:: with SMTP id m26mr16094696ejb.230.1559421027329;
 Sat, 01 Jun 2019 13:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190601103735.27506-1-olteanv@gmail.com> <20190601103735.27506-2-olteanv@gmail.com>
 <20190601160356.GB19081@lunn.ch>
In-Reply-To: <20190601160356.GB19081@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 1 Jun 2019 23:30:16 +0300
Message-ID: <CA+h21hpuYeyT6vPTXHQ-oJDcFuOb_q3L+t660YayPeDXm0AGtw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: sja1105: Force a negative value for
 enum sja1105_speed_t
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Jun 2019 at 19:03, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Jun 01, 2019 at 01:37:34PM +0300, Vladimir Oltean wrote:
> > The code in sja1105_adjust_port_config relies on the fact that an
> > invalid link speed is detected by sja1105_get_speed_cfg and returned as
> > -EINVAL.  However storing this into an enum that only has positive
> > members will cast it into an unsigned value, and it will miss the
> > negative check.
> >
> > So make the -EINVAL value part of the enum, so that it is stored as a
> > signed number and passes the negative check.
> >
> > Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>
> Hi Vladimir
>
> It seems like just using a switch statement would be simpler, and more
> likely to be correct. And it would avoid adding SJA1105_SPEED_INVALID
> = -EINVAL which feels hackish.
>
>   Andrew

Hi Andrew,

You mean I should completely remove the sja1105_get_speed_cfg function?
I suppose I can do that, I'm only using it in one place.

Thanks,
-Vladimir
