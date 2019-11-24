Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45791108249
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 07:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfKXGAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 01:00:10 -0500
Received: from mail-il1-f175.google.com ([209.85.166.175]:46106 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfKXGAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 01:00:10 -0500
Received: by mail-il1-f175.google.com with SMTP id q1so11142297ile.13;
        Sat, 23 Nov 2019 22:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yY4qgMXfeTQpIxFmEUuamwIpwcW0WarjR4Tj85LPKfI=;
        b=cFdfgZOR6jJiwqdE9ZdJdizNJmcMl1PgyhoDcREPjV4JUqYXSvt14aAttHV1UuJL2W
         QjjJXPvnB4nX5utHRNRc/+OZy3sdwDRPLAUbeEP4gX/g2vWdJBX4oon6FVcNVohzhYRZ
         1T2SK1Y4yejKBhucnn+QnQA/ifz8qZ1H8IlvS3IBeLLeVMmsB2Ljw1O5HM+/XF2IU8Gj
         qeOv4Nhok5d6tZHLWJF5a7DowLemcd1x5P59IOGCFlj7c8/+r91Y5yyc1XqRtcZaKi/z
         u2mFou1H4sVZ3oI5YKJyGmrWo1K21BcHKrqx+XtwZXE8TDJwnrYyDQwnMJmO1IDV6bPc
         Wapw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yY4qgMXfeTQpIxFmEUuamwIpwcW0WarjR4Tj85LPKfI=;
        b=dgeBYf4Dc2kZVhwqtkfDzHdV7Svy2XSCqKzzMssyWJmX1o6prYzm4/tZvmRexO2hDS
         B9kfRZWE/au6h2arfiRFnxNUheuxhUKdlLcF3/vKgEeEYuz0SSpAcLTMki+QA6KOfY0M
         k1BBGTeuAqIl7s/WocYI1do5w2s2bTIpEgFkjncNCIDtuf0rPYZm8TJ18vutqykexGz2
         k80OsB3wKWmmSJ13Rc0rWNIWZls5iKMJ/vtc026qOVNfCKm5aaTrQCbxL5tHpfwPw4bx
         +Oge1k6/XRhdJvb2HKcPqout1yrFoJma1hdiond+0aTLtndKql6pRZNzIc2REzew5mLz
         HKSQ==
X-Gm-Message-State: APjAAAUKGwLt5QqKCpVQHK1LyocpjPl26/P7qZJHf5zP3/w7NYXAQ/Lh
        gt+NjMs/Vj2XIRCqPUmDC5w=
X-Google-Smtp-Source: APXvYqx0YmCjieMgtfGMqdhO2zY/pEK8jm7GKt3OyYyMPh5KC+fB7Q/50PbpZ2wWgSl5JbodD8YPQA==
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr9389028ilq.282.1574575209642;
        Sat, 23 Nov 2019 22:00:09 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l15sm935674ils.64.2019.11.23.22.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 22:00:09 -0800 (PST)
Date:   Sat, 23 Nov 2019 22:00:01 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda1c61b18f4_62c72ad877f985c4f7@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-8-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-8-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 7/8] selftests/bpf: Extend SK_REUSEPORT tests to
 cover SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Parametrize the SK_REUSEPORT tests so that the map type for storing sockets
> can be selected at run-time. Also allow choosing which L4 protocols get
> tested.
> 
> Run the extended reuseport program test two times, once for
> REUSEPORT_ARRAY, and once for SOCKMAP but just with TCP to cover the newly
> enabled map type.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
