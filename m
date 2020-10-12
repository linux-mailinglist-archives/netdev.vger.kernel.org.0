Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D4C28B42D
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbgJLLxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388209AbgJLLxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:53:53 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E6CC0613D0;
        Mon, 12 Oct 2020 04:53:51 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id o8so8436575pll.4;
        Mon, 12 Oct 2020 04:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fb1d8gmC83mgx6ZXccfV51mL2eDPuoS5rOP1jKZbgr0=;
        b=WqRIRK1ILJUZ67z70QvMDBxN06fFvlwUdMAnAtrRsF1vPMIL52nvWTtO9rfNvOfdU4
         c4oZuWaKIk/IlnERqKlzhGmiDtbVDYOdV1fdSQVzA6WfvnuXzBtUY3oBM3bKCuLiUNlm
         wb+dROSaHcGVHWmWKRZYg9qnbiZB5vcXXcw+paU0XtrKDet/ZbtD0BTfiebCzZE3Vfm2
         MLJ9cjShvdWMG4+T+yqYAKI1y0hSMPLCUk05PHD/Bc2d8W7xSKuqa3zDnvdY+VSN5aFH
         PRFoObfPV/asfoDKDYQLEI9gLnEJZrKsg4L0BmXAkHnpxpP7YXYW6xU+OFXaOYsUs3eg
         SNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fb1d8gmC83mgx6ZXccfV51mL2eDPuoS5rOP1jKZbgr0=;
        b=eNZHAsF/GCmlMDxm7EphCHyg0YB173FMRtG2UbEU08C2/W7pxBlyAZxPyUFNfRSQ1b
         BPtsptSBjc6vlOX9oT57EW2yWQu0HtbeqlIfl1KlCdhIJNB5KPadqfkRyN3OCIr53qWf
         0UI0owi7+nf/977/fSCRpcXEYoncvRckyocXeZ9EyZJUQd97F2KPOqjzOrYIMIjLCmWe
         TOKAuBQR0dyZbiAUrdO+c0WWze8Jnyiji+rdkVJgQDFxJFpGUXnHwJPZrXrVuL/erAm9
         +kFMD4F6oXSDIwoHKACuyJZhLWIczb/sCLa6mSBjRbrA4Dq3SK+4rJiSetcrob/FjoFe
         Ue3A==
X-Gm-Message-State: AOAM5316vvGxOFMQs/eGvLcSMuAeuTOsbPVB3t315bZ8UedzDKmDMeR2
        tY2dEI3RTauJTu7bMRTEIZQ=
X-Google-Smtp-Source: ABdhPJxlO1TccaY9ka4oOYHIRdg81JvK1kUFDXWvaLfFg4GNc+QKlcsPPRGHb2yAxPpyrlh7CDA6BA==
X-Received: by 2002:a17:902:7c0d:b029:d3:de09:a3 with SMTP id x13-20020a1709027c0db02900d3de0900a3mr22968153pll.52.1602503631317;
        Mon, 12 Oct 2020 04:53:51 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id k25sm9638298pfi.42.2020.10.12.04.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 04:53:50 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Mon, 12 Oct 2020 19:51:14 +0800
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/6] staging: qlge: coredump via devlink health
 reporter
Message-ID: <20201012115114.lyh33rvmm4rt7mej@Rk>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-3-coiby.xu@gmail.com>
 <20201010074809.GB14495@f3>
 <20201010100258.px2go6nugsfbwoq7@Rk>
 <20201010132230.GA17351@f3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201010132230.GA17351@f3>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 10:22:30PM +0900, Benjamin Poirier wrote:
>On 2020-10-10 18:02 +0800, Coiby Xu wrote:
>[...]
>> > > +	do {                                                           \
>> > > +		err = fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
>> > > +		if (err) {					       \
>> > > +			kvfree(dump);                                  \
>> > > +			return err;				       \
>> > > +		}                                                      \
>> > > +	} while (0)
>> > > +
>> > > +static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
>> > > +				  struct devlink_fmsg *fmsg, void *priv_ctx,
>> > > +				  struct netlink_ext_ack *extack)
>> > > +{
>> > > +	int err = 0;
>> > > +
>> > > +	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);
>> >
>> > Please name this variable ql_devlink, like in qlge_probe().
>>
>> I happened to find the following text in drivers/staging/qlge/TODO
>> > * in terms of namespace, the driver uses either qlge_, ql_ (used by
>> >  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
>> >  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
>> >  prefix.
>
>This comment applies to global identifiers, not local variables.

Thank you for the explanation! Are you suggesting we should choose
different naming styles so we better tell global identifiers from local
variables?
>
>>
>> So I will adopt qlge_ instead. Besides I prefer qlge_dl to ql_devlink.
>
>Up to you but personally, I think ql_devlink is better. In any case,
>"dev" is too general and often used for struct net_device pointers
>instead.

Thank you for the suggestion. Another reason to use qlge_dl is many
other network drivers supporting devlink interface also adopt this kind
of style.

--
Best regards,
Coiby
