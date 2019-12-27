Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E85E12B078
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfL0CIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:08:24 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37138 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727337AbfL0CIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:08:24 -0500
Received: by mail-pg1-f174.google.com with SMTP id q127so13734266pga.4
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/jmHtZlQnSdY2QigopVkjawZyj3M/3UiiMQeaTFLc+I=;
        b=aSJqd5MEqTe9DNv9X5vNTABjMWatTf8LgM5Ipt9m1Lqn/9XHK2ydl+64I67R0MN52H
         j6Hj6PTgqLgJFOGWDCIP3/IwKa4elTuKmdekkXA74LnKNQihyMbZ6P6ORbExRgBDMUlc
         3qHBYgixTVshoYBOB+KKphcjWCpCdG5zTsZBfgP6xOTfhpbhStFWvFeZp0S7BPfcV4Cy
         NR4CeyIRwiRSiCySXECZFpe79vNAJ3ayYMruiXMo4zO/RtJzhM524Wnwb+JNRHZLwlck
         0LUBrWL7eUUfOsCQuvWxf4FKItmy3x0DDcRMlVPW+yQLd8JtGH+661itNaI9Ndo6FsAk
         2V3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/jmHtZlQnSdY2QigopVkjawZyj3M/3UiiMQeaTFLc+I=;
        b=AkWbsPPKjJMgOGfMYkHwDYy2FF3yDH/psXc1d24wErkSXvvmYRZoazkBL1KVW7Zbgc
         Xb6HChU4ZV4vQXvx5e3sB/G7Vy+lIzGdZqb+jZAZzJPXymqrJioDncnv2RoFr8ClnAe+
         kg4yC6NreUvXZ7fz4DjqBGbxysip1bS7jOG+JLo++l/qKbQaiteV2l2uhumY4C/YVW1H
         CEJ5pDvQPOdvrhI3yynS/ke9HCvUjrV4Q6Kwly+TF2pNP85t5e5wMoIkGkD+DEtKMufH
         yzFFUx8AT92hg5Gc0FJji0GXI534UExX+3kogRpCaMmy3j6Trduh3SXeJzGDGGhU0aQw
         Zj9Q==
X-Gm-Message-State: APjAAAXGMPSx9sVr+99IscQ3A4Suz04cQ6qFoXM2ZNTEL7m0z2WoLGTO
        l6SK8gjYsZ9aR4ibza6Rixw=
X-Google-Smtp-Source: APXvYqxHhrvwVKyNDjwnu6yXNn/qQQ4U+HBUrPcbySQ0E4iZmhRp3B3EXm+iFUjmqGm3hUWy2wSGYw==
X-Received: by 2002:aa7:90c5:: with SMTP id k5mr15941113pfk.143.1577412503667;
        Thu, 26 Dec 2019 18:08:23 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 7sm28436320pfx.52.2019.12.26.18.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:08:22 -0800 (PST)
Date:   Thu, 26 Dec 2019 18:08:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH] net: mscc: ocelot: support PPS signal generation
Message-ID: <20191227020820.GA6970@localhost>
References: <20191226095851.24325-1-yangbo.lu@nxp.com>
 <CA+h21hojJ=UU2i1kucYoD4G9VQgpz1XytSOp_MT9pjRYFnkc4A@mail.gmail.com>
 <AM7PR04MB68858970C5BA46FE33C01F48F82B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM7PR04MB68858970C5BA46FE33C01F48F82B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 11:17:26AM +0000, Y.b. Lu wrote:
> > -----Original Message-----
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Also, I think what you have implemented here is periodic output
> > (PTP_CLK_REQ_PEROUT) not PPS [input] (PTP_CLK_REQ_PPS). I have found
> > the PTP documentation to be rather confusing on what PTP_CLK_REQ_PPS
> > means, so I'm adding Richard in the hope that he may clarify (also
> > what's different between PTP_CLK_REQ_PPS and PTP_CLK_REQ_PPS).

The PTP_CLK_REQ_PPS is for generating events for the kernel's PPS
subsystem.  (See drivers/pps).  This has nothing to do with actual PPS
signals.

> My understand is PTP_CLK_REQ_PEROUT is for periodical output,

Yes.

> and PTP_CLK_REQ_PPS is for PPS event handling.

No.

Some cards generate an interrupt at the full second roll over.  The
interrupt service routine can feed a system time stamp into the
kernel's pps subsystem for use by NTP.

If your device is generating an actual PPS output signal, then you
should implement the PTP_CLK_REQ_PEROUT method.

Bonus points for making the signal fully programmable!

Thanks,
Richard
