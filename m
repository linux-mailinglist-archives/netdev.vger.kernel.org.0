Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77381256405
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 03:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgH2BtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 21:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgH2BtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 21:49:16 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D71C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:49:15 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id m7so1355463qki.12
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lFdiRD6eeBqcYKKce+Hske3rZkx0W72VbNWus0IdT5Y=;
        b=Voi5uw2ZSEQSkAOH/o+ow7fgbSfzk63YYAu0muwHrZAexEMytjUEBocfsvFx29f7v7
         eYa89CacWLjHnlPmdciitr10smtciyf58VwuyoZBYkV6KxwGM3LXmYV+edwtxYykrlbG
         Vbd5K3ho0KDczRfZItwyDvsnZ011d4wCEF9KJ2jSVJy5vOePKBePFA1NnQyK4daZ/o9/
         UScZnH+SXUYqoLoNBJc4pgwyRBg/LkuoKx8l89gs8ISnpktrmmBX3VLO20LL+bmUh7Lu
         L7al3U0PoGvM+H2wPn+fSXcTJ03cV89aTnVtFoEB2eobaBwxMsAwmz59fmaQ8M0/sqhv
         sFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lFdiRD6eeBqcYKKce+Hske3rZkx0W72VbNWus0IdT5Y=;
        b=nnc0tC+ITXZBcY+XVC/u54nNMywdObrKzxcTSna+5TC4Xfh8LnemdAIpeWscjmb50t
         8uZ0gwH7SeVjr0eihw/I261DaYK9dnbtnTNmWnzklbHJ3xuEtVL5gSHrm6em/v5I9t+g
         t5ah3Dy7fj1dKH4ZxlPHiDu+OkBTJpnfCsXIWtH5Cv/9h8HIG9U2hs8mwlTDFEaTEI9c
         il6p0ORGNqM1OPmTsItwWKdl3H49wyMD+MOrLDFG8sYT8sfAHQJDTEvLRYIhuyqFwkbT
         TRLbYFFQHP1BZEt6WH29jrTwAe8aZFr1taJL68eAo09KvKgSU11YyFzqCuEd2iu01DUA
         63Uw==
X-Gm-Message-State: AOAM533sg2Mxpq4q62mHWB4OPlSeDcGwAkJI7hNAKko8LFNrbOE9+Gju
        3hTnHso5x5tg3tM2nskVbas6brMsVOFeMw==
X-Google-Smtp-Source: ABdhPJwsKmP/x3ZeBCoP4QPzWVNNERcpCbXapkL3KjKh9LaCHmbr6sd65ezPYWuUnEJqwc8QvOuoxw==
X-Received: by 2002:ae9:f30e:: with SMTP id p14mr1814706qkg.26.1598665754494;
        Fri, 28 Aug 2020 18:49:14 -0700 (PDT)
Received: from localhost.localdomain ([177.220.174.181])
        by smtp.gmail.com with ESMTPSA id g55sm924835qta.94.2020.08.28.18.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 18:49:13 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 81D1DC1B80; Fri, 28 Aug 2020 22:49:11 -0300 (-03)
Date:   Fri, 28 Aug 2020 22:49:11 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] Add ip6_fragment in ipv6_stub
Message-ID: <20200829014911.GC2443@localhost.localdomain>
References: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598627672-10439-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 11:14:30PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add ip6_fragment in ipv6_stub and use it in openvswitch
> This version add default function eafnosupport_ipv6_fragment

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
