Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEF020EE1
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfEPSnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:43:17 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37014 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfEPSnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:43:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id h19so4054600ljj.4;
        Thu, 16 May 2019 11:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=unVG59VzBSYO4iOVXWL7fSEnwAhYhvevqAGHSVFtITs=;
        b=JzXCeX1bZ1ONHAEBSxYaRxUvqfPdgB39LOqzBGggD1p4Y7zZFtKKJoFFiDoun3nS3c
         1V3qUE/ds+HnbVRGYOWzTArmY9yvKrCT1q4aSK27OJLN1MtvREOrKrj/PjiGyc+xZ09/
         sGsMWCWtB/6kdzX/1kTY5K5vHLpMRa3qWUtkpb7290pgZF+Ehn93gzVtH1G1GBhfUko8
         0tXIhenPwkO6Oa4FK7Qzu08vuZ6AlKSXTO5igrr/8nA7/W2sF4Gk6qmwyrPpOqR4JIvZ
         RwAFK8PmfXQWHLs/C33C1JIL9MAQCrpu6kGpcZPDFb0wgv3y1uEXLGybFFRYF890hX5U
         wbGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=unVG59VzBSYO4iOVXWL7fSEnwAhYhvevqAGHSVFtITs=;
        b=g6JbNr9rSQoJL4nSbkwXUvNQGxNa6SxutRi+cU0DexETnDLw74j4mJQfop3d4NbrFK
         F3o01pSizuqb89CzxkT7Q/krkTuYz9bwOKJM5teZxnVaU+4ILBw1IMBqZevv0MQHmAMp
         IE+NXOjqLfSKOGJC0rW23gds/iTtiri8yubV2T+YLO2vgpA30nVCUnNpKnRJtLuZ/CJ9
         P36NpFYYmybgeRAYCo32LDw5oXvgfO71Z5LQ6wA29ob5A3M1M/plV9agboXnFhpAxbMF
         WOFutqCxI7TMFqo7/XtwWEkpX9oX2lYJz6EvxwNspxH/gd4sSWJ1MvbOptWaUuc3L/xI
         CPVw==
X-Gm-Message-State: APjAAAVsLMdKmZtOn3JX491s4JzzJgPAsk1wtYMvQtXsGC45DPFnFvSm
        nM+y74lxfa1ol8YZPRoQWF6/W8j9zhQczAOQ9d4=
X-Google-Smtp-Source: APXvYqxBDW9EwLKEM/loJ6ILDsGQzYnaLEazK9HiGiufleeEQCm+KRHOQSULmCZ4eO6rpb5lcU85bhL9Y8KiDYPaGX4=
X-Received: by 2002:a2e:9f44:: with SMTP id v4mr3078676ljk.85.1558032194378;
 Thu, 16 May 2019 11:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190516112105.12887-1-mrostecki@opensuse.org>
In-Reply-To: <20190516112105.12887-1-mrostecki@opensuse.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 May 2019 11:43:03 -0700
Message-ID: <CAADnVQLFrZyjbFb6o0YezLyqGBKcsiT=jVGfwDaupGLvgLp31A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Move bpf_printk to bpf_helpers.h
To:     Michal Rostecki <mrostecki@opensuse.org>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 4:21 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> This series of patches move the commonly used bpf_printk macro to
> bpf_helpers.h which is already included in all BPF programs which
> defined that macro on their own.

makes sense, but it needs to wait until bpf-next reopens.
