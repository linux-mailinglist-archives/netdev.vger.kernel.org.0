Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F2E5FDF7
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 22:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfGDUyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 16:54:53 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34859 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfGDUyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 16:54:53 -0400
Received: by mail-lf1-f68.google.com with SMTP id p197so4979461lfa.2
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 13:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EKosXk8IY43vkJkxGl0iU1fOZw9WRZsC81tWa05upeg=;
        b=lNYvofGRpjZMCQsbGCIszAABMfKJCl3s1GcomqhAptCWRxWYCevIhrkuiHGMgt1Fvs
         qcLlpvprCNSf6A5wNHTZUXgMu8BUVM+i1DAyD3gS891JUCJEnbbz5oR/fKgj6VEYe5cs
         XQUeJsUgnzAjX0iCA3DaKAXKW814FODDgF4gmc3EiDrfoPTmwZQY+ssWNCQipjcNShNo
         ov9ePoy2fR04fs96XrfxogECyZayhou8cQO57+eh1BYwr9ga9InXrN+w+u4iqpt424GH
         yiyXKm6STHoUc3kPzLyd7ihHNWHoPTwnSiNIpuUdkXp/7FI9CgDh/t8DYEL73u8ueHtz
         Q4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EKosXk8IY43vkJkxGl0iU1fOZw9WRZsC81tWa05upeg=;
        b=h0aEoY8bOK6ofSK8A5cSvJ0cfY74wiyrSFzemur9jS+Eal36diENnRemgXtebibsV6
         ZTFUrg7W964ows+6qBMWLq2uYIOUm82ps5JTB97boLQGm9aF8DEq8hIn6Wtsmg1bsFPq
         FcBAZhg1sw8CGx1iucLl6FaduVDguOZET6U+U9WU1/yyK1rI/2LwZ0GMRzRPZvCohYoq
         siIIeTPfpBs2wtvVyuPqScobWreTttIWZyzOINyYv4GP9m3r0OgRubX/4C8BtaaaMR6/
         E8VMqwC+OXHCyjjQcz7xQnTMyF/tGocuK9GsaaplAXg2R+I7M8hWlx6gLNnhG+m7XoSL
         s16A==
X-Gm-Message-State: APjAAAXWYRBQAqgrgSPMyIZ8OMT4XwpfgrMUwUhZ0beFj6YG47a4EIlM
        vgI2LMLR+72PvGMywIL9EyyJDdviAR6mtdzOfLoimA==
X-Google-Smtp-Source: APXvYqw6X8gdl105itYF/V8a/qLzsRkIjQQHmV2nI5iYCe0YIrCDB0H0QYqsdTcxVfw9UK9O/VT2gRFvhfIRERu61Vo=
X-Received: by 2002:ac2:518d:: with SMTP id u13mr243562lfi.40.1562273691602;
 Thu, 04 Jul 2019 13:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190703.134700.1755482990570068688.davem@davemloft.net>
 <20190703.134935.540885263693556753.davem@davemloft.net> <CALzJLG97wQ8EE+XwuCO-wuS0YcYQmSfzu12TFJupp3AAg76U=w@mail.gmail.com>
 <20190704.135005.2091981554195496315.davem@davemloft.net>
In-Reply-To: <20190704.135005.2091981554195496315.davem@davemloft.net>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Thu, 4 Jul 2019 16:54:40 -0400
Message-ID: <CALzJLG9fgh4GUKBocT4vCLK-Wp5u=53q5DXDeTHbwAGcdv5eQQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Mellanox, mlx5 devlink versions query
To:     David Miller <davem@davemloft.net>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 4, 2019 at 4:50 PM David Miller <davem@davemloft.net> wrote:
>
> From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
> Date: Wed, 3 Jul 2019 16:07:11 -0700
>
> > Or just  wait for my next pull request.
>
> Please resubmit this series once I pull your pull request in.
>

Done just submitted:
"[pull request][net-next V2 0/2] Mellanox, mlx5 updates 2019-07-04"
it includes both of the dependencies and the 2 mlx5 devlink fw version patches.

> Thanks.
