Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFD0257086
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgH3Umz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 16:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3Umy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 16:42:54 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E824C061573;
        Sun, 30 Aug 2020 13:42:53 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so3159496pgd.5;
        Sun, 30 Aug 2020 13:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lzp6goA2AviezS1ObcAhoJPkamd8oGFknl/lz9o3BHg=;
        b=D8ZMSq6ZCaMQH+SvK/2jSp60cp+cGxD66jR5JXrzKIa1yYxBpEhK37W6I+ozBoxP1W
         9NDE+WAgHHKNFLsc9BF69aVNY9azAERIZDstCOGuOwdO9gf4fPRZjO8bkrEoT2BKJ8je
         sJ1encrhctGQO1EYssfCY9vexv4WaxL10S6uEOIKDONNp6jjZF5muUcf9+FjbZkKA48H
         Xm82lzy4Iw5TyOA5t9yFVufuEPh8KutGPNWWcxgzWAKVvscsmlQ0IF1LoUtYE+6ByPNg
         KYN0s7qvNFV1YmK5jAlJs8YQEwHyn8z5HsSl5gTe7YSIt0suc1Gx/CYuGAAip+ia5Rj8
         ZvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lzp6goA2AviezS1ObcAhoJPkamd8oGFknl/lz9o3BHg=;
        b=gIvSjtmAgqOiYZ5Lz07QE6ZQtEVgYtpKPKhMLEVQoHZUPHKyEvPnLTRQtJKC/E/gwU
         93zxggRNItcD85tpKFBz2Ory2TOlfdSbEp6IvK6loPQlZTuvd7lBtfhg7dgz0ZuTolYr
         cuPa2glqdDpyo49QwBxpB7hjtLQrPX7pUhfROr95NSnaYvqrFLvMttxMgQnMThhBmybj
         +Pv02sU04IcugXyONR6mj7BhGkScFyTcXUqy7AFxCtG3nw4hxgEsxt/gOR9qDMHf7B+m
         UgKw1cFmtJHWJ+kK02RC7szzxWVvXWYelnNTIQT58Kq5H4XYM6pOjBuCCOVbCqKRRxZ+
         n5aQ==
X-Gm-Message-State: AOAM532hvEej1zu5CgfpYWdLOESuNs6ueF+ICR2FbFuJ+hCTeRXHoQa1
        vsC4ejtrHT+CoBXXADsgAuE=
X-Google-Smtp-Source: ABdhPJyWMomAVH6mrzGOHjhZQK6/BZ+CqwFOL6wR/LO7P0FYwX5dhks+kGq89NwZyRgyGLJ7LDyRJQ==
X-Received: by 2002:a63:6d4c:: with SMTP id i73mr6187609pgc.63.1598820172837;
        Sun, 30 Aug 2020 13:42:52 -0700 (PDT)
Received: from Thinkpad ([45.118.165.143])
        by smtp.gmail.com with ESMTPSA id 13sm5701842pfp.3.2020.08.30.13.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 13:42:51 -0700 (PDT)
Date:   Mon, 31 Aug 2020 02:12:45 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     syzbot+0bef568258653cff272f@syzkaller.appspotmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 deref in hci_phy_link_complete_evt
Message-ID: <20200830204245.GA249337@Thinkpad>
References: <20200829124112.227133-1-anmol.karan123@gmail.com>
 <20200829165712.229437-1-anmol.karan123@gmail.com>
 <20200830091917.GB122343@kroah.com>
 <20200830122623.GA235919@Thinkpad>
 <20200830173010.GA1872728@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830173010.GA1872728@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 07:30:10PM +0200, Greg KH wrote:
> On Sun, Aug 30, 2020 at 05:56:23PM +0530, Anmol Karn wrote:
> > On Sun, Aug 30, 2020 at 11:19:17AM +0200, Greg KH wrote:
> > > On Sat, Aug 29, 2020 at 10:27:12PM +0530, Anmol Karn wrote:
> > > > Fix null pointer deref in hci_phy_link_complete_evt, there was no 
> > > > checking there for the hcon->amp_mgr->l2cap_conn->hconn, and also 
> > > > in hci_cmd_work, for hdev->sent_cmd.
> > > > 
> > > > To fix this issue Add pointer checking in hci_cmd_work and
> > > > hci_phy_link_complete_evt.
> > > > [Linux-next-20200827]
> > > > 
> > > > This patch corrected some mistakes from previous patch.
> > > > 
> > > > Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> > > > Link: https://syzkaller.appspot.com/bug?id=0d93140da5a82305a66a136af99b088b75177b99
> > > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > > ---
> > > >  net/bluetooth/hci_core.c  | 5 ++++-
> > > >  net/bluetooth/hci_event.c | 4 ++++
> > > >  2 files changed, 8 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > > index 68bfe57b6625..996efd654e7a 100644
> > > > --- a/net/bluetooth/hci_core.c
> > > > +++ b/net/bluetooth/hci_core.c
> > > > @@ -4922,7 +4922,10 @@ static void hci_cmd_work(struct work_struct *work)
> > > >  
> > > >  		kfree_skb(hdev->sent_cmd);
> > > >  
> > > > -		hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> > > > +		if (hdev->sent_cmd) {
> > > > +			hdev->sent_cmd = skb_clone(skb, GFP_KERNEL);
> > > > +		}
> > > 
> > > How can sent_cmd be NULL here?  Are you sure something previous to this
> > > shouldn't be fixed instead?
> > 
> > Sir, sent_cmd was freed before this condition check, thats why i checked it,
> 
> But it can not be NULL at that point in time, as nothing set it to NULL,
> correct?
> 
> > i think i should check it before the free of hdev->sent_cmd like,
> > 
> > if (hdev->sent_cmd)
> > 	kfree_skb(hdev->sent_cmd);
> 
> No, that's not needed.
> 
> What is the problem with these lines that you are trying to solve?
> 
> > > > +
> > > >  		if (hdev->sent_cmd) {
> > > >  			if (hci_req_status_pend(hdev))
> > > >  				hci_dev_set_flag(hdev, HCI_CMD_PENDING);
> > > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > > index 4b7fc430793c..1e7d9bee9111 100644
> > > > --- a/net/bluetooth/hci_event.c
> > > > +++ b/net/bluetooth/hci_event.c
> > > > @@ -4941,6 +4941,10 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
> > > >  		hci_dev_unlock(hdev);
> > > >  		return;
> > > >  	}
> > > > +	if (!(hcon->amp_mgr->l2cap_conn->hcon)) {
> > > > +		hci_dev_unlock(hdev);
> > > > +		return;
> > > > +	}
> > > 
> > > How can this be triggered?
> > 
> > syzbot showed that this line is accessed irrespective of the null value it contains, so  added a 
> > pointer check for that.
> 
> But does hcon->amp_mgr->l2cap_conn->hcon become NULL here?

Sir, according to the report obtained by running decode_stacktrace on logs there is something getting null at this line, after verifying the buggy address i thought
it would be better to check this whole line. 

will dig more deeper into this and will make appropriate changes in the next version, thanks for review.

Anmol Karn

