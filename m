Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C495FCACEA
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732061AbfJCRb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:31:27 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:34764 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731946AbfJCRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:31:25 -0400
Received: by mail-io1-f50.google.com with SMTP id q1so7511575ion.1;
        Thu, 03 Oct 2019 10:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=f4r+K3y3nqXc3SI3VEfZUkUo3eN/bYW8k+rWr3yspv0=;
        b=sUP5WhImszFptgTBOakqcyoSspnLZ+BmVTcd+z9TsQKoYE5gXVc7iGc8EQjENSeJKG
         n8cvNBwRSfNx1QtOCay2kOMmI1yHCOVmlrKySn9EScvEBLToeto4fbTB8CQEXho+2kK6
         rV5xE7FpKIPyvdb5CXcYEiACCKQDYWqliZWoFh6MEhLogLmtiLlhs7P6Jgeu7hCJHXCn
         jUPB1NfxBBUrGz/TDNx6mBW/n2UnwbkPD0X1X/G+RkLuDlzG+5QUSFU6fY/KmarrUL0z
         Atxn65aBvRgajzh6wKZdEgQzeA+RXuf5IXJ+lxZo68kZ/TEtloklFN5PY0IQe7xtasls
         gnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=f4r+K3y3nqXc3SI3VEfZUkUo3eN/bYW8k+rWr3yspv0=;
        b=ogdp0uGZob0fR52S+U4ZsXFQeyQTcgnzO4CSMxgT/qT0LmcfS8GzlCkfugBip9yrl8
         DYzu3zpaSN5BKXYSL50LChEMrJdHNAZhgktS2tlAKHOA9abaljicpXc0veNlqyuwMhXy
         CemlmvQISLZO3NHHf5Otd9j6k5Zwe0o5pAUpU0MISMkm/LpnIwSPdbh0s8mU+AiS8LEp
         Rr3QclL9hJ9EheZC/4WaDLdYmW7OXSLx8NNEigivdGw83vFd5adJ6c2ppPz319mZWw4/
         ibK6z9DMVAcLcfRIIm+3tuVh9saOFf9YbKmDP4E/JSuMRiurjWt3oOaB2uz//1y2TGn0
         q1ew==
X-Gm-Message-State: APjAAAVPd7T+or4hkmcZQ1NzpV0INXYVYxdB4l9dt+YmU2g1+STTN+on
        D2r5plTWKafX/SBtQozUqCs=
X-Google-Smtp-Source: APXvYqzxLOEDOuTX7xAB3sjzdrGcJYADMiD5e8cq8GcNIr3TQmKuPLr/hpAhCTYl9lUr9+qZl7TGyA==
X-Received: by 2002:a02:c65a:: with SMTP id k26mr10360713jan.56.1570123884448;
        Thu, 03 Oct 2019 10:31:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s78sm2459089ila.40.2019.10.03.10.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 10:31:23 -0700 (PDT)
Date:   Thu, 03 Oct 2019 10:31:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5d96306468d97_55732aec43fe05c4f6@john-XPS-13-9370.notmuch>
In-Reply-To: <20191002215041.1083058-3-andriin@fb.com>
References: <20191002215041.1083058-1-andriin@fb.com>
 <20191002215041.1083058-3-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 2/7] selftests/bpf: samples/bpf: split off
 legacy stuff from bpf_helpers.h
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Split off few legacy things from bpf_helpers.h into separate
> bpf_legacy.h file:
> - load_{byte|half|word};
> - remove extra inner_idx and numa_node fields from bpf_map_def and
>   introduce bpf_map_def_legacy for use in samples;
> - move BPF_ANNOTATE_KV_PAIR into bpf_legacy.h.
> 
> Adjust samples and selftests accordingly by either including
> bpf_legacy.h and using bpf_map_def_legacy, or switching to BTF-defined
> maps altogether.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Eventually we convert tests to use bpf_create_map_in_map() and friends
so we can drop legacy. Assuming this is what you have in mind but agree
thats a next step.

Acked-by: John Fastabend <john.fastabend@gmail.com>
