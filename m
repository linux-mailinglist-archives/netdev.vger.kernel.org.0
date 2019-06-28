Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F359359508
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfF1HfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:35:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35022 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfF1HfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:35:15 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so7973948wml.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 00:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Enp4B+sXO8MV82pU9GMDcx+g5nYrKGxc618J5MuxsMk=;
        b=mkAVf+62y07IMrnytGGMoMmLc9DGac8yC+LczP3TSjtnAXO0CK08d1qYCOe0rBY3LH
         TlZABBxxpcwNp9aDZ0mQV7ySFDp0QkOIEnn/YC1hzXs2RF5ZfvTa8UkzeM3paZy/IL13
         M9LW0UmPrCLrSH7j2TobYBD5bpW6t3vYnJIRUudQfUPvGFkF6KT53C/8UmLqrCF8NkUU
         6JfMV6iBp/fUcoaLQMNIkhT53f+2NlQMs8edmmdRual1qi5m2vz/ySPeyQ0qJu0XLob2
         UMKTApHTAa4DPZRTVdAFTpcBjEfngTVC2T8c5neuSdKd8gt3QMgYVoEVyTq7U0OTcLvR
         mvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Enp4B+sXO8MV82pU9GMDcx+g5nYrKGxc618J5MuxsMk=;
        b=gHvSnhGg9r2Wj7nxws/Op8c3rZ0DO3EdyUavfZm9BMDzBmX52Vr3lwM1dmB1JRI16F
         I1Z2PM7KFqF3jWYmwTNkUHsDuw+j7Hytq81MtV1cKgu8F7b+YZ4rOheIiZEz6gCT2pDX
         dot6kCw3dwmfyJxkj5E3xnjAbgbUYwryArE3bUENCSrWNCdc1/YRFn+lePrct9fprrch
         xPm8nSLPm5iOHQQprhdz/Q86FXjMWqIkpIPRLvCm/8R+UfPZwdgfyZccG+ZQMi1v9oXk
         dW2R0Bz1wUzDJhdzNq2MqN8w6toMxHjhcMtu9Mb7POOh9VuKhlkUj5h8ztx7q2pjO7A7
         JDvw==
X-Gm-Message-State: APjAAAWDedcjt6JhO62r0ThJBF5Cvb+7EJqwQBcr0X/w76NfgNbwzKWc
        JQrX2/ehMFBI+KalyMldw6ZxUg==
X-Google-Smtp-Source: APXvYqyt/71uTb4AgiAMuzhKZUStNvfmdT5CQI1Uqu/c0a3x9N8vp6PbW4E76ZG98pSJeI9/QVXAmQ==
X-Received: by 2002:a1c:a1c5:: with SMTP id k188mr6144349wme.102.1561707312983;
        Fri, 28 Jun 2019 00:35:12 -0700 (PDT)
Received: from localhost ([212.89.239.228])
        by smtp.gmail.com with ESMTPSA id v27sm2928732wrv.45.2019.06.28.00.35.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 00:35:12 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:35:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, David Ahern <dsahern@gmail.com>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190628073510.GB2236@nanopsycho>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
 <20190627180803.GJ27240@unicorn.suse.cz>
 <20190627112305.7e05e210@hermes.lan>
 <20190627183538.GI31189@lunn.ch>
 <20190627183948.GK27240@unicorn.suse.cz>
 <20190627122041.18c46daf@hermes.lan>
 <e3188fc08a13ddff9ea5a200a69aa6adbd9278ed.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3188fc08a13ddff9ea5a200a69aa6adbd9278ed.camel@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 27, 2019 at 09:35:27PM CEST, dcbw@redhat.com wrote:
>On Thu, 2019-06-27 at 12:20 -0700, Stephen Hemminger wrote:
>> On Thu, 27 Jun 2019 20:39:48 +0200
>> Michal Kubecek <mkubecek@suse.cz> wrote:
>> 
>> > > $ ip li set dev enp3s0 alias "Onboard Ethernet"
>> > > # ip link show "Onboard Ethernet"
>> > > Device "Onboard Ethernet" does not exist.
>> > > 
>> > > So it does not really appear to be an alias, it is a label. To be
>> > > truly useful, it needs to be more than a label, it needs to be a
>> > > real
>> > > alias which you can use.  
>> > 
>> > That's exactly what I meant: to be really useful, one should be
>> > able to
>> > use the alias(es) for setting device options, for adding routes, in
>> > netfilter rules etc.
>> > 
>> > Michal
>> 
>> The kernel doesn't enforce uniqueness of alias.
>
>Can we even enforce unique aliases/labels? Given that the kernel hasn't
>enforced that in the past there's a good possibility of breaking stuff
>if it started. (unfortunately)

Correct. I think that Michal's idea to introduce "real aliases" is very
intereting. However, the existing "alias" as we have it does not seem
right to be used. Also because of the UAPI. We have IFLA_IFALIAS which
is a single value. For "real aliases" we need nested array.

[...]
