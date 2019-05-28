Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22F22CAE7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfE1QCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 12:02:05 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:40722 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfE1QCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 12:02:01 -0400
Received: by mail-wm1-f48.google.com with SMTP id 15so3472622wmg.5;
        Tue, 28 May 2019 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uP+X6CLAR5ihOYgarlRBZFY24hDmrsh3/yfRunEcp8w=;
        b=Ci2K/NXzoPqliveAuprmX0xD47KVoGoJDuwabgKb7d8dNalwUfutwRNXleRxyGBvAR
         cvsNPgXsk7HEFGc9kg+GPt4bw/Iq0b7NTeFa87FAVyJKF7a1Q5QL3sLdpOA2t8cZj6r6
         +9GQtJURSgv5NJ9F/oWVN1hECA+CWw3Yr4WZKxmiW6j2ACCV/cOrnJ0dkv/BmFiYMHGY
         Xkj9NtD4Hwl2O+cuc/3YNtQpBGRded/xOpaUj/4ZgsqncuVx5Dr2FegaWuvcRceYvnsK
         CyIHRc8C71lyycewNNv4Td+4voVHoccxrVDZZ74CrNC9/dthTluB9T4jMc9Efg8UkvzF
         sEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uP+X6CLAR5ihOYgarlRBZFY24hDmrsh3/yfRunEcp8w=;
        b=MucQBN4CRKlXKbJdb7Dk1uumC667IU20C+VIvxpzUwqJUjhTQ5tUjvRzBU4eWnDJJa
         Xti6K5hZKroRqDT4KYvd4mzhp1P7OumKUuhn+xraJu6Pw4pLcS6UJIHBhnnqW/caE4d0
         igBNTCN/2tqGj5I223LC5uQVqShODJkzSUJNRxzttDdrw1Wb/PP3KuiGL3YOWXtouNpz
         pYWJu4jK4rucgYnGf3O3xwpxgGVT9Ov6nbFTofni87Xw2iepPd35V4Fjj4P5UnVy8LEc
         IA+antZ3L5CvkbeSVOkIVM7Q6FWw7b2mFY15C46paNQ5MFC4HrRiPjvnNYVQX6VrZLe+
         8vCQ==
X-Gm-Message-State: APjAAAVzaQWvE6THOR3Bp+wJAiJdYEesRBNKyKUEvbB6FVaBb7cBTPFP
        ldA6e4qKL1OngAapJh0ZY14iCtoYa2jiH4chq3I=
X-Google-Smtp-Source: APXvYqzl/hfkNLgkDKnZ7veZXd+da650JltEI0Es4rD3jS8I20F7avQ8GNuRHlWyhLLks10dIwng4msymAIOXelTAaY=
X-Received: by 2002:a1c:cb0c:: with SMTP id b12mr3432043wmg.86.1559059318980;
 Tue, 28 May 2019 09:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPgz2Pzi5qNZkHwtN=fEXEwRpCQYFUkEzRWkdT39+YNWFA@mail.gmail.com>
 <875zpvvsar.fsf@toke.dk>
In-Reply-To: <875zpvvsar.fsf@toke.dk>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Tue, 28 May 2019 21:31:45 +0530
Message-ID: <CAA5aLPhrDbqJqfVVBWfCZ6TK0ZFMOSsqxK9DS9D1cd4GZJ0ctw@mail.gmail.com>
Subject: Re: Cake not doing rate limiting in a way it is expected to do
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, lartc <lartc@vger.kernel.org>,
        cake@lists.bufferbloat.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's a controlled lab setup. Users connected to eno2 and server on eno1.
Link speed 1Gbps.
No ingress shaping.
Simple http download.

I am having multiple rates requirement for multiple user groups, which
I am controlling using various classes and thus using htb.

Just to mention once again, fq_codel is working it's expected way.
