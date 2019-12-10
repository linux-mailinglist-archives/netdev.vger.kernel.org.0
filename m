Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F55119227
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfLJUep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:34:45 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:45648 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfLJUeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 15:34:44 -0500
Received: by mail-qv1-f67.google.com with SMTP id c2so4745727qvp.12
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 12:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=k9StEROeVFHgDma5h9VD+gMFs/72EafIdPmXm2r7ghk=;
        b=PsL8HeIF/pbv1HxDF4LzH/nSUtms0dwXA+dzZvwl/Wc9lv1sPtkRc4eDbX5ufVHO0A
         ez8TgCSMBNY/INVzWaE3Yu0NUdG0QQTUTJlq4M3pLXpdMXOmW4f5ljjU3DIYfUEmUIvN
         gjWJ5zGNX8qjWLGzHIg2dOLeZimFsS08SsAwv+xAPk8fVNpIuQIxFcwqN8OA26R8xFpU
         58ksFGwwl/iuODPS2x4Mn1AremLP+NxYbsai1vErzb/pR50tsMhwRbgNmWvU7G5Kl3Lo
         6jO8H81GG1vQJ/wW8Zg0ghFF6UryCCgLrdZJxpQJ2vCEJsp2Yu4XnLWgm5Ux6G3zAioi
         yGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=k9StEROeVFHgDma5h9VD+gMFs/72EafIdPmXm2r7ghk=;
        b=EdQvwrME9HqFDfkxvyCaVMDMkbythlkzjXCjfqSdrGkh0IryVTX02MFc5COE92ZvJK
         0cTsbc5vcXnGqc21OiTmx8WMNyxhwvHl5v/v4DmiH8UqhPLpmhwX0FFQSYe2G6OLUNC7
         SnL1MdULagvN2lh2Srby2mrrPZNCiBVtGHn6LP1TBGV92QjJdK1FcAo1fm8SSxZ7tOqV
         cmYah4TFQ+lzP/B34bpInv7ECi7YYwFRyoCKYBADtzhircwsgOwCoduedMhAVc0wh1PQ
         YwlqJkB6CeaUCn0B/LnlP+/GZnm18IFG145xmdnesKF1Xz9D6efyjsTjxN4CtnZHcpU/
         CkLg==
X-Gm-Message-State: APjAAAWggdjUSKWpC4zKWkA6IPe+ZvC+EgTAmqc1k4fB6DVUnmPUhyhA
        NsFCSwx1KQHhmqhmNsqhBBVXZoNG8xo=
X-Google-Smtp-Source: APXvYqxNYIhCvP5N4qvAggJtN7eDK4YJ9LB4h4K69m1xMvYCG3XLQgmX4jWnRUTxarsBg9JJD8I+7g==
X-Received: by 2002:ad4:55e8:: with SMTP id bu8mr30969794qvb.61.1576010083657;
        Tue, 10 Dec 2019 12:34:43 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p19sm4954qte.81.2019.12.10.12.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 12:34:43 -0800 (PST)
Date:   Tue, 10 Dec 2019 15:34:41 -0500
Message-ID: <20191210153441.GB1429230@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] net: bridge: add STP xstats
In-Reply-To: <1aa8b6e4-6a73-60b0-c5fb-c0dfa05e27e6@cumulusnetworks.com>
References: <20191209230522.1255467-1-vivien.didelot@gmail.com>
 <a3b8e24d-5152-7243-545f-8a3e5fbaa53a@cumulusnetworks.com>
 <20191210143931.GF1344570@t480s.localdomain>
 <2f4e351c-158a-4f00-629f-237a63742f66@cumulusnetworks.com>
 <20191210151047.GB1423505@t480s.localdomain>
 <1aa8b6e4-6a73-60b0-c5fb-c0dfa05e27e6@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 22:15:26 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> >>>> Why do you need percpu ? All of these seem to be incremented with the
> >>>> bridge lock held. A few more comments below.
> >>>
> >>> All other xstats are incremented percpu, I simply followed the pattern.
> >>>
> >>
> >> We have already a lock, we can use it and avoid the whole per-cpu memory handling.
> >> It seems to be acquired in all cases where these counters need to be changed.
> > 
> > Since the other xstats counters are currently implemented this way, I prefer
> > to keep the code as is, until we eventually change them all if percpu is in
> > fact not needed anymore.
> > 
> > The new series is ready and I can submit it now if there's no objection.
> 
> There is a reason other counters use per-cpu - they're incremented without any locking from fast-path.
> The bridge STP code already has a lock which is acquired in all of these paths and we don't need
> this overhead and the per-cpu memory allocations. Unless you can find a STP codepath which actually
> needs per-cpu, I'd prefer you drop it.

Ho ok I understand what you mean now. I'll drop the percpu attribute.


Thanks,

	Vivien
