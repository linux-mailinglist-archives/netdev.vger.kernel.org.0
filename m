Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8921C35CEDE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245518AbhDLQvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343509AbhDLQn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:43:58 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE726C061342
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:35:51 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id j7so413218pgi.3
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MFRxLFlZAYTFSlHlVMKGm5ZDq+iyqguCHvgNYLAMHUQ=;
        b=JiF1zVwfRiRoOC1gCfXFVpX/Gopsw7cFleNe0Pn93YVzUUemuWkNEcedefbJedIMpI
         UEmGBxaxMU6/nnXQG8to8XjMs3EzidWR56dMMoRfTsqGdJI2EOPkvoiF4je9V/6Pnfix
         ynI/BS1YQ308c/hT1R/eaQImHVGea4kiBSPnivcz0SEXttf4hcuznw+DpE9VjQbAC+V7
         MO955vd5UOMhOxbZ3AIFLyQpd4AODHj8S196/ftbAucnB7db4kJSoQf4uINL/q1nr7SW
         OHtrigPfWDJQACQjwjHB9nOlt/WYdchzfnParahVpg9wdsM7HHLYJAzK+keNOEZNs6Lt
         em6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MFRxLFlZAYTFSlHlVMKGm5ZDq+iyqguCHvgNYLAMHUQ=;
        b=dJgwCAPCt7y/epsZeBB1eQPucxULW+GHpqXdLAWT0kjZiS/L3A/cPGsfVrCLhpWWj9
         VzdA5GPHmE2ZDwMzEoAMznDJCAXYZUI8RwAet//4E4VniFMI8a3UCIo680eg5hXlQ1uK
         hygoOICnUqnpCtDgTJQgPhdpLkPgVwgelOytzY9L+BKV3Zz4YeteA5o3yf9Xs6bxrMrq
         7XFi7qaD+O4iq0s4md67M59DU2Z+M1PBtIigckUyrLFdWMvUW3A7EshHRoatCf74hqX3
         Jb8Ivw15lNbdgsBLi8wS2zmiyG13Kt1p8z0w0CAtIENcANr/BT7DUFARbbtrYJgnCmkQ
         LX2g==
X-Gm-Message-State: AOAM530+nwndEY2k65SyG+f5PRex0W3vcc7lrWzdk4ljzmmLSBl5SK+x
        jsfxsxIy18uiifhOsTLYteglZ6gzVnd9gbk2Z0et5dJj
X-Google-Smtp-Source: ABdhPJx6XMHo3AJdJZUIvdyTRfG95RyOyk4yHXOYjuSDchTH0SbPplPFqHEaS+6jVsj65lwW21Iv9GXyWoAyJcED8oA=
X-Received: by 2002:a62:ee09:0:b029:247:56aa:dfa6 with SMTP id
 e9-20020a62ee090000b029024756aadfa6mr15500218pfi.69.1618245351381; Mon, 12
 Apr 2021 09:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210406162802.9041-1-stephen@networkplumber.org> <20210409104947.36827-1-christian@poessinger.com>
In-Reply-To: <20210409104947.36827-1-christian@poessinger.com>
From:   William Tu <u9012063@gmail.com>
Date:   Mon, 12 Apr 2021 09:35:13 -0700
Message-ID: <CALDO+SanwrQ9jOnhNwkA0MTEWgEh3ykXJ6yahDWJL9npTKW=iA@mail.gmail.com>
Subject: Re: [PATCH] erspan/erspan6: fix JSON output
To:     Christian Poessinger <christian@poessinger.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 3:50 AM Christian Poessinger
<christian@poessinger.com> wrote:
>
> The format for erspan/erspan6 output is not valid JSON, as on version 2 a
> valueless key was presented. The direction should be value and erspan_dir
> should be the key.
>
> Fixes: 289763626721 ("erspan: add erspan version II support")
> Cc: u9012063@gmail.com
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Reported-by: Christian Poessinger <christian@poessinger.com>
> Signed-off-by: Christian Poessinger <christian@poessinger.com>
> ---

LGTM, thanks
Acked-by: William Tu <u9012063@gmail.com>
