Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3481E2346CB
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731099AbgGaNXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgGaNXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 09:23:18 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47F7C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 06:23:18 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a34so11191556ybj.9
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 06:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=szvvv+T8WGktwhOnk8elVEMBZZREhz0zEh6+I/LvyNE=;
        b=s15SnGAKfVmSNodTJmQfmxHCUUXSlAc3kClaDAmy811VuRwRkj4GOdAfCEQPV7k/Fj
         uzTVrqHYDx/e+QZaRUpZ+lf9FQVj/g6QcwtjcyG9C6vgdQ//yBtt45wIhGqoLFq5ypY7
         fiLrEfDjGXQ2ESQPF2yHFobaEpcyADZor5SzohCXogV1LvsssK8MZto5TzfY3cW+gTT9
         NmQcqW67OrC7cw5c0y+ZZOjuHsMVTMX+iZI657mJm7PnoPlEBS8gUUmap5elk9DSikLh
         aG4HUVFOmL+d0ly3PPFXcMieFqAWCGyFvtPj1/ivckzbmRd+ntwOdJsz/KCdynukT+qp
         jAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=szvvv+T8WGktwhOnk8elVEMBZZREhz0zEh6+I/LvyNE=;
        b=kYpIgTOKkxPDgDVVa6gXYoH1rZ5P8/t6rL4DOojJtJejM9lGsoiH5QSccu8NmQWXHG
         L3tnXy1TNYacgulqOMDl+8Ydl0HSxIuzcCKQYsPHNcFJ7N6E5Y0pEIT6w4NXKirWzoi3
         Ve/avoL2QjwYWV6HhfuiY2zVQbUDUmI/xcFWT4P1WOyLGoRR9Yfbzd2uo3v1y3sEvj8f
         aPQAokB1nBWIqYm1Wg0feaYE96R3uM+IEwxnMbo5WJgVqEg83v4FXgzeIaI4Fx2bZ8Vb
         B1b38DCE0YQow5FAXlmj7lS1HS9yLirl34hiSvYB3G0KowHGqlCiMKVM1eRjFdPDRQ5O
         q38Q==
X-Gm-Message-State: AOAM533Gavrh6Um3PiGVGE2G849y+LPYoHBxsbPeohOZhU+0iD0z1MKo
        M63I0niC5c90QJIj7UMvKbQT2uEYvaJNBb2zfsAbbswF
X-Google-Smtp-Source: ABdhPJzhhy5WyVLRQ6uD+7p67HnalAZKv9KAVB823fq0s2j82Mv6T0uQZLmPnrwY+OI72wnPUSVk2085aA2wyJnqZes=
X-Received: by 2002:a25:5887:: with SMTP id m129mr6676099ybb.11.1596201797823;
 Fri, 31 Jul 2020 06:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ3xEMhk+EQ_avGSBDB5_Gnj09w3goUJKkxzt8innWvFkTeEVA@mail.gmail.com>
 <20200728125136.6c5b46e8@hermes.lan>
In-Reply-To: <20200728125136.6c5b46e8@hermes.lan>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Fri, 31 Jul 2020 16:23:06 +0300
Message-ID: <CAJ3xEMisQFoFzghnoTC7joD5JxNi95o8T7gR8fW9OkxEbsuaQQ@mail.gmail.com>
Subject: Re: iproute2 DDMMYY versioning - why?
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 10:51 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:

> It is only an historical leftover, because 15 yrs ago that is how Alexy did it

So how about putting behind the burden created by this historical leftover
and moving to use the kernel releases as the emitted version?

Or.
