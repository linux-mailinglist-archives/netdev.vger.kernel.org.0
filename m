Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516961C4894
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgEDUwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgEDUwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:52:30 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46069C061A0E;
        Mon,  4 May 2020 13:52:30 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id j3so11129851ljg.8;
        Mon, 04 May 2020 13:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=FcJwBBQxQbyWZcPJFBqnN/UJHchybkhPoVMzas6ZLTM=;
        b=cyEBapTbOmBY/knMZm6OxVUK3zO5ygsk7cNkIWjMePjlA1HdUUd4gFLsjYnDs3ElFW
         +szCbOCQjMWBY8REqdOgmLFBM153c+jvDtURPb6PZmEHuvkYX1NwNHwnESfgSvY8wifr
         BmBcHhnJTTsKEBzRaiE2oXy7HgHlgsjvjeD0V78+GHwuxnu0WQcN2hlezy1MzVBWJidI
         TNgkU4mtVXDt4YjTBNh4bKqugUTv7ZZGphcRVHishpbYBFZ+fZzjUa+jer09K+zoM4T2
         vuNYDsJDDcQEz/hdkRQQRlQUJcYlY/J+f3ziVSMN7jtJSInWr8zfTf7Ar8eUNmZCYw4F
         tjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=FcJwBBQxQbyWZcPJFBqnN/UJHchybkhPoVMzas6ZLTM=;
        b=KzQjrktlta3K+iiLcky+i/IFkcbFGpSFW5A6Xl/8py0Vgwl4ooBc7au80NpgY8oa2w
         y6K4vq74fTVC3cSIwsGWR/AN+MHss0m+OQ74eZPda/jgsYkPjM1TnZ4KVZ+VhzmWLs7+
         uEHvPxQGMpHLCu8slSBUzzrcp14psHoWHg2nek5qx90/w8+2WcwgnTmBVtbqeCteafsn
         v2eaLHC7So6EAGOTzuTBHMB9vtHJq8Q1esNb80hke5Q3atHVh/XNXrHHkziN84ZTXo40
         FKosExiXyFYZMguMrGbJJCLB0gjD+fbj3jl3OIN4GLM2i6obNRhg7FjLGtRgnTIw6ZKP
         J6YA==
X-Gm-Message-State: AGi0PuYeZdDLl2NIpBNbFPEF1ZS+u2c/z6DVLflVOF0hLQfuAU7ose0g
        O46fcku4xMUun26GuZcOdH+rWR06ehMUv5rRhRI=
X-Google-Smtp-Source: APiQypK9VmvK6DN61Q45Dy8d9NaojuA1xvHIqJvnU+maaVKIstQUyvPb8m6eoCgyHe8GW1+O7VMuvp2t7PzAnMUoopA=
X-Received: by 2002:a2e:a169:: with SMTP id u9mr11690330ljl.144.1588625548623;
 Mon, 04 May 2020 13:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJfD1dLVsfg4=c4f6ftRNF_4z0wELjFq8z=7voi-Ak=7w@mail.gmail.com>
In-Reply-To: <CAADnVQJfD1dLVsfg4=c4f6ftRNF_4z0wELjFq8z=7voi-Ak=7w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 4 May 2020 13:52:17 -0700
Message-ID: <CAADnVQ+GOn4ZRGMZ+RScdSvM8gpXD9xbe3EYHCcUHdSs=i_NGA@mail.gmail.com>
Subject: Re: pulling cap_perfmon
To:     Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:03 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> Hi Ingo,
>
> I'd like to pull
> commit 980737282232 ("capabilities: Introduce CAP_PERFMON to kernel
> and user space")
> into bpf-next to base my CAP_BPF work on top of it.
> could you please prepare a stable tag for me to pull ?
> Last release cycle Thomas did a tag for bpf+rt prerequisite patches and
> it all worked well during the merge window.
> I think that one commit will suffice.
>
> Thanks!

Looks like Ingo is offline.
Thomas,
could you please create a branch for me to pull?

Thanks!
