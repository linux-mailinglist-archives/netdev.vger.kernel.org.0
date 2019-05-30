Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD122F8ED
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfE3JBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:01:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39619 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfE3JBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 05:01:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id e24so8071766edq.6;
        Thu, 30 May 2019 02:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hAvTxaltXYO/lyeicRERVDVuI1Ynh76x4sPUvK3WH+0=;
        b=c9wvPeNKmf1N2IwhyWnleJp2nETmlAMOZQNzJQXiYsFpP0DPOsQhTegaIFZ3J3lUrI
         lQTZCedqVxdZi7wxPGQmBOB4wgyutM2m1KqT08J+nWUZsXDcHixV3LawU9oSBaUB2vl6
         CRjt1gyF29uB8exwDmzEu7Ni1PTPAVZbLOIouDLDvfWtL/CeLZ9sLqFyVA2aGVRVSuf8
         fLXRvv1LsFDpZ0ESEAD3lDD0d5neLPOchIRGWSnJ0oYd+AOTAptV+E90jL+lSNOak3qG
         hNw3/uXkE0JbC5RCtz0p7Jt8RqCjVrCZRzO1CcaVZ2Z04dPeKmcryYoVA1qYWM7KmNpy
         ki6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hAvTxaltXYO/lyeicRERVDVuI1Ynh76x4sPUvK3WH+0=;
        b=eKmQeBwK6J8TE3KW2waqum5S2T0oAzPCPqP0zWXiRIcWzp905GpVd8c8rUcfBllMFs
         o+cSIM9joTsbalGouSUvvjwPKDrkRbbX3T+I2ftmEGbLc8xwbNxfp24xZ0fuI3FC73V0
         J9ja2ydRc4rZ24zWnZRuat/zSLHxw6t27QGZNSb7wMPdzfuT2dJOBPAgMbdaPBeTtkKz
         kCCc16OET+ZWOOdvlRE+IOAVdbefAhDsqrDPY5QwR976zXe8xgvuiDT8FYyvvnCE49AL
         3pN1aD74evXYg7onZFJOTcbYXM+6Cb2QWQ6x3DPrsyJCf5EG75KXHl020hrpCpUDXxb6
         sF5w==
X-Gm-Message-State: APjAAAVf3fE3DCzZ0znYRAz0bvYdBmSbFSeC+OgQjmJFLWL8CjoMipJi
        9OJzICBA+Hu5lX+0vBw3sA+yV78rv5bylC8Q9dk=
X-Google-Smtp-Source: APXvYqx8KYaMEsLueVj1BIkNrm2+mxAT1HJLHo0bQGvs+WBaD5AjevtcfVIq9CjQucuNoBSl4pBzpc5ooRBrFQYAlZ4=
X-Received: by 2002:a17:906:5a42:: with SMTP id l2mr2370579ejs.47.1559206894995;
 Thu, 30 May 2019 02:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com> <20190530034555.wv35efen3igwwzjq@localhost>
In-Reply-To: <20190530034555.wv35efen3igwwzjq@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 30 May 2019 12:01:23 +0300
Message-ID: <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 at 06:45, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Wed, May 29, 2019 at 11:41:22PM +0300, Vladimir Oltean wrote:
> > I'm sorry, then what does this code from raw.c do?
>
> It is a fallback for HW that doesn't support multicast filtering.
>
> Care to look a few lines above?  If you did, you would have seen this:
>
>         memset(&mreq, 0, sizeof(mreq));
>         mreq.mr_ifindex = index;
>         mreq.mr_type = PACKET_MR_MULTICAST;
>         mreq.mr_alen = MAC_LEN;
>         memcpy(mreq.mr_address, addr1, MAC_LEN);
>
>         err1 = setsockopt(fd, SOL_PACKET, option, &mreq, sizeof(mreq));
>

You're right.
In fact that's why it doesn't work: because linuxptp adds ptp_dst_mac
(01-1B-19-00-00-00) and (01-80-C2-00-00-0E) to the MAC's multicast
filter, but the switch in its great wisdom mangles bytes
01-1B-19-xx-xx-00 of the DMAC to place the switch id and source port
there (a rudimentary tagging mechanism). So the frames are no longer
accepted by this multicast MAC filter on the DSA master port unless
it's put in ALLMULTI or PROMISC.

> > > No.  The root cause is the time stamps delivered by the hardware or
> > > your driver.  That needs to be addressed before going forward.
> > >
> >
> > How can I check that the timestamps are valid?
>
> Well, you can see that there is something wrong.  Perhaps you are not
> matching the meta frames to the received packets.  That is one
> possible explanation, but you'll have to figure out what is happening.
>

If the meta frames weren't associated with the correct link-local
frame, then the whole expect_meta -> SJA1105_STATE_META_ARRIVED
mechanism would go haywire, but it doesn't.
I was actually thinking it has something to do with the fact that I
shouldn't apply frequency corrections on timestamps of PTP delay
messages. Does that make any sense?

Regards,
-Vladimir

> Thanks,
> Richard
