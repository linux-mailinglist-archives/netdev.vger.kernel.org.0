Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4275680F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfFZLzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:55:49 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45945 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFZLzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 07:55:49 -0400
Received: by mail-ed1-f65.google.com with SMTP id a14so2904155edv.12
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 04:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KBstZpEDr20TYwxNoTUwMw1PD5mJHJmqC2HMG0bL+Ns=;
        b=hqQ0eEq079fYxPB4pUanJ1WXP/amGPEB2+NJ2PM+qrY6xFiGRwwfa5MR1pI+9oOSyM
         LaH54nJOLsgyyUUfuo7mxVPeqdvCWCxTMlCueqLthCCu02Gu+fuoB87faWv0eOw5OWNF
         woHbGXST5PvYVSI/Y8rfnitscbqw4SZEfLNBj3+Yiem9GxTqBesRq2I8M33VoAAXpZt7
         CKG1kTxVNZZOB09c/kvuE6f3kq/UI/uwsUCAjimdyxtk4BzgtdZqd5PKb3PzDniE5Py2
         p3KE+5KYIoHbrngEbVLpazUgndub2Lqzh19I7/1u/HJUJyc8ZU7apfPthPzlmh7Ry+eG
         e+/g==
X-Gm-Message-State: APjAAAXL7DSqg6NIT2vYiMH8ZoIz01mmZnA+HQDSxG16xEMgc4H34Ky5
        pNMbk0fwIj3razVziWQXBY2WaQ==
X-Google-Smtp-Source: APXvYqyT7bE+19mE/Ss2ClXDovvQUfytAVdVb4EMmlx1wm62WSLc8tLmim/6sT5Fd1VtYisJjlspPQ==
X-Received: by 2002:a50:b3b8:: with SMTP id s53mr4727394edd.61.1561550147950;
        Wed, 26 Jun 2019 04:55:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f36sm5527405ede.47.2019.06.26.04.55.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 04:55:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D1949181CA7; Wed, 26 Jun 2019 13:55:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        ast@fb.com, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Cc:     Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 0/3] libbpf: add perf buffer abstraction and API
In-Reply-To: <20190626061235.602633-1-andriin@fb.com>
References: <20190626061235.602633-1-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Jun 2019 13:55:46 +0200
Message-ID: <877e98d0hp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> This patchset adds a high-level API for setting up and polling perf buffers
> associated with BPF_MAP_TYPE_PERF_EVENT_ARRAY map. Details of APIs are
> described in corresponding commit.
>
> Patch #1 adds a set of APIs to set up and work with perf buffer.
> Patch #2 enhances libbpf to supprot auto-setting PERF_EVENT_ARRAY map size.
> Patch #3 adds test.

Having this in libbpf is great! Do you have a usage example of how a
program is supposed to read events from the buffer? This is something we
would probably want to add to the XDP tutorial

-Toke
