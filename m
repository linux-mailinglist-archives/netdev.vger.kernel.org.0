Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21834CE45
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhC2Kwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhC2Kwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:52:41 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B43CC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 03:52:41 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a12so739320pfc.7
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 03:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zCi+8wvYAY67RniX/GEktTm2xA73r+u69GZxE6aKJwo=;
        b=dyobHRCWFtvrAnx0W9G5uuFSXdK9/s8BWM3GQGVJEsSPlEw7nrcgvxXQ3gSN3KMy3E
         rQZqUcJumvdo/GZqr6gEezFQBhz0FNB5j1lkW5i5cPPYfRsfPQBAzYZ5fVtl26Y998Xx
         ypkA1/n2rqWxyedoEwcb3tD9A0xzArroo5O8LP8zs5kWqXr0uWMb/mJY2bHXXaOhP36h
         FRvHE8XI6KFWdjy8GlyxSvnNDYDB4CY5js+NbZXHfLFS0COIwa1oAd+zMFKmSpxih8Yv
         eyDkqK0uw2BESgHoKlefBZanZPRC3t4oY5JWPKj5P0g+VDczcXpz+ZIw9pMdardG5JjR
         TlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zCi+8wvYAY67RniX/GEktTm2xA73r+u69GZxE6aKJwo=;
        b=r0GEGh6BpLcbmB9f536JIkA6/AKLLRgP1XAMhJoDSE64kjqPO7gYf5iN78qVuDpCEI
         S74SG+MWUX4sEfBZ/Ea4x5b20iYrcyIl3vRGy04yCosEv+GAk+vDn3E18PckR4i9mwBc
         3Kzvs1LFpu/8IC3kXQwSsYd2Ck89x2YIZf46RJ6hmYUnSfw4a3H9H0bxqKeZTa7evzu2
         hNzk7mD27G9iVzIWcedzIXycWrCT5CJzRAT8LMfeJL0+fUpTrTQ2GEbQXlcrTnCiXMWo
         uZtpyoWuIzXvcpXkCDvu0bAryUVqZjaNs9gPxp88vPkoij6Oie8U8hXB4IYEeWfY/16S
         JWAw==
X-Gm-Message-State: AOAM531+y4+z3dwTxRGTG9D7fsbjRlnqkT9xkZanMhlRxE60bFqj/62G
        dOihJIrTbGatKheyxob7HY1OsphJIo6S
X-Google-Smtp-Source: ABdhPJx+BynwlrVOX+Se1Udi5WtYJwlEGDmJtPvJB3qdl7NDJDRden16rkRtWZ4yCCCELfjZYJrQHg==
X-Received: by 2002:a63:5a26:: with SMTP id o38mr22839446pgb.54.1617015160806;
        Mon, 29 Mar 2021 03:52:40 -0700 (PDT)
Received: from work ([103.77.37.146])
        by smtp.gmail.com with ESMTPSA id r16sm16574665pfq.211.2021.03.29.03.52.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Mar 2021 03:52:40 -0700 (PDT)
Date:   Mon, 29 Mar 2021 16:22:36 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <20210329105236.GB2763@work>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
 <CAMZdPi_3B9Bxg=7MudFq+RnhD10Mm5QbX_pBb5vyPsZAC_bNOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi_3B9Bxg=7MudFq+RnhD10Mm5QbX_pBb5vyPsZAC_bNOQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Mon, Mar 29, 2021 at 11:47:12AM +0200, Loic Poulain wrote:
> Hi Greg,
> 
> On Sun, 28 Mar 2021 at 14:28, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> wrote:
> 
> > There does not seem to be any developers willing to maintain the
> > net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> > from the kernel tree entirely in a few kernel releases if no one steps
> > up to maintain it.
> >
> > Reported-by: Matthew Wilcox <willy@infradead.org>
> > Cc: Du Cheng <ducheng2@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> 
> As far as I know, QRTR/IPCR is still commonly used with Qualcomm-based
> platforms for accessing various components of the SoC.
> CCing Bjorn and Mani, In case they are interested in taking maintenance of
> that.
> 

As Loic said, QRTR is an integral component used in various Qualcomm based
upstream supported products like ChromeOS, newer WLAN chipsets (QCA6390) etc...

It is unfortunate that no one stepped up so far to maintain it. After
having an internal discussion, I decided to pitch in as a maintainer. I'll
send the MAINTAINERS change to netdev list now.

Thanks,
Mani

> Regards,
> Loic
