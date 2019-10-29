Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F17E6E836B
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfJ2InZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:43:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34573 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728995AbfJ2InZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:43:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so12659047wrr.1
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 01:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2Y1e6eXMXynj3RVm6A/v7p+Rx7z46GaGYsW4oOsjovc=;
        b=wavt2/1wTjV79EJap7JbgnE2Twi+9BnBLl1BHzBNl3vIs2ZXYZ5HrrxkfM3CKwswgj
         sw6aeOhyfWasmAuDA08IFOYHsMO5LIBf5pt7y/wA3OVWD1tdoJBDyMNGJDcZHed3K0hQ
         TGIps6ZZGwOZNPavurYTlkGlU30hmfoZIJOEcYN97v5MIS0O24fHR+K8ChWaH2zKHIsh
         ICO8D+vwppTHPxR+5+JldQ3zx6FnSsFOXwCb8M9bkBt88WuwnipSdlRin1MJUpzqVmXp
         EVrEom4gkCv75CNw3zuLBldoeXeMrrVQ1LiZ6DAEtqXZf6rd2VdeislzDMV+Bh1GEfnV
         poIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Y1e6eXMXynj3RVm6A/v7p+Rx7z46GaGYsW4oOsjovc=;
        b=F640umAMnA195Ft/GUCwLhG+C/A/iDouUe3k0BVB0M5EglRFp8ktOEEcb4UJr46s7D
         TTuaxIl48PhGkb0f8HNRXykWWJgaVihRXodGK2nBUsAJydAkFVi7JUABK0D6ev3Om1ke
         gV2cKEFYTB4urFr41wkbAY0jjqj4V8g4LGEb89NI1ZriWCsR9kiQBpSEHMwoZUbqXfPb
         +MJz80EHmiZrDjAho4trugyGRjIn8aJvNOERZG/fW/9XtXLIn0nLRDUVJOo+kjhIzRXa
         KMJefkA8yxxACruPOvGiCaWLm5DvHdc9UJGbQePxErQDR+D+a6l/vfGc3Lvch98EZHKl
         iMLQ==
X-Gm-Message-State: APjAAAW4UoVc07gFZ/8zFglb75ZqZcZ11DmU/SLv5fSXUMIupXJ+RY83
        xQiUBvftvJvnTXrUrIRowfJU7w==
X-Google-Smtp-Source: APXvYqx+LFWSW8vxJhxbdOsjx1jGLoXPJPKXrqqM25niggkWBSCsM/ioC7zlbwA136enGM6e3I1O9g==
X-Received: by 2002:adf:f152:: with SMTP id y18mr19562113wro.285.1572338603282;
        Tue, 29 Oct 2019 01:43:23 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id p10sm15381693wrx.2.2019.10.29.01.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 01:43:22 -0700 (PDT)
Date:   Tue, 29 Oct 2019 09:43:21 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, swinslow@gmail.com,
        will@kernel.org, opensource@jilayne.com, baijiaju1990@gmail.com,
        tglx@linutronix.de, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
Subject: Re: [PATCH] b43: Fix use true/false for bool type
Message-ID: <20191029084320.GC23615@netronome.com>
References: <20191028190204.GA27248@saurav>
 <20191029082427.GB23615@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029082427.GB23615@netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 09:24:27AM +0100, Simon Horman wrote:
> Hi Saurav,
> 
> thanks for your patch.
> 
> On Tue, Oct 29, 2019 at 12:32:04AM +0530, Saurav Girepunje wrote:
> > use true/false on bool type variable assignment.
> > 
> > Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
> 
> This does not seem to cover the case in dma.c,
> which seems to want fixing for the sake of consistency.

I now see this handled in a separate patch, sorry for the noise.

> Also, I wonder why bools rather than a bitmask was chosen
> for this field, it seems rather space intensive in its current form.
> 
> > ---
> >  drivers/net/wireless/broadcom/b43/main.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
> > index b85603e91c7a..39da1a4c30ac 100644
> > --- a/drivers/net/wireless/broadcom/b43/main.c
> > +++ b/drivers/net/wireless/broadcom/b43/main.c
> > @@ -3600,7 +3600,7 @@ static void b43_tx_work(struct work_struct *work)
> >  			else
> >  				err = b43_dma_tx(dev, skb);
> >  			if (err == -ENOSPC) {
> > -				wl->tx_queue_stopped[queue_num] = 1;
> > +				wl->tx_queue_stopped[queue_num] = true;
> >  				ieee80211_stop_queue(wl->hw, queue_num);
> >  				skb_queue_head(&wl->tx_queue[queue_num], skb);
> >  				break;
> > @@ -3611,7 +3611,7 @@ static void b43_tx_work(struct work_struct *work)
> >  		}
> >  
> >  		if (!err)
> > -			wl->tx_queue_stopped[queue_num] = 0;
> > +			wl->tx_queue_stopped[queue_num] = false;
> >  	}
> >  
> >  #if B43_DEBUG
> > @@ -5603,7 +5603,7 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
> >  	/* Initialize queues and flags. */
> >  	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
> >  		skb_queue_head_init(&wl->tx_queue[queue_num]);
> > -		wl->tx_queue_stopped[queue_num] = 0;
> > +		wl->tx_queue_stopped[queue_num] = false;
> >  	}
> >  
> >  	snprintf(chip_name, ARRAY_SIZE(chip_name),
> > -- 
> > 2.20.1
> > 
> 
