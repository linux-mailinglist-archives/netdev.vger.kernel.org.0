Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8972A221063
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgGOPIl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jul 2020 11:08:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50310 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728301AbgGOPIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:08:39 -0400
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jvj1S-0003xR-GS
        for netdev@vger.kernel.org; Wed, 15 Jul 2020 15:08:38 +0000
Received: by mail-pj1-f69.google.com with SMTP id e14so2987602pjt.0
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PjMy4io7R2jHdSWxArusOtwgBaqFTbEYz/sY2JlYP5w=;
        b=Ab3mF2EOcDIoaZy8AjNc0bGbetsEkPRW1cWBO8JZXxX2gDP8ndbmip8GZlE9YLuA16
         ovHLWlXZ2npTF15uvqgTydtH2uLgxbNRpe4S6UVCl6nLebo7VkbmefNIV2oIeoF4PqFN
         UDpxubne/TwCigKHa6900v9DrtJo6pw13LB+2cPDcZW06f0WAaRC9s22xKb1apuLa8BX
         le0V15Vt6Wt9ScG4oM2K0vfGWGZUssSnsIQ6JTYlASX8KSMGM8wgAYzvjGaYlvBfSPsx
         oc2L2jPDYEw9eVxYrCst4fJyEAlNRjvCSaVngfWcwfLoiuwPQTPUKSYWL1dPOl9QYMFb
         SBEA==
X-Gm-Message-State: AOAM531dUE+287l4qdXI1yzc09g/pbMif2oilgyYW7aP+nnzeqvog2BM
        mCSRnRnBkgk1iknMFthPK2XIAT5hYnfFvt24EZyI6rrIQIgMS1gfGvaupW13NiAaGEJdKGd2fvu
        klR3KLUYIHTG8TIm368Zcp6b0aVbI/1yBPQ==
X-Received: by 2002:a17:90a:3002:: with SMTP id g2mr108798pjb.68.1594825717131;
        Wed, 15 Jul 2020 08:08:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyeaLMdNxhmgRLyUdtuuy7GErTF8uag+bSGeUBRnl/y7/ExiAOI6J/b8SmUhYYGsqLrNQjV8w==
X-Received: by 2002:a17:90a:3002:: with SMTP id g2mr108775pjb.68.1594825716853;
        Wed, 15 Jul 2020 08:08:36 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id 7sm2467724pgw.85.2020.07.15.08.08.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:08:36 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
Date:   Wed, 15 Jul 2020 23:08:33 +0800
Cc:     matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6E0D09F1-601B-432B-81EE-9858EC1AF1DE@canonical.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <424D9E36-C51B-46E8-9A07-D329821F2647@oracle.com>
To:     Chuck Lever <chuck.lever@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 15, 2020, at 23:02, Chuck Lever <chuck.lever@oracle.com> wrote:
> 
> 
> 
>> On Jul 15, 2020, at 10:48 AM, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
>> 
>> Hi,
>> 
>> Multiple users reported NFS causes NULL pointer dereference [1] on Ubuntu, due to commit "SUNRPC: Add "@len" parameter to gss_unwrap()" and commit "SUNRPC: Fix GSS privacy computation of auth->au_ralign".
>> 
>> The same issue happens on upstream stable 5.4.y branch.
>> The mainline kernel doesn't have this issue though.
>> 
>> Should we revert them? Or is there any missing commits need to be backported to v5.4?
>> 
>> [1] https://bugs.launchpad.net/bugs/1886277
>> 
>> Kai-Heng
> 
> 31c9590ae468 ("SUNRPC: Add "@len" parameter to gss_unwrap()") is a refactoring
> change. It shouldn't have introduced any behavior difference. But in theory,
> practice and theory should be the same...
> 
> Check if 0a8e7b7d0846 ("SUNRPC: Revert 241b1f419f0e ("SUNRPC: Remove xdr_buf_trim()")")
> is also applied to 5.4.0-40-generic.

Yes, it's included. The commit is part of upstream stable 5.4.

> 
> It would help to know if v5.5 stable is working for you. I haven't had any
> problems with it.

I'll ask users to test it out. 
Thanks for you quick reply!

Kai-Heng

> 
> 
> --
> Chuck Lever
> 
> 
> 

