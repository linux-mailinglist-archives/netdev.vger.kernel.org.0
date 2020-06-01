Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6B41EB026
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 22:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgFAUXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 16:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgFAUXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 16:23:44 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED396C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 13:23:43 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id h188so4718253lfd.7
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 13:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qz5FAoTQx8T8gE8j7kKiXewzMi3OlovWcaQwsJrdmx4=;
        b=PqDzapFPdFvnfrunKEo1CHlRHj6Hm9cHDuWV47VjxHbSnbNt8neYunGh/JqZ/FfjWA
         Z47QGmkY+exLsQGCE+vKix6ikiWMeq3ydvD/q2tHME2mgJv+k8mbCGku6cYWZJ50JUlO
         l0vqzWxL2XIwv4rz16Lt9JsgO85NOJ8vE8T7UoFK0u+4p6X1dTR5eF6aM38xjZVhT7Nj
         nKUFy8m1+Aw/Gz47v1pq4zwGsnI/tSWhFyi8Lq3AnfPMEzqgopVmaFyOG8VIzZSd2bj6
         KXOcD1nDRDUADF7t/EpWTWkH3E8HuhB+Mw+0O8QlyAH7ksRRxqLXjprfvOToOf1BjBLP
         7mWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qz5FAoTQx8T8gE8j7kKiXewzMi3OlovWcaQwsJrdmx4=;
        b=f9RKUHOVfyjdmG2s+bzZUrM759y+1OY/Q/pWXceB8BH22+37ssk/MI9M/KiafMED4E
         QB7Qg/CEns+truuQEYNRfz8BgR/YjrA9zxbMNU0GRwCON29iObPr8Oy6LAqbrQE1vLas
         ZC6IGiUrjKvH7/wfkYbAmOr2mQQ6dVKzhMh80nYFHom0apwv03WcqDg0ye6xCmYnAE3V
         dd2o1ZTxdyP6CLqjLezHPcSxi1W5k/K/e3741D2WEGvCoyd9tKKprMcPotmqF4TdpMIT
         Dzfg74aSTU5NzDTgxQri3BnJI+TM9DHcisgpRPrrQb/tYLHsj5Vns5JdPpBIKEgnA5A1
         U1fQ==
X-Gm-Message-State: AOAM53191LL/1CXhO++Ig4s6kXkyAxMp56NQsV/pTDftaA7xrEQKadIg
        xbNxne6uBxdYUwF61Bf/iSK+pRabewmXwvSHp07kjQ==
X-Google-Smtp-Source: ABdhPJxhxi92o31uNCDmoNMyDyge9aqXdFWJAaVZ8nvy4AzRGHn7z9EdNp1AWOLKeKnFUVDjD2DS+cUEdP8B+wUZjUM=
X-Received: by 2002:a19:84:: with SMTP id 126mr11977971lfa.174.1591043022259;
 Mon, 01 Jun 2020 13:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <159053967673.36091.13796251125796306358.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <159053967673.36091.13796251125796306358.stgit@anambiarhost.jf.intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 13:23:31 -0700
Message-ID: <CAADnVQLk_aWFOAaJMZyBPwaE6Bw0RTe+im0AA1WcoxYeG69jEQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v3] bpf: Add rx_queue_mapping to bpf_sock
To:     Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 5:34 PM Amritha Nambiar
<amritha.nambiar@intel.com> wrote:
>
> Add "rx_queue_mapping" to bpf_sock. This gives read access for the
> existing field (sk_rx_queue_mapping) of struct sock from bpf_sock.
> Semantics for the bpf_sock rx_queue_mapping access are similar to
> sk_rx_queue_get(), i.e the value NO_QUEUE_MAPPING is not allowed
> and -1 is returned in that case. This is useful for transmit queue
> selection based on the received queue index which is cached in the
> socket in the receive path.
>
> v3: Addressed review comments to add usecase in patch description,
>     and fixed default value for rx_queue_mapping.
> v2: fixed build error for CONFIG_XPS wrapping, reported by
>     kbuild test robot <lkp@intel.com>
>
> Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>

Applied. Thanks
