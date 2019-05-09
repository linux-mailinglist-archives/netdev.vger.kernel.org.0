Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A50193C8
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfEIUt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:49:59 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43109 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfEIUt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 16:49:59 -0400
Received: by mail-lf1-f66.google.com with SMTP id u27so2541071lfg.10
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 13:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C27C4xYhG+l93DRQoIn8SohC1TaihRH0ZNkq4Jfpwzk=;
        b=SVN2Vo5IoWVjMFEqrQJ6AKD0zWB94IOqX1z9jZS+0YYm1IpFuW4o/kWKhIK+YXfL6x
         Qs1weOu7IX18cc0gjw0sazdGiVjNZdXdE9CitNsrq2zQu5WWP5kSeJQ7K6t2B4IIwJYC
         0J7MM+18sdE8D5N4IyktIZJzg6phXq9pelPf2rKD2kbO2Vv1asppFQYaRZzxLwUEpXK3
         55Zjh6I2iTCbfUEs5HAvsmRSfuIsYjM+BrEyfRBUArPR2j2l9SqPc1GLxTmxYa04F3+I
         wzsrdwb6GW6Yog05UbXI5Ar6xv+aLCkc8BZc93/7o4HCF5lToU2hnhvobXKGqkBT3MeD
         6P5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C27C4xYhG+l93DRQoIn8SohC1TaihRH0ZNkq4Jfpwzk=;
        b=VmoHdEE7wStNBjP7yPbvhMMnELtNkN/JsymF6/czNv6WkutEwidIzWDiYDwZUMN3RA
         6oCO7Al3V5zqKA/HFD6LSb5WaIhTHcYntEQ502/FEwt7A7vxUOgoqkNyHJAYlNGP/Er3
         zkyshyl/DfRmC5Qb/RvRDi5StHHWV366hFG5lANU/rURqNK8SoDVoyOxplaZ8cDJ6DVu
         TOZEwFhR5LYe8ptl13lwHC7X85/ezrAp5GSFNmQkhGZwiFjzZSDEIqsrhOBBMNixc5cJ
         VD2aswsZGl/rBKx3eE58wan83e/TpdOmZ0aGDqUdP0unTL6UMRT2SR5mZFrWRN41rdP9
         5Tzw==
X-Gm-Message-State: APjAAAWjVVJg1q5/fX+4J8LFIieEKlqAmZtNUxUIRY6QYdvLoL1IlaNE
        6Cq+Z79jKl6bVYE4kJdD0bqCvR9ZwFVHIimnLeU=
X-Google-Smtp-Source: APXvYqy6cqebPKHzO/T06InmGS/CpftIK5v/++EzZRiaKBCPF6eix4d4ufZjDbcnJgllSKLvQYSbS0RxD8GjfB7gL6o=
X-Received: by 2002:ac2:4109:: with SMTP id b9mr3517487lfi.90.1557434997494;
 Thu, 09 May 2019 13:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190506130310.12803-1-danieltimlee@gmail.com>
In-Reply-To: <20190506130310.12803-1-danieltimlee@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 May 2019 13:49:45 -0700
Message-ID: <CAADnVQLK-oRMDjExZrL1jiyTs8FC=sg1eH786fUXf3Vwm4_PmA@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix style in bpf_load
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 6, 2019 at 6:03 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> This commit fixes style problem in samples/bpf/bpf_load.c
>
> Styles that have been changed are:
>  - Magic string use of 'DEBUGFS'
>  - Useless zero initialization of a global variable
>  - Minor style fix with whitespace
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

bpf-next is closed. Pls resubmit in about 2 weeks
or watch for 'bpf-next is open' email.
