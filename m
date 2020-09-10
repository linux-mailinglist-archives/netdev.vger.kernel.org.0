Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D26326514A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgIJUux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730068AbgIJO6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 10:58:43 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8A8C061795;
        Thu, 10 Sep 2020 07:58:40 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so1044584plk.3;
        Thu, 10 Sep 2020 07:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c+jIOhRgqonxn9gWi6l8ZpfFwoQ7z7WBsHFiC8anX4Q=;
        b=XlGQF9XuctO2DJYPSPyHeW/lhATtADGhO23JHJstE97qMSAVFSOSjRevCHH7cLnmaa
         jKTk78ZhaxVjcb8GFw6y0ZK8/pc8YFnqe4Lgfvm350Yr4zOuigj1OwYcEZBH3Fa4Hopd
         f2JXQHcI7zIHWelYGT6BuO83OC2dMWcNELYXUx4ZjPMrYWABvYwXh5wvauERBXEA/KCj
         zCt73zratrDhMlwwRpv+qOG+TmdiqmVO5iKLq0V6KvZD3HDG8fJW3c7nnv6bHUbecrJX
         YSQ8qskzWdy9o9G+gn160C00yYczl8y5zKz5xQ/4lfR4AV2VL6BYF64Yo15qph5FiK4V
         D1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+jIOhRgqonxn9gWi6l8ZpfFwoQ7z7WBsHFiC8anX4Q=;
        b=k1iFeVdRvPFwGcc0KG0CviBRulCH75QjTnk6SXPF0lHxkYlyHfFA19DEGfmF+urN5h
         H3+B6NPyJ/iuqWO8us4gURIUrpOT7I9F9bUu0mOGWQOIGSOhOgaxyPUANtKjkMB37EoC
         h3yZDlRt9rtaJN3YFKVCTAb7k06eWGU9ue1hE+QO1x+70mWpEdqRjzCd0EgPDr4ZamVQ
         R9HN7EsZHB21qcSFH3vjYeoUVeFRheuG6itE/Vljqetj63N5d7XgZ5VSQFCRZU60HYQG
         4ZPCuvHpMioau1V361I9AxZgGAOXD2o/UE9CU2J9nda9cukoEIdUZjrjXGS+ZJRFWzbr
         L6og==
X-Gm-Message-State: AOAM530NfY/T/L/SLP+oICPO8LR/KgGsSoZpsQb8TTs8+9hkzMfSIusK
        Paor6MEoIkLzDsdjg17/m9c=
X-Google-Smtp-Source: ABdhPJyTyJInU3Ew5guC7S18EaBMn+CWm5koR7QxwkkRlVYQ2qn3nQcqOq07OGTmQ8ifN6WumFExOg==
X-Received: by 2002:a17:90a:81:: with SMTP id a1mr336645pja.136.1599749920004;
        Thu, 10 Sep 2020 07:58:40 -0700 (PDT)
Received: from Thinkpad ([45.118.165.135])
        by smtp.gmail.com with ESMTPSA id j2sm5424250pga.12.2020.09.10.07.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 07:58:39 -0700 (PDT)
Date:   Thu, 10 Sep 2020 20:28:31 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 dereference in hci_event_packet()
Message-ID: <20200910145831.GA33757@Thinkpad>
References: <20200910043424.19894-1-anmol.karan123@gmail.com>
 <20200910104918.GF12635@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910104918.GF12635@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 01:49:18PM +0300, Dan Carpenter wrote:
> On Thu, Sep 10, 2020 at 10:04:24AM +0530, Anmol Karn wrote:
> > Prevent hci_phy_link_complete_evt() from dereferencing 'hcon->amp_mgr'
> > as NULL. Fix it by adding pointer check for it.
> > 
> > Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
> > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > ---
> >  net/bluetooth/hci_event.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 4b7fc430793c..871e16804433 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> >  		return;
> >  	}
> >  
> > +	if (IS_ERR_OR_NULL(hcon->amp_mgr)) {
> 
> It can't be an error pointer.  Shouldn't we call hci_conn_del() on this
> path?  Try to find the Fixes tag to explain how this bug was introduced.
> 
> (Don't rush to send a v2.  The patch requires quite a bit more digging
> and detective work before it is ready).
> 
> > +		hci_dev_unlock(hdev);
> > +		return;
> > +	}
> > +
> >  	if (ev->status) {
> >  		hci_conn_del(hcon);
> >  		hci_dev_unlock(hdev);
> 
> regards,
> dan carpenter
> 

Sure sir, will  work on it, thanks for your review.

Anmol Karn
