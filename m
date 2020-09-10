Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA8D263DF2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgIJHEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbgIJHB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 03:01:58 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8245C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 00:00:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w1so5188936edr.3
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 00:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HpIePgtAi+Zt2c3FnKrFGH6/1qarSukoJjsAuKYFWGs=;
        b=ZvdJIRHYZONcuRfYgYS1dIN1pjWge1etYUPQc3zNRkrdT/wo9dG5YNgQTQD6+IvHxH
         5l9+8aau2JJP2H66Hhmlu0WaMpm4Po8t58uHNX+X883y/1SOzTr4fVvooCYLgjo8Y4gI
         sOBafywjwBqPrncAGUqwjhnpyo5MZNN4A/BspO0wcasIcOWc54pp28Qly+znxIo1nbiK
         5LY29tKpc/Bg23t6293+0k/A18c3bv3P5DIVE7HrgAfJZniYbW3xSr34cCu/hROZbrQx
         fd8eovQ4+zgBghzT6FRBCwj7el1rcZEPYgHyltX+nvy/pn2T76CWdAy/ujmNmMmm6iYt
         Yy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HpIePgtAi+Zt2c3FnKrFGH6/1qarSukoJjsAuKYFWGs=;
        b=gO9p4T/kPMPrjZbwBhKCKYn5FNTGS++KkeCPlcJAbKBvze5OGdMdNIQ8oxSCKP5bn/
         xFuUtlGq2pczBvEMKdVfxO7bbD4z5Hwf5iVwwbzml2zSHOoRxsv/77PBzLciP2cC6lns
         OQ7wAoGwg9OZwCKhY+eLmG7Ct+18ID6+G2zddtU2hmCuHa0qswqWic2GCAb6JcEE8NtM
         r72LOjoQE8yaaz5ZRAdU+CnyI4xK63r2/PIm/JSeqpXhDYKrrvp3TDh11359Rg9r9h7P
         ZznWLFQBp6wzl/kKbyzZ5D7jFNlhRBqhPsp+cqgTk/aM6EL0LN187CKg3gfN5RmQPepc
         A/Vw==
X-Gm-Message-State: AOAM531NsH1WGb8c8yFpXgZmlDp6LDI5ZDIy5UqFrzJpmmKOGBrn4NX6
        Jz5rHtVpJ2UmHSHjU+FZ3zS/mg==
X-Google-Smtp-Source: ABdhPJxms1qFPsP8oSsW/r6IuhVTyuEpHv+H4oQJOySHeR8SoXVW3lz5XEEHEyKgszu8KAQIxQh5cg==
X-Received: by 2002:a05:6402:28d:: with SMTP id l13mr8076687edv.293.1599721217581;
        Thu, 10 Sep 2020 00:00:17 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f10sm5983702edk.34.2020.09.10.00.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:00:17 -0700 (PDT)
Date:   Thu, 10 Sep 2020 09:00:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com
Subject: Re: Exposing device ACL setting through devlink
Message-ID: <20200910070016.GT2997@nanopsycho.orion>
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
 <20200904083141.GE2997@nanopsycho.orion>
 <20200904153751.17ad4b48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e4c2c8f-a5b0-799c-3083-cfefcf37bf10@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 08, 2020 at 08:27:13PM CEST, tlfalcon@linux.ibm.com wrote:
>On 9/4/20 5:37 PM, Jakub Kicinski wrote:
>> On Fri, 4 Sep 2020 10:31:41 +0200 Jiri Pirko wrote:
>> > Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>> > > Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM
>> > > VNIC devices to administrators through devlink (originally through
>> > > sysfs files, but that was rejected in favor of devlink). Could you
>> > > give any tips on how you might go about doing this?
>> > Tom, I believe you need to provide more info about what exactly do you
>> > need to setup. But from what you wrote, it seems like you are looking
>> > for bridge/tc offload. The infra is already in place and drivers are
>> > implementing it. See mlxsw for example.
>> I think Tom's use case is effectively exposing the the VF which VLANs
>> and what MAC addrs it can use. Plus it's pvid. See:
>> 
>> https://www.spinics.net/lists/netdev/msg679750.html
>
>Thanks, Jakub,
>
>Right now, the use-case is to expose the allowed VLAN's and MAC addresses and
>the VF's PVID. Other use-cases may be explored later on though.

Who is configuring those?

What does mean "allowed MAC address"? Does it mean a MAC address that VF
can use to send packet as a source MAC?

What does mean "allowed VLAN"? VF is sending vlan tagged frames and only
some VIDs are allowed.

Pardon my ignorance, this may be routine in the nic world. However I
find the desc very vague. Please explain in details, then we can try to
find fitting solution.

Thanks!
