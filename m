Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEFD256D9F
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 14:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgH3M0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 08:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgH3M0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 08:26:34 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F27C061573;
        Sun, 30 Aug 2020 05:26:33 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x18so516404pll.6;
        Sun, 30 Aug 2020 05:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ejqO87rorFkVXw0/ByXTM9CvLRvpm4qV9tVsBbkXl5I=;
        b=Qn/++4J3Z/bAbP0hfH0Wek8D4QXU9x5lXBOPjjGgyy3p6+DhkFdVlK0Qvg4sbZbHyi
         CspnA895diI0L0XAsK24N+J8fESh1feelF5xwmNNhoiSTCepBgdldjloZbw4/vZe2zDP
         MFGkygHfhqtWNHZh8kpm+fFqiz6gT1qfCwekkFSoTCejD0LBLfreK8URHXDxS9BRd0WL
         9IGdmslXLCm0sIlbc6e9rhoSWtKYoR17FJ7W7FwGuRs1i7vfZoggNq+0lXyEQ8Z2FnOP
         cn26BnOtUttf/mNbMH2hNrvEXPEJ7hsA82rYu1pSJEvQ93ItrDGAR4UXt4O4uI5vEPnw
         Jt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ejqO87rorFkVXw0/ByXTM9CvLRvpm4qV9tVsBbkXl5I=;
        b=FWs+QFB9pM+nZa4mQ7tSTToenNuVNBmjhnI+hu5JXsOK1rsa8Se9RfdU/SHMx44uGu
         oy9qwlkBbOn7CZurJzlnuA0K1CmGR4Ut6mJ5DqzkO0baRGihrg7OXjot85hMtJvc8Tpt
         MNGdg7WJsfML9RzLoqUxGPUf7S6eQMtv4EiPvxpSoM3tmxZRC9afCJC6rFvpdeR5VJ+B
         K4zjcMeJ2eERo/+XbU8iwGBTPfS9BLutrpMhXxkXr/gpL8MX1zTdVFbnJVTKgQ8lVOrc
         Tjy2Wk4ozADuk2NVn+VYwbxQzeWsamOG+eeStZ9Uy6xHuZnsY4Jl9ShW39L4cnGPg5p+
         JR3Q==
X-Gm-Message-State: AOAM533FdLyVa2aD9I6SVm7VunlDI5NM42XIiWaXoZI6H1Dr/G/cQabK
        paKTzjwSon55twUtr5PR1Yw=
X-Google-Smtp-Source: ABdhPJzZtb1Nfg209xbdteCKN2XIoYQJIeLuvoBWNxezlKGZpJEy+OsTzIZvgQ8YxxVX/yrRKcwePw==
X-Received: by 2002:a17:902:8347:: with SMTP id z7mr5506118pln.20.1598790391028;
        Sun, 30 Aug 2020 05:26:31 -0700 (PDT)
Received: from Thinkpad ([45.118.165.143])
        by smtp.gmail.com with ESMTPSA id lj3sm4290067pjb.26.2020.08.30.05.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 05:26:30 -0700 (PDT)
Date:   Sun, 30 Aug 2020 17:56:23 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     syzbot+0bef568258653cff272f@syzkaller.appspotmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, anmol.karan123@gmail.com
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 deref in hci_phy_link_complete_evt
Message-ID: <20200830122623.GA235919@Thinkpad>
References: <20200829124112.227133-1-anmol.karan123@gmail.com>
 <20200829165712.229437-1-anmol.karan123@gmail.com>
 <20200830091917.GB122343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830091917.GB122343@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 11:19:17AM +0200, Greg KH wrote:
> On Sat, Aug 29, 2020 at 10:27:12PM +0530, Anmol Karn wrote:
> > Fix null pointer deref in hci_phy_link_complete_evt, there was no 
> > checking there for the hcon->amp_mgr->l2cap_conn->hconn, and also 
> > in hci_cmd_work, for hdev->sent_cmd.
> > 
> > To fix this issue Add pointer checking in hci_cmd_work and
> > hci_phy_link_complete_evt.
> > [Linux-next-20200827]
> > 
> > This patch corrected some mistakes from previous patch.
> > 
> > Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?id=0d93140da5a82305a66a136af99b088b75177b99
> > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > ---
> >  net/bluetooth/hci_core.c  | 5 ++++-
> >  net/bluetooth/hci_event.c | 4 ++++
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index 68bfe57b6625..996efd654e7a 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -4922,7 +4922,10 @@ static void hci_cmd_work(struct work_struct *work)
> >  
> >  		kfree_skb(hdev->sent_cmd);
> >  
> > -		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> > +		if (hdev->sent_cmd) {
> > +			hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> > +		}
> 
> How can sent_cmd be NULL here?  Are you sure something previous to this
> shouldn't be fixed instead?

Sir, sent_cmd was freed before this condition check, thats why i checked it,

i think i should check it before the free of hdev->sent_cmd like,

if (hdev->sent_cmd)
	kfree_skb(hdev->sent_cmd);

what's your opininon on this.

> 
> 
> > +
> >  		if (hdev->sent_cmd) {
> >  			if (hci_req_status_pend(hdev))
> >  				hci_dev_set_flag(hdev, HCI_CMD_PENDING);
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 4b7fc430793c..1e7d9bee9111 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -4941,6 +4941,10 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> >  		hci_dev_unlock(hdev);
> >  		return;
> >  	}
> > +	if (!(hcon->amp_mgr->l2cap_conn->hcon)) {
> > +		hci_dev_unlock(hdev);
> > +		return;
> > +	}
> 
> How can this be triggered?

syzbot showed that this line is accessed irrespective of the null value it contains, so  added a 
pointer check for that.

please give some opinions on this,

if (!bredr_hcon) {
	hci_dev_unlock(hdev);
        return;
}

Thanks,
Anmol Karn
