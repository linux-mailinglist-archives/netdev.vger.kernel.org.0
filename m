Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409B016427B
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBSKot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:44:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29743 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726469AbgBSKot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:44:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582109087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y+tn+gMbqlpXQWFtJ2fPpofDPzaQP+Q4LGj46J7FNSw=;
        b=HPw8ltaUGdwqHApigkdZkUxAKbSEp6O57+ocunh2V0JWghfcmNkv9oCCmZX7RmUIWi5AMb
        M9KCq5m4RJKMp8Uf7phvvaH/S/fdN43nUP2XY4TKbGU8glg2+epBVzwUKOZ6fbGx4C38Nw
        FmWQa3wurra2yf2vlKnj3jb9K2gLkvg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-GZY4KOxbNTGa-eXun8O7Lg-1; Wed, 19 Feb 2020 05:44:38 -0500
X-MC-Unique: GZY4KOxbNTGa-eXun8O7Lg-1
Received: by mail-wr1-f69.google.com with SMTP id p8so12366521wrw.5
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 02:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y+tn+gMbqlpXQWFtJ2fPpofDPzaQP+Q4LGj46J7FNSw=;
        b=RXYoCmIvDyf3PSaqCD8Tc78bhd9kArTQZWtqppeKXUR000c4FaYaOquy8WtPmClMns
         My6eZJ1l3eBAnaMIwF/xWUVaB9ZeOlgH1lfIzWDB9TlcP5T23/a9xmpWKQybX0QTePY2
         oBPtGbzolB1V0pRI/9+2+61kFSEdn8DUXHdKftOdmnEKxDEdrwFmJEMU73SMgcNxfo+s
         hfEOV3IqI7XuhLnZvRESAcmD/EgLd9XP3B5PSCyIcaHWwOH0XNhUx9vulM75xc9h0OFw
         /ioHkkaaS77aCFYo1WdHvO6GetMmvGg6hlMwCec/u9ywdWQZQm7ADEnNk8nUcYghbRRD
         AuOw==
X-Gm-Message-State: APjAAAXbC1mtOLZvItICzD0V+7V7GX4m1EgNeylm3a3ASyRjemT1oufH
        /9gJGEIkiR3VKJheU/0PBQjixN/D96AHkTk/Nuy1w8ve3iZju0QPCmqgvYwiEGa2bJMAnG/uv79
        hzlbi0eZio+8T1JI8
X-Received: by 2002:a1c:b789:: with SMTP id h131mr9279219wmf.148.1582109076992;
        Wed, 19 Feb 2020 02:44:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0udWojDlLkGOqER8KELYXXzeklq9lDS7QMDVIu0wedvCu/gx2xmxOpWq/PIFyWQ8DlU9oSw==
X-Received: by 2002:a1c:b789:: with SMTP id h131mr9279187wmf.148.1582109076653;
        Wed, 19 Feb 2020 02:44:36 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id s15sm2409901wrp.4.2020.02.19.02.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 02:44:36 -0800 (PST)
Date:   Wed, 19 Feb 2020 11:44:34 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     ted.h.kim@oracle.com
Cc:     stefanha@redhat.com, netdev@vger.kernel.org
Subject: Re: vsock CID questions
Message-ID: <20200219104434.xmpgd3os3qlgjnb5@steredhat>
References: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f9dd3c9-9531-902c-3c8a-97119f559f65@oracle.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 02:45:38PM -0800, ted.h.kim@oracle.com wrote:
> Hi Stefano (and Stefan),

Hi Ted,

> 
> I have some questions about vsock CIDs, particularly when migration happens.
> 
> 1. Is there an API to lookup CIDs of guests from the host side (in libvirt)?

I don't know if there is a specific API, but looking at the xml, you can see
the assigned CID:

$ virsh dumpxml fedora31 | grep cid
      <cid auto='yes' address='3'/>

I'm not sure that's what you were asking, if you meant a list of all the
guest CIDs, I don't think there's an API for that.

> 
> 2. In the vsock(7) man page, it says the CID might change upon migration, if
> it is not available.
> Is there some notification when CID reassignment happens?

Connected stream sockets will receive an error after the migration and then
they'll be closed.

Usually it is not recommended to bind the guest's cid, it is preferable
to use VMADDR_CID_ANY.

> 
> 3. if CID reassignment happens, is this persistent? (i.e. will I see updated
> vsock definition in XML for the guest)

I guess so, but I didn't try.

> 
> 4. I would like to minimize the chance of CID collision. If I understand
> correctly, the CID is a 32-bit unsigned.

Right. 'struct sockaddr_vm' supports 32-bit unsigned CID.

>                                          So for my application, it might
> work to put an IPv4 address. But if I adopt this convention, then I need to
> look forward to possibly using IPv6. Anyway, would it be hard to potentially
> expand the size of the CID to 64 bits or even 128?

virtio-vsock specification [1] supports up to 64-bit CID.
The 'svm_cid' field in the 'struct sockaddr_vm' is the last one, before
the zero section, and we have 16-bit reserved on top that we can use for
some flags.
Maybe extending it to 64 bit might be feasible, but we need to check
other transports (vmci, hyperv).

Cheers,
Stefano

[1] https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.html#x1-3960006

