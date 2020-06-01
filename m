Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE611EA6BB
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 17:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgFAPRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 11:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgFAPRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 11:17:39 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE597C05BD43;
        Mon,  1 Jun 2020 08:17:39 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y11so76223plt.12;
        Mon, 01 Jun 2020 08:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=iZK3f5pJxBsQ3T3K996+9By5J2/mRGbV/k2KfLRnqQc=;
        b=t/fvGGRNaEIBvlKvKhZWthXmzvgNXPO48KVqNAZnQLldyI4pnDrKVzrDnJEd064Kr9
         xZxZdx1WJzfKQr3ZGBI5rSEo5BB+pUwdOK95IPG+AcnDCoftJrqeA2x8xDfpodixm0g8
         CWSNN+y6jq7JdIbrnjUC9qct3o30G3N4NAP/7VvwbNhUw8IWV3VJ9pjLZ/hCOvAFeO8O
         do1BdKiJTLJ2kegP2z3kD4Lkn4dPuK0HCG+ifUwWqSv9ZtpQYI3VbJhdKNMLppCCoBer
         cy8roxRtj4U4GTTCbvFv0szZa8x3xXGxQOHfmaYuCd02M5rNxyLbdmSul9lxa/GPSU7j
         Zfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=iZK3f5pJxBsQ3T3K996+9By5J2/mRGbV/k2KfLRnqQc=;
        b=eEUaqTBLc0wChupDvJt+e36+O2+xnRU+v8kIPNb8pW/a0/rDlpXSGWa1C1toi1sOrh
         9DdZQwiztREGZdnwAJI3cDwoS8pPsOmIiybwIQDFLKWeYVxXTKXCOYLHOQz6lCvlDDU6
         62IE99UDoqzf3bbHMU87viWdwyYpqrqNnD7VLSqCFQLL+My8vXwA/K4jg8o/h+DA6ocv
         fS3SgrONuhRM9/ijizZcfbv6u6Q/vmHA+fawNUA/FVniAfPbOSJP2Q24O0D58YePonUF
         57iZkn9y0Ll0zExL6ifiOm6fWH7PMMPnRKLMzk4eKg41AFcLSsazNpTaQ22bNGswr+6L
         3fkQ==
X-Gm-Message-State: AOAM533g3AJGloGlFAT9i8EhFOZNs8UbgVE4hyPqgULxENkTntnRD0Ym
        tXaeFxLFpy7oaQJItCzvxLU4egFJWuk=
X-Google-Smtp-Source: ABdhPJwlXq7gx2QtAiz6OfMpxdgkAOhg5RjJ+3AEGPysxfT/auMoWuPEhwpr9wAXvOzmXw3XWzCeMQ==
X-Received: by 2002:a17:90b:28d:: with SMTP id az13mr21845194pjb.67.1591024659197;
        Mon, 01 Jun 2020 08:17:39 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s13sm14500295pfh.118.2020.06.01.08.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 08:17:38 -0700 (PDT)
Date:   Mon, 01 Jun 2020 08:17:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Message-ID: <5ed51c0b35ee_3f612ade269e05b422@john-XPS-13-9370.notmuch>
In-Reply-To: <20200601161614.4bea42b0@toad>
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
 <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
 <20200601161614.4bea42b0@toad>
Subject: Re: [bpf-next PATCH 1/3] bpf: refactor sockmap redirect code so its
 easy to reuse
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Fri, 29 May 2020 16:06:41 -0700
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
> > We will need this block of code called from tls context shortly
> > lets refactor the redirect logic so its easy to use. This also
> > cleans up the switch stmt so we have fewer fallthrough cases.
> > 
> > No logic changes are intended.
> > 
> > Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> 
> Keeping out_free in the extracted helper might have been cleaner.

Perhaps. I had the out_free there at first then went back and did it
the way its done here after writing 2/3.

Thanks for the review!

> 
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
