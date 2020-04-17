Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AA31AE899
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgDQXYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgDQXYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 19:24:05 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C8AC061A0C;
        Fri, 17 Apr 2020 16:24:05 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id l5so1921595ybf.5;
        Fri, 17 Apr 2020 16:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HoiSxHhSigFRcJk85mjSruoDJHuLkPKUFTIYImgm6Ug=;
        b=kJdb1cMFcngGa0qp/KwVwgNtuNxTmrDtjaIwLAJFoNFpQhRy6q5sHg5MTKyXeGjwWu
         vBHicJ4/2qO+c9u26+845klREFX9I5XdF+lkZsUOX2W59oXD0X0snxgaFfClthr3xbn7
         CSudiFAf2zSIPObwc6IUG29u/5JVnUYcHJCsdF3lhu2ldziUi5lRt1Q4zpTHq3PeSNwp
         Ng7+cMA/1D8kIComwJKKXIEVQliODb/0w0bKTuk3Wjf9vtPXDhcpIxgRPo+bitkuLBz8
         T/MyKESZ3xGPBcP7fJ3cdb8wdGhksJnnBUgXmE7OdCW6qXouR6PLxcE4Ehr2Pan6h5je
         ocIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HoiSxHhSigFRcJk85mjSruoDJHuLkPKUFTIYImgm6Ug=;
        b=PpJ9P/8wjU3j4oc3yZw7kO8WwsGNPB8NCIPH30Tz6MYU7JIC3fRhBH8b2rEB7Jequj
         m5qV+TMT/hjNrBibT7NSb+T1c73BcBaiBFi94ypGHFs6DQPLNaTZQybeWBDkdu7kk3ln
         1BDDra7oOkvl9UwWvIHGZc5HcFqZmo4m+F+qDkZ7oC2hgqydndMhqJ1bp4lhLQG1g8/j
         29fRPRgbdy7IY2SaDpFbEUPvsg39H8+QO0Bp5UGe19qV8ZE5xU6+rPlUFk0TcYDN1pLe
         k7DwHR4YU7s4T9X3Xx2wg9JAZ2OHpn3WvWdV9HHxCeMOv48MtzoUxrsP8F/SQcR09qRT
         582g==
X-Gm-Message-State: AGi0PubH9hQX9syL+0r1MIJ3zNS+wTxwF1ydGLWBUuowGujn0jKFLV3r
        mmJknmdUUZqsQSqMr7c/ZJXrFm4gz/5CSLU9ohzZvcEVB2g=
X-Google-Smtp-Source: APiQypIaoZNcLb0nbIIWdy9AexGlinfJyksDNrXL01uuwQ39JevXQ5RG2DIGZoNajN0gFWDBeQoLtKsPk7LcZ6YXDU0=
X-Received: by 2002:a25:aa0c:: with SMTP id s12mr2066981ybi.183.1587165844440;
 Fri, 17 Apr 2020 16:24:04 -0700 (PDT)
MIME-Version: 1.0
References: <3865908.1586874010@warthog.procyon.org.uk>
In-Reply-To: <3865908.1586874010@warthog.procyon.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Apr 2020 18:23:53 -0500
Message-ID: <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
Subject: Re: What's a good default TTL for DNS keys in the kernel
To:     David Howells <dhowells@redhat.com>
Cc:     linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, fweimer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> The question remains what the expected impact of TTL expiry is.  Will
>> the kernel just perform a new DNS query if it needs one?

For SMB3/CIFS mounts, Paulo added support last year for automatic
reconnect if the IP address of the server changes.  It also is helpful
when DFS (global name space) addresses change.

It does not require a remount for SMB3/CIFS

On Tue, Apr 14, 2020 at 11:09 AM David Howells <dhowells@redhat.com> wrote:
>
> Since key.dns_resolver isn't given a TTL for the address information obtained
> for getaddrinfo(), no expiry is set on dns_resolver keys in the kernel for
> NFS, CIFS or Ceph.  AFS gets one if it looks up a cell SRV or AFSDB record
> because that is looked up in the DNS directly, but it doesn't look up A or
> AAAA records, so doesn't get an expiry for the addresses themselves.
>
> I've previously asked the libc folks if there's a way to get this information
> exposed in struct addrinfo, but I don't think that ended up going anywhere -
> and, in any case, would take a few years to work through the system.
>
> For the moment, I think I should put a default on any dns_resolver keys and
> have it applied either by the kernel (configurable with a /proc/sys/ setting)
> or by the key.dnf_resolver program (configurable with an /etc file).
>
> Any suggestion as to the preferred default TTL?  10 minutes?
>
> David
>


-- 
Thanks,

Steve
