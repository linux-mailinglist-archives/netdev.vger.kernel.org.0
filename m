Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749D964197
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 08:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfGJGsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 02:48:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39343 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfGJGsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 02:48:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so975108wma.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 23:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=gBXrY4BCZ06Oagv1PeGvZDpYIWDOeC1FEAOPiEhk+3A=;
        b=hnPiTpJjQ7JyMZNTZWbTJyR22jGYUA6xqEQ51ZBN9bU2uWN31BNQsU7kgyv8RIhaju
         T144ArE2J5fhT+b0t9gMNEd3Gj4EDw7z69CgKQaKSHCv8kImELl3BKOLvdkOpBFk6kXG
         ftxKnzpmN7B2YJacXo0D8+Bjsv4Xfno+dMHIANKNxvl8jzlmqgbiLdFFj9khvMtfwcmR
         Y3UkXCm311pZ1CGUzHN1zrqwI4RAIsD458T68F7D88YyJXDlaqHg7oSYgjo8fWNvDNov
         nu1lifDGud95Z7VT+o8voNYz8fOW0OaADuxP0pbxzh8sbOjZ2dTo8NlgBOBB1e3Es8E7
         8Z4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=gBXrY4BCZ06Oagv1PeGvZDpYIWDOeC1FEAOPiEhk+3A=;
        b=JpJWgY8k+0tJ6JHXuPc/9bApNS7XzVLoH3SvxRhQw/GZCOa3GJSxG/oClKT5VEc1hi
         Ohd4oh608lA/mro9Pjh3iLkJa0+yqAUCWQRpUj04NfPs29AkHN5d6BrjRczhqnQK+STF
         omYGbytiyo2w87Uxz0bm+pF4PBgiwhR8PbtjmHm8jORNxG517p6hghtdNY8hOcnKflyc
         /hMES33pDbt5t265vcmoNsLgpgM0Rz41zJZi/YDHjBZtp3hoK7O2vgTDARZM+fW1BSOE
         /+ZKaZMF74YPjZ0H5Vg7Vr/wk8JOkSFrU+eLaTbbKQSoAGGYKQNzHa2VzuttaMYWXPBb
         Wy2A==
X-Gm-Message-State: APjAAAU1sNpSHeToDkhDy4mRDDQ/CoBpG5wehei6rhNzbg49715OJ+Jc
        qcT59xtNQeXD5buGX9IQAECQUCKl
X-Google-Smtp-Source: APXvYqyg+sVXQvV5Di28idhCyKOAlC8Mhif5ZrvVgTpXNlUz23kaOFTlHazUhOwIKVWJj0SjHmnzfg==
X-Received: by 2002:a1c:1b97:: with SMTP id b145mr3142709wmb.158.1562741300549;
        Tue, 09 Jul 2019 23:48:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w67sm1299351wma.24.2019.07.09.23.48.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 23:48:19 -0700 (PDT)
Date:   Wed, 10 Jul 2019 08:48:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 19/19] ionic: Add basic devlink interface
Message-ID: <20190710064819.GC2282@nanopsycho>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-20-snelson@pensando.io>
 <20190708193454.GF2282@nanopsycho.orion>
 <af206309-514d-9619-1455-efc93af8431e@pensando.io>
 <20190708200350.GG2282@nanopsycho.orion>
 <6f9ebbca-4f13-b046-477c-678489e6ffbf@pensando.io>
 <20190709065620.GJ2282@nanopsycho.orion>
 <0ae90b8d-5c73-e60d-8e56-5f6f56331e1a@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ae90b8d-5c73-e60d-8e56-5f6f56331e1a@pensando.io>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 09, 2019 at 09:13:53PM CEST, snelson@pensando.io wrote:
>On 7/8/19 11:56 PM, Jiri Pirko wrote:
>> Tue, Jul 09, 2019 at 12:58:00AM CEST, snelson@pensando.io wrote:
>> > On 7/8/19 1:03 PM, Jiri Pirko wrote:
>> > > Mon, Jul 08, 2019 at 09:58:09PM CEST, snelson@pensando.io wrote:
>> > > > On 7/8/19 12:34 PM, Jiri Pirko wrote:
>> > > > > Mon, Jul 08, 2019 at 09:25:32PM CEST, snelson@pensando.io wrote:
>> > > > > > +
>> > > > > > +static const struct devlink_ops ionic_dl_ops = {
>> > > > > > +	.info_get	= ionic_dl_info_get,
>> > > > > > +};
>> > > > > > +
>> > > > > > +int ionic_devlink_register(struct ionic *ionic)
>> > > > > > +{
>> > > > > > +	struct devlink *dl;
>> > > > > > +	struct ionic **ip;
>> > > > > > +	int err;
>> > > > > > +
>> > > > > > +	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic *));
>> > > > > Oups. Something is wrong with your flow. The devlink alloc is allocating
>> > > > > the structure that holds private data (per-device data) for you. This is
>> > > > > misuse :/
>> > > > > 
>> > > > > You are missing one parent device struct apparently.
>> > > > > 
>> > > > > Oh, I think I see something like it. The unused "struct ionic_devlink".
>> > > > If I'm not mistaken, the alloc is only allocating enough for a pointer, not
>> > > > the whole per device struct, and a few lines down from here the pointer to
>> > > > the new devlink struct is assigned to ionic->dl.  This was based on what I
>> > > > found in the qed driver's qed_devlink_register(), and it all seems to work.
>> > > I'm not saying your code won't work. What I say is that you should have
>> > > a struct for device that would be allocated by devlink_alloc()
>> > Is there a particular reason why?  I appreciate that devlink_alloc() can give
>> > you this device specific space, just as alloc_etherdev_mq() can, but is there
>> Yes. Devlink manipulates with the whole device. However,
>> alloc_etherdev_mq() allocates only net_device. These are 2 different
>> things. devlink port relates 1:1 to net_device. However, devlink
>> instance can have multiple ports. What I say is do it correctly.
>
>So what you are saying is that anyone who wants to add even the smallest
>devlink feature to their driver needs to rework their basic device memory
>setup to do it the devlink way.  I can see where some folks may have a
>problem with this.

It's just about having a structure to hold device data. You don't have
to rework anything, just add this small one.


>
>> 
>> 
>> > a specific reason why this should be used instead of setting up simply a
>> > pointer to a space that has already been allocated?  There are several
>> > drivers that are using it the way I've setup here, which happened to be the
>> > first examples I followed - are they doing something different that makes
>> > this valid for them?
>> Nope. I'll look at that and fix.
>> 
>> 
>> > > The ionic struct should be associated with devlink_port. That you are
>> > > missing too.
>> > We don't support any of devlink_port features at this point, just the simple
>> > device information.
>> No problem, you can still register devlink_port. You don't have to do
>> much in order to do so.
>
>Is there any write-up to help guide developers new to devlink in using the
>interface correctly?  I haven't found much yet, but perhaps I've missed
>something.  The manpages are somewhat useful in showing what the user might
>do, but they really don't help much in guiding the developer through these
>details.

That is not job of a manpage. See the rest of the code to get inspired.

>
>sln
>
