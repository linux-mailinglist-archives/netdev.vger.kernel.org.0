Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92D2AC72F
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgKIVXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKIVXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:23:35 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4FFC0613CF;
        Mon,  9 Nov 2020 13:23:35 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id q28so1037544oof.1;
        Mon, 09 Nov 2020 13:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/8e23jmWF0zLSuDrh/DoOClOMWqEUTAgB9D0NlWAzvU=;
        b=e3OhyFo42YU0Uc9UdimaaWvc4Gx++UhE07xWCD3Tx/k2/P8enGVSxlhwasvrCgZ0FK
         ueaOzzl8QQLM5FBPxgLBsnE5FAgva3VkZi5NjS3323a9yVT/4HB3VvEd+O/A+isunEB8
         ok4mDx1YXduyrR7JplZGBPJTXBfESfYvQDimkfYI/63DpEa9VoceJfKht1Z3caOZZGWM
         4kLPduVKtOnDIG0Lmll93QPZQrEGZ/e7XyQtLHXpNPrjy9LFLuhrQ1C5S9UpEcP5hvev
         hI909JmbsV0SCHbWlymiA4jEkP7GujqKgyXDEm8J0gIzvMttgKivIMogdrqAs2X3kCDo
         LqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/8e23jmWF0zLSuDrh/DoOClOMWqEUTAgB9D0NlWAzvU=;
        b=grSTw0i1HKmlcNShANMr3oWlM7KUY4FKKnFDm3IwHNFMcxlteRnJfv1Q17iHS1VAvN
         fJZyDF339TFLU5xOZlHyHhFykY4HVZ4l0bzi2l7+2F39M9S8XS0TqUnjEMjbkNScFPrH
         VLCg3SF/uTCnxNBvLSvK9GuHviKmc9DYrZObCvdwH/ZJJoU37CgIRtS6yRaMPo94CDT6
         E4scaiVbW9HGlICucqQzJyxDYBdjTnM/sz1BHrqhZBsA7zBIBl6rcB2mz5Zj2dtA2nAV
         oOtQDEBZ4BU7CWpcOrp/Hq1kftsweS4Uyotp+voJk3Y7qyIO+UqgB4IgL5P1YJhW+Fa5
         n5ew==
X-Gm-Message-State: AOAM532tdemngCgfHwjJ7/n+DJj+3oDwnTMDkctzaSFvpdJk0Hp/BtiD
        77oRQG4TU/d7qsn3Sl8gZDc=
X-Google-Smtp-Source: ABdhPJxA352mKQ9xMZ+PPBzsmHTnAFsTAjfbNY+f7PuspaOWhQMA1QIBanNp9Y2UtsPyU03ukg2I5g==
X-Received: by 2002:a4a:9486:: with SMTP id k6mr11388212ooi.85.1604957014754;
        Mon, 09 Nov 2020 13:23:34 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w21sm1116483otq.20.2020.11.09.13.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 13:23:34 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:23:27 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <dong.menglong@zte.com.cn>
Message-ID: <5fa9b34f132a5_8c0e208ca@john-XPS-13-9370.notmuch>
In-Reply-To: <5fa8e9d4.1c69fb81.5d889.5c64@mx.google.com>
References: <5fa8e9d4.1c69fb81.5d889.5c64@mx.google.com>
Subject: RE: [PATCH] net: sched: fix misspellings using misspell-fixer tool
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

menglong8.dong@ wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Some typos are found out by misspell-fixer tool:
> 
> $ misspell-fixer -rnv ./net/sched/
> ./net/sched/act_api.c:686
> ./net/sched/act_bpf.c:68
> ./net/sched/cls_rsvp.h:241
> ./net/sched/em_cmp.c:44
> ./net/sched/sch_pie.c:408
> 
> Fix typos found by misspell-fixer.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---

Hi, you will want to add net-next to the [PATCH *] line next time
to make it clear this is for net-next. The contents make it
obvious in this case though.

Also I'm not sure why the bpf@ include but OK.

Acked-by: John Fastabend <john.fastabend@gmail.com>
