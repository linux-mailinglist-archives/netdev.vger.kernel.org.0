Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6C112B08B
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfL0CTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:19:31 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45809 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfL0CTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:19:30 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so13722573pgk.12
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W8rTewTSVNS3nAQhAOfmNAYAiwT/LYVLBwXFTIvI3Jk=;
        b=Y+WudrucTHq3znHl/yadan3lcrueoJIQNNCqtcKK9lGM9AXDGbeal7YrfPB5JrChiL
         FbiuUTjp14dPtJo+F1GRmazQo5/ONphtsr2r9ggWwLsuYS2Mf/GJmvA311ziMYgP79Jr
         NvNHSZ3Gv/vpK2VQYW/mttILaebVw0ARiCA3YKut1Sctf7CZ6KeyWw/BEdl9FLnb6JvG
         R5Ei0iX0XLZGd5aaAwDB6ZNrHv5Pl6vIPREP2UVcT+SIrBKyFBOp8TShQhvl/cd3UlQW
         NBoyqHW3KUqbUAOOLNp2ZyuBg3zJSENTUu4tpHUIqbMtgQXMO3Ua0HoVz9M4LALl6dZr
         5gsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W8rTewTSVNS3nAQhAOfmNAYAiwT/LYVLBwXFTIvI3Jk=;
        b=NQKxuSSZ32mFos7r64rC1ZnJQWUaO++FkSHM0OxMAX0Mi6OCKr0e1WzC0N/WoWIBLp
         rZWjHIqW5AkMLv02YLbgY4ZxundgZETygv6MLX0/f36eKsNp/Q/SBTUWnpOKSpggUdUC
         jQOqG8YoJUul+VjufiByxxFeKu5j0BBAQRIo9MAc262835GD4h8dym/IONgjjcct+k5d
         KI19+z9t0dYLExQmjeCCdItxOfb/BzC3YnXxl6IZ+T8nNt//0TDgHl7kogw22BRuau9y
         rCxGxTDAZIOYmNFOujmtKz8WpnVWiA1TFPcJbB0Sm4vw5ZKDxQ7WxZ8VPl7G3OaCkrm9
         Twmw==
X-Gm-Message-State: APjAAAXEKROt5fqiiYeflGuDRqQ7aHIFVcRwmGk49w7PM3f+egrhuQoy
        MojfWqs3Nt+0lOKfU5x6c7SsZfPXYqXjUQ==
X-Google-Smtp-Source: APXvYqxC9j+0PIXIFLUzZIQYBFyiy3ZZGZX9dKg1rDTPcNGwAa2u9ZNMVTd23sBiUr2IgAgQD5uaOg==
X-Received: by 2002:a63:1b49:: with SMTP id b9mr51582475pgm.258.1577413170192;
        Thu, 26 Dec 2019 18:19:30 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z64sm38028207pfz.23.2019.12.26.18.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:19:29 -0800 (PST)
Date:   Thu, 26 Dec 2019 18:19:21 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Leslie Monis <lesliemonis@gmail.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 00/10] tc: add support for JSON output in
 some qdiscs
Message-ID: <20191226181921.3e381b69@hermes.lan>
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Dec 2019 00:34:08 +0530
Leslie Monis <lesliemonis@gmail.com> wrote:

> Several qdiscs do not yet support the JSON output format. This patch series
> adds the missing compatibility to 9 classless qdiscs. Some of the patches
> also improve the oneline output of the qdiscs. The last patch in the series
> fixes a missing statistic in the JSON output of fq_codel.
> 
> Leslie Monis (10):
>   tc: cbs: add support for JSON output
>   tc: choke: add support for JSON output
>   tc: codel: add support for JSON output
>   tc: fq: add support for JSON output
>   tc: hhf: add support for JSON output
>   tc: pie: add support for JSON output
>   tc: sfb: add support for JSON output
>   tc: sfq: add support for JSON output
>   tc: tbf: add support for JSON output
>   tc: fq_codel: fix missing statistic in JSON output
> 
>  man/man8/tc-fq.8  |  14 +++---
>  man/man8/tc-pie.8 |  16 +++----
>  tc/q_cbs.c        |  10 ++---
>  tc/q_choke.c      |  26 +++++++----
>  tc/q_codel.c      |  45 +++++++++++++------
>  tc/q_fq.c         | 108 ++++++++++++++++++++++++++++++++--------------
>  tc/q_fq_codel.c   |   4 +-
>  tc/q_hhf.c        |  33 +++++++++-----
>  tc/q_pie.c        |  47 ++++++++++++--------
>  tc/q_sfb.c        |  67 ++++++++++++++++++----------
>  tc/q_sfq.c        |  66 +++++++++++++++++-----------
>  tc/q_tbf.c        |  68 ++++++++++++++++++++---------
>  12 files changed, 335 insertions(+), 169 deletions(-)
> 

After I test these, looks like they could go into iproute2 directly
and skip next. There is no kernel version dependency
