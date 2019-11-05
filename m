Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6DA7F0888
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbfKEVkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:40:53 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:40679 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfKEVkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:40:52 -0500
Received: by mail-qv1-f68.google.com with SMTP id r8so563453qvq.7
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=CCarobzHGNOHil93nYhiEEAg9JPbRd7bl+1A/9GYbn0=;
        b=PQKksr0iPUUIAc5HyhiRG+bSEgzXFG2WhyhLtHh+j3X0YlbUKt8vrcvtbVbt0KnEE4
         /vvQAIlg3Kw3JLysNixnt3Bm+kHZVLp/XBDKhmFie9GV3QvKqP4EErES4s+iBIlO6c88
         FzgDaiPGbOdXBZnhVngbjJg3/xaS4jqhnfKciQ5flPJK6hOpMqH8kcqHxilqHgb+YIqG
         e1a4+TIxjwSuquc8wrI6TE1sc8Qovas0oJ8cZIvFupbV8rRByGwZ+qYU0fZDG7zsQwPy
         M/mU/SkBn2tCMESXGFCjiZFyUazUZEMbV7ZO8sYEXaiP6wemKD3HWQ9HMC7PMSOOKE80
         Ujvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=CCarobzHGNOHil93nYhiEEAg9JPbRd7bl+1A/9GYbn0=;
        b=QPAkUV4uhd+RSDEq1h+CTMbhHGYhOhGDQsrINqqQ/Z4WJ89LYUbnj02kB3q/Zzudi4
         PBUo5J5A0ZBxeb/wpRJQkrBekm1VjCupVA2MQWipnlGscLA8Kajqy/4TtDQFHuYyzvhv
         VtF6OaxrqQVGEOKR3DFSB0JmEHi9qBCsrRLyI/P7ivUtJLWwyvj7aguXCh5J03pUss0g
         1LRvFWE4ldpRdGfLxOdbkcEIMxmrpQqWePhbcKBfPLktMBgtCBPRSY0tMRTzA88rX4d3
         PxZe+/UfbyftSgIaZwPtRLeCeYfWx8g+AJEDeY/DTkQUde/vXa+E/z4koEZVNAAF3UX0
         7Amw==
X-Gm-Message-State: APjAAAXeBPT2CSdL2ChJ5gNJDCM5j3iseU+c5wrWBp2KeiRbS7HquiZi
        kYOB7SmUIu27THxX3Rf6q5xhdP46QdpXk8uEwlyTGg==
X-Google-Smtp-Source: APXvYqxUx+Yr1UIVKLnGgO9lerXB1mlNZ4BqPvb/fzKU+AILBaAfCi0V5itmocjGJR60YLzmqQfERzQpNCnVDQjecAw=
X-Received: by 2002:a0c:814d:: with SMTP id 71mr28693160qvc.226.1572990051816;
 Tue, 05 Nov 2019 13:40:51 -0800 (PST)
MIME-Version: 1.0
References: <20191105191814.2788F95C0C16@us180.sjc.aristanetworks.com>
In-Reply-To: <20191105191814.2788F95C0C16@us180.sjc.aristanetworks.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 5 Nov 2019 13:40:40 -0800
Message-ID: <CA+HUmGh0=CL1xbFQ0PcMHN2ytWvNa5S1=knEG+GMbQpEQrCG6Q@mail.gmail.com>
Subject: Re: [PATCH net-next] selftest: net: add some traceroute tests
To:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org,
        Francesco Ruggeri <fruggeri@arista.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 11:18 AM Francesco Ruggeri <fruggeri@arista.com> wrote:
>
> Added the following traceroute tests.

I found some problems with this test, please ignore.
I will send a v2.

Francesco
