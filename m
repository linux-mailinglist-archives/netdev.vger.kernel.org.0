Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B56E3180D9C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgCKBk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:40:59 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35958 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgCKBk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:40:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so351077wme.1;
        Tue, 10 Mar 2020 18:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=AFzWa9AtXFLGIfoMPoJK6d5wfqfho8/Wj5PljPDOXn0=;
        b=Eb8DoaMtU5ZDMN3aXl+rooK4nC4/8oKVRnqHuvpGBrNcv3iwWZlTZlHDPvfyGZxdC+
         QgxC6UkYzdh2PzToUODgu1xeKLl5Pv+5r5RZO0q0zzBgQ9ebjwJg102FoahafrfdwEr+
         reHIm9KVkZ/1jGb2hUDghsBkI5zAeDoucHdC6z2Oi8T8Swl//It0jAn8GjEH5R5pcOgd
         TK+o0d7LkuF7pt4GIyPWRDyv2lAAXoRZvQWayYSDeABb+YmRa5E0TYYu1J9MBjxh3esu
         XMHgiL4EBnhr/EVOug8RGSpd1NqK0ffNYqHyM0gjHJCrfkkEMTI+yxl/OXAis24Adpw0
         u4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=AFzWa9AtXFLGIfoMPoJK6d5wfqfho8/Wj5PljPDOXn0=;
        b=fxfGKGXIzq4m6RhOfnWIgtsNX8l76aEm4iz0oFgPjZvb3OEHP76b941ZyZs25IiaJK
         IFr8NoxNL0rCUvtgFWmZuEfzN4zVO+cpUwgyWoXkLRRFm+mCc/Go4iaOIkD5/560mYmm
         GJ1/SZHjDFR+aIAjOUOCnyJK6zNK2zR7cLBGmoVNvXgNq1yzhtHWi+9L8Dku7wEWKO0D
         qsBDsBsP4FiWeIcUbdthBT6XKW0MznYJ9mvy7rTIrRKrPYWQerVn2wxjSw9J9SBqNUjJ
         /UgW5S9NcZX9Igv8rgdD4kZ6WjtnF1lZuHK2AhFNoHUo8iY7P8Fax4/HfMWa+SUShS6C
         SQkQ==
X-Gm-Message-State: ANhLgQ1E3kF41DhmZcrxFETtFxT24CBsVEy0IyA1tOqe0XLf338kVCKA
        n+d5EuxAt0Z0Cnj59Ev3iA==
X-Google-Smtp-Source: ADFU+vtExS5R99lSAnOMRnhr9zYw+HepbUPC60GDI+elRvjPDxKh/YqmV1aApbFNg6aSzIRZEj75+A==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr586617wmc.18.1583890854648;
        Tue, 10 Mar 2020 18:40:54 -0700 (PDT)
Received: from ninjahub.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.gmail.com with ESMTPSA id m11sm21774262wrn.92.2020.03.10.18.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:40:54 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
X-Google-Original-From: Jules Irenge <maxx@ninjahub.org>
Date:   Wed, 11 Mar 2020 01:40:46 +0000 (GMT)
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/8] raw: Add missing annotations to raw_seq_start() and
 raw_seq_stop()
In-Reply-To: <af9016d1-c224-ea61-3290-330ed0fe8d60@gmail.com>
Message-ID: <alpine.LFD.2.21.2003110138120.3619@ninjahub.org>
References: <0/8> <20200311010908.42366-1-jbi.octave@gmail.com> <20200311010908.42366-3-jbi.octave@gmail.com> <af9016d1-c224-ea61-3290-330ed0fe8d60@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 10 Mar 2020, Eric Dumazet wrote:

> 
> 
> On 3/10/20 6:09 PM, Jules Irenge wrote:
> > Sparse reports warnings at raw_seq_start() and raw_seq_stop()
> > 
> > warning: context imbalance in raw_seq_start() - wrong count at exit
> > warning: context imbalance in raw_seq_stop() - unexpected unlock
> > 
> > The root cause is the missing annotations at raw_seq_start()
> > 	and raw_seq_stop()
> > Add the missing __acquires(&h->lock) annotation
> > Add the missing __releases(&h->lock) annotation
> > 
> > Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
> > ---
> >  net/ipv4/raw.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> > index 3183413ebc6c..47665919048f 100644
> > --- a/net/ipv4/raw.c
> > +++ b/net/ipv4/raw.c
> > @@ -1034,6 +1034,7 @@ static struct sock *raw_get_idx(struct seq_file *seq, loff_t pos)
> >  }
> >  
> >  void *raw_seq_start(struct seq_file *seq, loff_t *pos)
> > +	__acquires(&h->lock)
> 
> I dunno, h variable is not yet defined/declared at this point,
> this looks weird.
> 
> >  {
> >  	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
> >  
> > @@ -1056,6 +1057,7 @@ void *raw_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> >  EXPORT_SYMBOL_GPL(raw_seq_next);
> >  
> >  void raw_seq_stop(struct seq_file *seq, void *v)
> > +	__releases(&h->lock)
> >  {
> >  	struct raw_hashinfo *h = PDE_DATA(file_inode(seq->file));
> >  
> > 
> 
Thanks for the feedback,

I think h is a pointer of type struct raw_hashinfo, in which member lock 
is initialized on line number 89. 

Kind regards
