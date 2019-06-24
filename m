Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE90510AC
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbfFXPgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:36:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37684 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfFXPge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:36:34 -0400
Received: by mail-qt1-f196.google.com with SMTP id y57so14959806qtk.4;
        Mon, 24 Jun 2019 08:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2fedAY1L1btlfl2SG7dqkjpbIsEJBo2iKLbpPw9GTe0=;
        b=DJzHvyiSbcQ6CRpXmTjpzIx9uYAQpj5lVFPLxsegvuhGQyCRdl6TKjWM2zXtplk3WP
         Fkj+9Jqz2ekthKHqTahkaSfuA8J04SORbLkZBNpuBRotxnutKyWMTMhUICa3mUmKW1Jw
         cwmYSOgbzkSjZxTqL1WY92md5GwcEqcLNf3lSEIG5wWqPeh9wMzEqIiMIEwOxDAhWJk0
         2ScNOn0aYlmPuj+XfxxCOYEosZeGxoSLAaVMIpohGFbUxeNm/LWrJRjKKw9k/wOVqEl3
         qPqVkTeDttiJngm7lIM1wDU8UJtDmKWfFhZjhxy52hQVkiB4s1psKwdWd9bPx/6dzb0m
         bKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2fedAY1L1btlfl2SG7dqkjpbIsEJBo2iKLbpPw9GTe0=;
        b=RW0db+DqFWuxnpQWKU6GOERjUdYx1Ytp67tS/vhPe/iqU9gXh7u8Mgate5hxa+1oPi
         NJtmoEh38kUXlEUm1/uOL9SSaAeKxU8bD3sc+gUwqw+PGTwOI5pQXwJYIrNF9vjRHY1k
         HIjkNdwW8kwDDz2mLqY3xrrYOXYpiwj/hHTPwadVzvBjtqfXVoDHmRisv4YZmEaQ8asD
         PkKtyU49b1SZftGULm6rrt7s+2rFxSOalfTwjttyy/w1Hij7HNHUrFCXpy9TAlv4Qj61
         XM3O9xVtHMSKm4IObuUEW9Qm/KFbiks3kmVAy+R/yLn2VSDxxUxHmPobjRpJLym2Xn0J
         9fDQ==
X-Gm-Message-State: APjAAAXUGMWdrSvXyomC2U3aUDoar7pnpdtuWuvM1AXhDpQ6okSIKhYi
        CoouKLFD6azUckJkZXIkEbnQmN5e6RE93THvbWbB173cRN4=
X-Google-Smtp-Source: APXvYqzud0u4l0tPcVLp9FP9+zn+iA4HMLTOKUiEi4BNJZaHRZKQcOi8G59OLZHPyhRjvq3u8N9Nr43JjGfISkrKlwM=
X-Received: by 2002:ac8:2f07:: with SMTP id j7mr118912618qta.359.1561390593748;
 Mon, 24 Jun 2019 08:36:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190620090958.2135-1-kevin.laatz@intel.com> <20190620090958.2135-11-kevin.laatz@intel.com>
In-Reply-To: <20190620090958.2135-11-kevin.laatz@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 24 Jun 2019 17:36:22 +0200
Message-ID: <CAJ+HfNhkXmDJO7nZx2A0Gg9vj7s83iUOtkRtWi=wpi5446_NcQ@mail.gmail.com>
Subject: Re: [PATCH 10/11] samples/bpf: use hugepages in xdpsock app
To:     Kevin Laatz <kevin.laatz@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 at 19:25, Kevin Laatz <kevin.laatz@intel.com> wrote:
>
> This patch modifies xdpsock to use mmap instead of posix_memalign. With
> this change, we can use hugepages when running the application in unalign=
ed
> chunks mode. Using hugepages makes it more likely that we have physically
> contiguous memory, which supports the unaligned chunk mode better.
>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  samples/bpf/xdpsock_user.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 7b4ce047deb2..8ed63ad68428 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -74,6 +74,7 @@ static int opt_interval =3D 1;
>  static u64 opt_buffer_size =3D XSK_UMEM__DEFAULT_FRAME_SIZE;
>  static u32 opt_umem_flags;
>  static int opt_unaligned_chunks;
> +static int opt_mmap_flags;
>  static u32 opt_xdp_bind_flags;
>  static __u32 prog_id;
>
> @@ -438,6 +439,7 @@ static void parse_command_line(int argc, char **argv)
>                 case 'u':
>                         opt_umem_flags |=3D XDP_UMEM_UNALIGNED_CHUNKS;
>                         opt_unaligned_chunks =3D 1;
> +                       opt_mmap_flags =3D MAP_HUGETLB;
>                         break;
>                 case 'b':
>                         opt_buffer_size =3D atoi(optarg);
> @@ -707,11 +709,13 @@ int main(int argc, char **argv)
>                 exit(EXIT_FAILURE);
>         }
>
> -       ret =3D posix_memalign(&bufs, getpagesize(), /* PAGE_SIZE aligned=
 */
> -                            NUM_FRAMES * opt_buffer_size);
> -       if (ret)
> -               exit_with_error(ret);
> -
> +       /* Reserve memory for the umem. Use hugepages if unaligned chunk =
mode */
> +       bufs =3D mmap(NULL, NUM_FRAMES * opt_buffer_size, PROT_READ|PROT_=
WRITE,
> +                       MAP_PRIVATE|MAP_ANONYMOUS|opt_mmap_flags, -1, 0);
> +       if (bufs =3D=3D MAP_FAILED) {
> +               printf("ERROR: mmap failed\n");
> +               exit(EXIT_FAILURE);
> +       }
>         /* Create sockets... */
>         umem =3D xsk_configure_umem(bufs,
>                                   NUM_FRAMES * opt_buffer_size);
> --
> 2.17.1
>
