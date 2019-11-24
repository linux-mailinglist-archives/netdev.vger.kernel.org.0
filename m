Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D208108246
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 06:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfKXF6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 00:58:05 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:47050 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfKXF6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 00:58:04 -0500
Received: by mail-il1-f170.google.com with SMTP id q1so11140379ile.13;
        Sat, 23 Nov 2019 21:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7NhDdUlR+wyJkJ0ZLg+wUD2dKyI4g1cYP3il952Geyc=;
        b=vc7kmAIWqvwSk3XM0+PzOkN6MObepDx5quHRKXfUo51SJOVMxFjN5pZ0XbdGP6bQX2
         HNc1vz/qRlUtyuwDjuSCs4adIgUS55wZoViUP5gRLGI/5Nnqs8OIMflwGdYX5HNIx3Qd
         VSZlFyxo+OUPca15mmBsZp0GmaBWXhS5Ed4b+DcCClEAr1uNGSmjvNCNyg9KYYDK7v/V
         E58s2KTFEmZzkzKgBrb5TkeJ/f1iev6qZ3jBTa1sUH1yQEvWcdSHwxNiaNurOufgGTfz
         6KWvHV0CYWsyfE6G8PbPZZcTxEvvSgTq5DcOABzdrD78ygyU0YKIY0nhCK0xXo2kRvEZ
         hsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7NhDdUlR+wyJkJ0ZLg+wUD2dKyI4g1cYP3il952Geyc=;
        b=mWQJcg4aknIXnHG5vaS+i4zwWT2i66Vrd/3M53Y6ALPu+X/JVfTbR+Q9QzRU04un6m
         sX8tzm77yPATaV9dOxqrcMhKSORW/BCyv1wyVPqgp6cvsvH3B8ogjy8QydjFT2Ycbn/j
         Yf3PQzKHpwXsYjDmqtuzbri1w3RZ2fiUR1OiWgS424rwGP9uwjZXHhes86mdY/kY3Chj
         m7OTAiJ/nw85heuCQHdPfHiM4GYWvZ40SLs/KhiN1Bs4WXeNpHu/Q5QUnEsBHygnJzE2
         0AVitqJpPtDs4Nblwcu4mm5IbB8ShC5jZqDUmDanmVu394If9PM3eiP2b0iUiOJZlbFR
         x+eQ==
X-Gm-Message-State: APjAAAUJfwIiY8UmvonsWqH69tsjlLFt/gHFEm5bAFwFz5qAd8R7GwBJ
        yF3mJchXCw3MdDKzRVbA3GQ=
X-Google-Smtp-Source: APXvYqxqrIEiQ5YAzHYHwy94L0zy3+2Md7rdfd5WPywJfYtbDojgFv6n2DSEi0lFCVxhFvVr+AJmOw==
X-Received: by 2002:a05:6e02:cc1:: with SMTP id c1mr28310648ilj.139.1574575084157;
        Sat, 23 Nov 2019 21:58:04 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d8sm936000ilr.82.2019.11.23.21.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 21:58:03 -0800 (PST)
Date:   Sat, 23 Nov 2019 21:57:56 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda1be41c6ba_62c72ad877f985c4e5@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-7-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-7-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 6/8] libbpf: Recognize SK_REUSEPORT programs from
 section name
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Allow loading BPF object files that contain SK_REUSEPORT programs without
> having to manually set the program type before load if the the section name
> is set to "sk_reuseport".
> 
> Makes user-space code needed to load SK_REUSEPORT BPF program more concise.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
