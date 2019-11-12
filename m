Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B853F910C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKLNut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:50:49 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38863 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbfKLNus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:50:48 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so3031402wmk.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 05:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+brfnZ3+v03u1yMPaD19zz4Q+9lSnpvxNNjizUxJGWU=;
        b=O8h/X2U7H3mOoQi1zyRPIOJ5R9L+xqUxQQrdLlrz27hXJiBOJxTVPr709X9PZp3tp4
         Dzwqs6kZzLwAq8G37tvXF8rXTOHJXcGmE8Cyy/envoeYS4f+hZj4lRQKSWDR9/IDhPtK
         jGWhQeDZhr94Q0cEvVHNEmK+7V9JDmpmpCrBjYARVsI0Vi87LmWc819jD7kpDPuSjzaM
         5xUKeRF5F5QgNySAQ61y5m6lLFO2uBKMIgryuVt/YaMUzN4oaKOJECsb78pUIcqw1Mbd
         QI5H6tYV4R9+5jSjG/H73ZgukaVSP0gr6QNkCSkZSTrLY5G/JgAgtI5cJczWsqldWQHP
         gEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+brfnZ3+v03u1yMPaD19zz4Q+9lSnpvxNNjizUxJGWU=;
        b=eRAuD7xRr6jk7DCU/l9JeIVXUDbufMLyjwtRDix/oX5l4ONd+eRVdcgATQHxaLPDIw
         WzwEZMA3JFQ6MDjt4MZC2SK7XDgwhipuzK4r7oulc/o0fQPvKHkwBkkCjy3YoqIPl1G5
         Xrsj7DDKfkDbX1Ia4uS5oSATKO662roufDR0v7zsiUA/doZ/a2CteJj3Tp+THJzDhkZA
         JC+R+LyMLkjtmWYWKtiKEgG30A8lzSAakHPuxZAoc76O0eFi+bJbb4utcu1s6N79vLkO
         xVc+2wHyTsBPwMem9gUDBHAM2v56gWdzR9aGE9DN4w/n6n9Ax4ad/Avr+GzhKQq3GW0b
         msoQ==
X-Gm-Message-State: APjAAAXjzSucXC0fpIdsHEc1sC6wKc1p7NagQMP2uOjiJMFDuCExH8zD
        6TsH5h3hjyJ6uMNUNC2zcVxxOg==
X-Google-Smtp-Source: APXvYqy5m7WXR82TGiKLzUKRK5dIkDwBpWW76BT4IPAI9S17eKjcG0T3L3UMRJusuZR2a49OjlSk7g==
X-Received: by 2002:a05:600c:c3:: with SMTP id u3mr3761956wmm.35.1573566646507;
        Tue, 12 Nov 2019 05:50:46 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id j3sm17948565wrs.70.2019.11.12.05.50.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 05:50:46 -0800 (PST)
Date:   Tue, 12 Nov 2019 14:50:45 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [net-next, 1/2] enetc: Configure the Time-Aware
 Scheduler via tc-taprio offload
Message-ID: <20191112135045.5qaau7kqdxrrpqo4@netronome.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
 <20191112094128.mbfil74gfdnkxigh@netronome.com>
 <VE1PR04MB6496CE5A0DA25D7AF9FD666492770@VE1PR04MB6496.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VE1PR04MB6496CE5A0DA25D7AF9FD666492770@VE1PR04MB6496.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 11:19:43AM +0000, Po Liu wrote:

...

> > > +/* class 5, command 0 */
> > > +struct tgs_gcl_conf {
> > > +     u8      atc;    /* init gate value */
> > > +     u8      res[7];
> > > +     union {
> > > +             struct {
> > > +                     u8      res1[4];
> > > +                     __le16  acl_len;
> > 
> > Given that u* types are used in this structure I think le16 would be more
> > appropriate than __le16.
>  
> Here keep the same code style of this .h file. I think it is better to have another patch to fix them all. Do you agree?
> 
> > 

> > > +                     u8      res2[2];
> > > +             };
> > > +             struct {
> > > +                     u32 cctl;
> > > +                     u32 ccth;
> > > +             };
> > 
> > I'm a little surprised to see host endian values in a structure that appears to be
> > written to hardware. Is this intentional?
> 
> Will remove.

If the HW defines these fields then I think its fine to leave them,
though with the correct byte-order.

I was more asking if it is intentional that the value for these
fields, when sent to the HW, is always zero in the context of this
patch-set. Likewise elsewhere.

...

> > > +
> > > +     gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
> > > +     gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
> > > +
> > > +     for (i = 0; i < gcl_len; i++) {
> > > +             struct tc_taprio_sched_entry *temp_entry;
> > > +             struct gce *temp_gce = gce + i;
> > > +
> > > +             temp_entry = &admin_conf->entries[i];
> > > +
> > > +             temp_gce->gate = cpu_to_le32(temp_entry->gate_mask);
> > 
> >         Gate is a u8 followed by 3 reserved bytes.
> >         Perhaps there needs to be some bounds checking on
> >         the value stored there given that the source is 32bits wide.
> > 
> >         Also, its not clear to me that the above logic, which I assume
> >         takes the last significant byte of a 32bit value, works on
> >         big endian systems as the 32bit value is always little endian.
> 
> temp_entry->gate_mask is 32bit for wide possible input. Here change to hardware set 8bit wide.
> Can it just be like:
> 	temp_gce->gate = (u8) temp_entry->gate_mask;

I think that would be better.
Perhaps its best to also mask out the unwanted bits.

...
