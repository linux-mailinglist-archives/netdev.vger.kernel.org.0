Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530EF15890A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 04:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgBKDud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 22:50:33 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43922 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgBKDua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 22:50:30 -0500
Received: by mail-pg1-f196.google.com with SMTP id u131so4962862pgc.10
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 19:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F0U52WoOTmznpmVQlips03nRcDHW124eA6wJkCew2vE=;
        b=NL+ktiBPYYZ8zpXButlfJWwqcrHceS7f+3rgqCXGxa4b1J9sQcm+Izzs3jSMbuLvXS
         wmZgfKzkymB752daqLQRXYSSjmjcQfqTQrQArmhNuSj0WYHexB1zhHZLDkXM6M8Zbb7u
         sRy+i6OXluZ43OTQb2U6TD6FMmvXPMQ0LVEwOJMJRRttU4yMnU8PxWoXIP6Zty0EcqU3
         QdM13bpXtf0j9aYF4TilBLL8yolnqqpzRrkwUGTeP5EKUW1JROJDxM64aPrOV7ABl3kd
         yAdZ3WIeMLEoFeLEGUNBkb24Lq/S1gR1oDNwrIoT1eYh40wdI5STHbWhedsJ9tQ7kRXT
         FmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F0U52WoOTmznpmVQlips03nRcDHW124eA6wJkCew2vE=;
        b=Ohd6ugEC8HSTjOKMiI7UpNpf179oo+y0h+ajwIom8F8P+c19TyqacN8SUZ+jpPYLDo
         l+lWxPlyucb3iMw38QEupFFj6/YxnEuo5UQTBvjRo7t0mQuyYEB362F3kzq/GZpyjX6j
         ZWgRcjidjzgLiE6RRlw7O/HW74l3mgDsI7ovWxhicIAQRooj7z2ZXatvaPwr4GS/8/CZ
         axT+qUMGoipD/0l6M5LXuhfOwM5loiZQJJbOs88KV4iuYNa8BizP7k+/HTaDE75mOExx
         zdUKWGCHMgQxSShpXtwQINa/6olsE19q/+VpGknY+GqfJsoDiExGXglxWakxQ9l3mqzU
         ihmA==
X-Gm-Message-State: APjAAAUh2Eq38pM3eRY3JrwhHg7+ccGD6bujcvFo16jeK+mATM3lT3Fu
        bKeeRiYwreAX0scVGqMrQm4A
X-Google-Smtp-Source: APXvYqzKmjTxhZKI1zpyKOREnV/LDVQAEKBbMyHrXGkxmtbsTL98gQk3MjS2BVFjI386gOomzrBYAg==
X-Received: by 2002:aa7:9218:: with SMTP id 24mr1188856pfo.145.1581393029174;
        Mon, 10 Feb 2020 19:50:29 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:638b:7653:754d:196d:c455:1f88])
        by smtp.gmail.com with ESMTPSA id e16sm1513040pgk.77.2020.02.10.19.50.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Feb 2020 19:50:28 -0800 (PST)
Date:   Tue, 11 Feb 2020 09:20:20 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Chris Lew <clew@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        arnd@arndb.de, smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, bjorn.andersson@linaro.org,
        hemantk@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 14/16] net: qrtr: Add MHI transport layer
Message-ID: <20200211035020.GA3358@Mani-XPS-13-9360>
References: <20200131135009.31477-1-manivannan.sadhasivam@linaro.org>
 <20200131135009.31477-15-manivannan.sadhasivam@linaro.org>
 <20200203101225.43bd27bc@cakuba.hsd1.ca.comcast.net>
 <20200204081914.GB7452@Mani-XPS-13-9360>
 <53018abf-4bc9-1ddb-0be5-a9a3b9871a33@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53018abf-4bc9-1ddb-0be5-a9a3b9871a33@codeaurora.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

On Thu, Feb 06, 2020 at 04:14:19PM -0800, Chris Lew wrote:
> 
> On 2/4/2020 12:19 AM, Manivannan Sadhasivam wrote:
> > Hi Jakub,
> > 
> > On Mon, Feb 03, 2020 at 10:12:25AM -0800, Jakub Kicinski wrote:
> > > On Fri, 31 Jan 2020 19:20:07 +0530, Manivannan Sadhasivam wrote:
> > > > +/* From QRTR to MHI */
> > > > +static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
> > > > +				      struct mhi_result *mhi_res)
> > > > +{
> > > > +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
> > > > +	struct qrtr_mhi_pkt *pkt;
> > > > +	unsigned long flags;
> > > > +
> > > > +	spin_lock_irqsave(&qdev->ul_lock, flags);
> > > > +	pkt = list_first_entry(&qdev->ul_pkts, struct qrtr_mhi_pkt, node);
> > > > +	list_del(&pkt->node);
> > > > +	complete_all(&pkt->done);
> > > > +
> > > > +	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
> > > Which kref_get() does this pair with?
> > > 
> > > Looks like qcom_mhi_qrtr_send() will release a reference after
> > > completion, too.
> > > 
> > Yikes, there is some issue here...
> > 
> > Acutally the issue is not in what you referred above but the overall kref
> > handling itself. Please see below.
> > 
> > kref_put() should be present in qcom_mhi_qrtr_ul_callback() as it will
> > decrement the refcount which got incremented in qcom_mhi_qrtr_send(). It
> > should be noted that kref_init() will fix the refcount to 1 and kref_get() will
> > increment to 2. So for properly releasing the refcount to 0, we need to call
> > kref_put() twice.
> > 
> > So if all goes well, the refcount will get decremented twice in
> > qcom_mhi_qrtr_ul_callback() as well as in qcom_mhi_qrtr_send() and we are good.
> > 
> > But, if the transfer has failed ie., when qcom_mhi_qrtr_ul_callback() doesn't
> > get called, then we are leaking the refcount. I need to rework the kref handling
> > code in next iteration.
> > 
> > Thanks for triggering this!
> > 
> > Regards,
> > Mani
> > 
> > > > +	spin_unlock_irqrestore(&qdev->ul_lock, flags);
> > > > +}
> 
> Hi Mani,
> 
> I'm not sure if this was changed in your patches but MHI is supposed to give a
> ul_callback() for any packet that is successfully queued. In the case of the
> transfer failing, the ul_callback() should still be called so there should
> be no refcount leaking. It is an essential assumption I made, if that no longer
> holds true then the entire driver needs to be reworked.
> 

Your assumption is correct. Only when the packet gets queued into the transfer
ring, the ul_xfer_cb will be called irrespective of the transfer state (success
or failure). But when the mhi_queue_transfer() returns even before queuing any
packet, then we need to decrease the refcount in the error path.

Please correct me if I'm wrong.

Thanks,
Mani

> Thanks,
> Chris
> 
> -- 
> 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
