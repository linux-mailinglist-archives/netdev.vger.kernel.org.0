Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC26D119A0F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfLJVtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:49:23 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45362 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfLJVIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:08:40 -0500
Received: by mail-qt1-f195.google.com with SMTP id p5so4111448qtq.12
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=3nRYlS0/YHih4zITmDaDbI3UpDrDOmoWaeoqzXN/ZeQ=;
        b=sIdCi2e60wFGD2yHBP69y330EaJI8nNHi7epjFzetDNeXwlj0wuR9rnoPzmcXw/BZ0
         b0k4kW1TF25SPsxcPM8XXV5AXxXS2dRrZIYXKcblY1aDsHrfNKZfxDQRZ7URIuSnvqt9
         rX69UE00nwNP05osLtNKA4cgluLQKwSC3leMhHLmk1GvNt2FdQTlL4Xi0nQZm0sIbKDO
         RfXlMwlZyXi10aVci8Huk5G5RG99sHDCsUfBI2bUFLI2DqozfDfCkGQF4RShEUP/vAy0
         7GTVzY1sSQE0Gsi/SkOLKTg9WqFePjetKcWPk8tCz7bt7Xkq5pNRJyrKfJbXkiAYIm53
         Qpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3nRYlS0/YHih4zITmDaDbI3UpDrDOmoWaeoqzXN/ZeQ=;
        b=Qiw9s3bLBJr9aW4C+ktXrouLUSQdtCEkiJ+P6J8wIQb44MBQ06U4zrNfqGWzYIvaVU
         H35niu3LUOBgrSUs9XbzCP7sx9Wqa9LeW6qDiH0S972ufL0Uz1geYG0cEpA7kokSHkG4
         VtbYJ4ef2TD25tFnV+BR6mZ94vnptWfPL37YGfC2fHBI/z0O6WCBombuXklNEOaBAt36
         wkL6l54wKa/p+PD+c4R+gdV8nHGrCSveJGK6A7Ht/JaZntzIzhI90WO1jVi3qGK2igGH
         zpAOJFVscYCaXpApju1CGqt6nICuCuKCdEWOJvUsWYAe7qPtYL9TtShBbQfhWyd8PMq0
         84mA==
X-Gm-Message-State: APjAAAV3BbEqxejKu+WxqdOFjFxBhgOu5j+cdgGkB6g2akEFWCDTEjMj
        e8+Lcm4AImRy2i3tX61QpoBsqZbG
X-Google-Smtp-Source: APXvYqx5XO1J58kTgw63WFnWTS22IVEci4YpTRq/EMSSUXKSpAZhlpgoNz3pVX7u2v2KS+84GtNgrA==
X-Received: by 2002:ac8:45c7:: with SMTP id e7mr4702199qto.334.1576012118946;
        Tue, 10 Dec 2019 13:08:38 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x68sm1305885qkc.22.2019.12.10.13.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:08:38 -0800 (PST)
Date:   Tue, 10 Dec 2019 16:08:36 -0500
Message-ID: <20191210160836.GB1439145@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
In-Reply-To: <40090370-4d81-0ea9-e81a-da59534161b7@cumulusnetworks.com>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
 <20191210143931.GF1344570@t480s.localdomain>
 <2f4e351c-158a-4f00-629f-237a63742f66@cumulusnetworks.com>
 <20191210151047.GB1423505@t480s.localdomain>
 <1aa8b6e4-6a73-60b0-c5fb-c0dfa05e27e6@cumulusnetworks.com>
 <20191210153441.GB1429230@t480s.localdomain>
 <40090370-4d81-0ea9-e81a-da59534161b7@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 22:52:59 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> >>>>>> Why do you need percpu ? All of these seem to be incremented with the
> >>>>>> bridge lock held. A few more comments below.
> >>>>>
> >>>>> All other xstats are incremented percpu, I simply followed the pattern.
> >>>>>
> >>>>
> >>>> We have already a lock, we can use it and avoid the whole per-cpu memory handling.
> >>>> It seems to be acquired in all cases where these counters need to be changed.
> >>>
> >>> Since the other xstats counters are currently implemented this way, I prefer
> >>> to keep the code as is, until we eventually change them all if percpu is in
> >>> fact not needed anymore.
> >>>
> >>> The new series is ready and I can submit it now if there's no objection.
> >>
> >> There is a reason other counters use per-cpu - they're incremented without any locking from fast-path.
> >> The bridge STP code already has a lock which is acquired in all of these paths and we don't need
> >> this overhead and the per-cpu memory allocations. Unless you can find a STP codepath which actually
> >> needs per-cpu, I'd prefer you drop it.
> > 
> > Ho ok I understand what you mean now. I'll drop the percpu attribute.
> 
> Great, thanks again.
> I think it's clear, but I'll add just in case to avoid extra work - you can drop
> the dynamic memory allocation altogether and make the struct part of net_bridge_port.

Yup, that's what I've done and it makes the patch shamely small now ;)


Thanks,

	Vivien
