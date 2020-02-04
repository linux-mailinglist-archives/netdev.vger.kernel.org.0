Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EFC1516EC
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 09:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgBDIT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 03:19:29 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40730 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgBDIT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 03:19:28 -0500
Received: by mail-pl1-f194.google.com with SMTP id y1so6952374plp.7
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 00:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e7VapZs7ToFtGQHirc2gqfuZaDOEBKykkyxeoFQPPr0=;
        b=qDFRSO55Rv/R04oSblvygRyyFRoB6x6wb+su1cgyo/BppoM0+ZDgs8RozwgkK78Sci
         ghPLeZFFf9kILD6GN0VLX2rpGOVtNip/n8BJEM708QGzL5965uow7Dp+dAorskXuSKkd
         kcn9QHnmSeaZkVwiPSATgkTv8F9ZlkKyJQbYDy3F5BJFrbb4zlsvmlOaGPXaJgwfqoS4
         m7OCdxGsCX/2yHJF65AXCxiler2uuqrKAaz6asOH0fvHc1zwYKC7ltO/LKQkLyK6f5hc
         qu8bXKEK7Qek05xniIc0pewDBxQqbEGS/GplfUOEldjkJJTPWVKvHHvAbehYWChMP6MW
         WtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e7VapZs7ToFtGQHirc2gqfuZaDOEBKykkyxeoFQPPr0=;
        b=SWjIit+QHj3mUrw5KrzfY3Z78838UEA19GhKxPCJsEjbxqN0eeL8A8dy3Co/cJELLg
         sljY5lB78blxQ20P1hxRgXqYlU8YTUCB5r/71MDKN80vsKcF/MUyWrOP1NK/RF5ZKSD3
         OKlt0rw361/rBhMNki24UpQz6X0lyOTtI0lU65z438oR+zdtzIFE61dJFaeZdgDntT5z
         1QCjMA0aEDIuXgcYKVqJYPR0/bxwO4OGn6KIxipMrIjzfTBnpHUvr062CRtd/LkRjsS8
         Il4TH6g/x/3AsAm/9LXYx+Sm0SKiZ3/Gq5TjQMHcQtQrWSOaFGiB7uxHgh4YQAQl0w93
         flZA==
X-Gm-Message-State: APjAAAWjfq/kdmPgjNWNWrEiD9Usa9KSLr0dsaLNp6R6G3GMV7Au1dow
        wxcC6IYwgd/AJ7v08sxvhBi1
X-Google-Smtp-Source: APXvYqwc3F+ajrWjrRQ9TQ7Nc/U7oGxap8lGBbplh9eigm6PnJygpBlf7IQd9svy86r/SV0NWozUhA==
X-Received: by 2002:a17:902:b909:: with SMTP id bf9mr27151608plb.96.1580804366289;
        Tue, 04 Feb 2020 00:19:26 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:184:5239:5cf8:8075:e072:4b02])
        by smtp.gmail.com with ESMTPSA id z29sm22684879pgc.21.2020.02.04.00.19.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 00:19:25 -0800 (PST)
Date:   Tue, 4 Feb 2020 13:49:16 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     gregkh@linuxfoundation.org, arnd@arndb.de, smohanad@codeaurora.org,
        jhugo@codeaurora.org, kvalo@codeaurora.org,
        bjorn.andersson@linaro.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 14/16] net: qrtr: Add MHI transport layer
Message-ID: <20200204081914.GB7452@Mani-XPS-13-9360>
References: <20200131135009.31477-1-manivannan.sadhasivam@linaro.org>
 <20200131135009.31477-15-manivannan.sadhasivam@linaro.org>
 <20200203101225.43bd27bc@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203101225.43bd27bc@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Feb 03, 2020 at 10:12:25AM -0800, Jakub Kicinski wrote:
> On Fri, 31 Jan 2020 19:20:07 +0530, Manivannan Sadhasivam wrote:
> > +/* From QRTR to MHI */
> > +static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
> > +				      struct mhi_result *mhi_res)
> > +{
> > +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
> > +	struct qrtr_mhi_pkt *pkt;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&qdev->ul_lock, flags);
> > +	pkt = list_first_entry(&qdev->ul_pkts, struct qrtr_mhi_pkt, node);
> > +	list_del(&pkt->node);
> > +	complete_all(&pkt->done);
> > +
> > +	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
> 
> Which kref_get() does this pair with?
> 
> Looks like qcom_mhi_qrtr_send() will release a reference after
> completion, too.
> 

Yikes, there is some issue here...

Acutally the issue is not in what you referred above but the overall kref
handling itself. Please see below.

kref_put() should be present in qcom_mhi_qrtr_ul_callback() as it will
decrement the refcount which got incremented in qcom_mhi_qrtr_send(). It
should be noted that kref_init() will fix the refcount to 1 and kref_get() will
increment to 2. So for properly releasing the refcount to 0, we need to call
kref_put() twice.

So if all goes well, the refcount will get decremented twice in
qcom_mhi_qrtr_ul_callback() as well as in qcom_mhi_qrtr_send() and we are good.

But, if the transfer has failed ie., when qcom_mhi_qrtr_ul_callback() doesn't
get called, then we are leaking the refcount. I need to rework the kref handling
code in next iteration.

Thanks for triggering this!

Regards,
Mani

> > +	spin_unlock_irqrestore(&qdev->ul_lock, flags);
> > +}
