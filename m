Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2575D19954B
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 13:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgCaLXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 07:23:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41588 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbgCaLXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 07:23:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id b1so10199092pgm.8
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 04:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JXxdjqfqKsI367q8g3+EJ/v0hXOY5Q6mELpkQJCd7wk=;
        b=cmejOzvwxWsAKsSDIXk6EJoFXbWVfi1jjPgaxvRqVm37ksv/8dHWnJd7OFc9fHcCdj
         Ly8QIKPqZvBgj8i5qgQZQHj1fIFL0+vuLzq5wXxn4WGbs4Z16J4k7hmf9Xx6t6vtoiyu
         iTdJ3gqKOcq/WFlXjreQNLgLQAlQ1TSEo404PBkG1Pw5dRerooiFmTTbRR+SQVC7Sacz
         H7VNtsQgFmo8SvrYmoswPnuXD9wOWBGORwHhyx0MT7ByTGjLcvmOteA5TgEE4rbXKqGE
         fWkXSnR4TPGDrm0CtwxzEcnT+gcj20xIHioZ78D30FUbqbUfp1LhXXedGi/oLbLt1Xvp
         Fr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JXxdjqfqKsI367q8g3+EJ/v0hXOY5Q6mELpkQJCd7wk=;
        b=eFs+GsmK6oMfzKucjFfNK8pTvvBfpGZ0Ofre+30z7TjGs4iaXBEYTptIXFV30jmstA
         pIahlVha4YHRuVz2zujb59B6c+ecc6ePqf8p8wUB2kEmZA8w7sPkFHj5tOlwMpVMYHKl
         HZomt3ZWgSbKsMwBpGf4mkY7lsfMAzVM8PNDymMCW31P/0eBb5cYm/7eO1jeyGcEerxu
         QZ/EpollMvuyE4rrwuwksk9OhIbZcZ7D9whHcOM/Xt6XKOd7OeKZr2hcmRYpHqAR7sOe
         Y5yZti6LXjkPT6nA1aAiEPCrc6vNmKXKBWyRu0dkeubcBkftRAXlxgFT07k9UoC2ZPfC
         C67g==
X-Gm-Message-State: ANhLgQ2hYCTAJNlBGYJMhVxEQr1LWOXOJJ8ngc5hTeuqL40/wQAE55n2
        413/KEmmiF6xfshoyRqHmJfR
X-Google-Smtp-Source: ADFU+vua2WWw22BJNgir87I4Bn/FSDg8vWUO/X+nkfFs5lP44LsMIG180Kn7igbKPzREsGKTyjW1iw==
X-Received: by 2002:a65:5383:: with SMTP id x3mr17166618pgq.279.1585653814612;
        Tue, 31 Mar 2020 04:23:34 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:630f:1337:c28:2530:7bf4:e941])
        by smtp.gmail.com with ESMTPSA id q71sm12347339pfc.92.2020.03.31.04.23.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Mar 2020 04:23:33 -0700 (PDT)
Date:   Tue, 31 Mar 2020 16:53:26 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Chris Lew <clew@codeaurora.org>, gregkh@linuxfoundation.org,
        davem@davemloft.net, smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 6/7] net: qrtr: Add MHI transport layer
Message-ID: <20200331112326.GB21688@Mani-XPS-13-9360>
References: <20200324061050.14845-1-manivannan.sadhasivam@linaro.org>
 <20200324061050.14845-7-manivannan.sadhasivam@linaro.org>
 <20200324203952.GC119913@minitux>
 <20200325103758.GA7216@Mani-XPS-13-9360>
 <89f3c60c-70fb-23d3-d50f-98d1982b84b9@codeaurora.org>
 <20200330094913.GA2642@Mani-XPS-13-9360>
 <20200330221932.GB215915@minitux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330221932.GB215915@minitux>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

On Mon, Mar 30, 2020 at 03:19:32PM -0700, Bjorn Andersson wrote:
> On Mon 30 Mar 02:49 PDT 2020, Manivannan Sadhasivam wrote:
> 
> > Hi Chris,
> > 
> > On Thu, Mar 26, 2020 at 03:54:42PM -0700, Chris Lew wrote:
> > > 
> > > 
> > > On 3/25/2020 3:37 AM, Manivannan Sadhasivam wrote:
> > > > Hi Bjorn,
> > > > 
> > > > + Chris Lew
> > > > 
> > > > On Tue, Mar 24, 2020 at 01:39:52PM -0700, Bjorn Andersson wrote:
> > > > > On Mon 23 Mar 23:10 PDT 2020, Manivannan Sadhasivam wrote:
> [..]
> > > > > > +	spin_lock_irqsave(&qdev->ul_lock, flags);
> > > > > > +	list_for_each_entry(pkt, &qdev->ul_pkts, node)
> > > > > > +		complete_all(&pkt->done);
> > > > 
> > > > Chris, shouldn't we require list_del(&pkt->node) here?
> > > > 
> > > 
> > > No this isn't a full cleanup, with the "early notifier" we just unblocked
> > > any threads waiting for the ul_callback. Those threads will wake, check
> > > in_reset, return an error back to the caller. Any list cleanup will be done
> > > in the ul_callbacks that the mhi bus will do for each queued packet right
> > > before device remove.
> > > 
> > > Again to simplify the code, we can probable remove the in_reset handling
> > > since it's not required with the current feature set.
> > > 
> > 
> > So since we are not getting status_cb for fatal errors, I think we should just
> > remove status_cb, in_reset and timeout code.
> > 
> 
> Looks reasonable.
> 
> [..]
> > > I thought having the client get an error on timeout and resend the packet
> > > would be better than silently dropping it. In practice, we've really only
> > > seen the timeout or ul_callback errors on unrecoverable errors so I think
> > > the timeout handling can definitely be redone.
> > > 
> > 
> > You mean we can just remove the timeout handling part and return after
> > kref_put()?
> > 
> 
> If all messages are "generated" by qcom_mhi_qrtr_send() and "released"
> in qcom_mhi_qrtr_ul_callback() I don't think you need the refcounting at
> all.
> 

Hmm, you're right. We can move the packet releasing part to ul_callback now.

> 
> Presumably though, it would have been nice to not have to carry a
> separate list of packets (and hope that it's in sync with the mhi core)
> and instead have the ul callback somehow allow us to derive the skb to
> be freed.
> 

Yep, MHI stack holds the skb in buf_addr member of mhi_result. So, we can just
use below to get the skb in ul_callback:

struct sk_buff *skb = (struct sk_buff *)mhi_res->buf_addr;

This will help us to avoid the use of pkt, ul_pkts list and use the skb directly
everywhere. At the same time I think we can also remove the ul_lock which
was added to protect the ul_pkts list.

Let me know your opinion, I'll just send a series with this modified QRTR MHI
client driver and MHI suspend/resume patches.

Thanks,
Mani

> Regards,
> Bjorn
