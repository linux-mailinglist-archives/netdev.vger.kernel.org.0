Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D668D891
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfHNQ6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:58:17 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35927 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNQ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:58:16 -0400
Received: by mail-lj1-f195.google.com with SMTP id u15so10481481ljl.3;
        Wed, 14 Aug 2019 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QIKWMah9z81d5Ciq8DbElfNQyPLbhJzJJRSu5nRoozI=;
        b=qStH5YE7Cb+rTVUvFPpHNi+lOc+hJxIruleCF1hvx0BGhOfaUE6sJ6V9zvYnCNnd3I
         IiZl0cHaDPKyeXKjuCCCEIgqARmEVCBMETBkyXv1grsjUX81m8Iz97TXQIv1fKhc6rWv
         usYay6VIPTMLu6ZLoIgyZzYa46wkHTI1fTeGss7+VTZYOOtIQjE3mV9lF2LEa/5YYlO7
         4mLJhvLeD2JT3BJDByCFcjT46Ubz3XZm82ljI6szBjI5hms96Jk4jOLiV1ZYR/35rpwL
         XzbTd/wA9ymID2vYFaxGKvBGQQfQA0X8f5d1iWmspnfAegDQB4Z55HPSSFDELTxtrL4A
         q2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QIKWMah9z81d5Ciq8DbElfNQyPLbhJzJJRSu5nRoozI=;
        b=LDdI4RUAJNw61gbW7Nh86CUo7WEsOUYARWoica6k8+bFagS8JOD0FlgK3IQ5VnJC2P
         bUUxZ2uzH8A+UcEELWjxRLt7ai6hWjT6ioJTm7NZSm8BVEFZVYeE3hDy4TUDd/WnuO33
         WUj626LKblfXBjtIj6mN5OMz04TH/atkZYuhVo4V5zmjnRJtugqnH+zp2xH2K1HbBOXk
         UWH52tjidOI4Hq+vGj0D0vl9Nx9n8W6UwSzdGWaGxqQpOHp60NE9oGaVaQ7CvZURyyvP
         JHfIzPJXNFJS/JikUWon6fuYHlY8ySUcHUt4aosjOqECIJ9Yc1oA4w9JLvH+jotdtV+2
         8+IA==
X-Gm-Message-State: APjAAAUZAfkb8qYngD5+2y9r8//1ErB8E6IEwfQ4hLTcXqDnpq4CymdX
        FxA9DISNZWeD8BmRvNYDqhXH4AdL5OtUX7InuHA=
X-Google-Smtp-Source: APXvYqxvJ75ppnFsFwcpxF01U3wFdNovxKssHYKOz2hyAOqpjrv/fsRpsiLATURwuurW7ppJXFxw5zQQTiMX2pHHuwg=
X-Received: by 2002:a2e:93cc:: with SMTP id p12mr400054ljh.11.1565801894591;
 Wed, 14 Aug 2019 09:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
 <20190814015149.b4pmubo3s4ou5yek@ast-mbp> <ab11a9f2-0fbd-d35f-fee1-784554a2705a@netronome.com>
 <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com>
In-Reply-To: <bdb4b47b-25fa-eb96-aa8d-dd4f4b012277@solarflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 14 Aug 2019 09:58:02 -0700
Message-ID: <CAADnVQJE2DCU0J2_d4Z-1cmXZsb_q2FODcbC1S24C0f=_b2ffg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map entries
To:     Edward Cree <ecree@solarflare.com>
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 9:45 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 14/08/2019 10:42, Quentin Monnet wrote:
> > 2019-08-13 18:51 UTC-0700 ~ Alexei Starovoitov
> > <alexei.starovoitov@gmail.com>
> >> The same can be achieved by 'bpftool map dump|grep key|wc -l', no?
> > To some extent (with subtleties for some other map types); and we use a
> > similar command line as a workaround for now. But because of the rate of
> > inserts/deletes in the map, the process often reports a number higher
> > than the max number of entries (we observed up to ~750k when max_entries
> > is 500k), even is the map is only half-full on average during the count.
> > On the worst case (though not frequent), an entry is deleted just before
> > we get the next key from it, and iteration starts all over again. This
> > is not reliable to determine how much space is left in the map.
> >
> > I cannot see a solution that would provide a more accurate count from
> > user space, when the map is under pressure?
> This might be a really dumb suggestion, but: you're wanting to collect a
>  summary statistic over an in-kernel data structure in a single syscall,
>  because making a series of syscalls to examine every entry is slow and
>  racy.  Isn't that exactly a job for an in-kernel virtual machine, and
>  could you not supply an eBPF program which the kernel runs on each entry
>  in the map, thus supporting people who want to calculate something else
>  (mean, min and max, whatever) instead of count?

Pretty much my suggestion as well :)

It seems the better fix for your nat threshold is to keep count of
elements in the map in a separate global variable that
bpf program manually increments and decrements.
bpftool will dump it just as regular map of single element.
(I believe it doesn't recognize global variables properly yet)
and BTF will be there to pick exactly that 'count' variable.
