Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5AD0C27
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbfJIKEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:04:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729761AbfJIKD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:03:59 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BED195945B
        for <netdev@vger.kernel.org>; Wed,  9 Oct 2019 10:03:58 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id m16so474685wmg.8
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 03:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nm4tgUTtfAGA91iZbiBcU/rtFWzTOBoRFaRHZuxuW9M=;
        b=NgE484S5w8eZg6qpuUDhvOphiP/SUANVQEJZMKABXliRmrP5Gps3Cl+LwMTfgL/+jQ
         OR1kqEDFiBuJ2A1TEhxH8IJRXHuAGFUPcrl6Q09xNtT53EO7RNcd+St5GYZunH0TkdBV
         BjoNWsgF/p9Lwd4Yv4o2pi3u3P2OUTSw8ZIocURrFJzBtLKZ67uaeNEL91Lb+dwSPAPZ
         np0Ptu/yGerhTGyG7LfEEePKRAql8I8ry86F+yCeQCQA4/vIRv/chBFQkTs2r0PaOpOd
         PFMlsagoGuo6zizFSLXt0q0VIMcC5GnW1woRwywf623kLgYaobDmDhCCWItgja/NKXcc
         PBXw==
X-Gm-Message-State: APjAAAVnxydzrwqA5G6CJzlJJsGH/lTK9dys/yLZeM9RS0NtYR8cf4ek
        eESM957VxWXpKwVocQpPQmvD+oNmPvn5OWw1q4ayEok8XZD9Ds4Z0pBW9I3flIDnNzY+9LrZaG0
        N2/rVDfX7k4rYYM+g
X-Received: by 2002:a1c:7c0a:: with SMTP id x10mr1987646wmc.48.1570615437006;
        Wed, 09 Oct 2019 03:03:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy+zveZ8xAKr0BHKF8ffWhbsRTFLY7qOsymMsPWJ8yuJN+EDryRlFKgw9ecO/DyjcLO48n3sA==
X-Received: by 2002:a1c:7c0a:: with SMTP id x10mr1987610wmc.48.1570615436602;
        Wed, 09 Oct 2019 03:03:56 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id g3sm2501916wro.14.2019.10.09.03.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 03:03:55 -0700 (PDT)
Date:   Wed, 9 Oct 2019 12:03:53 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/11] VSOCK: add AF_VSOCK test cases
Message-ID: <CAGxU2F4N5ACePf6YLQCBFMHPu8wDLScF+AGQ2==JAuBUj0GB-A@mail.gmail.com>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-8-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801152541.245833-8-sgarzare@redhat.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,
I'm thinking about dividing this test into single applications, one
for each test, do you think it makes sense?
Or is it just a useless complication?

Thanks,
Stefano

On Thu, Aug 1, 2019 at 5:27 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> From: Stefan Hajnoczi <stefanha@redhat.com>
>
> The vsock_test.c program runs a test suite of AF_VSOCK test cases.
>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
>  * Drop unnecessary includes [Stefan]
>  * Aligned with the current SPDX [Stefano]
>  * Set MULTICONN_NFDS to 100 [Stefano]
>  * Change (i % 1) in (i % 2) in the 'multiconn' test [Stefano]
> ---
>  tools/testing/vsock/.gitignore   |   1 +
>  tools/testing/vsock/Makefile     |   5 +-
>  tools/testing/vsock/README       |   1 +
>  tools/testing/vsock/vsock_test.c | 312 +++++++++++++++++++++++++++++++
>  4 files changed, 317 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/vsock/vsock_test.c
>
> diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitignore
> index dc5f11faf530..7f7a2ccc30c4 100644
> --- a/tools/testing/vsock/.gitignore
> +++ b/tools/testing/vsock/.gitignore
> @@ -1,2 +1,3 @@
>  *.d
> +vsock_test
>  vsock_diag_test
> diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
> index a916878a2d8c..f8293c6910c9 100644
> --- a/tools/testing/vsock/Makefile
> +++ b/tools/testing/vsock/Makefile
> @@ -1,10 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  all: test
> -test: vsock_diag_test
> +test: vsock_test vsock_diag_test
> +vsock_test: vsock_test.o timeout.o control.o util.o
>  vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>
>  CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
>  .PHONY: all test clean
>  clean:
> -       ${RM} *.o *.d vsock_diag_test
> +       ${RM} *.o *.d vsock_test vsock_diag_test
>  -include *.d
> diff --git a/tools/testing/vsock/README b/tools/testing/vsock/README
> index cf7dc64273bf..4d5045e7d2c3 100644
> --- a/tools/testing/vsock/README
> +++ b/tools/testing/vsock/README
> @@ -5,6 +5,7 @@ Hyper-V.
>
>  The following tests are available:
>
> +  * vsock_test - core AF_VSOCK socket functionality
>    * vsock_diag_test - vsock_diag.ko module for listing open sockets
>
>  The following prerequisite steps are not automated and must be performed prior
> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> new file mode 100644
> index 000000000000..06099d037405
> --- /dev/null
> +++ b/tools/testing/vsock/vsock_test.c
> @@ -0,0 +1,312 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vsock_test - vsock.ko test suite
> + *
> + * Copyright (C) 2017 Red Hat, Inc.
> + *
> + * Author: Stefan Hajnoczi <stefanha@redhat.com>
> + */
> +
> +#include <getopt.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <unistd.h>
> +
> +#include "timeout.h"
> +#include "control.h"
> +#include "util.h"
> +
> +static void test_stream_connection_reset(const struct test_opts *opts)
> +{
> +       union {
> +               struct sockaddr sa;
> +               struct sockaddr_vm svm;
> +       } addr = {
> +               .svm = {
> +                       .svm_family = AF_VSOCK,
> +                       .svm_port = 1234,
> +                       .svm_cid = opts->peer_cid,
> +               },
> +       };
> +       int ret;
> +       int fd;
> +
> +       fd = socket(AF_VSOCK, SOCK_STREAM, 0);
> +
> +       timeout_begin(TIMEOUT);
> +       do {
> +               ret = connect(fd, &addr.sa, sizeof(addr.svm));
> +               timeout_check("connect");
> +       } while (ret < 0 && errno == EINTR);
> +       timeout_end();
> +
> +       if (ret != -1) {
> +               fprintf(stderr, "expected connect(2) failure, got %d\n", ret);
> +               exit(EXIT_FAILURE);
> +       }
> +       if (errno != ECONNRESET) {
> +               fprintf(stderr, "unexpected connect(2) errno %d\n", errno);
> +               exit(EXIT_FAILURE);
> +       }
> +
> +       close(fd);
> +}
> +
> +static void test_stream_client_close_client(const struct test_opts *opts)
> +{
> +       int fd;
> +
> +       fd = vsock_stream_connect(opts->peer_cid, 1234);
> +       if (fd < 0) {
> +               perror("connect");
> +               exit(EXIT_FAILURE);
> +       }
> +
> +       send_byte(fd, 1);
> +       close(fd);
> +       control_writeln("CLOSED");
> +}
> +
> +static void test_stream_client_close_server(const struct test_opts *opts)
> +{
> +       int fd;
> +
> +       fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
> +       if (fd < 0) {
> +               perror("accept");
> +               exit(EXIT_FAILURE);
> +       }
> +
> +       control_expectln("CLOSED");
> +
> +       send_byte(fd, -EPIPE);
> +       recv_byte(fd, 1);
> +       recv_byte(fd, 0);
> +       close(fd);
> +}
> +
> +static void test_stream_server_close_client(const struct test_opts *opts)
> +{
> +       int fd;
> +
> +       fd = vsock_stream_connect(opts->peer_cid, 1234);
> +       if (fd < 0) {
> +               perror("connect");
> +               exit(EXIT_FAILURE);
> +       }
> +
> +       control_expectln("CLOSED");
> +
> +       send_byte(fd, -EPIPE);
> +       recv_byte(fd, 1);
> +       recv_byte(fd, 0);
> +       close(fd);
> +}
> +
> +static void test_stream_server_close_server(const struct test_opts *opts)
> +{
> +       int fd;
> +
> +       fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
> +       if (fd < 0) {
> +               perror("accept");
> +               exit(EXIT_FAILURE);
> +       }
> +
> +       send_byte(fd, 1);
> +       close(fd);
> +       control_writeln("CLOSED");
> +}
> +
> +/* With the standard socket sizes, VMCI is able to support about 100
> + * concurrent stream connections.
> + */
> +#define MULTICONN_NFDS 100
> +
> +static void test_stream_multiconn_client(const struct test_opts *opts)
> +{
> +       int fds[MULTICONN_NFDS];
> +       int i;
> +
> +       for (i = 0; i < MULTICONN_NFDS; i++) {
> +               fds[i] = vsock_stream_connect(opts->peer_cid, 1234);
> +               if (fds[i] < 0) {
> +                       perror("connect");
> +                       exit(EXIT_FAILURE);
> +               }
> +       }
> +
> +       for (i = 0; i < MULTICONN_NFDS; i++) {
> +               if (i % 2)
> +                       recv_byte(fds[i], 1);
> +               else
> +                       send_byte(fds[i], 1);
> +       }
> +
> +       for (i = 0; i < MULTICONN_NFDS; i++)
> +               close(fds[i]);
> +}
> +
> +static void test_stream_multiconn_server(const struct test_opts *opts)
> +{
> +       int fds[MULTICONN_NFDS];
> +       int i;
> +
> +       for (i = 0; i < MULTICONN_NFDS; i++) {
> +               fds[i] = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
> +               if (fds[i] < 0) {
> +                       perror("accept");
> +                       exit(EXIT_FAILURE);
> +               }
> +       }
> +
> +       for (i = 0; i < MULTICONN_NFDS; i++) {
> +               if (i % 2)
> +                       send_byte(fds[i], 1);
> +               else
> +                       recv_byte(fds[i], 1);
> +       }
> +
> +       for (i = 0; i < MULTICONN_NFDS; i++)
> +               close(fds[i]);
> +}
> +
> +static struct test_case test_cases[] = {
> +       {
> +               .name = "SOCK_STREAM connection reset",
> +               .run_client = test_stream_connection_reset,
> +       },
> +       {
> +               .name = "SOCK_STREAM client close",
> +               .run_client = test_stream_client_close_client,
> +               .run_server = test_stream_client_close_server,
> +       },
> +       {
> +               .name = "SOCK_STREAM server close",
> +               .run_client = test_stream_server_close_client,
> +               .run_server = test_stream_server_close_server,
> +       },
> +       {
> +               .name = "SOCK_STREAM multiple connections",
> +               .run_client = test_stream_multiconn_client,
> +               .run_server = test_stream_multiconn_server,
> +       },
> +       {},
> +};
> +
> +static const char optstring[] = "";
> +static const struct option longopts[] = {
> +       {
> +               .name = "control-host",
> +               .has_arg = required_argument,
> +               .val = 'H',
> +       },
> +       {
> +               .name = "control-port",
> +               .has_arg = required_argument,
> +               .val = 'P',
> +       },
> +       {
> +               .name = "mode",
> +               .has_arg = required_argument,
> +               .val = 'm',
> +       },
> +       {
> +               .name = "peer-cid",
> +               .has_arg = required_argument,
> +               .val = 'p',
> +       },
> +       {
> +               .name = "help",
> +               .has_arg = no_argument,
> +               .val = '?',
> +       },
> +       {},
> +};
> +
> +static void usage(void)
> +{
> +       fprintf(stderr, "Usage: vsock_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
> +               "\n"
> +               "  Server: vsock_test --control-port=1234 --mode=server --peer-cid=3\n"
> +               "  Client: vsock_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
> +               "\n"
> +               "Run vsock.ko tests.  Must be launched in both guest\n"
> +               "and host.  One side must use --mode=client and\n"
> +               "the other side must use --mode=server.\n"
> +               "\n"
> +               "A TCP control socket connection is used to coordinate tests\n"
> +               "between the client and the server.  The server requires a\n"
> +               "listen address and the client requires an address to\n"
> +               "connect to.\n"
> +               "\n"
> +               "The CID of the other side must be given with --peer-cid=<cid>.\n");
> +       exit(EXIT_FAILURE);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +       const char *control_host = NULL;
> +       const char *control_port = NULL;
> +       struct test_opts opts = {
> +               .mode = TEST_MODE_UNSET,
> +               .peer_cid = VMADDR_CID_ANY,
> +       };
> +
> +       init_signals();
> +
> +       for (;;) {
> +               int opt = getopt_long(argc, argv, optstring, longopts, NULL);
> +
> +               if (opt == -1)
> +                       break;
> +
> +               switch (opt) {
> +               case 'H':
> +                       control_host = optarg;
> +                       break;
> +               case 'm':
> +                       if (strcmp(optarg, "client") == 0)
> +                               opts.mode = TEST_MODE_CLIENT;
> +                       else if (strcmp(optarg, "server") == 0)
> +                               opts.mode = TEST_MODE_SERVER;
> +                       else {
> +                               fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
> +                               return EXIT_FAILURE;
> +                       }
> +                       break;
> +               case 'p':
> +                       opts.peer_cid = parse_cid(optarg);
> +                       break;
> +               case 'P':
> +                       control_port = optarg;
> +                       break;
> +               case '?':
> +               default:
> +                       usage();
> +               }
> +       }
> +
> +       if (!control_port)
> +               usage();
> +       if (opts.mode == TEST_MODE_UNSET)
> +               usage();
> +       if (opts.peer_cid == VMADDR_CID_ANY)
> +               usage();
> +
> +       if (!control_host) {
> +               if (opts.mode != TEST_MODE_SERVER)
> +                       usage();
> +               control_host = "0.0.0.0";
> +       }
> +
> +       control_init(control_host, control_port,
> +                    opts.mode == TEST_MODE_SERVER);
> +
> +       run_tests(test_cases, &opts);
> +
> +       control_cleanup();
> +       return EXIT_SUCCESS;
> +}
> --
> 2.20.1
