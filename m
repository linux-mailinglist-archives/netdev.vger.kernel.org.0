Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7235C64F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 02:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfGBA1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 20:27:05 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42866 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfGBA1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 20:27:05 -0400
Received: by mail-io1-f66.google.com with SMTP id u19so24475613ior.9;
        Mon, 01 Jul 2019 17:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=msi3sIe/2rMoiFrFYyGGvyE4Wu0xewK5rPPdG+6lYn8=;
        b=AfBN8LmSqeGgskBqoEmnmS8ybWRuUohBhf6pYxueGAQDxk+aJaIynrcs7thghMvFbC
         hDpxSM8LLS6omQgRYJ7TliK3x4hfLUQ5DmpJ7M6NN1pV5dYYUD2iKuyO+jEzdglVhEQD
         xQNXUMoYXX45PIlyc6XeF/t7FwpiRA7qnSLIHPRGRQzo+XOKSYqPLLzeuQhrxnpaw1jE
         PpjSV7usaP2fbx9jTBYaKHErJnbhghnWLurK0FdiZq2Dp7sOTUZPPcVs0ufsTwmof2lh
         pBoVNSdMjG157kRjV6/luiboZG6cmYC5sg04CiOMv29sQgHDPdhvIn8cXJjSc3/vzG++
         m4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=msi3sIe/2rMoiFrFYyGGvyE4Wu0xewK5rPPdG+6lYn8=;
        b=YeR7+dPLQBlMU4lhmkJ6AyZkbeBZAjd9rgQAei/XzgGNKQZyIO0enEOY+23Hgtf5jb
         LuRi18b6KLuGMI23sYq5s3O9/lSvzX0+Pzn1ejIO3Qcjun8GLuFJlFfkCnm5gVybxiuN
         ntpUbiwhBlYhIIGeZgc2AfXNEDLTIOcZYJU67Fq9/FjvTfnkLAyksVIDei1GviGafDb2
         AXj8a45pP4OAbJwY6f0BnUM3LEcnsr8WA47+BpWytFUDacj4yhTNUoNlhfXZr2yBOOBI
         kzCZsJC73VfXZjAFrvan4qP/4//33rU/Ar4C70ziatcEK1yXrqzvNNE0v8NzqcFkWkRT
         cUzw==
X-Gm-Message-State: APjAAAX3TJIPetcqfOkxJai0ukyFedtnlWhRXgaWjEoMIBoV/06DBgLO
        BnLbGYR1eM86iG+UIhGSVhuvHugVvnFDjMm1Aw8=
X-Google-Smtp-Source: APXvYqylXNYNiQCClbHXcFgG3J/fkEa2SqCly+StUIRmzNT89jL95outBI31qsU6sVnlwWkZ6DZjuZlw+kshyvcRfo0=
X-Received: by 2002:a5d:9448:: with SMTP id x8mr31542962ior.102.1562027224739;
 Mon, 01 Jul 2019 17:27:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190701204821.44230-1-sdf@google.com> <20190701204821.44230-7-sdf@google.com>
 <CAH3MdRXx4uO3pTFiLZk8j9ooO0gd1ppbSyT8zHMsVs01P6wKpA@mail.gmail.com> <20190702000736.GH6757@mini-arch>
In-Reply-To: <20190702000736.GH6757@mini-arch>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 1 Jul 2019 17:26:28 -0700
Message-ID: <CAH3MdRUSaqHmuu1cx5ckPvWYSDot8uwHCbgMRp26kKtkQ10N=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/8] selftests/bpf: test BPF_SOCK_OPS_RTT_CB
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 5:07 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/01, Y Song wrote:
> > On Mon, Jul 1, 2019 at 1:49 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > Make sure the callback is invoked for syn-ack and data packet.
> > >
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Priyaranjan Jha <priyarjha@google.com>
> > > Cc: Yuchung Cheng <ycheng@google.com>
> > > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile        |   3 +-
> > >  tools/testing/selftests/bpf/progs/tcp_rtt.c |  61 +++++
> > >  tools/testing/selftests/bpf/test_tcp_rtt.c  | 253 ++++++++++++++++++++
> > >  3 files changed, 316 insertions(+), 1 deletion(-)
> > >  create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
> > >  create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index de1754a8f5fe..2620406a53ec 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -27,7 +27,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
> > >         test_cgroup_storage test_select_reuseport test_section_names \
> > >         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
> > >         test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
> > > -       test_sockopt_multi
> > > +       test_sockopt_multi test_tcp_rtt
> > >
> > >  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
> > >  TEST_GEN_FILES = $(BPF_OBJ_FILES)
> > > @@ -107,6 +107,7 @@ $(OUTPUT)/test_cgroup_attach: cgroup_helpers.c
> > >  $(OUTPUT)/test_sockopt: cgroup_helpers.c
> > >  $(OUTPUT)/test_sockopt_sk: cgroup_helpers.c
> > >  $(OUTPUT)/test_sockopt_multi: cgroup_helpers.c
> > > +$(OUTPUT)/test_tcp_rtt: cgroup_helpers.c
> > >
> > >  .PHONY: force
> > >
> > > diff --git a/tools/testing/selftests/bpf/progs/tcp_rtt.c b/tools/testing/selftests/bpf/progs/tcp_rtt.c
> > > new file mode 100644
> > > index 000000000000..233bdcb1659e
> > > --- /dev/null
> > > +++ b/tools/testing/selftests/bpf/progs/tcp_rtt.c
> > > @@ -0,0 +1,61 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +#include <linux/bpf.h>
> > > +#include "bpf_helpers.h"
> > > +
> > > +char _license[] SEC("license") = "GPL";
> > > +__u32 _version SEC("version") = 1;
> > > +
> > > +struct tcp_rtt_storage {
> > > +       __u32 invoked;
> > > +       __u32 dsack_dups;
> > > +       __u32 delivered;
> > > +       __u32 delivered_ce;
> > > +       __u32 icsk_retransmits;
> > > +};
[...]
> > > +
> > > +static void *server_thread(void *arg)
> > > +{
> > > +       struct sockaddr_storage addr;
> > > +       socklen_t len = sizeof(addr);
> > > +       int fd = *(int *)arg;
> > > +       int client_fd;
> > > +
> > > +       if (listen(fd, 1) < 0)
> > > +               error(1, errno, "Failed to listed on socket");
> >
> > The error() here only reports the error, right? In case of error,
> > should the control jumps to the end of this function and return?
> > The same for several error() calls below.
> No, error() calls exit(), so the whole process should die. Do you think
> it's better to gracefully handle that with pthread_join?

Thanks for explanation of error() semantics.
test_tcp_rtt is a standalone a program, so exiting
with a meaningful error message is fine to me. No need to change then.

>
> > > +
> > > +       client_fd = accept(fd, (struct sockaddr *)&addr, &len);
> > > +       if (client_fd < 0)
> > > +               error(1, errno, "Failed to accept client");
> > > +
> > > +       if (accept(fd, (struct sockaddr *)&addr, &len) >= 0)
> > > +               error(1, errno, "Unexpected success in second accept");
> >
> > What is the purpose of this second default to-be-failed accept() call?
> So the server_thread waits here for the next client (that never arrives)
> and doesn't exit and call close(client_fd). I can add a comment here to
> clarify. Alternatively, I can just drop close(client_fd) and let
> the thread exit. WDYT?

Adding a comment to explain should be good enough. Thanks!

>
> > > +
> > > +       close(client_fd);
> > > +
> > > +       return NULL;
> > > +}
> > > +
> > > +int main(int args, char **argv)
> > > +{
> > > +       int server_fd, cgroup_fd;
> > > +       int err = EXIT_SUCCESS;
> > > +       pthread_t tid;
> > > +
> > > +       if (setup_cgroup_environment())
> > > +               goto cleanup_obj;
> > > +
> > > +       cgroup_fd = create_and_get_cgroup(CG_PATH);
> > > +       if (cgroup_fd < 0)
> > > +               goto cleanup_cgroup_env;
> > > +
> > > +       if (join_cgroup(CG_PATH))
> > > +               goto cleanup_cgroup;
> > > +
> > > +       server_fd = start_server();
> > > +       if (server_fd < 0) {
> > > +               err = EXIT_FAILURE;
> > > +               goto cleanup_cgroup;
> > > +       }
> > > +
> > > +       pthread_create(&tid, NULL, server_thread, (void *)&server_fd);
> > > +
> > > +       if (run_test(cgroup_fd, server_fd))
> > > +               err = EXIT_FAILURE;
> > > +
> > > +       close(server_fd);
> > > +
> > > +       printf("test_sockopt_sk: %s\n",
> > > +              err == EXIT_SUCCESS ? "PASSED" : "FAILED");
> > > +
> > > +cleanup_cgroup:
> > > +       close(cgroup_fd);
> > > +cleanup_cgroup_env:
> > > +       cleanup_cgroup_environment();
> > > +cleanup_obj:
> > > +       return err;
> > > +}
> > > --
> > > 2.22.0.410.gd8fdbe21b5-goog
> > >
