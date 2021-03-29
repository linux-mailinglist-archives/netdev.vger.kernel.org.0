Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7DB34CE7E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhC2LHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhC2LHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:07:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23138C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:07:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s21so5832179pjq.1
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BV5SCzlqlhZmgVnGU+pslrgQPwkiNjT8cD66WrSSQNE=;
        b=a6awiX5lrAYxSeLc0i0BlgG1v8Wek+tSjO0nNebSZ1tzlA7qFxKdwZ6M1LqVgij7ni
         1kHBs/s+MN1CnZxjeagshJgaLqiw247yVxs45X65XzjlSfWk8wlSAoxW41W283VCEX2g
         XhAunZMWCWvIrFTTvVJYg0o7ah0KZcCgzhI/uovq6RvRTilxyGO+4x98b1CqWpXLLhwx
         LtA0MVkHkA2ZL7Hauh+g49Det4je0HFMipc/ESqLXqNrY6mLcjzspJYLsog/8qZxyy9K
         cK3mtKHDagTl5ho6/2Rx6HGF0PfZogeqTU/3HB/46s3LQsD4s/29IX/XrJlNdeH/4Pt1
         WNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BV5SCzlqlhZmgVnGU+pslrgQPwkiNjT8cD66WrSSQNE=;
        b=I70TmCAGyhNIXsK+blVkZ0OLetu1+8EyaD+UkywxSIc/i3buH7NXryYasAzIwU/5o3
         zYKJk+jeF5urWf1z7kv2+V3QKaPe/sPCJbowMoFyBl8wo8a8Rd1xXqpclFJB/DG4ORzm
         JGqIY/BYzkfz1y82nvxCXccvC2RTKEtxZ/OJHQd7W2jR81qarPy7ejZZRuxfi0qXKxU3
         SEVg1+p3ljo5Ww6J4BVT55Nqnr7Hhl3fmqsWjcdd97tbXQhHRaGgmDAAbqF+kpTZWSWl
         dexWyBmquEUA81HHpf4rs+75KVXBzSDa1pCPqWu4lN7iAn+JU9h8Ih2Acdw+QDz+ibk8
         iGhA==
X-Gm-Message-State: AOAM533bzp2IIrqypMbG43vE5J3WbgHq0JUErzfZ/WTVttgkUL4UOvGB
        qsn8H/OD1zGrV1P84Y5E5LSR
X-Google-Smtp-Source: ABdhPJzBpn6BzK9KN9ilpYNiGpyLrHi6NXGW4ilcKV1+w393KwX54OMtenBhXfgg5RN/ue3ypw9VXw==
X-Received: by 2002:a17:90a:1696:: with SMTP id o22mr25238896pja.0.1617016065639;
        Mon, 29 Mar 2021 04:07:45 -0700 (PDT)
Received: from work ([103.77.37.146])
        by smtp.gmail.com with ESMTPSA id q10sm16353763pfc.190.2021.03.29.04.07.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 04:07:45 -0700 (PDT)
Date:   Mon, 29 Mar 2021 16:37:41 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <20210329110741.GC2763@work>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
 <CAMZdPi_3B9Bxg=7MudFq+RnhD10Mm5QbX_pBb5vyPsZAC_bNOQ@mail.gmail.com>
 <20210329105236.GB2763@work>
 <YGGz/BaibxykzxOW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGGz/BaibxykzxOW@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 01:03:24PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Mar 29, 2021 at 04:22:36PM +0530, Manivannan Sadhasivam wrote:
> > Hi Greg,
> > 
> > On Mon, Mar 29, 2021 at 11:47:12AM +0200, Loic Poulain wrote:
> > > Hi Greg,
> > > 
> > > On Sun, 28 Mar 2021 at 14:28, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > wrote:
> > > 
> > > > There does not seem to be any developers willing to maintain the
> > > > net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> > > > from the kernel tree entirely in a few kernel releases if no one steps
> > > > up to maintain it.
> > > >
> > > > Reported-by: Matthew Wilcox <willy@infradead.org>
> > > > Cc: Du Cheng <ducheng2@gmail.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >
> > > 
> > > As far as I know, QRTR/IPCR is still commonly used with Qualcomm-based
> > > platforms for accessing various components of the SoC.
> > > CCing Bjorn and Mani, In case they are interested in taking maintenance of
> > > that.
> > > 
> > 
> > As Loic said, QRTR is an integral component used in various Qualcomm based
> > upstream supported products like ChromeOS, newer WLAN chipsets (QCA6390) etc...
> > 
> > It is unfortunate that no one stepped up so far to maintain it. After
> > having an internal discussion, I decided to pitch in as a maintainer. I'll
> > send the MAINTAINERS change to netdev list now.
> 
> Great, can you also fix up the reported problems with the codebase that
> resulted in this "ask for removal"?
> 

Yes, ofc. I do see couple of Syzbot bug reports now... I will look into them.
It turned out I fixed one of them earlier but should've handled all :)

Thanks,
Mani

> thanks,
> 
> greg k-h
