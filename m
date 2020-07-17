Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F292242A5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgGQR4T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jul 2020 13:56:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42739 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgGQR4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:56:18 -0400
Received: from mail-pf1-f199.google.com ([209.85.210.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jwUal-0003bk-GR
        for netdev@vger.kernel.org; Fri, 17 Jul 2020 17:56:15 +0000
Received: by mail-pf1-f199.google.com with SMTP id 75so7379699pfb.21
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DJeYw43KCdF1n+mtxqHrWGu9uDmkgMx6dDVvN1r/iUI=;
        b=Q0m9V+of3K7l2y79MHR2gECntzAeDWrHIWtGCRrPzPcxU5rGP5GQB7F27STeZakCkr
         JFiqJ4NDOu/zkbI/LAqYZXiHz1cCc7Ukf0Bw6iNugqeDcg2BYw0CRFQ84a/a5JOoDEkf
         SYK9ItcD4yOMgJX7AapNCwKxuikd2nbHtLWsEmOLPikxui1hP+OmdUoJ4ymSkP79IFFC
         aRlvQUpTBgOVZ0/BcGdZb67awDB3eM6EPiV4fz3EfTQ9I0geXVQWgmPJMy+xjvAkWePU
         b7Jg45WvBc+kZydjdUCJZb4pKySGdpFZ//UdhIGpuYGM0hS4NA8+4Mk+4INAHd/bRAc7
         nAig==
X-Gm-Message-State: AOAM533yeqvmCtUr8tueC01nF4l4mqOlrVVNx0QCb1nU5rKhoPI5cilb
        TnVvhrrjWRyDXrnO6CsufFNh1iyMoNoqrE53r8SGqebt0dFWtOIEpsqv6Ag+r+weHwP5DAZ6tGl
        TP+risKDYnmQJuMWLYvX7j3P3OGKcL9yaPQ==
X-Received: by 2002:a17:902:a412:: with SMTP id p18mr8397699plq.283.1595008574083;
        Fri, 17 Jul 2020 10:56:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfTo9D7lyFkDMei5LDbgFf/qwVM6msV/kFw7ZA8SiHACyAuV9cXxTJL0fSYj34hSeq6uLdww==
X-Received: by 2002:a17:902:a412:: with SMTP id p18mr8397678plq.283.1595008573667;
        Fri, 17 Jul 2020 10:56:13 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id b18sm3514062pju.10.2020.07.17.10.56.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jul 2020 10:56:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [Regression] "SUNRPC: Add "@len" parameter to gss_unwrap()"
 breaks NFS Kerberos on upstream stable 5.4.y
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <650B6279-9550-4844-9375-280F11C3DC4B@oracle.com>
Date:   Sat, 18 Jul 2020 01:56:09 +0800
Cc:     Pierre Sauter <pierre.sauter@stwm.de>,
        matthew.ruffell@canonical.com,
        linux-stable <stable@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kernel-owner@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CCF13E29-7B8B-47B3-A8D0-1A6E0E626BA6@canonical.com>
References: <309E203B-8818-4E33-87F0-017E127788E2@canonical.com>
 <5619613.lOV4Wx5bFT@keks.as.studentenwerk.mhn.de>
 <0885F62B-F9D2-4248-9313-70DAA1A1DE71@oracle.com>
 <4546230.GXAFRqVoOG@keks.as.studentenwerk.mhn.de>
 <650B6279-9550-4844-9375-280F11C3DC4B@oracle.com>
To:     Chuck Lever <chuck.lever@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 18, 2020, at 01:34, Chuck Lever <chuck.lever@oracle.com> wrote:
> 
> 
> 
>> On Jul 17, 2020, at 1:29 PM, Pierre Sauter <pierre.sauter@stwm.de> wrote:
>> 
>> Hi Chuck,
>> 
>> Am Donnerstag, 16. Juli 2020, 21:25:40 CEST schrieb Chuck Lever:
>>> So this makes me think there's a possibility you are not using upstream
>>> stable kernels. I can't help if I don't know what source code and commit
>>> stream you are using. It also makes me question the bisect result.
>> 
>> Yes you are right, I was referring to Ubuntu kernels 5.4.0-XX. From the
>> discussion in the Ubuntu bugtracker I got the impression that Ubuntu kernels
>> 5.4.0-XX and upstream 5.4.XX are closely related, obviously they are not. The
>> bisection was done by the original bug reporter and also refers to the Ubuntu
>> kernel.
>> 
>> In the meantime I tested v5.4.51 upstream, which shows no problems. Sorry for
>> the bother.
> 
> Pierre, thanks for confirming!
> 
> Kai-Heng suspected an upstream stable commit that is missing in 5.4.0-40,
> but I don't have any good suggestions.

Well, Ubuntu's 5.4 kernel is based on upstream stable v5.4, so I asked users to test stable v5.4.51, however the feedback was negative, and that's the reason why I raised the issue here.

Anyway, good to know that it's fixed in upstream stable, everything's good now!
Thanks for your effort Chuck.

Kai-Heng


> 
> 
>>>> My krb5 etype is aes256-cts-hmac-sha1-96.
>>> 
>>> Thanks! And what is your NFS server and filesystem? It's possible that the
>>> client is not estimating the size of the reply correctly. Variables include
>>> the size of file handles, MIC verifiers, and wrap tokens.
>> 
>> The server is Debian with v4.19.130 upstream, filesystem ext4.
>> 
>>> You might try:
>>> 
>>> e8d70b321ecc ("SUNRPC: Fix another issue with MIC buffer space")
>> 
>> That one is actually in Ubuntus 5.4.0-40, from looking at the code.
> 
> --
> Chuck Lever

