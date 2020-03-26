Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87C194783
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgCZTg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:36:57 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38354 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZTg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:36:57 -0400
Received: by mail-qk1-f196.google.com with SMTP id h14so8183318qke.5;
        Thu, 26 Mar 2020 12:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cSKf7QNXt+JckaG9t46BeP/AGWtgOKiTRyYa0ZIR7z8=;
        b=B5M0ygGjGFupcRnAN42KsNLIVygi4tP72ujQ0r/aCfsqr+PNY7OXXCgl0AA9clN081
         eKUQh4r1fIlRlOR0k+MPiEKgVZq8CVp9kTaMks/AkBB5u98TAt2tWVrnIw5I5k6zAMiv
         rhdIyla1fC1f5X2zhA1gPoZsQ6c3CghbjaTk2QiOCkDCAcLVs+cWukFfCA/OxPqyMgb/
         O6PZlTPX51fxoVJICVXAoVgnkjNySwoSRuOBYLhsYKFqoNnzG++KXolrNzR4GgsYNV4m
         oCKJ2vZU809GgfM3DkWrk+UQFvRvxN//lrvmTzajDEDE36UGbBfWUQKRnBl0xXlZS23N
         EGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cSKf7QNXt+JckaG9t46BeP/AGWtgOKiTRyYa0ZIR7z8=;
        b=QFqpk3BCGFt4K1qcJdvNzcsuBuFaptv27k3EEED1CLAm4FOeUgL/a7S0A/nlpdnr32
         /B/oXiS7KvojUHrUBcaqKlsDBuXSmNYl4M1U08eH651b7Olyjs02SNJGlEW+kZ+/0iPS
         jSnKnQzHra7yk6bgXdwmiEMTy4IO7UPvOUd1CZK0L3F4pkP/Q9hps0c/qIf87iUIYiOv
         Ev1GYShmRMqOnjRPHW4ICjG7TjFRViBvlkp/+ons+jX8uQXlbJeKX9m10wkVBQmiv7Ks
         J3CJJ2L9Dya+2jK5nQlMxWWmnitwBLT9krwNirA8cQnOcfPC/5Vz+MR0MLohYRxbbGDV
         B4Cw==
X-Gm-Message-State: ANhLgQ17pTYx5lKGg0Eozg/XsDcT5DhLAQsAbeCnn/bSbZBrECpKe224
        ftxVaWtij283nETcetyG3YMgxzVZpT2HXnB/Md4=
X-Google-Smtp-Source: ADFU+vvrA1Sou9WCiWveCr8vjebpcje8lQEmQ75XzoWY01/U5goxX5pIR4KPIsHVB3JO6rKW9E8J+BVZm0wo3LkOdr4=
X-Received: by 2002:a05:620a:88e:: with SMTP id b14mr10466253qka.449.1585251414630;
 Thu, 26 Mar 2020 12:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-6-joe@wand.net.nz>
 <CAEf4BzYXedX7Bsv8jzfawYoRkN8Wu4z3+kGfQ9CWcO4dOJe+bg@mail.gmail.com> <CAOftzPhkoZkooOk9SkwLQnZFxM9KGO4M1XpMbzni9TrEKcepjg@mail.gmail.com>
In-Reply-To: <CAOftzPhkoZkooOk9SkwLQnZFxM9KGO4M1XpMbzni9TrEKcepjg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 26 Mar 2020 12:36:43 -0700
Message-ID: <CAEf4Bza=fiCdXacf3pmdXGiiLx0U1qBKHbbjN-=AEvTZ+S8q0A@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:28 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> On Wed, Mar 25, 2020 at 7:16 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Mar 24, 2020 at 10:58 PM Joe Stringer <joe@wand.net.nz> wrote:
> > >
> > > From: Lorenz Bauer <lmb@cloudflare.com>
> > >
> > > Attach a tc direct-action classifier to lo in a fresh network
> > > namespace, and rewrite all connection attempts to localhost:4321
> > > to localhost:1234 (for port tests) and connections to unreachable
> > > IPv4/IPv6 IPs to the local socket (for address tests).
> > >
> > > Keep in mind that both client to server and server to client traffic
> > > passes the classifier.
> > >
> > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > Co-authored-by: Joe Stringer <joe@wand.net.nz>
> > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > ---
>
> <snip>
>
> > > +static void handle_timeout(int signum)
> > > +{
> > > +       if (signum == SIGALRM)
> > > +               fprintf(stderr, "Timed out while connecting to server\n");
> > > +       kill(0, SIGKILL);
> > > +}
> > > +
> > > +static struct sigaction timeout_action = {
> > > +       .sa_handler = handle_timeout,
> > > +};
> > > +
> > > +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
> > > +{
> > > +       int fd = -1;
> > > +
> > > +       fd = socket(addr->sa_family, SOCK_STREAM, 0);
> > > +       if (CHECK_FAIL(fd == -1))
> > > +               goto out;
> > > +       if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
> > > +               goto out;
> >
> > no-no-no, we are not doing this. It's part of prog_tests and shouldn't
> > install its own signal handlers and sending asynchronous signals to
> > itself. Please find another way to have a timeout.
>
> I realise it didn't clean up after itself. How about signal(SIGALRM,
> SIG_DFL); just like other existing tests do?

You have alarm(3), which will deliver SIGALARM later, when other test
is running. Once you clean up this custom signal handler it will cause
test_progs to coredump. So still no, please find another way to do
timeouts.


>
> > > +       test__start_subtest("ipv4 addr redir");
> > > +       if (run_test(server, (const struct sockaddr *)&addr4, sizeof(addr4)))
> > > +               goto out;
> > > +
> > > +       test__start_subtest("ipv6 addr redir");
> >
> > test__start_subtest() returns false if subtest is supposed to be
> > skipped. If you ignore that, then test_progs -t and -n filtering won't
> > work properly.
>
> Will fix.
>
> > > +       if (run_test(server_v6, (const struct sockaddr *)&addr6, sizeof(addr6)))
> > > +               goto out;
> > > +
> > > +       err = 0;
> > > +out:
> > > +       close(server);
> > > +       close(server_v6);
> > > +       return err;
> > > +}
> > > +
> > > +void test_sk_assign(void)
> > > +{
> > > +       int self_net;
> > > +
> > > +       self_net = open(NS_SELF, O_RDONLY);
> >
> > I'm not familiar with what this does. Can you please explain briefly
> > what are the side effects of this? Asking because of shared test_progs
> > environment worries, of course.
>
> This one is opening an fd to the current program's netns path on the
> filesystem. The intention was to use it to switch back to the current
> netns after the unshare() call elsewhere which switches to a new
> netns. As per the other feedback the bit where it switches back to
> this netns was dropped along the way so I'll fix it up in the next
> revision.
>
> > > +SEC("sk_assign_test")
> >
> > Please use "canonical" section name that libbpf recognizes. This
> > woulde be "action/" or "classifier/", right?
>
> Will fix.
