Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA589254AE0
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgH0QjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0QjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:39:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E992DC061264;
        Thu, 27 Aug 2020 09:39:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 2so2906516pjx.5;
        Thu, 27 Aug 2020 09:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jxCXbgMcETXHjztc3e+kVoudG6X3Da4/3xGoUmDe/go=;
        b=XW/uM5Wcqs1yZHw4538Bg/z+LBQqf02T/ePJeyRyj6ZTeQLUXBuzSHvXfAZB1cQ9a8
         VaFudvP3ZLv6nyZ/9buDVA4JdvR6nksaKtuBpLFJxdCx3gpXn8K9ZWLKx+NxmgridkZ/
         cgn3Dbc/AMeiUxpoy51H8Cyu3qbIwV8b5ENB2IbHg9QW+jOjqkO6CaM80ZuGE2IrA/8D
         xk8OsYLegXgl3Qqb02lyEUv5zMZU5L+l5wBUfQG+zA18yMsrm5KPya3RpWnrYpBmriOp
         x8GwF8H/8lX/4s+1cber7Jg/S72tqXiJDe3rQIGfR58af6X9ertm4bezF1pkWMEPu1xb
         gMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jxCXbgMcETXHjztc3e+kVoudG6X3Da4/3xGoUmDe/go=;
        b=OKFhYIYEUJrYcdL3LnALQQtbJ0ML7JxHc87UxkLfor5SEk8R3h+xBdOhwrVkbEkxGH
         PKeUPAsgV2PMjcQRG/rDn8pZzowKB+itlbr4ZfViW+ZK4u5G95Gzl3nTrwCDE5CIRbNv
         9OLNXWKYL3e4Vq8sDni5FsAvRqsz2Zsga0xdHJNdYk7bbXrP1zqHtCk1WME4m/6SBdVg
         keWhYOhXaYJAeUI7gXN490yki+OLt4G0dpo6YyIa4AIBk4vJW89S/3uSUWsyfaWl58RR
         73HoIFVemwtqkTyaOKtSMGFp960quib9oWsrFmnjH9qz0YvY5e5TPVPZf3AAYeuLevim
         k06Q==
X-Gm-Message-State: AOAM533fLVCYgmdS5lhjrQcJgjTRPid/HbfIemcRKSrJS70ZGU+YgQEg
        L+QOB9IIgofQKkipY7WOCPY=
X-Google-Smtp-Source: ABdhPJwpWQ29kxC+TVlHr+oDZK4vtLSemSmHkpzr9sxgG/h+Squy5aUs9Iec1ATAW/4STRoSgEjkog==
X-Received: by 2002:a17:90b:298:: with SMTP id az24mr12053655pjb.192.1598546359254;
        Thu, 27 Aug 2020 09:39:19 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y196sm3343989pfc.202.2020.08.27.09.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 09:39:18 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:39:16 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: ptp_ines: Remove redundant null check
Message-ID: <20200827163916.GC13292@hoboy>
References: <20200826031251.4362-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826031251.4362-1-vulab@iscas.ac.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 03:12:51AM +0000, Xu Wang wrote:
> Because kfree_skb already checked NULL skb parameter,
> so the additional check is unnecessary, just remove it.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Acked-by: Richard Cochran <richardcochran@gmail.com>
