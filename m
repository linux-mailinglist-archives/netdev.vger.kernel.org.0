Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34744848A0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 20:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiADTdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 14:33:52 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:40694 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiADTdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 14:33:51 -0500
Received: by mail-lf1-f42.google.com with SMTP id r4so40761978lfe.7;
        Tue, 04 Jan 2022 11:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SzeOzJpBlYRxW3ZGC/HtbwqKN8nz84Drg6aC2SWkkns=;
        b=BH/YO6cIZbVR6YQt7bXvltsKkdXm9LAvNPTqLH3K/h9TGGlS8MVstCuvhUCXkObP0Y
         1TSS/1z3Hoic9aFYQFX+lOA4kQ55HOUczrXfrCuJ6V7tRA5YJ1/7IMU8N3tNYxWvBwRf
         O/f/qvW4Ycw+qJyD9E1NR/rPet/iwqn19/I2MT9wFTnx4dv4HqctM5i2fs2/0tnXy8PM
         DhgdrrD27TzxPy0Udtg9SAGFspv3fX3zlNQ/Uc9AABY0Oqm3Qlu4GOHR7EaL/D1W/3eR
         BhX4MtzI5x5Xy7pvGaFxbBxwo0r0MSTyz5H50ZEuC15O54XbUu8AdRQoRYIxjkPiRMHW
         AOLQ==
X-Gm-Message-State: AOAM531Q8A4fvZV93wXCqhkTDuEuufeD43nz4KsDhwADdzmTFeSoAOCj
        M7xLXz2/ylfyqueZKyfE7z2rRFqtKgRrAFkEU68=
X-Google-Smtp-Source: ABdhPJyRXOgqzyFL8LKi/7LVSPHWRmchBwEzWHoOnlSfR+ituWO4A8l1oh51jg9bVz5Occ8ou3L1M7YmXsU9E6ZnBCI=
X-Received: by 2002:a05:6512:3a89:: with SMTP id q9mr43703809lfu.99.1641324830055;
 Tue, 04 Jan 2022 11:33:50 -0800 (PST)
MIME-Version: 1.0
References: <4C0186FE-729D-4F77-947D-11933BA38818@gmail.com>
 <CAM9d7ciroZswudPXAAs9Zo3_veFMugJJZ4XZWhGSKHdFPcDOjQ@mail.gmail.com> <64E36F38-E037-4561-8E0C-B288674A5BD9@gmail.com>
In-Reply-To: <64E36F38-E037-4561-8E0C-B288674A5BD9@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Tue, 4 Jan 2022 11:33:38 -0800
Message-ID: <CAM9d7cgzpyp03y3w009upnftK=24r8NtQFZB0t23pnc1PwyJug@mail.gmail.com>
Subject: Re: Lock problems in linux/tools/perf/util/dso.c
To:     Ryan Cai <ycaibb@gmail.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 6:42 PM Ryan Cai <ycaibb@gmail.com> wrote:
>
> Hi, Namhyung,
>
> 1. Indeed, I got wrong here.
> 2. Yes, the branch should be if (pthread_mutex_lock(&dso__data_open_lock))
> instead of if (pthread_mutex_lock(&dso__data_open_lock) < 0).
>
> Could I send a patch?

Sure!

Thanks,
Namhyung
