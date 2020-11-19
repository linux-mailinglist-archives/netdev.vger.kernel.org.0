Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FE82B9D0D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgKSVmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgKSVmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:42:08 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B706DC0617A7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:42:06 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id s9so7837394ljo.11
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YFkhGODobbzscYbsSLvNA9esMh0aaLBLRIgEaTHlg0Q=;
        b=V7SJ0bU1TRqB34SR542Skh+B3DoXX93hK/87i3egewmUjkgnDDLc0BEFjgOmu8tdC5
         fJUmedd/BDAs6dCTzYa72tU3gS56bkO2zSyb2p4KWAu4/kBnt3xqOBYPwU41zAogXBLd
         5uepg4JrDaMxwSfA+PuE847OvVJm2pE3q3dXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YFkhGODobbzscYbsSLvNA9esMh0aaLBLRIgEaTHlg0Q=;
        b=sBlS0sH1jBTdidIHnmUhGLcykvqpQ8DZ1vzNz6qidIMe9/NfBha0PtyYBq6Pu1iI05
         q2j3w021cnmXzJbQ8a0J+y4vewQNwJG1ezkmdNs8+VqfqwZWDCxrb+f6hnTV77qikyzz
         R4xEoXI1CzZkL2FnEF7Mkew2q5RZLNy2iKYexvzTWWz+yeV7r6Tld0IglzonhEtWv0SB
         LAmZDummLKg2K2SIBmYPo545Prfh3ZErkq4yEFwUF7+LKZaaFIc3v8LuGcxrUjhN6rKr
         puyImSBE8AoYMHAvi1YpDCohDHxLCEX+BsCykMY2oykSZBzeoT4/OaXxDsb7ZTc09j7l
         fG4w==
X-Gm-Message-State: AOAM530EWCfk2wlDSqrbTn9f9hB/dHeubgRS8XZgUIj7BthyoAl6fek2
        lOcsnTkGnTCZWi1U4GC90vZUyA5fvPNYBCBD3OZlfw==
X-Google-Smtp-Source: ABdhPJyu+RaCXT86/IyEVefxZW+raWLyGyY6P5DffMuj2ymfKnTJCZjkJWXuok51uEUPjIW0DKcr0TspHJWyION66Uc=
X-Received: by 2002:a2e:b0cc:: with SMTP id g12mr7039513ljl.309.1605822124931;
 Thu, 19 Nov 2020 13:42:04 -0800 (PST)
MIME-Version: 1.0
References: <20201119162654.2410685-1-revest@chromium.org>
In-Reply-To: <20201119162654.2410685-1-revest@chromium.org>
From:   KP Singh <kpsingh@chromium.org>
Date:   Thu, 19 Nov 2020 22:41:54 +0100
Message-ID: <CACYkzJ5W_4o7iqa4rsDQBYWtuByjO23=w5L=vXyvbu_dtTStLA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] net: Remove the err argument from sock_from_file
To:     Florent Revest <revest@chromium.org>
Cc:     bpf <bpf@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Florent Revest <revest@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think you meant to send these as [PATCH bpf-next] for bpf-next.

I guess we can do a round of reviews and update the next revision (if
any) with the correct prefixes.

On Thu, Nov 19, 2020 at 5:27 PM Florent Revest <revest@chromium.org> wrote:
>
> From: Florent Revest <revest@google.com>
>
> Currently, the sock_from_file prototype takes an "err" pointer that is
> either not set or set to -ENOTSOCK IFF the returned socket is NULL. This
> makes the error redundant and it is ignored by a few callers.
>
> This patch simplifies the API by letting callers deduce the error based
> on whether the returned socket is NULL or not.
>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Florent Revest <revest@google.com>
> ---
>  fs/eventpoll.c               |  3 +--
>  fs/io_uring.c                | 16 ++++++++--------
>  include/linux/net.h          |  2 +-
>  net/core/netclassid_cgroup.c |  3 +--
>  net/core/netprio_cgroup.c    |  3 +--
>  net/core/sock.c              |  8 +-------
>  net/socket.c                 | 27 ++++++++++++++++-----------
>  7 files changed, 29 insertions(+), 33 deletions(-)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 4df61129566d..c764d8d5a76a 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -415,12 +415,11 @@ static inline void ep_set_busy_poll_napi_id(struct epitem *epi)
>         unsigned int napi_id;
>         struct socket *sock;
>         struct sock *sk;
> -       int err;
>
>         if (!net_busy_loop_on())
>                 return;
>
> -       sock = sock_from_file(epi->ffd.file, &err);
> +       sock = sock_from_file(epi->ffd.file);
>         if (!sock)
>                 return;
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8018c7076b25..ace99b15cbd3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4341,9 +4341,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
>         unsigned flags;
>         int ret;
>
> -       sock = sock_from_file(req->file, &ret);
> +       sock = sock_from_file(req->file);
>         if (unlikely(!sock))
> -               return ret;
> +               return -ENOTSOCK;
>
>         if (req->async_data) {
>                 kmsg = req->async_data;
> @@ -4390,9 +4390,9 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
>         unsigned flags;
>         int ret;
>
> -       sock = sock_from_file(req->file, &ret);
> +       sock = sock_from_file(req->file);
>         if (unlikely(!sock))
> -               return ret;
> +               return -ENOTSOCK;
>
>         ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
>         if (unlikely(ret))
> @@ -4569,9 +4569,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
>         unsigned flags;
>         int ret, cflags = 0;
>
> -       sock = sock_from_file(req->file, &ret);
> +       sock = sock_from_file(req->file);
>         if (unlikely(!sock))
> -               return ret;
> +               return -ENOTSOCK;
>
>         if (req->async_data) {
>                 kmsg = req->async_data;
> @@ -4632,9 +4632,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
>         unsigned flags;
>         int ret, cflags = 0;
>
> -       sock = sock_from_file(req->file, &ret);
> +       sock = sock_from_file(req->file);
>         if (unlikely(!sock))
> -               return ret;
> +               return -ENOTSOCK;
>
>         if (req->flags & REQ_F_BUFFER_SELECT) {
>                 kbuf = io_recv_buffer_select(req, !force_nonblock);
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 0dcd51feef02..9e2324efc26a 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -240,7 +240,7 @@ int sock_sendmsg(struct socket *sock, struct msghdr *msg);
>  int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags);
>  struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname);
>  struct socket *sockfd_lookup(int fd, int *err);
> -struct socket *sock_from_file(struct file *file, int *err);
> +struct socket *sock_from_file(struct file *file);
>  #define                     sockfd_put(sock) fput(sock->file)
>  int net_ratelimit(void);
>
> diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
> index 41b24cd31562..b49c57d35a88 100644
> --- a/net/core/netclassid_cgroup.c
> +++ b/net/core/netclassid_cgroup.c
> @@ -68,9 +68,8 @@ struct update_classid_context {
>
>  static int update_classid_sock(const void *v, struct file *file, unsigned n)
>  {
> -       int err;
>         struct update_classid_context *ctx = (void *)v;
> -       struct socket *sock = sock_from_file(file, &err);
> +       struct socket *sock = sock_from_file(file);
>
>         if (sock) {
>                 spin_lock(&cgroup_sk_update_lock);
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index 9bd4cab7d510..99a431c56f23 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -220,8 +220,7 @@ static ssize_t write_priomap(struct kernfs_open_file *of,
>
>  static int update_netprio(const void *v, struct file *file, unsigned n)
>  {
> -       int err;
> -       struct socket *sock = sock_from_file(file, &err);
> +       struct socket *sock = sock_from_file(file);
>         if (sock) {
>                 spin_lock(&cgroup_sk_update_lock);
>                 sock_cgroup_set_prioidx(&sock->sk->sk_cgrp_data,
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 727ea1cc633c..dd0598d831ef 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2808,14 +2808,8 @@ EXPORT_SYMBOL(sock_no_mmap);
>  void __receive_sock(struct file *file)
>  {
>         struct socket *sock;
> -       int error;
>
> -       /*
> -        * The resulting value of "error" is ignored here since we only
> -        * need to take action when the file is a socket and testing
> -        * "sock" for NULL is sufficient.
> -        */
> -       sock = sock_from_file(file, &error);
> +       sock = sock_from_file(file);
>         if (sock) {
>                 sock_update_netprioidx(&sock->sk->sk_cgrp_data);
>                 sock_update_classid(&sock->sk->sk_cgrp_data);
> diff --git a/net/socket.c b/net/socket.c
> index 6e6cccc2104f..c799d9652a2c 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -445,17 +445,15 @@ static int sock_map_fd(struct socket *sock, int flags)
>  /**
>   *     sock_from_file - Return the &socket bounded to @file.
>   *     @file: file
> - *     @err: pointer to an error code return
>   *
> - *     On failure returns %NULL and assigns -ENOTSOCK to @err.
> + *     On failure returns %NULL.
>   */
>
> -struct socket *sock_from_file(struct file *file, int *err)
> +struct socket *sock_from_file(struct file *file)
>  {
>         if (file->f_op == &socket_file_ops)
>                 return file->private_data;      /* set in sock_map_fd */
>
> -       *err = -ENOTSOCK;
>         return NULL;
>  }
>  EXPORT_SYMBOL(sock_from_file);
> @@ -484,9 +482,11 @@ struct socket *sockfd_lookup(int fd, int *err)
>                 return NULL;
>         }
>
> -       sock = sock_from_file(file, err);
> -       if (!sock)
> +       sock = sock_from_file(file);
> +       if (!sock) {
> +               *err = -ENOTSOCK;
>                 fput(file);
> +       }
>         return sock;
>  }
>  EXPORT_SYMBOL(sockfd_lookup);
> @@ -498,11 +498,12 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
>
>         *err = -EBADF;
>         if (f.file) {
> -               sock = sock_from_file(f.file, err);
> +               sock = sock_from_file(f.file);
>                 if (likely(sock)) {
>                         *fput_needed = f.flags & FDPUT_FPUT;
>                         return sock;
>                 }
> +               *err = -ENOTSOCK;
>                 fdput(f);
>         }
>         return NULL;
> @@ -1715,9 +1716,11 @@ int __sys_accept4_file(struct file *file, unsigned file_flags,
>         if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
>                 flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
>
> -       sock = sock_from_file(file, &err);
> -       if (!sock)
> +       sock = sock_from_file(file);
> +       if (!sock) {
> +               err = -ENOTSOCK;
>                 goto out;
> +       }
>
>         err = -ENFILE;
>         newsock = sock_alloc();
> @@ -1840,9 +1843,11 @@ int __sys_connect_file(struct file *file, struct sockaddr_storage *address,
>         struct socket *sock;
>         int err;
>
> -       sock = sock_from_file(file, &err);
> -       if (!sock)
> +       sock = sock_from_file(file);
> +       if (!sock) {
> +               err = -ENOTSOCK;
>                 goto out;
> +       }
>
>         err =
>             security_socket_connect(sock, (struct sockaddr *)address, addrlen);
> --
> 2.29.2.299.gdc1121823c-goog
>
