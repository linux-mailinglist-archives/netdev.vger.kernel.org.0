Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A354233915
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgG3TbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730497AbgG3TbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:31:06 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4554DC061574;
        Thu, 30 Jul 2020 12:31:05 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id v89so791288ybi.8;
        Thu, 30 Jul 2020 12:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5FEEnrZXlSxUHvW2wIVYPb6qoZnfA0638bKW+bX8O9s=;
        b=Ovi4tUleUwfC3CdzW3DPEwqFMnah+Pxsur0bNb54Q7xoG3zyIOnhZlkCML+aihC6sI
         XuionKk+FXR0X/17569vkEsvVy2e03xXa/I84IzW83inuhw54d5QtV5HgARK8NvEvrUD
         sa0gZjcG31iXamLq8l06eSQ5/cNfS8eijRsi0IOeXQScSHq9gtUovlJ6PZ6pYNUVCycp
         vl35re4171pAxJw0RpoChy6avgyB26a2JMi3aLKguWzbaRmos/FeetW9IzVqLdIWLJyI
         ogEmdXD+qVwr3QMWPdVBRGUUeZTerfiie3v/a9YtqeC2HL40SFiH7zFaDzHhkFcSSuVs
         tHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5FEEnrZXlSxUHvW2wIVYPb6qoZnfA0638bKW+bX8O9s=;
        b=ob8jypp7eKfOIo/LtUtNF9TolCLjQ24EjWbdy0erYDSLdsSHtjk33EdUMSInCk8Ri4
         YvKCco62vEN3r3OUuuNq6cjxMJTGd7+IZDSRBG6EVDc6152mmCwulZhWCoyWDZAond6L
         ddRQeDm7iX6yct9x629dC2FSkco1JZ1Hjemu7jp7nJSHBi2QAVrh9kUtY/gZc8rFaiK9
         c7nJNim+gO6H+HiD24yzU1HWcxOoyL2cJZ2BHD+BCRoFRvuGYcTrb4zb17okk7K3poWM
         Fm2Lf1qFrZxajgVmVBesT4ehXy05xykhySb+VYpgt6XCQtOoH9/X+AOWdXEitt/P2TRH
         WN7A==
X-Gm-Message-State: AOAM532MAyqDSAaY2Bdb8+/+g7g3bu8QqFdunoNzlzZvudBXlbP0GgB3
        ithYSXAwJ6zPqDRp7CSn7HYE9iloGx9PN2/xXz0=
X-Google-Smtp-Source: ABdhPJy5y5SymkBeA9AHUM0LHSlU1xiJSJfYrV04fm873XRmlmkWVjllrwFPD/iVWyU7VI5mpLSDvqpD3JSEsA7hQmI=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr617569ybg.459.1596137464532;
 Thu, 30 Jul 2020 12:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200730125325.1869363-1-jakub@cloudflare.com>
In-Reply-To: <20200730125325.1869363-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 30 Jul 2020 12:30:53 -0700
Message-ID: <CAEf4Bzan-B5ZTc6jSf3Dut7frEKq1XhYxg3sTtdKbds+mmmrrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Omit nodad flag when adding
 addresses to loopback
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 5:53 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Setting IFA_F_NODAD flag for IPv6 addresses to add to loopback is
> unnecessary. Duplicate Address Detection does not happen on loopback
> device.
>
> Also, passing 'nodad' flag to 'ip address' breaks libbpf CI, which runs in
> an environment with BusyBox implementation of 'ip' command, that doesn't
> understand this flag.
>
> Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---


This fixes the nodad issue, thanks for quick fix!

Tested-by: Andrii Nakryiko <andrii@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>


But now I see these, which seems like you have a separate fix for, right?

(network_helpers.c:112: errno: Cannot assign requested address) Failed
to connect to server
run_lookup_test:FAIL:connect_fd_to_fd unexpected result err -1 errno 99
#14 cgroup_skb_sk_lookup:FAIL

udp_recv_send:FAIL:recvmsg failed
(/data/users/andriin/linux/tools/testing/selftests/bpf/prog_tests/sk_lookup.c:339:
errno: Resource temporarily unavailable) failed to receive
#73/14 UDP IPv4 redir and reuseport with conns:FAIL


>  tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> index 9bbd2b2b7630..379da6f10ee9 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> @@ -1290,8 +1290,8 @@ static void run_tests(struct test_sk_lookup *skel)
>  static int switch_netns(void)
>  {
>         static const char * const setup_script[] = {
> -               "ip -6 addr add dev lo " EXT_IP6 "/128 nodad",
> -               "ip -6 addr add dev lo " INT_IP6 "/128 nodad",
> +               "ip -6 addr add dev lo " EXT_IP6 "/128",
> +               "ip -6 addr add dev lo " INT_IP6 "/128",
>                 "ip link set dev lo up",
>                 NULL,
>         };
> --
> 2.25.4
>
