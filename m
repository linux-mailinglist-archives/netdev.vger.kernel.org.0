Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4DF6F7B5
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 05:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfGVDBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 23:01:00 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36915 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfGVDBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 23:01:00 -0400
Received: by mail-pg1-f193.google.com with SMTP id i70so6196976pgd.4
        for <netdev@vger.kernel.org>; Sun, 21 Jul 2019 20:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=19wNIXU4xjiQS6qw4IVTQbuwCXIhgNtndWsV8EDBMNI=;
        b=UUR4d6YKm4A8TPNIWQuHX9RVJWJEQkykpWK6udc1eL7z0qJ8T+kaYzbamN3zw3Mkxf
         tDqIjO/kMSf4N5RVFeladKbKn8q+l5Nm2ksXcp617Hy6/CDbxNHEYuETZQ0os5cT9p9b
         N4YOixg5f8rpAz5DrWWfj4DcDnJl6e+s/n8EFgi39nZ7N3aSryxPevEEcEv6NIjYnq4m
         MaePITIg8pHAXo9qRoxboE1TwZI8GC9LJlCfqZCqIrT70+ftphbxwy+lsZhtmHs/1rPV
         Asve9C3yimqvPdDl9w9FbQ10F0kLKB5aAryRFXcQWukrMiBkz4USapZYyZqigMelh1mB
         CK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=19wNIXU4xjiQS6qw4IVTQbuwCXIhgNtndWsV8EDBMNI=;
        b=IJZE7aF89BJayRKnOE7+A93UJJ6gLk+ak8wvN/4J+57eaNfpaEXhYioZGZ7WsYBpsb
         2y5Tz8WUDTi4M2T3MVSAzJV2AmbR5b8PonUUMyBU7YjO2lo8m1sYSNR8PV+2PRqfAB9U
         UaqMB/SfLt8jyCClTBuduEmnFjS0lD+dZcdvd0xeGIRv2XVnYSp78lHJHxLYbOVEaS05
         1YDLDL1biNmZfdTniqMUoIOvt2jdTHzeUPmddvqrVWy2qD5OME/ez/suC2IapNgk7/7J
         gvDeMAMR16bHWzQsBkRUzYN12CZakHFbVc7lw9FxMwa5Kalnv1nQCxfWOYMeCOyH8xoT
         ZCBA==
X-Gm-Message-State: APjAAAUrQgOB5OkxFfYxpFWXZfeIEVqOBKoc+RUAYhXILjiZbErfFSLJ
        bZxlI3nTraOx8vTOKU/xjh4=
X-Google-Smtp-Source: APXvYqyNkd9HlFIxsJWYZRa13fys5dplH675NtzyIcpLT6mMthU530ZIjyh78KWabSAmDl7ucdx5QA==
X-Received: by 2002:a63:58c:: with SMTP id 134mr72267904pgf.106.1563764459373;
        Sun, 21 Jul 2019 20:00:59 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h16sm41084547pfo.34.2019.07.21.20.00.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 21 Jul 2019 20:00:58 -0700 (PDT)
Date:   Mon, 22 Jul 2019 11:00:49 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jianlin Shi <jishi@redhat.com>
Subject: Re: [PATCH v2 net-next 03/11] net/ipv4: Plumb support for filtering
 route dumps
Message-ID: <20190722030049.GP18865@dhcp-12-139.nay.redhat.com>
References: <20181016015651.22696-1-dsahern@kernel.org>
 <20181016015651.22696-4-dsahern@kernel.org>
 <20190719041700.GO18865@dhcp-12-139.nay.redhat.com>
 <147df36b-75df-5e71-3d74-9454db676bce@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147df36b-75df-5e71-3d74-9454db676bce@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 10:55:49AM -0600, David Ahern wrote:
> Hi:
> 
> On 7/18/19 10:17 PM, Hangbin Liu wrote:
> > Hi David,
> > 
> > Before commit 18a8021a7be3 ("net/ipv4: Plumb support for filtering route
> > dumps"), when we dump a non-exist table, ip cmd exits silently.
> > 
> > # ip -4 route list table 1
> > # echo $?
> > 0
> > 
> > After commit 18a8021a7be3 ("net/ipv4: Plumb support for filtering route
> > dumps"). When we dump a non-exist table, as we returned -ENOENT, ip route
> > shows:
> > 
> > # ip -4 route show table 1
> > Error: ipv4: FIB table does not exist.
> > Dump terminated
> > # echo $?
> > 2
> > 
> > For me it looks make sense to return -ENOENT if we do not have the route
> > table. But this changes the userspace behavior. Do you think if we need to
> > keep backward compatible or just let it do as it is right now?
> > 
> 
> It is not change in userspace behavior; ip opted into the strict
> checking. The impact is to 'ip' users.
> 
> A couple of people have asked about this, and I am curious as to why
> people run a route dump for a table that does not exist and do not like
> being told that it does not exist.

Hi David,

Thanks for the reply. We have some route function tests and the new behavior
break the test. I just want to make sure this is expected so we can change our
tests to match the new behavior.

Cheers
Hangbin
